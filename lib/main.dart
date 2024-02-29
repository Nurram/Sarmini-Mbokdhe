import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:sarmini_mbokdhe/features/splash/splash_screen.dart';

import 'core_imports.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FlutterSizer(
      builder: (p0, p1, p2) => GetMaterialApp(
        title: 'Sarmini Mbokdhe',
        theme: ThemeData(
          primarySwatch: CustomColors.getPrimarySwatch(),
        ),
        initialBinding: MainBinding(),
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}
