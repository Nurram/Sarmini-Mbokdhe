import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:sarmini_mbokdhe/core_imports.dart';
import 'package:sarmini_mbokdhe/features/search_result/search_result_controller.dart';
import 'package:sarmini_mbokdhe/widgets/product_item.dart';

class SearchResultScreen extends GetView<SearchResultController> {
  const SearchResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Text(controller.title.value),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.dp),
        child: RefreshIndicator(
          onRefresh: () => controller.getProductByName(),
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
