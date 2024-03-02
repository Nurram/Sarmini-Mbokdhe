import 'package:sarmini_mbokdhe/core_imports.dart';

import 'products_controller.dart';

class ProductsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProductsController());
  }
}
