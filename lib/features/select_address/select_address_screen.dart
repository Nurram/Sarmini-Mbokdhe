import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:sarmini_mbokdhe/core_imports.dart';
import 'package:sarmini_mbokdhe/features/select_address/select_address_controller.dart';

class SelectAddressScreen extends GetView<SelectAddressController> {
  const SelectAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Text(controller.currentSteps.value == 0
              ? 'Pilih Provinsi'
              : controller.currentSteps.value == 1
                  ? 'Pilih Kabupaten'
                  : 'Piilh Kecamatan'),
        ),
      ),
      body: Obx(
        () => controller.isLoading.value ? const Center(child: CircularProgressIndicator(),) : ListView.builder(
          itemCount: controller.currentSteps.value == 0
              ? controller.provinces.length
              : controller.currentSteps.value == 1
                  ? controller.regencies.length
                  : controller.districts.length,
          itemBuilder: (context, index) {
            final dynamic data = controller.currentSteps.value == 0
                ? controller.provinces
                : controller.currentSteps.value == 1
                    ? controller.regencies
                    : controller.districts;

            return InkWell(
              onTap: () => controller.setSelectedData(data: data[index]),
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 16.dp, vertical: 10.dp),
                child: Text(data[index].name),
              ),
            );
          },
        ),
      ),
    );
  }
}
