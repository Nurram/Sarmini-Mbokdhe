import 'package:sarmini_mbokdhe/core_imports.dart';
import 'package:sarmini_mbokdhe/models/cart_response.dart';
import 'package:sarmini_mbokdhe/network/api_provider.dart';

import '../checkout_cart/checkout_cart_binding.dart';
import '../checkout_cart/checkout_cart_screen.dart';
import '../home/home_controller.dart';

class CartController extends BaseController {
  final carts = <CartDatum>[].obs;
  final selectMode = false.obs;
  final allSelected = false.obs;

  checkAddress() {
    try {
      final homeController = Get.find<HomeController>();
      if (homeController.selectedAddress.value == null) {
        throw 'Anda belum memilih alamat pengiriman';
      }

      Get.to(
        () => const CheckoutCartScreen(),
        binding: CheckoutCartBinding(),
        arguments: carts,
      )?.then(
        (value) => getCarts(),
      );
    } catch (e) {
      Utils.showGetSnackbar(e.toString(), false);
    }
  }

  getCarts() async {
    selectMode(false);
    allSelected(false);

    final user = await getCurrentLoggedInUser();

    isLoading(true);

    try {
      final cartResponse = await ApiProvider()
          .post(endpoint: '/cart', body: {'userId': user.value!.id});
      final cart = CartResponse.fromJson(cartResponse);
      carts(cart.data);

      isLoading(false);
    } catch (e) {
      isLoading(false);
      Utils.showGetSnackbar(e.toString(), false);
    }
  }

  setSelected({required int index}) {
    carts[index].selected = !carts[index].selected;

    if (carts.where((p0) => p0.selected).isEmpty) {
      selectMode(false);
    }

    if (carts.where((p0) => p0.selected).length == carts.length) {
      allSelected(true);
    }

    if (!carts[index].selected) {
      allSelected(false);
    }

    carts.refresh();
  }

  int getTotalPrice() {
    final selectedItems = carts.where((p0) => p0.selected);
    if (selectedItems.isNotEmpty) {
      return selectedItems
          .map((element) => element.price * element.cartQty)
          .reduce((a, b) => a + b);
    }

    return 0;
  }

  setAllSelected() {
    for (int i = 0; i < carts.length; i++) {
      if (allSelected.value) {
        carts[i].selected = true;
      } else {
        carts[i].selected = false;
        selectMode(false);
      }
    }

    carts.refresh();
  }

  delete() async {
    selectMode(false);
    isLoading(true);

    try {
      final selectedCart = carts.where((p0) => p0.selected).toList();
      final ids = <int>[];

      for (var element in selectedCart) {
        ids.add(element.id);
      }

      await ApiProvider().delete(endpoint: '/cart', body: {'ids': ids});
      final cartCount = Get.find<HomeController>().cartCount.value;
      Get.find<HomeController>().cartCount(cartCount - 1);

      await getCarts();
    } catch (e) {
      isLoading(false);
      Utils.showGetSnackbar(e.toString(), false);
    }
  }

  addQty({required int value, required int index}) {
    if (carts[index].cartQty + value < 1) {
      return;
    }

    carts[index].cartQty = carts[index].cartQty + value;
    carts.refresh();
  }

  @override
  void onInit() {
    getCarts();
    super.onInit();
  }
}
