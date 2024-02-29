import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sarmini_mbokdhe/core_imports.dart';
import 'package:sarmini_mbokdhe/features/address/address_binding.dart';
import 'package:sarmini_mbokdhe/features/address/address_screen.dart';
import 'package:sarmini_mbokdhe/features/dashboard/dashboard_binding.dart';
import 'package:sarmini_mbokdhe/features/dashboard/dashboard_screen.dart';
import 'package:sarmini_mbokdhe/features/eit_profile/edit_profile_binding.dart';
import 'package:sarmini_mbokdhe/features/eit_profile/edit_profile_screen.dart';
import 'package:sarmini_mbokdhe/features/login/login_binding.dart';
import 'package:sarmini_mbokdhe/features/login/login_screen.dart';
import 'package:sarmini_mbokdhe/features/profile/profile_controller.dart';
import 'package:sarmini_mbokdhe/features/topup/topup_binding.dart';
import 'package:sarmini_mbokdhe/features/topup/topup_screen.dart';
import 'package:sarmini_mbokdhe/network/api_provider.dart';
import 'package:sarmini_mbokdhe/widgets/custom_divider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProfileWidget extends GetView<ProfileController> {
  const ProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomDivider(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => controller.getLoggedInUser(),
              child: Obx(
                () => Skeletonizer(
                  enabled: controller.isLoading.value,
                  child: ListView(
                    children: [
                      _buildHeader(),
                      const CustomDivider(height: 8),
                      Visibility(
                        visible: controller.user.value != null,
                        child: Column(
                          children: [
                            _buildItem(
                                icon: Icons.location_on_outlined,
                                label: 'Alamat Pengiriman',
                                onTap: () async {
                                  if (await Permission.location
                                      .request()
                                      .isGranted) {
                                    Get.to(
                                      () => const AddressScreen(),
                                      binding: AddressBinding(),
                                    );
                                  }
                                }),
                            _buildItem(
                              icon: Icons.person_outline,
                              label: 'Edit Profile',
                              onTap: () {
                                Get.to(() => const EditProfileScreen(),
                                        binding: EditProfileBinding(),
                                        arguments: controller.user.value)
                                    ?.then((value) {
                                  if (value != null) {
                                    controller.getLoggedInUser();
                                  }
                                });
                              },
                            ),
                            _buildItem(
                              icon: Icons.messenger_outline_sharp,
                              label: 'Diskusi',
                              onTap: () {
                                Get.to(() => const EditProfileScreen(),
                                        binding: EditProfileBinding(),
                                        arguments: controller.user.value)
                                    ?.then((value) {
                                  if (value != null) {
                                    controller.getLoggedInUser();
                                  }
                                });
                              },
                            ),
                            const CustomDivider(height: 8),
                            _buildItem(
                                icon: Icons.credit_card,
                                label: 'Topup',
                                onTap: () {
                                  Get.to(
                                    () => const TopupScreen(),
                                    binding: TopupBinding(),
                                  );
                                }),
                            const CustomDivider(height: 8),
                            _buildItem(
                                icon: Icons.email_outlined,
                                label: 'Kontak Kami',
                                onTap: () {}),
                            _buildItem(
                                icon: Icons.privacy_tip_outlined,
                                label: 'Privacy Policy',
                                onTap: () {}),
                            _buildItem(
                                icon: Icons.info_outline,
                                label: 'About',
                                onTap: () {}),
                            const CustomDivider(height: 8),
                            InkWell(
                              onTap: () async {
                                controller.logout();

                                Get.offAll(
                                  () => const DashboardScreen(),
                                  binding: DashboardBinding(),
                                );
                              },
                              child: Padding(
                                padding: EdgeInsets.all(16.dp),
                                child: Row(
                                  children: [
                                    const Icon(Icons.exit_to_app,
                                        color: CustomColors.errorColor),
                                    SizedBox(width: 8.dp),
                                    Text(
                                      'Logout',
                                      style: CustomTextStyle.red14w400(),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final user = controller.user.value;
    final userNotNull = user != null;

    return InkWell(
      onTap: userNotNull
          ? () {
              Get.to(
                () => const LoginScreen(),
                binding: LoginBinding(),
              );
            }
          : null,
      child: Padding(
        padding: EdgeInsets.all(16.dp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(99),
                child: userNotNull && user.image != null
                    ? Image.network(
                        '${ApiProvider().baseUrl}/${user.image}',
                        width: 80.dp,
                        height: 80.dp,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        'assets/images/logo.png',
                        width: 80.dp,
                        height: 80.dp,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            SizedBox(height: 12.dp),
            Text(
              'Selamat Datang',
              style: CustomTextStyle.black15Bold(),
            ),
            Row(
              children: [
                Text(
                  userNotNull
                      ? '${user.firstname} ${user.lastname}'
                      : 'Silahkan masuk ke akun anda disini',
                  style: CustomTextStyle.black13w400(),
                ),
                const Spacer(),
                Visibility(
                  visible: !userNotNull,
                  child: Icon(Icons.arrow_forward_ios, size: 18.dp),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(
      {required IconData icon,
      required String label,
      required Function() onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(16.dp),
        child: Row(
          children: [
            Icon(icon),
            SizedBox(width: 8.dp),
            Text(
              label,
              style: CustomTextStyle.black14w400(),
            ),
          ],
        ),
      ),
    );
  }
}
