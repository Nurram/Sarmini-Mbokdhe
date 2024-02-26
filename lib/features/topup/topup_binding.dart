import 'package:sarmini_mbokdhe/core_imports.dart';
import 'package:sarmini_mbokdhe/features/topup/topup_controller.dart';

class TopupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TopupController());
  }
}
