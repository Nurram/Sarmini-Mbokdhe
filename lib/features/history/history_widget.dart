import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sarmini_mbokdhe/core_imports.dart';
import 'package:sarmini_mbokdhe/features/payment/payment_binding.dart';
import 'package:sarmini_mbokdhe/features/payment/payment_screen.dart';
import 'package:sarmini_mbokdhe/features/history/history_controller.dart';
import 'package:sarmini_mbokdhe/models/order_response.dart';
import 'package:sarmini_mbokdhe/network/api_provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HistoryWidget extends GetView<HistoryController> {
  const HistoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Pesanan'),
      ),
      body: Padding(
        padding: EdgeInsets.only(right: 16.dp, left: 16.dp),
        child: Obx(
          () => Skeletonizer(
            enabled: controller.isLoading.value,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                DropdownButton(
                  value: controller.selectedType.value,
                  items: controller.types
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(e == 'Unpaid'
                              ? 'Menunggu Pembayaran'
                              : e == 'Waiting'
                                  ? 'Sedang Diproses'
                                  : e),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      controller.setSelectedType(type: value);
                    }
                  },
                ),
                SizedBox(height: 16.dp),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => controller.getOrders(),
                    child: controller.histories.isEmpty
                        ? ListView(
                            children: const [EmptyWidget()],
                          )
                        : ListView.separated(
                            itemBuilder: (context, index) =>
                                controller.isLoading.value
                                    ? _buildLoadingItem(index: index)
                                    : _buildHistoryItem(index: index),
                            separatorBuilder: (context, index) =>
                                SizedBox(height: 8.dp),
                            itemCount: controller.isLoading.value
                                ? 5
                                : controller.histories.length,
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryItem({required int index}) {
    OrderDatum history = controller.histories[index];
    List<OrderProduct> products = history.products;

    return Card(
      surfaceTintColor: Colors.white,
      child: Column(
        children: [
          ...products.map((e) {
            return Padding(
              padding: EdgeInsets.only(
                  top: history.products.indexOf(e) == 1 ? 12 : 0),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(8),
                      bottomLeft: Radius.circular(history.status == 'Unpaid'
                          ? products.length - 1 == history.products.indexOf(e)
                              ? 0
                              : 8
                          : 8),
                    ),
                    child: Image.network(
                      '${ApiProvider().baseUrl}/${e.file}',
                      width: 80.dp,
                      height: 80.dp,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.dp),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  e.name,
                                  style: CustomTextStyle.black11w600(),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Rp${Utils.numberFormat(e.price)}',
                                  textAlign: TextAlign.end,
                                  style: CustomTextStyle.black11w600(),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4.dp),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  'Jumlah: ${Utils.numberFormat(e.qty)}',
                                  style: CustomTextStyle.black10w400(),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  history.status == 'Unpaid'
                                      ? 'Menunggu Pembayaran'
                                      : history.status == 'Waiting'
                                          ? 'Sedang diproses'
                                          : history.status,
                                  textAlign: TextAlign.end,
                                  style: GoogleFonts.inter(
                                    color: history.status == 'Dikirim'
                                        ? Colors.blue
                                        : history.status == 'Waiting'
                                            ? CustomColors.primaryColor
                                            : Colors.amber,
                                    fontSize: 10.dp,
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 8.dp),
                          Text(
                            Utils.formatDate(
                              pattern: 'dd MMMM yyyy',
                              date: history.createdAt,
                            ),
                            style: CustomTextStyle.black10w400(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          Visibility(
            visible: history.status == 'Unpaid',
            child: InkWell(
              onTap: () {
                Get.to(
                  () => const PaymentScreen(),
                  binding: PaymentBinding(),
                  arguments: history,
                )?.then((value) {
                  if (value != null) controller.getOrders();
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

  Widget _buildLoadingItem({required int index}) {
    return Card(
      surfaceTintColor: Colors.white,
      child: Column(
        children: [
          ...[0].map((e) {
            return Padding(
              padding: EdgeInsets.only(top: 12.dp),
              child: Row(
                children: [
                  Container(
                    width: 80.dp,
                    height: 80.dp,
                    decoration: BoxDecoration(
                      color: CustomColors.primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.dp),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '',
                                  style: CustomTextStyle.black11w600(),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Rp0',
                                  textAlign: TextAlign.end,
                                  style: CustomTextStyle.black11w600(),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4.dp),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  'Jumlah:',
                                  style: CustomTextStyle.black10w400(),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  '',
                                  textAlign: TextAlign.end,
                                  style: GoogleFonts.inter(
                                    fontSize: 10.dp,
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 8.dp),
                          Text(
                            '',
                            style: CustomTextStyle.black10w400(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          InkWell(
            onTap: null,
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
          )
        ],
      ),
    );
  }
}
