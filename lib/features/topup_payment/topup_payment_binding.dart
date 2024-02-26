import 'package:sarmini_mbokdhe/core_imports.dart';
import 'package:sarmini_mbokdhe/features/topup_payment/topup_payment_controller.dart';

class TopupPaymentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TopupPaymentController());
  }
}
