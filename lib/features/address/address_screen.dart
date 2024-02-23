import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:sarmini_mbokdhe/core_imports.dart';
import 'package:sarmini_mbokdhe/features/address/address_controller.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AddressScreen extends GetView<AddressController> {
  const AddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alamat'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.dp),
        child: RefreshIndicator(
          child: Obx(
            () => Skeletonizer(
              enabled: controller.isLoading.value,
              child: controller.addresses.isEmpty
                  ? ListView(
                      children: const [EmptyWidget()],
                    )
                  : ListView.separated(
                      itemBuilder: (context, index) => _buildItem(index: index),
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 8.dp),
                      itemCount: controller.addresses.length),
            ),
          ),
          onRefresh: () => controller.getAddress(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: const Text('Tambah Alamat'),
      ),
    );
  }

  Widget _buildItem({required int index}) {
    final address = controller.addresses[index];

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.dp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    address.name,
                    style: CustomTextStyle.black15Bold(),
                  ),
                ),
                Visibility(
                  visible: address.isPrimary,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 4.dp, horizontal: 12.dp),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: CustomColors.primaryColor),
                    child: Text(
                      'Alamat Utama',
                      style: CustomTextStyle.white(),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 8.dp),
            Text('${address.receipient} | ${address.phoneNumber}'),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 2.dp),
              child: Text(address.address),
            ),
            Text(address.postalCode.toString())
          ],
        ),
      ),
    );
  }
}