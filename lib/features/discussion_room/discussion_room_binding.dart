import 'package:sarmini_mbokdhe/core_imports.dart';
import 'package:sarmini_mbokdhe/features/discussion_room/discussion_room_controller.dart';

class DiscussionRoomBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DiscussionRoomController());
  }
}
