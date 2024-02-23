import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:sarmini_mbokdhe/core_imports.dart';
import 'package:sarmini_mbokdhe/features/login/login_controller.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
        foregroundColor: CustomColors.primaryColor,
        backgroundColor: CustomColors.primaryColor.withAlpha(50),
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: CustomColors.primaryColor.withAlpha(50),
          ),
          Padding(
            padding: EdgeInsets.all(16.dp),
            child: ListView(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 120.dp,
                    height: 120.dp,
                  ),
                ),
                SizedBox(height: 32.dp),
                Text(
                  'Selamat Datang',
                  style: CustomTextStyle.black16w700(),
                ),
                SizedBox(height: 8.dp),
                Text(
                  'Masukan nomor whatsapp anda untuk lanjut',
                  style: CustomTextStyle.black12w400(),
                ),
                SizedBox(height: 24.dp),
                CustomTextFormField(
                  controller: controller.phoneCtr,
                  hint: '08xxxxxxxxxx',
                  inputType: TextInputType.number,
                ),
                SizedBox(height: 24.dp),
                Obx(
                  () => CustomElevatedButton(
                    text: 'Lanjut',
                    onPressed: controller.sendOtp,
                    bgColor: CustomColors.primaryColor,
                    isLoading: controller.isLoading.value,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
