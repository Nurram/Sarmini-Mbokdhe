import 'package:sarmini_mbokdhe/core_imports.dart';
import 'package:sarmini_mbokdhe/features/home/home_controller.dart';
import 'package:sarmini_mbokdhe/models/address_response.dart';

class AddressController extends BaseController {
  final addresses = <AddressDatum>[].obs;

  getAddress() async {
    isLoading(true);

    try {
      // final user = await getCurrentLoggedInUser();
      // final addressResponse = await ApiProvider()
      //     .post(endpoint: '/address', body: {'userId': user.value!.id});
      // final address = AddressResponse.fromJson(addressResponse);
      final controller = Get.find<HomeController>();
      await controller.getAddress();
      addresses(controller.addresses);

      isLoading(false);
    } catch (e) {
      isLoading(false);
      Utils.showGetSnackbar(e.toString(), false);
    }
  }

  @override
  void onInit() {
    getAddress();
    super.onInit();
  }
}
