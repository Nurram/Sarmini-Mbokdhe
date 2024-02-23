import 'package:sarmini_mbokdhe/core_imports.dart';
import 'package:sarmini_mbokdhe/features/login/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController());
  }
}
