import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:sarmini_mbokdhe/core_imports.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 3.dp,
      color: Colors.grey.shade200,
    );
  }
}
