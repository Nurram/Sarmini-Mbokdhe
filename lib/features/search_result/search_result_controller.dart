import 'package:sarmini_mbokdhe/core_imports.dart';
import 'package:sarmini_mbokdhe/models/product_response.dart';
import 'package:sarmini_mbokdhe/network/api_provider.dart';

class SearchResultController extends BaseController {
  final title = ''.obs;
  final products = <ProductDatum>[].obs;

  getProductByName() async {
    isLoading(true);

    try {
      final productResponse = await ApiProvider()
          .post(endpoint: '/products/search', body: {'q': title.value});
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
    title(Get.arguments);
    getProductByName();
    super.onInit();
  }
}
