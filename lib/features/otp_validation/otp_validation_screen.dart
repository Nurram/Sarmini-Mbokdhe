import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:sarmini_mbokdhe/core_imports.dart';
import 'package:sarmini_mbokdhe/features/otp_validation/otp_validation_controller.dart';

class OtpValidationScreen extends GetView<OtpValidationController> {
  const OtpValidationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verifikasi'),
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
                SizedBox(height: 32.dp),
                Text(
                  'Silahkan Masukan Kode OTP Anda',
                  style: CustomTextStyle.black12w400(),
                ),
                SizedBox(height: 24.dp),
                CustomTextFormField(
                  controller: controller.otpCtr,
                  inputType: TextInputType.number,
                ),
                SizedBox(height: 24.dp),
                Obx(
                  () => CustomElevatedButton(
                    text: 'Lanjut',
                    onPressed: controller.validateOtp,
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
