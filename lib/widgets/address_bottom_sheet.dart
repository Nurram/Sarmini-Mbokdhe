import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:sarmini_mbokdhe/features/home/home_controller.dart';

import '../core_imports.dart';

class AddressBottomSheet extends GetView<HomeController> {
  const AddressBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 24.dp, top: 24.dp, right: 24.dp),
          child: Text(
            'Pilih Alamat Pengiriman',
            style: CustomTextStyle.black15Bold(),
          ),
        ),
        SizedBox(height: 16.dp),
        Expanded(
          child: Obx(
            () => controller.addresses.isNotEmpty
                ? ListView.builder(
                    itemCount: controller.addresses.length,
                    itemBuilder: (context, index) {
                      final data = controller.addresses[index];

                      return RadioListTile(
                        onChanged: (value) {
                          if (value != null) {
                            controller.setSelectedAddress(id: value);
                          }
                        },
                        groupValue: controller.selectedAddressId.value,
                        value: data.id,
                        selected: data.id == controller.selectedAddressId.value,
                        title: Text(data.name),
                        subtitle: Text(data.address),
                      );
                    },
                  )
                : Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(24.dp),
                    child: const Center(
                      child: Text('Anda belum menambahkan alamat'),
                    ),
                  ),
          ),
        )
      ],
    );
  }
}
