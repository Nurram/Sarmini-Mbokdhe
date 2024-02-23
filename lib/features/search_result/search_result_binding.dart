import 'package:sarmini_mbokdhe/core_imports.dart';
import 'package:sarmini_mbokdhe/features/search_result/search_result_controller.dart';

class SearchResultBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SearchResultController());
  }
}
