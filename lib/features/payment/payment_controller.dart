import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sarmini_mbokdhe/core_imports.dart';
import 'package:sarmini_mbokdhe/features/home/home_controller.dart';
import 'package:sarmini_mbokdhe/models/order_response.dart';
import 'package:sarmini_mbokdhe/network/api_provider.dart';

import '../../models/user_response.dart';

class PaymentController extends BaseController {
  final Rx<OrderDatum?> selectedOrder = Rx(null);
  OrderDatum? get getOrder => selectedOrder.value;

  final Rx<XFile?> selectedImage = Rx(null);

  final bankName = ''.obs;
  final bankNo = ''.obs;
  final bankPerson = ''.obs;

  pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      selectedImage(pickedImage);
    }
  }

  changeStatus() async {
    if (selectedImage.value == null) {
      Utils.showGetSnackbar('Silahkan pilih bukti pembayaran', false);
      return;
    }

    isLoading(true);

    try {
      final selectedImage = this.selectedImage.value!;
      final file = await MultipartFile.fromFile(
        selectedImage.path,
        filename: selectedImage.name,
      );

      final formData = FormData.fromMap({
        'file': file,
        'orderId': getOrder!.id.toString(),
        'status': 'Waiting'
      });

      await ApiProvider()
          .postMultipart(endpoint: '/orders/upload', body: formData);
      final user = await getCurrentLoggedInUser();
      final response =
          await ApiProvider().post(endpoint: '/users/deduct', body: {
        'userId': user.value!.id,
        'amount': getOrder!.totalPrice,
      });
      final userData = UserResponse.fromJson(response);
      await setCurrentLoggedInUser(userData.user);

      Get.back(result: 'success');

      Utils.showGetSnackbar('Pembayaran Berhasil!', true);
    } catch (e) {
      isLoading(false);
      Utils.showGetSnackbar(e.toString(), false);
    }
  }

  @override
  void onInit() async {
    selectedOrder(Get.arguments);

    final homeCtr = Get.find<HomeController>();
    final constants = homeCtr.constants;
    bankName(
        constants.firstWhere((element) => element.name == 'bankName').value);
    bankNo(
        constants.firstWhere((element) => element.name == 'noRekening').value);
    bankPerson(constants
        .firstWhere((element) => element.name == 'rekeningName')
        .value);

    super.onInit();
  }
}
