import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sarmini_mbokdhe/core_imports.dart';
import 'package:sarmini_mbokdhe/features/home/home_controller.dart';
import 'package:sarmini_mbokdhe/models/district_response.dart';
import 'package:sarmini_mbokdhe/models/product_response.dart';
import 'package:sarmini_mbokdhe/models/province_response.dart';
import 'package:sarmini_mbokdhe/models/regencies_response.dart';
import 'package:sarmini_mbokdhe/network/api_provider.dart';

import '../checkout/checkout_binding.dart';
import '../checkout/checkout_screen.dart';

class ProductDetailController extends BaseController {
  final Rx<ProductDatum?> selectedProduct = Rx(null);

  final provinces = <ProvinceResponse>[].obs;
  final regencies = <RegenciesResponse>[].obs;
  final districts = <DistrictResponse>[].obs;

  final Rx<ProvinceResponse?> selectedProvince = Rx(null);
  final Rx<RegenciesResponse?> selectedRegency = Rx(null);
  final Rx<DistrictResponse?> selectedDistrict = Rx(null);

  final serviceFee = '0'.obs;
  final qty = 1.obs;
  final isStockLoading = false.obs;
  final isStockAvailable = true.obs;

  getDetail() async {
    isLoading(true);

    try {
      final detailResponse = await ApiProvider().post(
          endpoint: '/products/detail',
          body: {'id': selectedProduct.value!.id});
      final detail = ProductDatum.fromJson(detailResponse['data']);

      isStockAvailable(detail.stock > 0);
      selectedProduct(detail);

      isLoading(false);
    } catch (e) {
      isLoading(false);
      Utils.showGetSnackbar(e.toString(), false);
    }
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

  calculateFee() {
    final lat = selectedDistrict.value!.latitude;
    final long = selectedDistrict.value!.longitude;

    if (lat == null || long == null) {
      Utils.showGetSnackbar(
          'Tidak dapat mengambil perkiraan ongkos kirim', false);
      return;
    }

    final homeCtr = Get.find<HomeController>();
    final constants = homeCtr.constants;

    final lat2 = double.parse(
      constants.firstWhere((element) => element.name == 'lat').value,
    );
    final long2 = double.parse(
      constants.firstWhere((element) => element.name == 'long').value,
    );

    final distance = Geolocator.distanceBetween(lat, long, lat2, long2) / 1000;
    final fee =
        constants.firstWhere((element) => element.name == 'feePerKm').value;
    final feeInt = int.parse(fee);

    if (distance <= 1) {
      serviceFee('Gratis');
    } else {
      serviceFee(
        'Rp${Utils.numberFormat(distance.ceil() * feeInt)}',
      );
    }
  }

  addToCart() async {
    try {
      final user = await getCurrentLoggedInUser();

      if (user.value != null) {
        await ApiProvider().post(
          endpoint: '/cart/add',
          body: {
            'userId': user.value!.id,
            'productId': selectedProduct.value!.id
          },
        );
        Utils.showGetSnackbar('Ditambahkan ke cart!', true);
      } else {
        throw 'Tidak dapat menambhkan ke cart';
      }
    } catch (e) {
      Utils.showGetSnackbar(e.toString(), false);
    }
  }

  checkStock() async {
    try {
      final homeController = Get.find<HomeController>();
      if (homeController.selectedAddress.value == null) {
        throw 'Anda belum memilih alamat pengiriman';
      }

      isStockLoading(true);

      final detailResponse = await ApiProvider().post(
          endpoint: '/products/detail',
          body: {'id': selectedProduct.value!.id});
      final detail = ProductDatum.fromJson(detailResponse['data']);

      if (detail.stock < qty.value) {
        throw 'Stock telah habis';
      }

      Get.back();
      Get.to(
        () => const CheckoutScreen(),
        binding: CheckoutBinding(),
      );

      isStockLoading(false);
    } catch (e) {
      isStockLoading(false);
      Utils.showGetSnackbar(e.toString(), false);

      getDetail();
    }
  }

  addQty() {
    qty(qty.value + 1);
  }

  reduceQty() {
    if (qty.value > 1) {
      qty(qty.value - 1);
    }
  }

  @override
  void onInit() async {
    selectedProduct(Get.arguments);

    final String province =
        await rootBundle.loadString('assets/docs/provinces.json');
    final provinceData = provinceResponseFromJson(province);
    provinces(provinceData);

    await getDetail();
    super.onInit();
  }
}
