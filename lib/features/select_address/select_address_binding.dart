import 'package:sarmini_mbokdhe/core_imports.dart';

import 'select_address_controller.dart';

class SelectAddressBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SelectAddressController());
  }

}