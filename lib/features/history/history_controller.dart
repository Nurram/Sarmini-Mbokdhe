import 'package:sarmini_mbokdhe/core_imports.dart';
import 'package:sarmini_mbokdhe/models/order_response.dart';
import 'package:sarmini_mbokdhe/network/api_provider.dart';

class HistoryController extends BaseController {
  final masterHistories = <OrderDatum>[].obs;
  final histories = <OrderDatum>[].obs;
  final selectedType = 'All'.obs;
  final types = <String>['All', 'Unpaid', 'Waiting', 'Dikirim'];

  setSelectedType({required String type}) {
    selectedType(type);

    if (type == 'All') {
      histories(masterHistories);
      return;
    }

    histories(
      masterHistories.where((p0) => p0.status == type).toList(),
    );
  }

  getOrders() async {
    isLoading(true);

    try {
      final user = await getCurrentLoggedInUser();
      final historyResponse = await ApiProvider()
          .post(endpoint: '/orders', body: {'userId': user.value!.id});
      final history = OrderResponse.fromJson(historyResponse);

      masterHistories(history.data);
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
