import '../../core_imports.dart';
import '../../models/user_response.dart';

class BaseController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final isLoading = false.obs;

  final searchCtr = TextEditingController();
  final userController = Get.find<UserController>();

  Future<Rx<User?>> getCurrentLoggedInUser() async {
    await userController.getCurrentLoggedInUser();
    return userController.loggedInUser;
  }

  Future setCurrentLoggedInUser(User userData) async {
    await userController.setCurrentLoggedInUser(userData);
    await Utils.storeToSecureStorage(
        key: Constants.userId, data: userData.id.toString());
  }

  Future<String?> getUserId() {
    return Utils.readFromSecureStorage(key: Constants.userId);
  }

  Future<bool> isLoggedIn() async => await userController.isLoggedIn();

  search({
    required String query,
    required RxList<Map<String, dynamic>> transactionList,
    required RxList<Map<String, dynamic>> masterList,
    required String fieldName,
  }) {
    transactionList(
      masterList
          .where((p0) => p0[fieldName].toLowerCase().contains(
                query.toLowerCase(),
              ))
          .toList(),
    );
  }

  handleError({required String msg}) {
    isLoading(false);
    Utils.showGetSnackbar(msg, false);
  }

  logout() async {
    await Utils.clearSecureStorage();
    userController.loggedInUser(null);
  }
}
