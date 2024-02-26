import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sarmini_mbokdhe/core_imports.dart';
import 'package:sarmini_mbokdhe/features/home/home_controller.dart';
import 'package:sarmini_mbokdhe/models/topup_response.dart';
import 'package:sarmini_mbokdhe/network/api_provider.dart';


class TopupPaymentController extends BaseController {
  final Rx<TopupDatum?> selectedTopup = Rx(null);
  TopupDatum? get getTopup => selectedTopup.value;

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
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(selectedImage.path,
            filename: selectedImage.name),
        'topupId': getTopup!.id,
      });

      await ApiProvider().post(endpoint: '/topup/upload', body: formData);
      Get.back(result: 'success');

      Utils.showGetSnackbar('Pembayaran Berhasil!', true);
    } catch (e) {
      isLoading(false);
      Utils.showGetSnackbar(e.toString(), false);
    }
  }

  @override
  void onInit() async {
    selectedTopup(Get.arguments);

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
