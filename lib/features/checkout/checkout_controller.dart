import 'package:geolocator/geolocator.dart';
import 'package:sarmini_mbokdhe/core_imports.dart';
import 'package:sarmini_mbokdhe/features/dashboard/dashboard_binding.dart';
import 'package:sarmini_mbokdhe/features/dashboard/dashboard_screen.dart';
import 'package:sarmini_mbokdhe/features/home/home_controller.dart';
import 'package:sarmini_mbokdhe/features/product_detail/product_detail_controller.dart';
import 'package:sarmini_mbokdhe/models/address_response.dart';
import 'package:sarmini_mbokdhe/models/order_request.dart';
import 'package:sarmini_mbokdhe/models/order_response.dart';
import 'package:sarmini_mbokdhe/models/product_response.dart';
import 'package:sarmini_mbokdhe/models/user_response.dart';
import 'package:sarmini_mbokdhe/models/voucher_response.dart';
import 'package:sarmini_mbokdhe/network/api_provider.dart';

import '../payment/payment_binding.dart';
import '../payment/payment_screen.dart';

class CheckoutController extends BaseController {
  final homeController = Get.find<HomeController>();
  final detailController = Get.find<ProductDetailController>();

  final voucherCtr = TextEditingController();
  final voucherNode = FocusNode();
  final notesCtr = TextEditingController();

  final Rx<ProductDatum?> selectedProduct = Rx(null);
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
    final productPrice = selectedProduct.value!.price;
    final qty = detailController.qty.value;
    final fee = int.parse(
      serviceFee.value
          .replaceAll('Rp', '')
          .replaceAll(',', '')
          .replaceAll('.', ''),
    );

    int total = (productPrice * qty) + fee;
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
        final totalTrx =
            selectedProduct.value!.price * detailController.qty.value;

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
      final detailResponse = await ApiProvider().post(
          endpoint: '/products/detail',
          body: {'id': selectedProduct.value!.id});
      final detail = ProductDatum.fromJson(detailResponse['data']);

      if (detail.stock < detailController.qty.value) {
        throw 'Stock tidak cukup / telah habis';
      }

      final user = await getCurrentLoggedInUser();
      final userData =
          await ApiProvider().post(endpoint: '/users/detail', body: {
        'userId': user.value!.id,
      });

      final userResponse = UserResponse.fromJson(userData).user;
      await setCurrentLoggedInUser(userResponse);

      if (selectedPayment.value == 'Saldo' &&
          userResponse.balance < _calculateTotal()) {
        Utils.showGetSnackbar('Saldo anda kurang', false);
        isBuyLoading(false);

        return;
      }

      final request = OrderRequest(
        products: [
          {
            'productId': selectedProduct.value!.id,
            'qty': detailController.qty.value
          }
        ],
        userId: user.value!.id,
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

      final response = await ApiProvider().post(
        endpoint: '/orders/add',
        body: request.toJson(),
      );

      if (selectedPayment.value == 'Transfer') {
        Get.off(
          () => const PaymentScreen(),
          binding: PaymentBinding(),
          arguments: OrderDatum.fromJson(response['data']),
        );
      } else {
        if (selectedVoucher.value != null) {
          if (selectedVoucher.value!.type != 'discount') {
            await ApiProvider().post(endpoint: '/users/topup', body: {
              'userId': user.value!.id,
              'amount': selectedVoucher.value!.amount,
            });
          }
        }

        await ApiProvider().post(endpoint: '/products/reduceStock', body: {
          'productId': selectedProduct.value!.id,
          'qty': detailController.qty.value,
        });
        final response =
            await ApiProvider().post(endpoint: '/users/deduct', body: {
          'userId': user.value!.id,
          'amount': _calculateTotal(),
        });
        final userData = UserResponse.fromJson(response);
        await setCurrentLoggedInUser(userData.user);

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

  showAddressBottomSheet({required BuildContext context}) async {
    final selectedAddress =
        await homeController.showAddressBottomSheet(context: Get.context!);

    if (selectedAddress != null) address(selectedAddress);
  }

  @override
  void onInit() {
    address(homeController.selectedAddress.value);
    selectedProduct(detailController.selectedProduct.value);

    if (address.value == null) {
      address(homeController.addresses.first);
    }

    _calculateFee();
    _calculateTotal();
    super.onInit();
  }
}
