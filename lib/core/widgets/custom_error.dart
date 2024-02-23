import '../../core_imports.dart';

class CustomErrorWidget extends StatelessWidget {
  final String message;
  final Function() onRefresh;

  const CustomErrorWidget({
    super.key,
    required this.message,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(message),
        const SizedBox(
          height: 8,
          width: double.infinity,
        ),
        ElevatedButton(
          onPressed: onRefresh,
          child: const Text('Refresh'),
        )
      ],
    );
  }
}
