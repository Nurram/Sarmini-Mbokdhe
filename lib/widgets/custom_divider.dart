import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:sarmini_mbokdhe/core_imports.dart';

class CustomDivider extends StatelessWidget {
  final int height;

  const CustomDivider({super.key, this.height = 3});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height.dp,
      color: Colors.grey.shade200,
    );
  }
}
