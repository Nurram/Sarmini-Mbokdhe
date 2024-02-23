import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:sarmini_mbokdhe/core_imports.dart';
import 'package:sarmini_mbokdhe/widgets/product_item.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'search_category_controller.dart';

class SearchCategoryScreen extends GetView<SearchCategoryController> {
  const SearchCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Text(controller.selectedCategory.value!.name),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.dp),
        child: RefreshIndicator(
          onRefresh: () => controller.getProductByCategory(),
          child: Obx(
            () => ListView(
              children: [
                SizedBox(height: 16.dp),
                Text(
                  'Menampilkan hasil ${controller.products.length} produk',
                  style: CustomTextStyle.black12w600(),
                ),
                SizedBox(height: 16.dp),
                Skeletonizer(
                  enabled: controller.isLoading.value,
                  child: controller.products.isEmpty
                      ? const EmptyWidget()
                      : Wrap(
                          spacing: 7.dp,
                          runSpacing: 7.dp,
                          children: [
                            ...List.generate(
                              controller.isLoading.value
                                  ? 5
                                  : controller.products.length,
                              (index) => ProductItem(
                                index: index,
                                datum: controller.isLoading.value
                                    ? null
                                    : controller.products[index],
                              ),
                            )
                          ],
                        ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
