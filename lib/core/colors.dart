import '../core_imports.dart';

class CustomColors {
  static const primaryColor = Color(0XFF6fc276);
  static const secondaryColor = Color(0xFF6fc2a0);
  static const scaffoldColor = Color(0xffffffff);
  static const errorColor = Colors.red;
  static const color30 = Color.fromARGB(255, 30, 30, 30);
  static const colorF6 = Color(0xffF6F6F6);
  static const color9A = Color(0xff9A9A9A);

  static MaterialColor getPrimarySwatch() {
    const color = CustomColors.primaryColor;

    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }

    return MaterialColor(color.value, swatch);
  }
}
