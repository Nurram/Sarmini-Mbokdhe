import 'package:flutter/services.dart';
import 'package:sarmini_mbokdhe/core_imports.dart';

import '../../models/district_response.dart';
import '../../models/province_response.dart';
import '../../models/regencies_response.dart';

class SelectAddressController extends BaseController {
  final currentSteps = 0.obs;

  final provinces = <ProvinceResponse>[].obs;
  final regencies = <RegenciesResponse>[].obs;
  final districts = <DistrictResponse>[].obs;

  final Rx<ProvinceResponse?> selectedProvince = Rx(null);
  final Rx<RegenciesResponse?> selectedRegency = Rx(null);
  final Rx<DistrictResponse?> selectedDistrict = Rx(null);

  setSelectedData({required dynamic data}) {
    if (currentSteps.value < 2) {
      if (currentSteps.value == 0) {
        onProvinceSelected(id: data.id);
      } else {
        onRegencySelected(id: data.id);
      }

      currentSteps(currentSteps.value + 1);
    } else {
      onDistrictSelected(id: data.id);
    }
  }

  onProvinceSelected({required String id}) async {
    isLoading(true);

    final String regency =
        await rootBundle.loadString('assets/docs/regencies.json');
    final regencyData = regenciesResponseFromJson(regency);

    selectedProvince(
      provinces.firstWhere((element) => element.id == id),
    );
    regencies(
      regencyData.where((element) => element.provinceId == id).toList(),
    );

    isLoading(false);
  }

  onRegencySelected({required String id}) async {
    isLoading(true);

    final String district =
        await rootBundle.loadString('assets/docs/districts.json');
    final districtData = districtResponseFromJson(district);

    selectedRegency(
      regencies.firstWhere((element) => element.id == id),
    );

    districts(
      districtData.where((element) => element.regencyId == id).toList(),
    );

    isLoading(false);
  }

  onDistrictSelected({required String id}) async {
    isLoading(true);

    selectedDistrict(
      districts.firstWhere((element) => element.id == id),
    );

    isLoading(false);
    Get.back(result: {
      'province': selectedProvince.value,
      'district': selectedDistrict.value,
      'regency': selectedRegency.value,
    });
  }

  @override
  void onInit() async {
    final String province =
        await rootBundle.loadString('assets/docs/provinces.json');
    final provinceData = provinceResponseFromJson(province);
    provinces(provinceData);

    super.onInit();
  }
}
