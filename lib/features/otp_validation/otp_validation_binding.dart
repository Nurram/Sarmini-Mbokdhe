import 'package:sarmini_mbokdhe/core_imports.dart';
import 'package:sarmini_mbokdhe/features/otp_validation/otp_validation_controller.dart';

class OtpValidationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OtpValidationController());
  }
}
