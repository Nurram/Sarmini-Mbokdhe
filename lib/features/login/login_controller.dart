import 'package:sarmini_mbokdhe/core_imports.dart';
import 'package:sarmini_mbokdhe/models/login_response.dart';
import 'package:sarmini_mbokdhe/network/api_provider.dart';

import '../otp_validation/otp_validation_binding.dart';
import '../otp_validation/otp_validation_screen.dart';

class LoginController extends BaseController {
  final phoneCtr = TextEditingController();

  sendOtp() async {
    if (!phoneCtr.text.isPhoneNumber) {
      Utils.showGetSnackbar('Masukan nomor telpon yang valid', false);
      return;
    }

    isLoading(true);

    try {
      final response = await ApiProvider().post(endpoint: '/login', body: {
        'phoneNumber': phoneCtr.text,
      });
      final loginResponse = LoginResponse.fromJson(response);

      Get.to(
        () => const OtpValidationScreen(),
        binding: OtpValidationBinding(),
        arguments: loginResponse.data.userId,
      );

      Utils.showGetSnackbar('OTP terkirim, silahkan cek whatsapp anda', true);
    } catch (e) {
      isLoading(false);
      Utils.showGetSnackbar(e.toString(), false);
    }
  }
}
