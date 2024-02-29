import 'package:sarmini_mbokdhe/core_imports.dart';
import 'package:sarmini_mbokdhe/features/discussion/discussion_controller.dart';

class DiscussionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DiscussionController());
  }
}
