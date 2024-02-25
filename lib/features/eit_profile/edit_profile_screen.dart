import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:sarmini_mbokdhe/core_imports.dart';
import 'package:sarmini_mbokdhe/features/eit_profile/edit_profile_controller.dart';
import 'package:sarmini_mbokdhe/network/api_provider.dart';

class EditProfileScreen extends GetView<EditProfileController> {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.dp),
        child: ListView(
          children: [
            CustomTextFormField(
              controller: controller.phoneCtr,
              prefixIcon: const Icon(Icons.phone_outlined),
              readOnly: true,
            ),
            CustomTextFormField(
              controller: controller.emailCtr,
              prefixIcon: const Icon(Icons.email_outlined),
              hint: 'email@mail.com',
              inputType: TextInputType.emailAddress,
            ),
            CustomTextFormField(
              controller: controller.firstnameCtr,
              prefixIcon: const Icon(Icons.person_2_outlined),
              hint: 'First Name',
              inputType: TextInputType.name,
            ),
            CustomTextFormField(
              controller: controller.lastNameCtr,
              prefixIcon: const Icon(Icons.person_2_outlined),
              hint: 'Last Name',
              inputType: TextInputType.name,
            ),
            SizedBox(height: 16.dp),
            Text(
              'Foto Profil',
              style: CustomTextStyle.black13w400(),
            ),
            SizedBox(height: 8.dp),
            InkWell(
              onTap: () => controller.pickImage(),
              child: Obx(
                () => controller.user.image == null
                    ? Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(24.dp),
                        decoration: BoxDecoration(
                            color: CustomColors.primaryColor.withAlpha(80),
                            borderRadius: BorderRadius.circular(8)),
                        child: const Column(
                          children: [
                            Icon(Icons.add),
                            Text('Silahkan pilih gambar')
                          ],
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: controller.selectedImage.value != null
                            ? Image.file(
                                File(controller.selectedImage.value!.path),
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                '${ApiProvider().baseUrl}/${controller.user.image}',
                                fit: BoxFit.cover,
                              ),
                      ),
              ),
            ),
            SizedBox(height: 24.dp),
            Obx(
              () => CustomElevatedButton(
                text: 'Simpan',
                onPressed: () {
                  controller.edit();
                },
                bgColor: CustomColors.primaryColor,
                isLoading: controller.isLoading.value,
              ),
            )
          ],
        ),
      ),
    );
  }
}
