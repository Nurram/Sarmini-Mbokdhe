import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:sarmini_mbokdhe/core_imports.dart';
import 'package:sarmini_mbokdhe/features/chat_room/chat_room_controller.dart';
import 'package:sarmini_mbokdhe/widgets/custom_divider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ChatRoomScreen extends GetView<ChatRoomController> {
  const ChatRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Skeletonizer(
            enabled: controller.isLoading.value,
            child: Text(
                controller.chats.isEmpty ? '' : controller.chats.first.name),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.dp),
        child: Column(
          children: [
            Expanded(
              child: Obx(
                () => RefreshIndicator(
                  onRefresh: () => controller.getChats(),
                  child: Skeletonizer(
                    enabled: controller.isLoading.value,
                    child: ListView.separated(
                        controller: controller.scrollController,
                        itemBuilder: (context, index) =>
                            controller.isLoading.value
                                ? _buildLoadingChatItem(index: index)
                                : _buildChatItem(index: index),
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 8.dp),
                        itemCount: controller.isLoading.value
                            ? 5
                            : controller.chats.length),
                  ),
                ),
              ),
            ),
            const CustomDivider(),
            Row(
              children: [
                // const Icon(
                //   Icons.attach_file,
                //   color: CustomColors.primaryColor,
                // ),
                // SizedBox(width: 12.dp),
                Expanded(
                  child: TextField(
                    controller: controller.messageCtr,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(
                        border: InputBorder.none, hintText: 'Ketik disini'),
                  ),
                ),
                SizedBox(width: 12.dp),
                InkWell(
                  onTap: () => controller.postToDiscussion(),
                  child: const Icon(
                    Icons.send,
                    color: CustomColors.primaryColor,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildChatItem({required int index}) {
    final discuss = controller.chats[index];

    return Row(
      mainAxisAlignment: discuss.senderId == controller.userId
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        Card(
          child: Padding(
            padding: EdgeInsets.all(12.dp),
            child: Column(
              crossAxisAlignment: discuss.senderId == controller.userId
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Text(discuss.message),
                SizedBox(height: 4.dp),
                Text(
                  Utils.formatDate(pattern: 'HH:mm', date: discuss.createdAt),
                  style: CustomTextStyle.grey10w400(),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildLoadingChatItem({required int index}) {
    return Row(
      mainAxisAlignment:
          index % 2 == 0 ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Card(
          child: Padding(
            padding: EdgeInsets.all(12.dp),
            child: Column(
              crossAxisAlignment: index % 2 == 0
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                const Text('discuss.message'),
                SizedBox(height: 4.dp),
                Text(
                  '',
                  style: CustomTextStyle.grey10w400(),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
