import '../../core_imports.dart';

class EmptyWidget extends StatelessWidget {
  final String image;
  final String message;

  const EmptyWidget({
    super.key,
    this.image = 'assets/images/empty.png',
    this.message = 'No Data!',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Image.asset(
          image,
          height: 120,
        ),
        const SizedBox(height: 16),
        Text(
          message,
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}
