import 'package:sarmini_mbokdhe/core_imports.dart';

import 'search_category_controller.dart';

class SearchCategoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SearchCategoryController());
  }
}
