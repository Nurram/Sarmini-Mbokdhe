import 'package:sarmini_mbokdhe/core_imports.dart';
import 'package:sarmini_mbokdhe/features/add_topup/add_topup_controller.dart';

class AddTopupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddTopupController());
  }
}
