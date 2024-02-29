import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:sarmini_mbokdhe/core_imports.dart';
import 'package:sarmini_mbokdhe/features/chat_room/chat_room_screen.dart';
import 'package:sarmini_mbokdhe/features/chat_room/chat_room_binding.dart';
import 'package:sarmini_mbokdhe/network/api_provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'chat_list_controller.dart';

class ChatListScreen extends GetView<ChatListController> {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.dp),
        child: RefreshIndicator(
          onRefresh: () => controller.getChats(),
          child: Obx(
            () => Skeletonizer(
              enabled: controller.isLoading.value,
              child: ListView.separated(
                  itemBuilder: (context, index) => controller.isLoading.value
                      ? _buildLoadingChatItem(index: index)
                      : _buildChatItem(index: index),
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount:
                      controller.isLoading.value ? 5 : controller.chats.length),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChatItem({required int index}) {
    final chat = controller.chats[index];

    return InkWell(
      onTap: () {
        Get.to(
          () => const ChatRoomScreen(),
          binding: ChatRoomBinding(),
          arguments: chat.productId,
        );
      },
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: Image.network(
              '${ApiProvider().baseUrl}/${chat.file}',
              width: 56.dp,
              height: 56.dp,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 16.dp),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chat.name,
                  maxLines: 1,
                  style: CustomTextStyle.black(),
                ),
                SizedBox(height: 4.dp),
                Text(
                  chat.message,
                  maxLines: 1,
                  style: CustomTextStyle.grey12w400(),
                )
              ],
            ),
          ),
          SizedBox(width: 8.dp),
          Text(
            Utils.formatDate(pattern: 'HH:mm', date: chat.createdAt),
            style: CustomTextStyle.grey10w400(),
          )
        ],
      ),
    );
  }

  Widget _buildLoadingChatItem({required int index}) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(99),
          child: Image.asset(
            'assets/images/logo.png',
            width: 56.dp,
            height: 56.dp,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(width: 16.dp),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Daging Ayam',
                maxLines: 1,
                style: CustomTextStyle.black(),
              ),
              SizedBox(height: 4.dp),
              Text(
                'Halo kang ayam',
                maxLines: 1,
                style: CustomTextStyle.grey12w400(),
              )
            ],
          ),
        ),
        SizedBox(width: 8.dp),
        Container(
          width: 18.dp,
          height: 18.dp,
          padding: EdgeInsets.all(2.dp),
          decoration: const BoxDecoration(
              shape: BoxShape.circle, color: CustomColors.primaryColor),
          child: Text(
            '9999',
            maxLines: 1,
            style: CustomTextStyle.white(fontSize: 10.dp),
          ),
        )
      ],
    );
  }
}
