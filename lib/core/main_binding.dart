import '../core_imports.dart';
import '../features/splash/splash_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UserController(), fenix: true);
    Get.lazyPut(() => BaseController());
    Get.lazyPut(() => SplashController());
  }
}
