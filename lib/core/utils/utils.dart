import 'dart:convert';

import '../../core_imports.dart';

class Utils {
  static checkFileExtension(File file) {
    final supportedExtensions = ['jpg', 'jpeg', 'png', 'webp'];

    final filePath = file.path;
    final dotIndex = filePath.lastIndexOf('.');
    final fileExtension = filePath.substring(dotIndex + 1);

    return supportedExtensions.contains(fileExtension);
  }

  static String dateFromMillis(int millis) {
    final date = DateTime.fromMillisecondsSinceEpoch(millis);
    final formatted = DateFormat('dd MMMM yyyy').format(date);

    return formatted;
  }

  static showGetSnackbar(String msg, bool success) {
    Get.snackbar(
      success ? 'Success!' : 'Error!',
      msg,
      backgroundColor: success ? Colors.green : Colors.red,
      snackPosition: SnackPosition.BOTTOM,
      colorText: Colors.white,
      borderRadius: 0,
      margin: EdgeInsets.zero,
    );
  }

  static String formatDateFromMillis(
      {required String pattern, required int millis}) {
    final date = DateTime.fromMillisecondsSinceEpoch(millis);
    final format = DateFormat(pattern);

    return format.format(date);
  }

  static String formatDate({required String pattern, required DateTime date}) {
    final format = DateFormat(pattern);

    return format.format(date);
  }

  static String getCurrentDateddMMMyyyyHHmm() {
    final date = DateTime.now();
    final format = DateFormat('dd MMM yyyy, HH:mm');

    return format.format(date);
  }

  static String getCurrentDateddMMMyyyyHHmmss(
      {Duration addition = Duration.zero}) {
    final date = DateTime.now().add(addition);
    final format = DateFormat('dd MMM yyyy, HH:mm:ss');

    return format.format(date);
  }

  static String getCurrentDateEEEddMMMMyyyy() {
    final date = DateTime.now();
    final format = DateFormat('EEE, dd MMMM yyyy');

    return format.format(date);
  }

  static String getCurrentDateddMMMMyyyy() {
    final date = DateTime.now();
    final format = DateFormat('dd MMMM yyyy');

    return format.format(date);
  }

  static String getCurrentDateMMMMyyyy() {
    final date = DateTime.now();
    final format = DateFormat('MMMM yyyy');

    return format.format(date);
  }

  static String getCurrentTimeHHmmss() {
    final date = DateTime.now();
    final format = DateFormat('HH:mm:ss');

    return format.format(date);
  }

  static String getCurrentTimeHHmm() {
    final date = DateTime.now();
    final format = DateFormat('HH:mm');

    return format.format(date);
  }

  static String numberFormat(num number) {
    final oCcy = NumberFormat("#,##0", "en_US");
    return oCcy.format(number);
  }

  static String formatStringDateddMMMMyyyy(String source) {
    final date = DateFormat('yyyy-MM-dd').parse(source);
    return DateFormat('dd MMMM yyyy').format(date);
  }

  static Future<void> storeToSecureStorage(
      {required String key, required String data}) async {
    const storage = FlutterSecureStorage();
    await storage.write(key: key, value: data);
  }

  static Future<String?> readFromSecureStorage({required String key}) async {
    const storage = FlutterSecureStorage();
    return await storage.read(key: key);
  }

  static Future clearSecureStorage() async {
    const storage = FlutterSecureStorage();
    await storage.deleteAll();
  }

  static bool isPasswordFormatValid({required String password}) {
    final numberRegex = RegExp(r'[0-9]');
    final specialCharRegex =
        RegExp(r'[\^$*.\[\]{}()?\-"!@#%&/\,><:;_~`+=' "'" ']');
    final letterRegex = RegExp(r"(?=.*[a-z])(?=.*[A-Z])\w+");

    if (!numberRegex.hasMatch(password) ||
        !specialCharRegex.hasMatch(password) ||
        !letterRegex.hasMatch(password)) {
      return false;
    } else {
      return true;
    }
  }

  static String getAssetImage({required String imageName}) {
    return 'assets/$imageName';
  }

  static dynamic getJsonFromAsset(
      {required BuildContext context, required String path}) async {
    String data = await DefaultAssetBundle.of(context).loadString(path);
    return jsonDecode(data);
  }
}
