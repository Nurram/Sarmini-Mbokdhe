import 'package:sarmini_mbokdhe/core_imports.dart';
import 'package:sarmini_mbokdhe/features/dashboard/dashboard_controller.dart';
import 'package:sarmini_mbokdhe/features/login/login_binding.dart';
import 'package:sarmini_mbokdhe/features/login/login_screen.dart';

class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => controller.getCurrentPage(),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
            currentIndex: controller.pageIndex.value,
            selectedItemColor: CustomColors.primaryColor,
            onTap: (value) async {
              if (value != 0) {
                if (await controller.isLoggedIn()) {
                  controller.pageIndex(value);
                } else {
                  Get.to(
                    () => const LoginScreen(),
                    binding: LoginBinding(),
                  );
                }
              } else {
                controller.pageIndex(value);
              }
            },
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.history), label: 'Riwayat Pesanan'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.account_circle_outlined), label: 'Akun'),
            ]),
      ),
    );
  }
}
