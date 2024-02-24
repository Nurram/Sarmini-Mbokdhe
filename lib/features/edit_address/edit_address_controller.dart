import 'package:flutter/services.dart';
import 'package:sarmini_mbokdhe/core_imports.dart';
import 'package:sarmini_mbokdhe/models/address_request.dart';
import 'package:sarmini_mbokdhe/models/address_response.dart';
import 'package:sarmini_mbokdhe/network/api_provider.dart';

import '../../models/district_response.dart';
import '../../models/province_response.dart';
import '../../models/regencies_response.dart';

class EditAddressController extends BaseController {
  final nameCtr = TextEditingController();
  final addressCtr = TextEditingController();
  final zipCtr = TextEditingController();
  final recipientCtr = TextEditingController();
  final phoneCtr = TextEditingController();
  final locationCtr = TextEditingController();
  final latLngCtr = TextEditingController();

  final Rx<ProvinceResponse?> selectedProvince = Rx(null);
  final Rx<RegenciesResponse?> selectedRegency = Rx(null);
  final Rx<DistrictResponse?> selectedDistrict = Rx(null);

  int addressId = -1;
  final isPrimary = false.obs;

  setSelectedAddress({required Map<String, dynamic> result}) {
    selectedProvince(result['province']);
    selectedDistrict(result['district']);
    selectedRegency(result['regency']);

    locationCtr.text =
        '${selectedDistrict.value!.name}, ${selectedRegency.value!.name}, ${selectedProvince.value!.name}';
  }

  editAddress() {
    if (nameCtr.text.isNotEmpty &&
        recipientCtr.text.isNotEmpty &&
        phoneCtr.text.isNotEmpty &&
        selectedProvince.value != null &&
        selectedDistrict.value != null &&
        selectedRegency.value != null &&
        addressCtr.text.isNotEmpty &&
        zipCtr.text.isNotEmpty &&
        latLngCtr.text.isNotEmpty) {
      _doEdit();
    } else {
      Utils.showGetSnackbar('Silahkan isi semua field!', false);
      return;
    }
  }

  _doEdit() async {
    isLoading(true);

    try {
      final user = await getCurrentLoggedInUser();

      final latLng = latLngCtr.text.split(', ');
      final lat = double.parse(latLng.first);
      final lng = double.parse(latLng.last);

      final request = AddressRequest(
          userId: user.value!.id,
          name: nameCtr.text,
          receipient: recipientCtr.text,
          address: addressCtr.text,
          province: selectedProvince.value!.name,
          district: selectedDistrict.value!.name,
          regency: selectedRegency.value!.name,
          phoneNumber: phoneCtr.text,
          lat: lat,
          long: lng,
          postalCode: int.parse(zipCtr.text),
          isPrimary: isPrimary.value);

      await ApiProvider().post(
        endpoint: '/address/update',
        body: {'id': addressId, ...request.toJson()},
      );

      isLoading(false);
      Get.back(result: true);
    } catch (e) {
      isLoading(false);
      Utils.showGetSnackbar(e.toString(), false);
    }
  }

  delete() async {
    isLoading(true);

    try {
      await ApiProvider().delete(endpoint: '/address', body: {'id': addressId});

      isLoading(false);
      Get.back(result: true);
    } catch (e) {
      isLoading(false);
      Utils.showGetSnackbar(e.toString(), false);
    }
  }

  @override
  void onInit() async {
    final AddressDatum? address = Get.arguments;

    if (address != null) {
      addressId = address.id;

      final String province =
          await rootBundle.loadString('assets/docs/provinces.json');
      final provinceData = provinceResponseFromJson(province);
      final String regency =
          await rootBundle.loadString('assets/docs/regencies.json');
      final regencyData = regenciesResponseFromJson(regency);

      final String district =
          await rootBundle.loadString('assets/docs/districts.json');
      final districtData = districtResponseFromJson(district);

      selectedProvince(
        provinceData.firstWhere((element) => element.name == address.province),
      );
      selectedDistrict(
        districtData.firstWhere((element) => element.name == address.district),
      );
      selectedRegency(
        regencyData.firstWhere((element) => element.name == address.regency),
      );

      nameCtr.text = address.name;
      addressCtr.text = address.address;
      zipCtr.text = address.postalCode.toString();
      recipientCtr.text = address.receipient;
      phoneCtr.text = address.phoneNumber.toString();
      locationCtr.text = '${address.district}, '
          '${address.regency},'
          '${address.province},';
      latLngCtr.text = '${address.lat}, ${address.long}';
      isPrimary(address.isPrimary);
    } else {
      Get.back();
      Utils.showGetSnackbar('Something happened', false);
    }
    super.onInit();
  }
}
