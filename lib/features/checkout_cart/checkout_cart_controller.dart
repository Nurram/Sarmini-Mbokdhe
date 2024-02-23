import 'package:geolocator/geolocator.dart';
import 'package:sarmini_mbokdhe/core_imports.dart';
import 'package:sarmini_mbokdhe/features/dashboard/dashboard_binding.dart';
import 'package:sarmini_mbokdhe/features/dashboard/dashboard_screen.dart';
import 'package:sarmini_mbokdhe/features/home/home_controller.dart';
import 'package:sarmini_mbokdhe/models/address_response.dart';
import 'package:sarmini_mbokdhe/models/cart_response.dart';
import 'package:sarmini_mbokdhe/models/order_request.dart';
import 'package:sarmini_mbokdhe/models/product_response.dart';
import 'package:sarmini_mbokdhe/models/user_response.dart';
import 'package:sarmini_mbokdhe/models/voucher_response.dart';
import 'package:sarmini_mbokdhe/network/api_provider.dart';

import '../../models/order_response.dart';
import '../payment/payment_binding.dart';
import '../payment/payment_screen.dart';

class CheckoutCartController extends BaseController {
  final homeController = Get.find<HomeController>();

  final voucherCtr = TextEditingController();
  final voucherNode = FocusNode();
  final notesCtr = TextEditingController();

  final carts = <CartDatum>[].obs;
  final Rx<VoucherDatum?> selectedVoucher = Rx(null);
  final Rx<AddressDatum?> address = Rx(null);
  final Rx<String?> inputtedVoucher = Rx(null);
  final selectedPayment = 'Transfer'.obs;
  final serviceFee = '0'.obs;
  final total = 0.obs;
  final isBuyLoading = false.obs;

  _calculateFee() {
    final fromLat = double.parse(
      homeController.constants
          .firstWhere((element) => element.name == 'lat')
          .value,
    );
    final fromLong = double.parse(
      homeController.constants
          .firstWhere((element) => element.name == 'long')
          .value,
    );
    final address = this.address.value;
    final toLat = double.parse(address!.lat!);
    final toLong = double.parse(address.long!);

    final distance =
        Geolocator.distanceBetween(fromLat, fromLong, toLat, toLong) / 1000;
    final fee = homeController.constants
        .firstWhere((element) => element.name == 'feePerKm')
        .value;
    final feeInt = int.parse(fee);

    if (distance <= 1) {
      serviceFee('Gratis');
    } else {
      serviceFee(
        'Rp${Utils.numberFormat(distance.ceil() * feeInt)}',
      );
    }
  }

  int _calculateTotal() {
    final fee = int.parse(
      serviceFee.value
          .replaceAll('Rp', '')
          .replaceAll(',', '')
          .replaceAll('.', ''),
    );
    int total = carts
            .map((element) => element.cartQty * element.price)
            .reduce((value, element) => value + element) +
        fee;

    final voucher = selectedVoucher.value;

    if (voucher != null && voucher.type == 'discount') {
      total -= voucher.amount;
    }

    this.total(total);
    return total;
  }

  setVoucher() async {
    FocusScope.of(Get.context!).unfocus();

    if (voucherCtr.text.trim().isNotEmpty) {
      isLoading(true);

      try {
        final voucherResponse = await ApiProvider()
            .post(endpoint: '/vouchers', body: {'code': voucherCtr.text});
        final voucher = VoucherResponse.fromJson(voucherResponse).data.first;
        final totalTrx = carts
            .map((element) => element.cartQty * element.price)
            .reduce((value, element) => value + element);

        if (totalTrx < voucher.minimumTrx) {
          throw 'Total transaksi kurang';
        }

        selectedVoucher(voucher);
        inputtedVoucher(voucherCtr.text);

        _calculateTotal();
        Get.back();
        isLoading(false);
      } catch (e) {
        isLoading(false);
        Utils.showGetSnackbar(e.toString(), false);
      }
    } else {
      Get.back();

      inputtedVoucher(inputtedVoucher.value = null);
      selectedVoucher(selectedVoucher.value = null);

      _calculateTotal();
    }
  }

