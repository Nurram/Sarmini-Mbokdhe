import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:sarmini_mbokdhe/core_imports.dart';

class SearchTextfield extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final Function() onTap;
  final bool readOnly;
  final FocusNode? node;
  final Color? bgColor;
  final Function(String) onChanged;
  final Function(String)? onSubmitted;

  const SearchTextfield({
    super.key,
    required this.controller,
    required this.hint,
    required this.onTap,
    required this.onChanged,
    this.onSubmitted,
    this.readOnly = false,
    this.node,
    this.bgColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 5.h,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: SizedBox(
        height: 2.5.h,
        child: TextField(
          controller: controller,
          focusNode: node,
          readOnly: readOnly,
          onTap: onTap,
          autofocus: true,
          onSubmitted: onSubmitted,
          cursorColor: CustomColors.primaryColor,
          style: TextStyle(fontSize: 14.dp, fontWeight: FontWeight.w400),
          textAlignVertical: TextAlignVertical.center,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(Icons.search, size: 18.dp),
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(bottom: 1.5.h, right: 3.w),
          ),
        ),
      ),
    );
  }
}
