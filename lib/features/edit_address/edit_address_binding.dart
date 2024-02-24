import 'package:sarmini_mbokdhe/core_imports.dart';

import 'edit_address_controller.dart';

class EditAddressBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EditAddressController());
  }
}
