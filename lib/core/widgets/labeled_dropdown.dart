import '../../core_imports.dart';

class CustomLabeledDropdown extends StatelessWidget {
  final String label;
  final List<dynamic> items;
  final Function(dynamic value) onSelect;
  final dynamic selectedValue;
  final String? hint;
  final TextInputType? textInputType;
  final EdgeInsets? contentPadding;
  final String? prefix;
  final TextStyle? labelStyle;
  final bool? obscureText;
  final bool? readOnly;
  final double? borderRadius;
  final Color? bgColor;
  final bool isBordered;
  final Color? borderColor;
  final double borderGap;

  const CustomLabeledDropdown({
    super.key,
    required this.label,
    required this.items,
    required this.onSelect,
    required this.selectedValue,
    this.hint,
    this.textInputType,
    this.contentPadding,
    this.prefix,
    this.labelStyle,
    this.obscureText,
    this.readOnly,
    this.borderRadius,
    this.bgColor,
    this.isBordered = true,
    this.borderColor,
    this.borderGap = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: labelStyle ?? CustomTextStyle.black14w700(),
        ),
        SizedBox(height: borderGap),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
          decoration: BoxDecoration(
            borderRadius:
                isBordered ? BorderRadius.circular(borderRadius ?? 16) : null,
            border: isBordered
                ? Border.all(color: borderColor ?? Colors.grey.shade400)
                : BorderDirectional(
                    bottom:
                        BorderSide(color: borderColor ?? Colors.grey.shade400),
                  ),
            color: bgColor,
          ),
          child: DropdownButton(
            underline: const SizedBox(),
            hint: Text('Pilih $label'),
            value: selectedValue,
            isExpanded: true,
            items: items
                .map(
                  (e) => DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  ),
                )
                .toList(),
            onChanged: (value) => onSelect(value),
          ),
        ),
      ],
    );
  }
}
