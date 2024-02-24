import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:sarmini_mbokdhe/core_imports.dart';
import 'package:sarmini_mbokdhe/features/add_address/add_address_controller.dart';
import 'package:sarmini_mbokdhe/features/select_address/select_address_binding.dart';
import 'package:sarmini_mbokdhe/features/select_address/select_address_screen.dart';

import 'place_picker.dart';

class AddAddressScreen extends GetView<AddAddressController> {
  const AddAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Alamat'),
        backgroundColor: Colors.white,
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
                children: [
                  SizedBox(height: 8.dp),
                  _buildLabel(label: 'Kontak'),
                  _buildSection([
                    _buildInput(
                        label: 'Nama Alamat', controller: controller.nameCtr),
                    _buildInput(
                        label: 'Nama Penerima',
                        controller: controller.recipientCtr),
                    _buildInput(
                      label: 'Nomor Telepon',
                      controller: controller.phoneCtr,
                      textInputType: TextInputType.phone,
                    )
                  ]),
                  SizedBox(height: 8.dp),
                  _buildLabel(label: 'Detail'),
                  _buildSection([
                    _buildClickableInput(
                      label: 'Provinsi, Kabupaten, Kecamatan',
                      controller: controller.locationCtr,
                      onTap: () {
                        Get.to(
                          () => const SelectAddressScreen(),
                          binding: SelectAddressBinding(),
                        )?.then((value) {
                          if (value != null) {
                            controller.setSelectedAddress(result: value);
                          }
                        });
                      },
                    ),
                    _buildInput(
                        label: 'Nama Jalan, RT, RW',
                        controller: controller.addressCtr),
                    _buildInput(
                      label: 'Kode Pos',
                      controller: controller.zipCtr,
                      textInputType: TextInputType.number,
                    ),
                  ]),
                  SizedBox(height: 8.dp),
                  _buildLabel(label: 'Titik Lokasi'),
                  _buildSection([
                    _buildClickableInput(
                      label: 'Pilih Titik Lokasi',
                      controller: controller.latLngCtr,
                      onTap: () {
                        Get.to(
                          () => const PlacePicker(),
                        )?.then((value) {
                          if (value != null) {
                            controller.latLngCtr.text = value;
                          }
                        });
                      },
                    )
                  ]),
                  SizedBox(height: 32.dp),
                  Padding(
                    padding: EdgeInsets.all(16.dp),
                    child: Obx(
                      () => CustomElevatedButton(
                        isLoading: controller.isLoading.value,
                        text: 'Simpan',
                        onPressed: controller.addAddress,
                        bgColor: CustomColors.primaryColor,
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }

  Widget _buildLabel({
    required String label,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.dp, vertical: 8.dp),
      child: Text(
        label,
        style: CustomTextStyle.grey12w600(),
      ),
    );
  }

  Widget _buildSection(List<Widget> childs) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.dp),
      color: Colors.white,
      child: Column(
        children: childs,
      ),
    );
  }

  Widget _buildInput({
    required String label,
    required TextEditingController controller,
    TextInputType textInputType = TextInputType.name,
  }) {
    return TextField(
      controller: controller,
      keyboardType: textInputType,
      style: CustomTextStyle.black12w400(),
      decoration: InputDecoration(
          hintText: label,
          hintStyle: CustomTextStyle.grey12w400(),
          border: InputBorder.none),
    );
  }

  Widget _buildClickableInput({
    required String label,
    required TextEditingController controller,
    required Function() onTap,
  }) {
    return TextField(
      controller: controller,
      readOnly: true,
      onTap: onTap,
      style: CustomTextStyle.black12w400(),
      decoration: InputDecoration(
        hintText: label,
        hintStyle: CustomTextStyle.grey12w400(),
        border: InputBorder.none,
        suffixIcon: Icon(
          Icons.arrow_forward_ios,
          size: 14,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }
}
