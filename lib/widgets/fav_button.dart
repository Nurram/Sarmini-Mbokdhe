import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:sarmini_mbokdhe/core_imports.dart';

class FavButton extends StatelessWidget {
  const FavButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.dp),
      margin: EdgeInsets.only(top: 8.dp, right: 8.dp),
      decoration:
          BoxDecoration(shape: BoxShape.circle, color: Colors.grey.shade300),
      child: Icon(
        Icons.favorite,
        color: Colors.grey,
        size: 18.sp,
      ),
    );
  }
}
