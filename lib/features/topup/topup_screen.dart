import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sarmini_mbokdhe/core_imports.dart';
import 'package:sarmini_mbokdhe/features/add_topup/add_topup_binding.dart';
import 'package:sarmini_mbokdhe/features/add_topup/add_topup_screen.dart';
import 'package:sarmini_mbokdhe/features/topup/topup_controller.dart';
import 'package:sarmini_mbokdhe/features/topup_payment/topup_payment_binding.dart';
import 'package:sarmini_mbokdhe/features/topup_payment/topup_payment_screen.dart';
import 'package:sarmini_mbokdhe/widgets/custom_divider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class TopupScreen extends GetView<TopupController> {
  const TopupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Topup'),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => controller.getHistories(),
              child: ListView(
                children: [
                  _buildItem(
                    children: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Saldo anda'),
                        SizedBox(height: 8.dp),
                        Obx(
                          () => Skeletonizer(
                            enabled: controller.isLoading.value,
                            child: Text(
                              'Rp${Utils.numberFormat(controller.isLoading.value ? 0 : controller.user.value!.balance)}',
                              style: CustomTextStyle.black20w600(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const CustomDivider(height: 8),
                  Padding(
                    padding: EdgeInsets.only(left: 16.dp, top: 16.dp),
                    child: Text(
                      'Riwayat Topup',
                      style: CustomTextStyle.black14w600(),
                    ),
                  ),
                  SizedBox(height: 16.dp),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.dp),
                    child: Obx(
                      () => Skeletonizer(
                        enabled: controller.isLoading.value,
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 12.dp),
                          itemCount: controller.isLoading.value
                              ? 5
                              : controller.histories.length,
                          itemBuilder: (context, index) =>
                              controller.isLoading.value
                                  ? _buildLoadingItem()
                                  : _buildHistoryItem(index: index),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          CustomElevatedButton(
            text: 'Topup',
            onPressed: () {
              Get.to(
                () => const AddTopupScreen(),
                binding: AddTopupBinding(),
              )?.then((value) {
                if (value != null) {
                  controller.getHistories();
                }
              });
            },
            borderRadius: 0,
            bgColor: CustomColors.primaryColor,
          )
        ],
      ),
    );
  }

  Widget _buildItem({required Widget children}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24.dp, horizontal: 16.dp),
      child: children,
    );
  }

  Widget _buildHistoryItem({required int index}) {
    final data = controller.histories[index];

    return Card(
      surfaceTintColor: Colors.white,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.dp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '+Rp${Utils.numberFormat(data.amount)}',
                      style: CustomTextStyle.black16w700(),
                    ),
                    const Spacer(),
                    Text(
                      data.status == 'Waiting'
                          ? 'Sedang Diproses'
                          : data.status == 'Unpaid'
                              ? 'Menunggu Pembayaran'
                              : data.status,
                      textAlign: TextAlign.end,
                      style: GoogleFonts.inter(
                        color: data.status == 'Selesai'
                            ? Colors.blue
                            : data.status == 'Waiting'
                                ? CustomColors.primaryColor
                                : data.status == 'Ditolak'
                                    ? Colors.red
                                    : Colors.amber,
                        fontSize: 10.dp,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.dp),
                Text(
                  Utils.formatDate(
                      pattern: 'dd MMMM yyyy', date: data.createdAt),
                  style: CustomTextStyle.grey10w400(),
                ),
              ],
            ),
          ),
          Visibility(
            visible: data.status == 'Unpaid',
            child: InkWell(
              onTap: () {
                Get.to(
                  () => const TopupPaymentScreen(),
                  binding: TopupPaymentBinding(),
                  arguments: data,
                )?.then((value) {
                  if (value != null) {
                    controller.getHistories();
                  }
                });
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(8.dp),
                decoration: BoxDecoration(
                  color: CustomColors.primaryColor.withAlpha(50),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Bayar sekarang',
                    style: CustomTextStyle.primary(),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildLoadingItem() {
    return Card(
      surfaceTintColor: Colors.white,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(16.dp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '+Rp1.000.000',
                  style: CustomTextStyle.black16w700(),
                ),
                const Spacer(),
                Text(
                  'Berhasil',
                  textAlign: TextAlign.end,
                  style: GoogleFonts.inter(
                    color: Colors.blue,
                    fontSize: 10.dp,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.dp),
            Text(
              '12 Januari 2024',
              style: CustomTextStyle.grey10w400(),
            )
          ],
        ),
      ),
    );
  }
}
