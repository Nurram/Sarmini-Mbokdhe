import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:sarmini_mbokdhe/core_imports.dart';
import 'package:sarmini_mbokdhe/features/checkout/checkout_controller.dart';
import 'package:sarmini_mbokdhe/widgets/custom_divider.dart';

import '../../network/api_provider.dart';

class CheckoutScreen extends GetView<CheckoutController> {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                const CustomDivider(),
                _buildAddress(),
                const CustomDivider(),
                ListTile(
                  title: Row(
                    children: [
                      Text(
                        'Ongkos kirim',
                        style: CustomTextStyle.black(),
                      ),
                      const Spacer(),
                      Obx(
                        () => Text(
                          controller.serviceFee.value,
                          style: CustomTextStyle.black(),
                        ),
                      ),
                    ],
                  ),
                ),
                const CustomDivider(),
                _buildProductItem(),
                const CustomDivider(),
                InkWell(
                  onTap: _showVoucherBottomSheet,
                  child: Padding(
                    padding: EdgeInsets.all(16.dp),
                    child: Row(
                      children: [
                        const Icon(Icons.airplane_ticket_outlined,
                            color: CustomColors.primaryColor),
                        SizedBox(width: 16.dp),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.selectedVoucher.value != null
                                  ? 'Voucher yang dimasukan'
                                  : 'Masukan Voucher',
                              style: CustomTextStyle.primary(),
                            ),
                            Obx(
                              () => controller.inputtedVoucher.value != null
                                  ? Text(controller.inputtedVoucher.value!)
                                  : const SizedBox(),
                            )
                          ],
                        ),
                        const Spacer(),
                        const Icon(Icons.arrow_forward_ios,
                            color: CustomColors.primaryColor)
                      ],
                    ),
                  ),
                ),
                const CustomDivider(),
                Padding(
                  padding: EdgeInsets.all(16.dp),
                  child: Row(
                    children: [
                      const Icon(Icons.edit, color: CustomColors.primaryColor),
                      SizedBox(width: 16.dp),
                      Expanded(
                        child: TextFormField(
                          controller: controller.notesCtr,
                          decoration: const InputDecoration(
                              hintText: 'Catatan',
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none),
                        ),
                      )
                    ],
                  ),
                ),
                const CustomDivider(),
                _buildPayment(),
              ],
            ),
          ),
          const CustomDivider(),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.dp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Total pembayaran:'),
                      Obx(
                        () => Text(
                          'Rp${Utils.numberFormat(controller.total.value)}',
                          style: CustomTextStyle.primary14w600(),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Obx(
                  () => CustomElevatedButton(
                    text: 'Bayar',
                    isLoading: controller.isBuyLoading.value,
                    onPressed: () {
                      controller.buy();
                    },
                    bgColor: CustomColors.primaryColor,
                    borderRadius: 0,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildAddress() {
    final address = controller.address.value;

    return InkWell(
      onTap: () {
        controller.showAddressBottomSheet(context: Get.context!);
      },
      child: Padding(
        padding: EdgeInsets.all(16.dp),
        child: Obx(
          () => Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 14.dp,
                  ),
                  SizedBox(width: 8.dp),
                  Expanded(
                    child: Text(
                      'Alamat Pengiriman',
                      style: CustomTextStyle.black(),
                    ),
                  )
                ],
              ),
              SizedBox(height: 8.dp),
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    color: Colors.white,
                    size: 14.dp,
                  ),
                  SizedBox(width: 8.dp),
                  Expanded(
                    child: Text(
                      '${address?.receipient} | ${address?.phoneNumber}',
                      style: CustomTextStyle.black(),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    color: Colors.white,
                    size: 14.dp,
                  ),
                  SizedBox(width: 8.dp),
                  Expanded(
                    child: Text(
                      '${controller.address.value!.address}, '
                      '${controller.address.value!.district}, '
                      '${controller.address.value!.regency}, '
                      '${controller.address.value!.province}, '
                      '${controller.address.value!.postalCode}',
                      style: CustomTextStyle.black(),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductItem() {
    final product = controller.detailController.selectedProduct.value!;

    return Padding(
      padding: EdgeInsets.all(16.dp),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  '${ApiProvider().baseUrl}/${product.file}',
                  height: 80.dp,
                  width: 80.dp,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.dp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: CustomTextStyle.black14w600(),
                      ),
                      SizedBox(height: 8.dp),
                      Row(
                        children: [
                          Text(
                            'x${controller.detailController.qty.value}',
                            style: CustomTextStyle.black11w400(),
                          ),
                          const Spacer(),
                          Text(
                            'Rp${product.price}',
                            style: CustomTextStyle.black11w400(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _showVoucherBottomSheet() {
    controller.voucherNode.requestFocus();

    showModalBottomSheet(
      context: Get.context!,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(16.dp),
          child: Column(
            children: [
              TextFormField(
                controller: controller.voucherCtr,
                focusNode: controller.voucherNode,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Masukan kode voucher'),
              ),
              SizedBox(height: 24.dp),
              Obx(
                () => CustomElevatedButton(
                  text: 'Masukan',
                  isLoading: controller.isLoading.value,
                  onPressed: () {
                    controller.setVoucher();
                  },
                  bgColor: CustomColors.primaryColor,
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildPayment() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 16.dp, top: 16.dp, right: 16.dp),
          child: Text(
            'Pilih Metode Pembayaran',
            style: CustomTextStyle.black14w600(),
          ),
        ),
        Obx(
          () => RadioListTile(
            value: 'Transfer',
            title: const Text('Transfer'),
            fillColor: MaterialStateProperty.all(CustomColors.primaryColor),
            groupValue: controller.selectedPayment.value,
            onChanged: (value) => controller.selectedPayment(value),
          ),
        ),
        Obx(
          () => RadioListTile(
            value: 'Saldo',
            title: const Text('Saldo'),
            fillColor: MaterialStateProperty.all(CustomColors.primaryColor),
            groupValue: controller.selectedPayment.value,
            onChanged: (value) => controller.selectedPayment(value),
          ),
        ),
      ],
    );
  }
}
