import 'dart:convert';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:sarmini_mbokdhe/core_imports.dart';
import 'package:sarmini_mbokdhe/models/discussion_response.dart';
import 'package:sarmini_mbokdhe/network/api_provider.dart';

class DiscussionRoomController extends BaseController {
  final ScrollController scrollController = ScrollController();
  final PusherChannelsFlutter _pusher = PusherChannelsFlutter.getInstance();

  final discussions = <DiscussionDatum>[].obs;
  String channelName = '';
  int productId = 0;
  int userId = 0;

  final messageCtr = TextEditingController();

  getChats() async {
    isLoading(true);

    try {
      final response = await ApiProvider().post(
          endpoint: '/discussion',
          body: {'userId': userId, 'productId': productId});
      final discussionResponse = DiscussionResponse.fromJson(response);
      discussions(discussionResponse.data);

      _scrollToBottom();
      isLoading(false);
    } catch (e) {
      isLoading(false);
      Utils.showGetSnackbar(e.toString(), false);
    }
  }

  _initPusher() async {
    try {
      await _pusher.init(
        apiKey: '31351825d1cffa1d493b',
        cluster: 'ap1',
        useTLS: true,
        onError: (message, code, error) {
          print('Error: $error');
        },
        onEvent: (event) {
          try {
            print(event.data);
            final datum = DiscussionDatum.fromJson(
              jsonDecode(event.data)['discussion'],
            );
            discussions.add(datum);
          } catch (e) {
            print(e);
          }

          messageCtr.clear();
          _scrollToBottom();
        },
        onSubscriptionError: (message, error) {
          print('Subs Error: ${message}, Error: ${error}');
        },
        onSubscriptionSucceeded: (channelName, data) {
          data as Map;
          print('Subs Succeed: $channelName: $data');
        },
      );

      await _pusher.subscribe(channelName: channelName);
      await _pusher.connect();
      print('Done');
    } catch (e) {
      print(e.toString());
    }
  }

  postToDiscussion() async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (messageCtr.text.isEmpty) return;

    final user = await getCurrentLoggedInUser();
    await ApiProvider().post(
      endpoint: '/discussion/broadcast',
      body: {
        'userId': user.value!.id,
        'productId': productId,
        'message': messageCtr.text
      },
    );
  }

  _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });
  }

  @override
  void onInit() async {
    final user = await getCurrentLoggedInUser();
    userId = user.value!.id;

    productId = Get.arguments;
    channelName = 'discussion.$productId';

    await _initPusher();
    await getChats();

    _scrollToBottom();

    super.onInit();
  }

  @override
  void dispose() {
    _pusher.disconnect();
    _pusher.unsubscribe(channelName: channelName);
    super.dispose();
  }
}
