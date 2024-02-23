import '../../core_imports.dart';

class CustomConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final Function() onConfirm;
  final Function()? onCancel;

  const CustomConfirmationDialog({
    super.key,
    required this.title,
    this.message = 'Apakah anda yakin?',
    required this.onConfirm,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: CustomTextStyle.red16w600(),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Divider(),
            TextButton(
              onPressed: onConfirm,
              child: const Text(
                'Ya',
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
              ),
            ),
            const Divider(),
            TextButton(
              onPressed: onCancel ?? Get.back,
              child: Text(
                'Tidak',
                style: CustomTextStyle.red14w600(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
