import 'package:flutter/widgets.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:sarmini_mbokdhe/core_imports.dart';
import 'package:sarmini_mbokdhe/features/voucher_detail/voucher_detail_screen.dart';
import 'package:sarmini_mbokdhe/features/vouchers/voucher_controller.dart';
import 'package:sarmini_mbokdhe/network/api_provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class VouchersScreen extends GetView<VoucherController> {
  const VouchersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vouchers'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.dp),
        child: Obx(
          () => Skeletonizer(
            enabled: controller.isLoading.value,
            child: RefreshIndicator(
              onRefresh: () => controller.getVouchers(),
              child: ListView.separated(
                  itemBuilder: (context, index) =>
                      _buildVoucherItem(index: index),
                  separatorBuilder: (context, index) => SizedBox(
                        height: 12.dp,
                      ),
                  itemCount: controller.vouchers.isNotEmpty
                      ? controller.vouchers.length
                      : 5),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVoucherItem({required int index}) {
    return InkWell(
      onTap: () {
        Get.to(() => const VoucherDetail(),
            arguments: controller.vouchers[index]);
      },
      child: Container(
        width: 160.dp,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: controller.isLoading.value
                    ? Image.asset(
                        'assets/images/logo.png',
                        width: double.infinity,
                        height: 90.dp,
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        '${ApiProvider().baseUrl}/${controller.vouchers[index].image}',
                        height: 90.dp,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.dp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.isLoading.value
                        ? 'Test Promo'
                        : controller.vouchers[index].title,
                    style: CustomTextStyle.black14w600(),
                  ),
                  SizedBox(height: 4.dp),
                  Text(
                    controller.isLoading.value
                        ? '01 Januari 2024 - 31 Januari 2024'
                        : '${Utils.formatDate(pattern: 'dd MMMM yyyy', date: controller.vouchers[index].validFrom)} -'
                            ' ${Utils.formatDate(pattern: 'dd MMMM yyyy', date: controller.vouchers[index].validTo)}',
                    style: CustomTextStyle.grey12w400(),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
