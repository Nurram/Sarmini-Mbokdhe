import 'package:flutter/services.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:sarmini_mbokdhe/core_imports.dart';
import 'package:sarmini_mbokdhe/features/topup_payment/topup_payment_controller.dart';
import 'package:skeletonizer/skeletonizer.dart';

class TopupPaymentScreen extends GetView<TopupPaymentController> {
  const TopupPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran'),
      ),
      body: Obx(
        () => Skeletonizer(
          enabled: controller.isLoading.value,
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(16.dp),
                  child: ListView(
                    children: [
                      Text(
                        'Total Tagihan',
                        style: CustomTextStyle.black14w600(),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.dp),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.getTopup == null
                                  ? ''
                                  : 'Rp${Utils.numberFormat(controller.getTopup!.amount)}',
                              style: CustomTextStyle.primary24W700(),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.dp),
                      Text(
                        'Petunjuk Pembayaran:',
                        style: CustomTextStyle.black14w600(),
                      ),
                      SizedBox(height: 16.dp),
                      const Text(
                          '1. Silahkan transfer sesuai nominal tagihan anda ke bank berikut:'),
                      SizedBox(height: 12.dp),
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/bank.png',
                            width: 30.w,
                          ),
                          SizedBox(width: 8.dp),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.bankNo.value,
                                style: CustomTextStyle.black14w600(),
                              ),
                              Text(
                                'A.n ${controller.bankPerson.value}',
                                style: CustomTextStyle.black12w400(),
                              ),
                            ],
                          ),
                          SizedBox(width: 8.dp),
                          SizedBox(
                            width: 16.dp,
                            height: 16.dp,
                            child: InkWell(
                              onTap: () async {
                                await Clipboard.setData(
                                  ClipboardData(text: controller.bankNo.value),
                                );
                                Utils.showGetSnackbar(
                                    'Copied to clipboard!', true);
                                // copied successfully
                              },
                              child: Icon(
                                Icons.copy,
                                size: 16.dp,
                                color: CustomColors.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.dp),
                      const Text(
                          '2. Silahkan upload bukti pembayaran anda dengan menekan tombol dibawah:'),
                      SizedBox(height: 8.dp),
                      CustomOutlinedButton(
                        onPressed: () {
                          controller.pickImage();
                        },
                        text: 'Pilih Gambar',
                        borderColor: Colors.green.shade600,
                        textColor: Colors.green.shade600,
                      ),
                      SizedBox(height: 8.dp),
                      Visibility(
                        visible: controller.selectedImage.value != null,
                        child: Text(
                          'Pratinjau',
                          style: CustomTextStyle.black14w600(),
                        ),
                      ),
                      SizedBox(height: 4.dp),
                      controller.selectedImage.value != null
                          ? Image.file(
                              File(controller.selectedImage.value!.path),
                            )
                          : const SizedBox(),
                      SizedBox(height: 16.dp),
                      Visibility(
                        visible: controller.selectedImage.value != null,
                        child: const Text(
                            '2. Setelah selesai memilih bukti pembayaran anda, silahkan tekan tombol "Saya sudah membayar" dibawah'),
                      ),
                      SizedBox(height: 8.dp),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: controller.selectedImage.value != null,
                child: CustomElevatedButton(
                  onPressed: controller.changeStatus,
                  text: 'Saya sudah membayar',
                  bgColor: CustomColors.primaryColor,
                  borderRadius: 0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
