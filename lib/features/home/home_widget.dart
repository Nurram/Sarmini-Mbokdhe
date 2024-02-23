import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:sarmini_mbokdhe/core_imports.dart';
import 'package:sarmini_mbokdhe/features/cart/cart_binding.dart';
import 'package:sarmini_mbokdhe/features/cart/cart_screen.dart';
import 'package:sarmini_mbokdhe/features/home/home_controller.dart';
import 'package:sarmini_mbokdhe/features/login/login_binding.dart';
import 'package:sarmini_mbokdhe/features/login/login_screen.dart';
import 'package:sarmini_mbokdhe/features/search/search_binding.dart';
import 'package:sarmini_mbokdhe/features/search/search_screen.dart';
import 'package:sarmini_mbokdhe/features/search_category/search_category_binding.dart';
import 'package:sarmini_mbokdhe/features/search_category/search_category_screen.dart';
import 'package:sarmini_mbokdhe/features/voucher_detail/voucher_detail_screen.dart';
import 'package:sarmini_mbokdhe/features/vouchers/voucher_screen.dart';
import 'package:sarmini_mbokdhe/models/category_response.dart';
import 'package:sarmini_mbokdhe/network/api_provider.dart';
import 'package:sarmini_mbokdhe/widgets/address_bottom_sheet.dart';
import 'package:sarmini_mbokdhe/widgets/product_item.dart';
import 'package:sarmini_mbokdhe/widgets/search_textfield.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../vouchers/voucher_binding.dart';

