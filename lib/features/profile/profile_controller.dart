import 'package:sarmini_mbokdhe/core_imports.dart';
import 'package:sarmini_mbokdhe/network/api_provider.dart';

import '../../models/user_response.dart';

class ProfileController extends BaseController {
  final Rx<User?> user = Rx(null);

  getLoggedInUser() async {
    final loggedInUser = await getCurrentLoggedInUser();
    user(loggedInUser.value);

    await _getUserDetail();
  }

  _getUserDetail() async {
    isLoading(true);

    try {
      final response = await ApiProvider()
          .post(endpoint: '/users/detail', body: {'userId': user.value!.id});
      final userResponse = UserResponse.fromJson(response);
      user(userResponse.user);

      await setCurrentLoggedInUser(user.value!);
      isLoading(false);
    } catch (e) {
      isLoading(false);
      Utils.showGetSnackbar(e.toString(), false);
    }
  }

  @override
  void onInit() async {
    await getLoggedInUser();

    super.onInit();
  }
}
