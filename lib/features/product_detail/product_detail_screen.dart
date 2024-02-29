import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:sarmini_mbokdhe/core_imports.dart';
import 'package:sarmini_mbokdhe/features/login/login_binding.dart';
import 'package:sarmini_mbokdhe/features/login/login_screen.dart';
import 'package:sarmini_mbokdhe/features/product_detail/product_detail_controller.dart';
import 'package:sarmini_mbokdhe/network/api_provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../widgets/custom_divider.dart';
import '../chat_room/chat_room_binding.dart';
import '../chat_room/chat_room_screen.dart';

class ProductDetailScreen extends GetView<ProductDetailController> {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Text(controller.selectedProduct.value!.name),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => Skeletonizer(
                enabled: controller.isLoading.value,
                child: RefreshIndicator(
                  onRefresh: () => controller.getDetail(),
                  child: ListView(
                    children: [
                      _buildHeader(),
                      const CustomDivider(),
                      _buildDescription(),
                      const SizedBox(height: 32)
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: .5.dp,
            color: CustomColors.primaryColor,
          ),
          Row(
            children: [
              _buildButtons(
                outlined: true,
                child: const Icon(
                  Icons.chat_outlined,
                  color: CustomColors.primaryColor,
                ),
                onTap: () {
                  Get.to(
                    () => const ChatRoomScreen(),
                    binding: ChatRoomBinding(),
                    arguments: controller.selectedProduct.value!.id,
                  );
                },
              ),
              Container(
                width: .5.dp,
                height: 48.dp,
                color: CustomColors.primaryColor,
              ),
              _buildButtons(
                outlined: true,
                child: const Icon(
                  Icons.add_shopping_cart,
                  color: CustomColors.primaryColor,
                ),
                onTap: controller.addToCart,
              ),
              _buildButtons(
                outlined: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Checkout',
                      style: CustomTextStyle.white(),
                    )
                  ],
                ),
                onTap: _showQtyBottomSheet,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final product = controller.selectedProduct.value;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        controller.isLoading.value
            ? Container(
                width: 100.w,
                height: 100.w,
                color: CustomColors.primaryColor,
              )
            : Image.network(
                '${ApiProvider().baseUrl}/${product!.file}',
                height: 100.w,
                width: 100.w,
                fit: BoxFit.cover,
              ),
        Container(
          padding: EdgeInsets.all(16.dp),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Rp${Utils.numberFormat(product!.price)}',
                    style: CustomTextStyle.black16w700(),
                  ),
                  Text(
                    '/${product.unit}',
                    style: CustomTextStyle.black11w400(),
                  ),
                ],
              ),
              SizedBox(height: 8.dp),
              Text(
                product.name,
                style: CustomTextStyle.black16w400(),
              )
            ],
          ),
        ),
        InkWell(
          onTap: () {
            controller.predictFee();
          },
          child: Container(
            width: double.infinity,
            height: 24.dp,
            padding: EdgeInsets.symmetric(horizontal: 16.dp),
            color: CustomColors.primaryColor.withAlpha(40),
            child: Center(
              child: Row(
                children: [
                  Icon(
                    Icons.delivery_dining_outlined,
                    color: Colors.green.shade600,
                  ),
                  SizedBox(width: 8.dp),
                  Text(
                    controller.serviceFee.value == '0'
                        ? 'Cek Ongkos Kirim'
                        : 'Perkiraan Ongkos kirim: ${controller.serviceFee.value}',
                    style: TextStyle(color: Colors.green.shade600),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  _buildDescription() {
    final product = controller.selectedProduct.value!;

    return Padding(
      padding: EdgeInsets.all(16.dp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Table(
            children: [
              TableRow(children: [
                Text(
                  'Berat',
                  style: CustomTextStyle.black12w400(),
                ),
                Text(
                  product.weight,
                  style: CustomTextStyle.black12w400(),
                ),
              ]),
              const TableRow(children: [
                Text(''),
                Text(''),
              ]),
              TableRow(children: [
                Text(
                  'Stok',
                  style: CustomTextStyle.black12w400(),
                ),
                Text(
                  product.stock > 0
                      ? Utils.numberFormat(product.stock)
                      : 'Stok Habis',
                  style: CustomTextStyle.black12w400(),
                ),
              ]),
            ],
          ),
          SizedBox(height: 24.dp),
          Text(product.description)
        ],
      ),
    );
  }

  _buildButtons(
      {required bool outlined,
      required Widget child,
      required Function() onTap}) {
    return Expanded(
      child: InkWell(
        onTap: () async {
          if (await controller.isLoggedIn()) {
            onTap();
          } else {
            _showLoginDialog();
          }
        },
        child: Container(
          height: 48.dp,
          decoration: BoxDecoration(
            color: outlined ? Colors.white : CustomColors.primaryColor,
          ),
          child: Center(
            child: child,
          ),
        ),
      ),
    );
  }

  _showLoginDialog() {
    showDialog(
      context: Get.context!,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.dp),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Untuk menggunakan fitur ini anda harus login',
                style: CustomTextStyle.black(),
              ),
              SizedBox(
                height: 12.dp,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Get.back(),
                      child: Text(
                        'Batalkan',
                        style: CustomTextStyle.red(),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Get.to(
                          () => const LoginScreen(),
                          binding: LoginBinding(),
                        );
                      },
                      child: Text(
                        'Login',
                        style: CustomTextStyle.primary(),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _showQtyBottomSheet() {
    final product = controller.selectedProduct.value!;

    showModalBottomSheet(
      context: Get.context!,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(16.dp),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 80.dp,
                    height: 80.dp,
                    color: CustomColors.primaryColor,
                  ),
                  SizedBox(width: 8.dp),
                  Column(
                    children: [
                      Text(
                        'Rp${Utils.numberFormat(product.price)}',
                        style: CustomTextStyle.primary(),
                      ),
                      Text(
                        'Stock: ${product.stock > 0 ? Utils.numberFormat(product.stock) : 'Stok Habis'}',
                        style: CustomTextStyle.black11w400(),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: .5,
              color: Colors.grey,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.dp),
              child: Row(
                children: [
                  const Text('Jumlah'),
                  const Spacer(),
                  IconButton(
                    onPressed: controller.reduceQty,
                    icon: Icon(
                      Icons.remove,
                      size: 12.dp,
                    ),
                  ),
                  Obx(
                    () => Text(
                      controller.qty.string,
                      style: CustomTextStyle.black12w400(),
                    ),
                  ),
                  IconButton(
                    onPressed: controller.addQty,
                    icon: Icon(
                      Icons.add,
                      size: 12.dp,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.dp),
            Obx(
              () => CustomElevatedButton(
                text: 'Checkout Sekarang',
                isLoading: controller.isStockLoading.value,
                onPressed: () {
                  controller.checkStock();
                },
                borderRadius: 0,
                bgColor: CustomColors.primaryColor,
                padding: EdgeInsets.symmetric(vertical: 12.dp),
              ),
            )
          ],
        );
      },
    );
  }
}