class HomeWidget extends GetView<HomeController> {
  const HomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buildHeader(),
        surfaceTintColor: Colors.transparent,
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.getDatas(),
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.dp),
              child: Obx(
                () => Skeletonizer(
                  enabled: controller.isLoading.value,
                  child: SearchTextfield(
                    controller: controller.searchCtr,
                    hint: 'Cari berbagai kebutuhan harian',
                    bgColor: Colors.grey.shade100,
                    readOnly: true,
                    onChanged: (p0) {},
                    onTap: () {
                      Get.to(() => const SearchScreen(),
                          binding: SearchBinding());
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 24.dp),
            _buildPromo(),
            SizedBox(height: 12.dp),
            _buildCategory(),
            SizedBox(height: 12.dp),
            _buildProduct()
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Obx(
      () => Skeletonizer(
        enabled: controller.isLoading.value,
        child: Column(
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () {
                    showAddressBottomSheet(
                      groupValue: controller.selectedAddressId,
                      addresses: controller.addresses,
                      onChanged: (p0) {
                        controller.setSelectedAddress(id: p0);
                      },
                    );
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 20.dp,
                        color: CustomColors.primaryColor,
                      ),
                      SizedBox(width: 8.dp),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.selectedAddress.value != null
                                ? controller.selectedAddress.value!.name
                                : 'Alamat belum dipilih',
                            style: CustomTextStyle.black14w400(),
                          ),
                          controller.selectedAddress.value != null
                              ? SizedBox(
                                  width: 25.w,
                                  child: Text(
                                    controller.selectedAddress.value!.address,
                                    style: CustomTextStyle.grey10w400(),
                                    maxLines: 1,
                                  ),
                                )
                              : const SizedBox()
                        ],
                      ),
                      SizedBox(width: 16.dp),
                      Icon(
                        Icons.keyboard_arrow_down_sharp,
                        size: 20.dp,
                        color: CustomColors.primaryColor,
                      )
                    ],
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () async {
                    final loggedIn = await controller.checkLoggedIn();

                    if (!loggedIn) {
                      Get.to(
                        () => const LoginScreen(),
                        binding: LoginBinding(),
                      );
                    } else {
                      Get.to(
                        () => const CartScreen(),
                        binding: CartBinding(),
                      );
                    }
                  },
                  child: Icon(
                    Icons.chat_outlined,
                    size: 20.dp,
                    color: CustomColors.primaryColor,
                  ),
                ),
                SizedBox(width: 16.dp),
                InkWell(
                  onTap: () async {
                    final loggedIn = await controller.checkLoggedIn();

                    if (!loggedIn) {
                      Get.to(
                        () => const LoginScreen(),
                        binding: LoginBinding(),
                      );
                    } else {
                      Get.to(
                        () => const CartScreen(),
                        binding: CartBinding(),
                      );
                    }
                  },
                  child: Icon(
                    Icons.shopping_cart_outlined,
                    size: 20.dp,
                    color: CustomColors.primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromo() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.dp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Promosi',
                style: CustomTextStyle.black16w700(),
              ),
              const Spacer(),
              InkWell(
                onTap: () => Get.to(
                  () => const VouchersScreen(),
                  binding: VoucherBinding(),
                ),
                child: Text(
                  'Semua',
                  style: CustomTextStyle.primary12w400(),
                ),
              ),
            ],
          ),
          Container(
            height: 90.dp,
            margin: EdgeInsets.only(top: 16.dp),
            child: Obx(
              () => Skeletonizer(
                enabled: controller.isLoading.value,
                child: ListView.separated(
                  itemCount: controller.vouchers.isNotEmpty
                      ? controller.vouchers.length
                      : 5,
                  separatorBuilder: (context, index) => SizedBox(width: 8.dp),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => _buildPromoItem(index),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPromoItem(int index) {
    return InkWell(
      onTap: () {
        Get.to(() => const VoucherDetail(),
            arguments: controller.vouchers[index]);
      },
      child: SizedBox(
        width: 160.dp,
        height: 90.dp,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.dp),
          child: controller.vouchers.isNotEmpty
              ? Image.network(
                  '${ApiProvider().baseUrl}/${controller.vouchers[index].image}',
                  fit: BoxFit.cover,
                )
              : Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );
  }

  Widget _buildCategory() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.dp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Kategori',
                style: CustomTextStyle.black16w700(),
              ),
              const Spacer(),
            ],
          ),
          SizedBox(height: 16.dp),
          Obx(
            () => Skeletonizer(
              enabled: controller.isLoading.value,
              child: Wrap(
                spacing: 8.dp,
                runSpacing: 8.dp,
                children: [
                  ...List.generate(
                    controller.categories.isNotEmpty
                        ? controller.categories.length
                        : 5,
                    (index) => _buildCategoryItem(
                      index: index,
                      isNotEmpty: controller.categories.isNotEmpty,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCategoryItem({required int index, required bool isNotEmpty}) {
    final width = 72.dp;
    CategoryDatum? categoryDatum;

    if (isNotEmpty) categoryDatum = controller.categories[index];

    return InkWell(
      onTap: categoryDatum != null
          ? () {
              Get.to(() => const SearchCategoryScreen(),
                  binding: SearchCategoryBinding(), arguments: categoryDatum);
            }
          : null,
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: width,
              height: width,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.dp),
                child: isNotEmpty
                    ? Image.network(
                        '${ApiProvider().baseUrl}/${categoryDatum!.image}',
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            SizedBox(height: 8.dp),
            Container(
              height: 40.dp,
              margin: EdgeInsets.symmetric(horizontal: 4.dp),
              child: Text(
                isNotEmpty ? categoryDatum!.name : 'Daging segar',
                style: CustomTextStyle.black12w400(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildProduct() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.dp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Produk',
            style: CustomTextStyle.black16w700(),
          ),
          SizedBox(height: 16.dp),
          Obx(
            () => Skeletonizer(
              enabled: controller.isLoading.value,
              child: Wrap(
                spacing: 7.dp,
                runSpacing: 7.dp,
                children: [
                  ...List.generate(
                    controller.products.isNotEmpty
                        ? controller.products.length
                        : 5,
                    (index) => ProductItem(
                      index: index,
                      datum: controller.products.isEmpty
                          ? null
                          : controller.products[index],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
