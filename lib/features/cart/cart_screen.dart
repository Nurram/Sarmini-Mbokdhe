import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:sarmini_mbokdhe/core_imports.dart';
import 'package:sarmini_mbokdhe/features/cart/cart_controller.dart';
import 'package:sarmini_mbokdhe/network/api_provider.dart';
import 'package:sarmini_mbokdhe/widgets/custom_divider.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../checkout_cart/checkout_cart_binding.dart';
import '../checkout_cart/checkout_cart_screen.dart';

class CartScreen extends GetView<CartController> {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        actions: [
          Obx(
            () => Visibility(
              visible: controller.selectMode.value,
              child: IconButton(
                onPressed: () => controller.delete(),
                icon: const Icon(Icons.delete_outline),
              ),
            ),
          ),
          Obx(
            () => Visibility(
              visible: controller.selectMode.value,
              child: Checkbox(
                value: controller.allSelected.value,
                onChanged: (value) {
                  controller.allSelected(value);
                  controller.setAllSelected();
                },
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 16.dp, top: 16.dp, right: 16.dp),
              child: Obx(
                () => RefreshIndicator(
                  onRefresh: () => controller.getCarts(),
                  child: Skeletonizer(
                    enabled: controller.isLoading.value,
                    child: controller.carts.isEmpty
                        ? ListView(
                            children: const [EmptyWidget()],
                          )
                        : ListView.separated(
                            itemBuilder: (context, index) {
                              return InkWell(
                                onLongPress: () {
                                  if (!controller.selectMode.value) {
                                    controller.setSelected(index: index);
                                    controller.selectMode(true);
                                  }
                                },
                                onTap: () {
                                  if (controller.selectMode.value) {
                                    controller.setSelected(index: index);
                                  }
                                },
                                child: _buildCartItem(index: index),
                              );
                            },
                            separatorBuilder: (context, index) => SizedBox(
                                  height: 12.dp,
                                ),
                            itemCount: controller.isLoading.value
                                ? 5
                                : controller.carts.length),
                  ),
                ),
              ),
            ),
          ),
          const CustomDivider(),
          Obx(
            () => controller.carts.isEmpty
                ? const SizedBox()
                : Visibility(
                    visible: controller.selectMode.value,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.dp),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Total:'),
                                Text(
                                  'Rp${Utils.numberFormat(controller.getTotalPrice())}',
                                  style: CustomTextStyle.primary14w600(),
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: CustomElevatedButton(
                            text: 'Bayar',
                            onPressed: () {
                              Get.to(
                                () => const CheckoutCartScreen(),
                                binding: CheckoutCartBinding(),
                                arguments: controller.carts,
                              )?.then(
                                (value) => controller.getCarts(),
                              );
                            },
                            bgColor: CustomColors.primaryColor,
                            borderRadius: 0,
                          ),
                        )
                      ],
                    ),
                  ),
          )
        ],
      ),
    );
  }

  Widget _buildCartItem({required int index}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.dp),
          child: controller.isLoading.value
              ? Image.asset(
                  'assets/images/logo.png',
                  width: 80.dp,
                  height: 80.dp,
                  fit: BoxFit.cover,
                )
              : Image.network(
                  '${ApiProvider().baseUrl}/'
                  '${controller.carts[index].file}',
                  width: 80.dp,
                  height: 80.dp,
                  fit: BoxFit.cover,
                ),
        ),
        SizedBox(width: 12.dp),
        Expanded(
          child: Container(
            height: 90.dp,
            margin: EdgeInsets.symmetric(horizontal: 4.dp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 2.dp),
                Row(
                  children: [
                    Text(
                      'Rp${Utils.numberFormat(controller.isLoading.value ? 9000 : controller.carts[index].price)}',
                      style: CustomTextStyle.black14w600(),
                    ),
                    Text(
                      '/${controller.isLoading.value ? 'gram' : controller.carts[index].unit}',
                      style: CustomTextStyle.black11w400(),
                    ),
                    const Spacer(),
                    Visibility(
                      visible: controller.isLoading.value
                          ? true
                          : controller.carts[index].selected,
                      child: const Icon(
                        Icons.check_circle_outline_outlined,
                        color: CustomColors.primaryColor,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 4.dp),
                Text(
                  controller.isLoading.value
                      ? ''
                      : controller.carts[index].name,
                  maxLines: 2,
                  style: CustomTextStyle.black12w400(),
                ),
                Row(
                  children: [
                    const Text('Jumlah'),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        controller.addQty(value: -1, index: index);
                      },
                      icon: Icon(
                        Icons.remove,
                        size: 12.sp,
                      ),
                    ),
                    Text(
                      controller.isLoading.value
                          ? '1'
                          : controller.carts[index].cartQty.toString(),
                      style: CustomTextStyle.black12w400(),
                    ),
                    IconButton(
                      onPressed: () {
                        controller.addQty(value: 1, index: index);
                      },
                      icon: Icon(
                        Icons.add,
                        size: 12.sp,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