  buy() async {
    isBuyLoading(true);

    try {
      await _checkBalance();

      for (var element in carts) {
        await _checkStock(cart: element);
      }

      final response = await _doBuy();

      if (selectedPayment.value == 'Transfer') {
        final order = OrderDatum.fromJson(response['data']);

        Get.off(() => const PaymentScreen(),
            binding: PaymentBinding(), arguments: order);

        return;
      } else {
        await _applyVoucher();
        await _reduceStocks();
        await _reduceBalance();

        Get.offAll(
          () => const DashboardScreen(),
          binding: DashboardBinding(),
        );

        Utils.showGetSnackbar('Order berhasil dilakukan', true);
      }

      isBuyLoading(false);
    } catch (e) {
      isBuyLoading(false);
      Utils.showGetSnackbar(e.toString(), false);
    }
  }

  _checkStock({required CartDatum cart}) async {
    final detailResponse = await ApiProvider()
        .post(endpoint: '/products/detail', body: {'id': cart.productId});
    final detail = ProductDatum.fromJson(detailResponse['data']);

    if (detail.stock < cart.cartQty) {
      throw 'Stock ${cart.name} tidak cukup / telah habis';
    }
  }

  _checkBalance() async {
    final user = await getCurrentLoggedInUser();
    final userData = await ApiProvider().post(endpoint: '/users/detail', body: {
      'userId': user.value!.id,
    });

    final userResponse = UserResponse.fromJson(userData).user;
    await setCurrentLoggedInUser(userResponse);

    if (selectedPayment.value == 'Saldo' &&
        userResponse.balance < _calculateTotal()) {
      throw ('Saldo anda kurang');
    }
  }

  Future<dynamic> _doBuy() async {
    final user = await getCurrentLoggedInUser();
    final products = <Map<String, dynamic>>[];

    for (var element in carts) {
      products.add({'productId': element.id, 'qty': element.cartQty});
    }

    final request = OrderRequest(
      userId: user.value!.id,
      products: products,
      totalPrice: total.value,
      destination: address.value!.address,
      status: selectedPayment.value == 'Saldo' ? 'Waiting' : 'Unpaid',
      image: null,
      paymentMethod: selectedPayment.value,
      serviceFee: serviceFee.value,
      voucherId: selectedVoucher.value?.id,
      voucherAmount: selectedVoucher.value?.amount,
      notes: notesCtr.text,
    );

    return await ApiProvider().post(
      endpoint: '/orders/add',
      body: request.toJson(),
    );
  }

  _applyVoucher() async {
    if (selectedVoucher.value != null) {
      if (selectedVoucher.value!.type != 'discount') {
        final user = await getCurrentLoggedInUser();
        await ApiProvider().post(endpoint: '/users/topup', body: {
          'userId': user.value!.id,
          'amount': selectedVoucher.value!.amount,
        });
      }
    }
  }

  _reduceStocks() async {
    for (var element in carts) {
      await ApiProvider().post(endpoint: '/products/reduceStock', body: {
        'productId': element.productId,
        'qty': element.cartQty,
      });
    }
  }

  _reduceBalance() async {
    final user = await getCurrentLoggedInUser();
    if (selectedPayment.value == 'Saldo') {
      final response =
          await ApiProvider().post(endpoint: '/users/deduct', body: {
        'userId': user.value!.id,
        'amount': _calculateTotal(),
      });
      final userData = UserResponse.fromJson(response);
      await setCurrentLoggedInUser(userData.user);
    }
  }

  @override
  void onInit() {
    address(homeController.selectedAddress.value);
    carts(Get.arguments);

    if (address.value == null) {
      address(homeController.addresses.first);
    }

    _calculateFee();
    _calculateTotal();
    super.onInit();
  }
}
