import 'dart:convert';

import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:sarmini_mbokdhe/core_imports.dart';
import 'package:sarmini_mbokdhe/models/address_response.dart';
import 'package:sarmini_mbokdhe/network/api_provider.dart';

import '../../models/category_response.dart';
import '../../models/chat_list_response.dart';
import '../../models/constants.response.dart';
import '../../models/product_response.dart';
import '../../models/voucher_response.dart';
import '../../widgets/address_bottom_sheet.dart';
import '../chat_list/chat_list_binding.dart';
import '../chat_list/chat_list_screen.dart';

class HomeController extends BaseController {
  final PusherChannelsFlutter _pusher = PusherChannelsFlutter.getInstance();

  final Rx<AddressDatum?> selectedAddress = Rx(null);
  final selectedAddressId = (-1).obs;

  final addresses = <AddressDatum>[].obs;
  final vouchers = <VoucherDatum>[].obs;
  final categories = <CategoryDatum>[].obs;
  final products = <ProductDatum>[].obs;
  final constants = <ConstantsDatum>[].obs;

  final chatCount = 0.obs;

  _getUnread() async {
    isLoading(true);

    try {
      final user = await getCurrentLoggedInUser();
      final userData = user.value;

      final response = await ApiProvider()
          .post(endpoint: '/chats/unread', body: {'userId': userData!.id});

      final ureadData = ChatListResponse.fromJson(response);
      chatCount(ureadData.data.length);

      isLoading(false);
    } catch (e) {
      isLoading(false);
      Utils.showGetSnackbar(e.toString(), false);
    }
  }

  _initPusher() async {
    final user = await getCurrentLoggedInUser();
    final userData = user.value;

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
            final datum = ChatListDatum.fromJson(
              jsonDecode(event.data)['chat'],
            );

            if (datum.senderId != userData!.id && datum.userId == userData.id) {
              chatCount(chatCount.value + 1);
            }
          } catch (e) {
            print(e);
          }
        },
        onSubscriptionError: (message, error) {
          print('Subs Error: ${message}, Error: ${error}');
        },
        onSubscriptionSucceeded: (channelName, data) {
          data as Map;
          print('Subs Succeed: $channelName: $data');
        },
      );

      await _pusher.subscribe(channelName: 'chat.all');
      await _pusher.connect();
      print('Done');
    } catch (e) {
      print(e.toString());
    }
  }

  goToChat() async {
    final savedUser = await getCurrentLoggedInUser();
    final user = savedUser.value!;

    if (user.firstname != null &&
        user.firstname!.isNotEmpty &&
        user.lastname != null &&
        user.lastname!.isNotEmpty) {
      Get.to(
        () => const ChatListScreen(),
        binding: ChatListBinding(),
      );
    } else {
      Utils.showGetSnackbar('Silahkan lengkapi profil terlebih dahulu', false);
    }
  }

  setSelectedAddress({required int id}) async {
    if (selectedAddress.value!.id != id) {
      try {
        final user = await getCurrentLoggedInUser();
        final response = await ApiProvider().post(
            endpoint: '/address/setPrimary',
            body: {'userId': user.value!.id, 'id': id});

        selectedAddress(AddressDatum.fromJson(response['data']));
        selectedAddressId(selectedAddress.value!.id);

        Utils.storeToSecureStorage(
          key: Constants.address,
          data: jsonEncode(
            selectedAddress.value!.toJson(),
          ),
        );

        Get.back(result: selectedAddress.value);
      } catch (e) {
        Utils.showGetSnackbar(e.toString(), false);
      }
    }
  }

  Future<AddressDatum?> showAddressBottomSheet(
      {required BuildContext context}) async {
    final selectedAddress = await showModalBottomSheet(
      context: Get.context!,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.dp),
          topRight: Radius.circular(16.dp),
        ),
      ),
      builder: (context) {
        return const AddressBottomSheet();
      },
    );

    return selectedAddress;
  }

  getDatas() async {
    isLoading(true);

    try {
      if (userController.loggedInUser.value != null) {
        await getAddress();
      }

      final voucherResult = await ApiProvider().get(endpoint: '/vouchers');

      vouchers(
        VoucherResponse.fromJson(voucherResult).data,
      );

      final categoryResult = await ApiProvider().get(endpoint: '/categories');
      categories(
        CategoryResponse.fromJson(categoryResult).data,
      );

      final productResult =
          await ApiProvider().get(endpoint: '/products/newest');
      products(
        ProductResponse.fromJson(productResult).data,
      );

      await getConstants();
      await _getUnread();

      isLoading(false);
    } catch (e) {
      if (!e.toString().contains('Unauthenticated')) {
        Utils.showGetSnackbar(e.toString(), false);
      }
    }
  }

  getAddress() async {
    final user = userController.loggedInUser.value!;
    final addressResult = await ApiProvider()
        .post(endpoint: '/address', body: {'userId': user.id});

    final adddress = AddressResponse.fromJson(addressResult);

    addresses(adddress.data);
    Utils.storeToSecureStorage(
      key: Constants.addresses,
      data: jsonEncode(
        adddress.toJson(),
      ),
    );

    selectedAddress(
      addresses.firstWhereOrNull((element) => element.isPrimary),
    );
    selectedAddressId(selectedAddress.value?.id);
  }

  getConstants() async {
    isLoading(true);

    try {
      final constantsResponse = await ApiProvider().get(endpoint: '/constants');
      final constants = ConstantsResponse.fromJson(constantsResponse);

      this.constants(constants.data);
      isLoading(false);
    } catch (e) {
      isLoading(false);
      Utils.showGetSnackbar(e.toString(), false);
    }
  }

  Future<bool> checkLoggedIn() async {
    final loggedInUser = await getCurrentLoggedInUser();
    return loggedInUser.value != null;
  }

  @override
  void onInit() async {
    isLoading(true);

    // final addressJson =
    //     await Utils.readFromSecureStorage(key: Constants.address);
    // if (addressJson != null) {
    //   final address = AddressDatum.fromJson(
    //     jsonDecode(addressJson),
    //   );

    //   selectedAddress(address);
    //   selectedAddressId(selectedAddress.value!.id);
    // }

    await _initPusher();
    await getDatas();
    super.onInit();
  }

  @override
  void dispose() {
    _pusher.disconnect();
    _pusher.unsubscribe(channelName: 'chat.all');
    super.dispose();
  }
}
