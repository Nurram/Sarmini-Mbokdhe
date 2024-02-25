import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sarmini_mbokdhe/core_imports.dart';

import '../../models/user_response.dart';
import '../../network/api_provider.dart';

class EditProfileController extends BaseController {
  late User user;

  final firstnameCtr = TextEditingController();
  final lastNameCtr = TextEditingController();
  final emailCtr = TextEditingController();
  final phoneCtr = TextEditingController();

  final Rx<XFile?> selectedImage = Rx(null);

  pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image != null) {
      selectedImage(image);
    }
  }

  edit() async {
    try {
      if (emailCtr.text.isEmpty ||
          firstnameCtr.text.isEmpty ||
          lastNameCtr.text.isEmpty) {
        throw 'Silahkan isi semua field';
      }

      isLoading(true);
      MultipartFile? imageData;

      if (selectedImage.value != null) {
        imageData = await MultipartFile.fromFile(selectedImage.value!.path,
            filename: selectedImage.value!.name);
      }

      final formData = FormData.fromMap({
        'userId': user.id,
        'file': imageData,
        'email': emailCtr.text,
        'firstName': firstnameCtr.text,
        'lastName': lastNameCtr.text,
      });

      await ApiProvider().post(endpoint: '/users/update', body: formData);

      isLoading(false);
      Get.back(result: true);
    } catch (e) {
      isLoading(false);
      Utils.showGetSnackbar(e.toString(), false);
    }
  }

  @override
  void onInit() {
    user = Get.arguments;

    firstnameCtr.text = user.firstname ?? '';
    lastNameCtr.text = user.lastname ?? '';
    emailCtr.text = user.email ?? '';
    phoneCtr.text = user.phone;

    super.onInit();
  }
}
