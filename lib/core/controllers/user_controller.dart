import 'dart:convert';

import 'package:sarmini_mbokdhe/models/user_response.dart';

import '../../core_imports.dart';

class UserController extends GetxController {
  final Rx<User?> loggedInUser = Rx(null);

  Future<bool> isLoggedIn() async {
    final token = await Utils.readFromSecureStorage(key: Constants.token);
    return token != null;
  }

  Future<User?> getCurrentLoggedInUser() async {
    final userJson = await Utils.readFromSecureStorage(key: Constants.userData);

    if (userJson != null) {
      loggedInUser(
        User.fromJson(
          jsonDecode(userJson),
        ),
      );
    }

    return loggedInUser.value;
  }

  Future setCurrentLoggedInUser(User userData) async {
    await Utils.storeToSecureStorage(
      key: Constants.userData,
      data: jsonEncode(userData.toJson()),
    );

    loggedInUser(userData);
  }

  @override
  void onInit() {
    getCurrentLoggedInUser();
    super.onInit();
  }
}
