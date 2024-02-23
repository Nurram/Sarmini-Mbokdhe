import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:sarmini_mbokdhe/core_imports.dart';
import 'package:sarmini_mbokdhe/features/search/search_view_controller.dart';
import 'package:sarmini_mbokdhe/features/search_result/search_result_binding.dart';
import 'package:sarmini_mbokdhe/features/search_result/search_result_screen.dart';

import '../../widgets/search_textfield.dart';

class SearchScreen extends GetView<SearchViewController> {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.secondaryColor,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            SizedBox(
              width: 7.5.w,
              height: 3.75.h,
              child: InkWell(
                onTap: () => Get.back(),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: SearchTextfield(
                controller: controller.searchCtr,
                node: controller.serachNode,
                hint: 'Cari beragam kebutuhan harian',
                readOnly: false,
                onTap: () {},
                onSubmitted: (p0) {
                  Get.to(() => const SearchResultScreen(),
                      binding: SearchResultBinding(), arguments: p0);
                },
                onChanged: (p0) {
                  controller.getSuggestions(q: p0);
                },
              ),
            ),
          ],
        ),
      ),
      body: Obx(
        () => ListView.separated(
            itemBuilder: (context, index) => _buildSuggestion(index: index),
            separatorBuilder: (context, index) => Container(
                  width: double.infinity,
                  height: .25,
                  color: Colors.black12,
                ),
            itemCount: controller.suggestions.length),
      ),
    );
  }

  Widget _buildSuggestion({required int index}) {
    final data = controller.suggestions[index];

    return InkWell(
      onTap: () {
        Get.to(() => const SearchResultScreen(),
            binding: SearchResultBinding(), arguments: data.name);
      },
      child: Container(
        padding: EdgeInsets.all(4.w),
        child: Row(
          children: [
            Icon(Icons.search, size: 14.dp),
            SizedBox(width: 2.w),
            Text(
              data.name,
              style: CustomTextStyle.black12w400(),
            )
          ],
        ),
      ),
    );
  }
}
