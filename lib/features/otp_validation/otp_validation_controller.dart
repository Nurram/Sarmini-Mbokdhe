import 'dart:convert';

import 'package:sarmini_mbokdhe/core_imports.dart';
import 'package:sarmini_mbokdhe/features/dashboard/dashboard_binding.dart';
import 'package:sarmini_mbokdhe/features/dashboard/dashboard_screen.dart';
import 'package:sarmini_mbokdhe/models/otp_response.dart';
import 'package:sarmini_mbokdhe/network/api_provider.dart';

class OtpValidationController extends BaseController {
  final otpCtr = TextEditingController();

  validateOtp() async {
    if (otpCtr.text.length < 6) {
      Utils.showGetSnackbar('OTP tidak valid', false);
      return;
    }

    isLoading(true);

    try {
      final response = await ApiProvider().post(
          endpoint: '/login/validate',
          body: {'userId': Get.arguments, 'otp': otpCtr.text});
      final otpResponse = OtpResponse.fromJson(response);

      await Utils.storeToSecureStorage(
        key: Constants.userData,
        data: jsonEncode(
          otpResponse.user.toJson(),
        ),
      );

      await Utils.storeToSecureStorage(
        key: Constants.token,
        data: otpResponse.token,
      );

      Get.offAll(
        () => const DashboardScreen(),
        binding: DashboardBinding(),
      );

      isLoading(false);
    } catch (e) {
      isLoading(false);
      Utils.showGetSnackbar(e.toString(), false);
    }
  }
}
