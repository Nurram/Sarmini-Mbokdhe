import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:sarmini_mbokdhe/core_imports.dart';
import 'package:sarmini_mbokdhe/features/add_topup/add_topup_controller.dart';

class AddTopupScreen extends GetView<AddTopupController> {
  const AddTopupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Topup'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.dp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Masukan nominal',
              style: CustomTextStyle.black14w600(),
            ),
            SizedBox(height: 16.dp),
            TextFormField(
              controller: controller.amountCtr,
              autofocus: true,
              style: CustomTextStyle.black32w400(),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                final amount = double.tryParse(
                  value.replaceAll(',', ''),
                );

                if (amount != null) {
                  controller.amountCtr.text = Utils.numberFormat(amount);
                }
              },
              decoration: InputDecoration(
                hintText: '10,000',
                hintStyle: CustomTextStyle.grey(fontSize: 32.dp),
                border: InputBorder.none,
              ),
            ),
            SizedBox(height: 32.dp),
            Wrap(
              spacing: 8.dp,
              runSpacing: 8.dp,
              children: [
                _buildAmount(amount: 10000),
                _buildAmount(amount: 20000),
                _buildAmount(amount: 50000),
                _buildAmount(amount: 100000),
                _buildAmount(amount: 250000),
                _buildAmount(amount: 1000000),
              ],
            ),
            const Spacer(),
            Obx(
              () => CustomElevatedButton(
                text: 'Bayar',
                isLoading: controller.isLoading.value,
                onPressed: () {
                  controller.pay();
                },
                borderRadius: 0,
                bgColor: CustomColors.primaryColor,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAmount({required int amount}) {
    return InkWell(
      onTap: () {
        controller.amountCtr.text = Utils.numberFormat(amount);
      },
      child: SizedBox(
        width: 44.w,
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(16.dp),
            child: Text(
              'Rp${Utils.numberFormat(amount)}',
              textAlign: TextAlign.center,
              style: CustomTextStyle.black16w400(),
            ),
          ),
        ),
      ),
    );
  }
}
