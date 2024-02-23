import '../../core_imports.dart';
import 'splash_controller.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    controller.onInit();

    return Scaffold(
      backgroundColor: CustomColors.primaryColor,
      body: Center(
        child: Image.asset(
          'assets/images/logo.png',
          width: 240,
          height: 240,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
