import 'package:sarmini_mbokdhe/core_imports.dart';
import 'package:sarmini_mbokdhe/models/chat_list_response.dart';
import 'package:sarmini_mbokdhe/network/api_provider.dart';

class ChatListController extends BaseController {
  final chats = <ChatListDatum>[].obs;

  getChats() async {
    isLoading(true);

    try {
      final user = await getCurrentLoggedInUser();
      final response = await ApiProvider()
          .post(endpoint: '/chats', body: {'userId': user.value!.id});
      final chatListResponse = ChatListResponse.fromJson(response);
      chats(chatListResponse.data);

      isLoading(false);
    } catch (e) {
      isLoading(true);
      Utils.showGetSnackbar(e.toString(), false);
    }
  }

  setNewChat(ChatListDatum datum) {
    final index =
        chats.indexWhere((element) => element.productId == datum.productId);
    final chat = chats[index];
    chat.message = datum.message;
    chat.createdAt = datum.createdAt;

    chats[index] = chat;
  }

  @override
  void onInit() {
    getChats();
    super.onInit();
  }
}
