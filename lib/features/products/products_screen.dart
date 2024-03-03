import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:sarmini_mbokdhe/core_imports.dart';
import 'package:sarmini_mbokdhe/widgets/product_item.dart';

import 'products_controller.dart';

class ProductsScreen extends GetView<ProductsController> {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produk'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.dp),
        child: RefreshIndicator(
          onRefresh: () => controller.getProducts(),
          child: Obx(
            () => controller.products.isEmpty
                ? ListView(
                    children: const [
                      EmptyWidget(
                        image: 'assets/images/empty.png',
                      )
                    ],
                  )
                : ListView(
                    children: [
                      SizedBox(height: 16.dp),
                      Obx(
                        () => Text(
                          'Menampilkan hasil ${controller.products.length} produk',
                          style: CustomTextStyle.black12w600(),
                        ),
                      ),
                      SizedBox(height: 16.dp),
                      controller.products.isNotEmpty
                          ? Wrap(
                              spacing: 7.dp,
                              runSpacing: 7.dp,
                              children: [
                                ...List.generate(
                                  controller.products.length,
                                  (index) => ProductItem(
                                      index: index,
                                      datum: controller.products[index]),
                                )
                              ],
                            )
                          : const SizedBox()
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
