import '../../core_imports.dart';
import '../dashboard/dashboard_binding.dart';
import '../dashboard/dashboard_screen.dart';

class SplashController extends BaseController {
  @override
  void onInit() async {
    await Future.delayed(const Duration(seconds: 2));

    Get.off(() => const DashboardScreen(), binding: DashboardBinding());
    super.onInit();
  }
}
