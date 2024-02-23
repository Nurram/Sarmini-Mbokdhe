import 'package:sarmini_mbokdhe/core_imports.dart';
import 'package:sarmini_mbokdhe/features/dashboard/dashboard_controller.dart';
import 'package:sarmini_mbokdhe/features/history/history_controller.dart';
import 'package:sarmini_mbokdhe/features/home/home_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DashboardController());
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => HistoryController());
  }

}