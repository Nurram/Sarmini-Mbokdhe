import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:sarmini_mbokdhe/core_imports.dart';
import 'package:sarmini_mbokdhe/features/discussion_room/discussion_room_binding.dart';
import 'package:sarmini_mbokdhe/features/discussion_room/discussion_room_screen.dart';
import 'package:sarmini_mbokdhe/features/product_detail/product_detail_binding.dart';
import 'package:sarmini_mbokdhe/features/product_detail/product_detail_screen.dart';
import 'package:sarmini_mbokdhe/models/product_response.dart';
import 'package:sarmini_mbokdhe/network/api_provider.dart';

class ProductItem extends StatelessWidget {
  final int index;
  final ProductDatum? datum;
  final bool isToDetail;

  const ProductItem({
    super.key,
    required this.index,
    required this.datum,
    this.isToDetail = true,
  });

  @override
  Widget build(BuildContext context) {
    final width = 160.dp;

    return SizedBox(
      width: width,
      height: 240.dp,
      child: InkWell(
        onTap: () {
          if (isToDetail) {
            Get.to(() => const ProductDetailScreen(),
                binding: ProductDetailBinding(), arguments: datum);
          } else {
            Get.to(() => const DiscussionRoomScreen(),
                binding: DiscussionRoomBinding(), arguments: datum!.id);
          }
        },
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            width: width,
            height: width,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: datum != null
                  ? Image.network(
                      '${ApiProvider().baseUrl}/${datum!.file}',
                      fit: BoxFit.cover,
                      height: width,
                    )
                  : Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          Container(
            height: 72.dp,
            margin: EdgeInsets.symmetric(horizontal: 4.dp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8.dp),
                Row(
                  children: [
                    Text(
                      'Rp${Utils.numberFormat(datum != null ? datum!.price : 9000)}',
                      style: CustomTextStyle.black14w600(),
                    ),
                    Text(
                      datum != null ? '/${datum!.unit}' : '/gram',
                      style: CustomTextStyle.black11w400(),
                    ),
                  ],
                ),
                SizedBox(height: 4.dp),
                Text(
                  datum != null ? datum!.name : 'Daging Ayam',
                  style: CustomTextStyle.black12w400(),
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
