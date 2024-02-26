import 'package:sarmini_mbokdhe/core_imports.dart';
import 'package:sarmini_mbokdhe/features/topup_payment/topup_payment_binding.dart';
import 'package:sarmini_mbokdhe/features/topup_payment/topup_payment_screen.dart';
import 'package:sarmini_mbokdhe/models/topup_response.dart';
import 'package:sarmini_mbokdhe/network/api_provider.dart';

class AddTopupController extends BaseController {
  final amountCtr = TextEditingController();

  pay() async {
    if (amountCtr.text.isEmpty) {
      Utils.showGetSnackbar('Silahkan masukan nominal', false);
      return;
    }

    try {
      isLoading(true);

      final user = await getCurrentLoggedInUser();
      final response = await ApiProvider().post(endpoint: '/topup/add', body: {
        'userId': user.value!.id,
        'amount': double.parse(amountCtr.text.replaceAll(',', ''))
      });

      final topupResponse = TopupResponse.fromJson(response);
      Get.off(
        () => const TopupPaymentScreen(),
        binding: TopupPaymentBinding(),
        arguments: topupResponse.data.first,
      );

      isLoading(false);
    } catch (e) {
      isLoading(false);
      Utils.showGetSnackbar(e.toString(), false);
    }
  }
}
