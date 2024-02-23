import 'package:sarmini_mbokdhe/core_imports.dart';
import 'package:sarmini_mbokdhe/models/order_response.dart';
import 'package:sarmini_mbokdhe/network/api_provider.dart';

class HistoryController extends BaseController {
  final histories = <OrderDatum>[].obs;

  getOrders() async {
    isLoading(true);

    try {
      final user = await getCurrentLoggedInUser();
      final historyResponse = await ApiProvider()
          .post(endpoint: '/orders', body: {'userId': user.value!.id});
      final history = OrderResponse.fromJson(historyResponse);

      histories(history.data);
      isLoading(false);
    } catch (e) {
      isLoading(false);
      Utils.showGetSnackbar(e.toString(), false);
    }
  }

  @override
  void onInit() async {
    await getOrders();
    super.onInit();
  }
}
