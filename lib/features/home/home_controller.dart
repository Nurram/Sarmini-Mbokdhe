import 'dart:convert';

import 'package:sarmini_mbokdhe/core_imports.dart';
import 'package:sarmini_mbokdhe/models/address_response.dart';
import 'package:sarmini_mbokdhe/models/user_response.dart';
import 'package:sarmini_mbokdhe/network/api_provider.dart';

import '../../models/category_response.dart';
import '../../models/constants.response.dart';
import '../../models/product_response.dart';
import '../../models/voucher_response.dart';

class HomeController extends BaseController {
  final Rx<AddressDatum?> selectedAddress = Rx(null);

  final Rx<User?> loggedInUser = Rx(null);
  final addresses = <AddressDatum>[].obs;
  final vouchers = <VoucherDatum>[].obs;
  final categories = <CategoryDatum>[].obs;
  final products = <ProductDatum>[].obs;
  final constants = <ConstantsDatum>[].obs;

  setSelectedAddress({required int id}) {
    selectedAddress(
      addresses.firstWhere((element) => element.id == id),
    );

    Utils.storeToSecureStorage(
      key: Constants.address,
      data: jsonEncode(
        selectedAddress.value!.toJson(),
      ),
    );
  }

  getDatas() async {
    isLoading(true);

    try {
      final voucherResult = await ApiProvider().get(endpoint: '/vouchers');
      final categoryResult = await ApiProvider().get(endpoint: '/categories');
      final productResult =
          await ApiProvider().get(endpoint: '/products/newest');
      await getConstants();

      if (loggedInUser.value != null) {
        final user = loggedInUser.value!;
        final addressResult = await ApiProvider()
            .post(endpoint: '/address', body: {'userId': user.id});
        final adddress = AddressResponse.fromJson(addressResult);

        addresses(adddress.data);
        Utils.storeToSecureStorage(
          key: Constants.addresses,
          data: jsonEncode(
            adddress.toJson(),
          ),
        );
      }

      vouchers(
        VoucherResponse.fromJson(voucherResult).data,
      );
      categories(
        CategoryResponse.fromJson(categoryResult).data,
      );
      products(
        ProductResponse.fromJson(productResult).data,
      );

      isLoading(false);
    } catch (e) {
      Utils.showGetSnackbar(e as String, false);
    }
  }

  getConstants() async {
    isLoading(true);

    try {
      final constantsResponse = await ApiProvider().get(endpoint: '/constants');
      final constants = ConstantsResponse.fromJson(constantsResponse);

      this.constants(constants.data);
      isLoading(false);
    } catch (e) {
      isLoading(false);
      Utils.showGetSnackbar(e.toString(), false);
    }
  }

  Future<bool> checkLoggedIn() async {
    final loggedInUser = await getCurrentLoggedInUser();
    return loggedInUser.value != null;
  }

  @override
  void onInit() async {
    isLoading(true);

    final userCtr = Get.find<UserController>();
    loggedInUser(await userCtr.getCurrentLoggedInUser());

    final addressJson =
        await Utils.readFromSecureStorage(key: Constants.address);
    if (addressJson != null) {
      final address = AddressDatum.fromJson(
        jsonDecode(addressJson),
      );

      selectedAddress(address);
    }

    final addressesJson =
        await Utils.readFromSecureStorage(key: Constants.addresses);
    if (addressesJson != null) {
      final addresses = AddressResponse.fromJson(
        jsonDecode(addressesJson),
      );

      this.addresses(addresses.data);
    }

    await getDatas();
    super.onInit();
  }
}
