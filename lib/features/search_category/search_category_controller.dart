import 'package:sarmini_mbokdhe/core_imports.dart';
import 'package:sarmini_mbokdhe/models/category_response.dart';
import 'package:sarmini_mbokdhe/models/product_response.dart';
import 'package:sarmini_mbokdhe/network/api_provider.dart';

class SearchCategoryController extends BaseController {
  final Rx<CategoryDatum?> selectedCategory = Rx(null);
  final products = <ProductDatum>[].obs;

  getProductByCategory() async {
    isLoading(true);

    try {
      final productResponse =
          await ApiProvider().post(endpoint: '/products/byCategory', body: {
        'categoryId': selectedCategory.value!.id,
      });
      final products = ProductResponse.fromJson(productResponse);

      this.products(products.data);
      isLoading(false);
    } catch (e) {
      isLoading(false);
      Utils.showGetSnackbar(e.toString(), false);
    }
  }

  @override
  void onInit() {
    selectedCategory(Get.arguments);
    getProductByCategory();
    super.onInit();
  }
}
