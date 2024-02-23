import 'package:sarmini_mbokdhe/core_imports.dart';

import 'checkout_cart_controller.dart';

class CheckoutCartBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CheckoutCartController());
  }

}