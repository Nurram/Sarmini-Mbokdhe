import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:sarmini_mbokdhe/models/address_response.dart';

import '../core_imports.dart';

showAddressBottomSheet(
    {required Rx<AddressDatum?> groupValue,
    required List<AddressDatum> addresses,
    required Function(int) onChanged}) {
  showModalBottomSheet(
    context: Get.context!,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16.dp),
        topRight: Radius.circular(16.dp),
      ),
    ),
    builder: (context) {
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
              () => addresses.isNotEmpty
                  ? ListView.builder(
                      itemCount: addresses.length,
                      itemBuilder: (context, index) {
                        final data = addresses[index];

                        return Obx(
                          () => CheckboxListTile(
                            onChanged: (value) => onChanged(data.id),
                            value: groupValue.value != null
                                ? data.id == groupValue.value!.id
                                : false,
                            title: Text(data.name),
                            subtitle: Text(data.address),
                          ),
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
    },
  );
}
