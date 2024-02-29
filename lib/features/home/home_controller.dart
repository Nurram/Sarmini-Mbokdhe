import 'dart:convert';

import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:sarmini_mbokdhe/core_imports.dart';
import 'package:sarmini_mbokdhe/models/address_response.dart';
import 'package:sarmini_mbokdhe/models/user_response.dart';
import 'package:sarmini_mbokdhe/network/api_provider.dart';

import '../../models/category_response.dart';
import '../../models/constants.response.dart';
import '../../models/product_response.dart';
import '../../models/voucher_response.dart';
import '../../widgets/address_bottom_sheet.dart';

class HomeController extends BaseController {
  final Rx<AddressDatum?> selectedAddress = Rx(null);
  final selectedAddressId = (-1).obs;

  final Rx<User?> loggedInUser = Rx(null);
  final addresses = <AddressDatum>[].obs;
  final vouchers = <VoucherDatum>[].obs;
  final categories = <CategoryDatum>[].obs;
  final products = <ProductDatum>[].obs;
  final constants = <ConstantsDatum>[].obs;

  setSelectedAddress({required int id}) async {
    if (selectedAddress.value!.id != id) {
      try {
        final user = await getCurrentLoggedInUser();
        final response = await ApiProvider().post(
            endpoint: '/address/setPrimary',
            body: {'userId': user.value!.id, 'id': id});

        selectedAddress(AddressDatum.fromJson(response['data']));
        selectedAddressId(selectedAddress.value!.id);

        Utils.storeToSecureStorage(
          key: Constants.address,
          data: jsonEncode(
            selectedAddress.value!.toJson(),
          ),
        );

        Get.back(result: selectedAddress.value);
      } catch (e) {
        Utils.showGetSnackbar(e.toString(), false);
      }
    }
  }

  Future<AddressDatum?> showAddressBottomSheet(
      {required BuildContext context}) async {
    final selectedAddress = await showModalBottomSheet(
      context: Get.context!,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.dp),
          topRight: Radius.circular(16.dp),
        ),
      ),
      builder: (context) {
        return const AddressBottomSheet();
      },
    );

    return selectedAddress;
  }

  getDatas() async {
    isLoading(true);

    try {
      if (loggedInUser.value != null) {
        await getAddress();
      }

      final voucherResult = await ApiProvider().get(endpoint: '/vouchers');
      final categoryResult = await ApiProvider().get(endpoint: '/categories');
      final productResult =
          await ApiProvider().get(endpoint: '/products/newest');
      await getConstants();

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

  getAddress() async {
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

    selectedAddress(
      addresses.firstWhereOrNull((element) => element.isPrimary),
    );
    selectedAddressId(selectedAddress.value?.id);
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

    // final addressJson =
    //     await Utils.readFromSecureStorage(key: Constants.address);
    // if (addressJson != null) {
    //   final address = AddressDatum.fromJson(
    //     jsonDecode(addressJson),
    //   );

    //   selectedAddress(address);
    //   selectedAddressId(selectedAddress.value!.id);
    // }

    await getDatas();
    super.onInit();
  }
}
