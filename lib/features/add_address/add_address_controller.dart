import 'package:flutter/services.dart';
import 'package:sarmini_mbokdhe/core_imports.dart';
import 'package:sarmini_mbokdhe/features/home/home_controller.dart';
import 'package:sarmini_mbokdhe/models/address_request.dart';
import 'package:sarmini_mbokdhe/network/api_provider.dart';

import '../../models/district_response.dart';
import '../../models/province_response.dart';
import '../../models/regencies_response.dart';

class AddAddressController extends BaseController {
  final nameCtr = TextEditingController();
  final addressCtr = TextEditingController();
  final zipCtr = TextEditingController();
  final recipientCtr = TextEditingController();
  final phoneCtr = TextEditingController();
  final locationCtr = TextEditingController();
  final latLngCtr = TextEditingController();

  final provinces = <ProvinceResponse>[].obs;
  final regencies = <RegenciesResponse>[].obs;
  final districts = <DistrictResponse>[].obs;

  final Rx<ProvinceResponse?> selectedProvince = Rx(null);
  final Rx<RegenciesResponse?> selectedRegency = Rx(null);
  final Rx<DistrictResponse?> selectedDistrict = Rx(null);

  setSelectedAddress({required Map<String, dynamic> result}) {
    selectedProvince(result['province']);
    selectedDistrict(result['district']);
    selectedRegency(result['regency']);

    locationCtr.text =
        '${selectedDistrict.value!.name}, ${selectedRegency.value!.name}, ${selectedProvince.value!.name}';
  }

  onProvinceSelected({required String id}) async {
    final String regency =
        await rootBundle.loadString('assets/docs/regencies.json');
    final regencyData = regenciesResponseFromJson(regency);

    selectedProvince(
      provinces.firstWhere((element) => element.id == id),
    );
    regencies(
      regencyData.where((element) => element.provinceId == id).toList(),
    );
  }

  onRegencySelected({required String id}) async {
    final String district =
        await rootBundle.loadString('assets/docs/districts.json');
    final districtData = districtResponseFromJson(district);

    selectedRegency(
      regencies.firstWhere((element) => element.id == id),
    );

    districts(
      districtData.where((element) => element.regencyId == id).toList(),
    );
  }

  onDistrictSelected({required String id}) async {
    selectedDistrict(
      districts.firstWhere((element) => element.id == id),
    );
  }

  addAddress() {
    if (nameCtr.text.isNotEmpty &&
        recipientCtr.text.isNotEmpty &&
        phoneCtr.text.isNotEmpty &&
        selectedProvince.value != null &&
        selectedDistrict.value != null &&
        selectedRegency.value != null &&
        addressCtr.text.isNotEmpty &&
        zipCtr.text.isNotEmpty &&
        latLngCtr.text.isNotEmpty) {
      _doAdd();
    } else {
      Utils.showGetSnackbar('Silahkan isi semua field!', false);
      return;
    }
  }

  _doAdd() async {
    isLoading(true);

    try {
      final user = await getCurrentLoggedInUser();

      final address = '${addressCtr.text}, '
          '${selectedDistrict.value!.name}, '
          '${selectedRegency.value!.name}, '
          '${selectedProvince.value!.name}';

      final latLng = latLngCtr.text.split(', ');
      final lat = double.parse(latLng.first);
      final lng = double.parse(latLng.last);

      final request = AddressRequest(
          userId: user.value!.id,
          name: nameCtr.text,
          receipient: recipientCtr.text,
          address: address,
          phoneNumber: phoneCtr.text,
          lat: lat,
          long: lng,
          postalCode: int.parse(zipCtr.text),
          isPrimary: false);

      await ApiProvider().post(
        endpoint: '/address/add',
        body: request.toJson(),
      );
      await Get.find<HomeController>().getAddress();

      isLoading(false);
      Get.back(result: true);
    } catch (e) {
      isLoading(false);
      Utils.showGetSnackbar(e.toString(), false);
    }
  }

  @override
  void onInit() async {
    isLoading(true);

    final String province =
        await rootBundle.loadString('assets/docs/provinces.json');
    final provinceData = provinceResponseFromJson(province);
    provinces(provinceData);

    isLoading(false);
    super.onInit();
  }
}
