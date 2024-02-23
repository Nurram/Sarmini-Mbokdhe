import 'package:sarmini_mbokdhe/core_imports.dart';

import '../../models/user_response.dart';

class ProfileController extends BaseController {
  final Rx<User?> user = Rx(null);

  @override
  void onInit() async {
    final loggedInUser = await getCurrentLoggedInUser();
    user(loggedInUser.value);

    super.onInit();
  }
}
