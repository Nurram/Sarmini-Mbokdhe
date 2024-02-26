import 'package:sarmini_mbokdhe/core_imports.dart';
import 'package:sarmini_mbokdhe/models/topup_response.dart';
import 'package:sarmini_mbokdhe/network/api_provider.dart';

import '../../models/user_response.dart';

class TopupController extends BaseController {
  final Rx<User?> user = Rx(null);
  final histories = <TopupDatum>[].obs;

  getHistories() async {
    isLoading(true);

    try {
      final user = await getCurrentLoggedInUser();
      final userData =
          await ApiProvider().post(endpoint: '/users/detail', body: {
        'userId': user.value!.id,
      });

      final userResponse = UserResponse.fromJson(userData).user;
      this.user(userResponse);
      await setCurrentLoggedInUser(userResponse);

      final response = await ApiProvider().post(endpoint: '/topup', body: {
        'userId': user.value!.id,
      });
      final topupResponse = TopupResponse.fromJson(response);
      histories(topupResponse.data);

      isLoading(false);
    } catch (e) {
      isLoading(false);
      Utils.showGetSnackbar(e.toString(), false);
    }
  }

  @override
  void onInit() async {
    await getHistories();
    super.onInit();
  }
}
