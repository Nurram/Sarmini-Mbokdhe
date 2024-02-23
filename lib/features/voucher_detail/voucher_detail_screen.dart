import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:sarmini_mbokdhe/core_imports.dart';
import 'package:sarmini_mbokdhe/models/voucher_response.dart';
import 'package:sarmini_mbokdhe/network/api_provider.dart';
import 'package:sarmini_mbokdhe/widgets/custom_divider.dart';

class VoucherDetail extends StatelessWidget {
  const VoucherDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final VoucherDatum voucher = Get.arguments;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Voucher'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            '${ApiProvider().baseUrl}/${voucher.image}',
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: EdgeInsets.only(left: 16.dp, top: 16.dp, right: 16.dp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  voucher.title,
                  style: CustomTextStyle.black16w700(),
                ),
                SizedBox(height: 8.dp),
                Text(
                  'Kode Promo: ${voucher.code}',
                  style: CustomTextStyle.black(),
                ),
                SizedBox(height: 8.dp),
                Text(
                  '${Utils.formatDate(pattern: 'dd MMMM yyyy', date: voucher.validFrom)} -'
                  ' ${Utils.formatDate(pattern: 'dd MMMM yyyy', date: voucher.validTo)}',
                  style: CustomTextStyle.grey12w400(),
                ),
                SizedBox(height: 12.dp),
              ],
            ),
          ),
          const CustomDivider(),
          Padding(
            padding: EdgeInsets.only(left: 16.dp, top: 16.dp, right: 16.dp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Deskripsi',
                  style: CustomTextStyle.black16w700(),
                ),
                SizedBox(height: 8.dp),
                Text(
                  voucher.description,
                  style: CustomTextStyle.black(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
