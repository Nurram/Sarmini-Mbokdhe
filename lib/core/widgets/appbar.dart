import 'package:flutter/services.dart';

import '../../core_imports.dart';

// ignore: non_constant_identifier_names
class CustomAppbar {
  static PreferredSizeWidget standard(
      {String title = '',
      Widget? titleWidget,
      List<Widget>? actions,
      bool centerTitle = false,
      double elevation = 2}) {
    return AppBar(
      title: titleWidget ?? Text(
        title,
        maxLines: 1,
      ),
      actions: actions,
      elevation: elevation,
      centerTitle: centerTitle,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: CustomColors.primaryColor,
          statusBarIconBrightness: Brightness.dark),
    );
  }

  static PreferredSizeWidget transparent(
      {String? title,
      Widget? titleWidget,
      Color? titleColor,
      FontWeight? fontWeight,
      double? elevation,
      List<Widget>? actions}) {
    return AppBar(
      title: titleWidget ??
          Text(
            title ?? '',
            maxLines: 1,
            style: TextStyle(fontWeight: fontWeight, color: titleColor),
          ),
      actions: actions,
      elevation: elevation,
      centerTitle: false,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.black,
      systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: CustomColors.primaryColor,
          statusBarIconBrightness: Brightness.dark),
    );
  }

  static PreferredSizeWidget customColor({
    required Color bgColor,
    String? title,
    Widget? titleWidget,
    Color? titleColor,
    bool centerTitle = false,
    FontWeight? fontWeight,
    double? elevation,
    List<Widget>? actions,
    Color foregroundColor = Colors.black,
  }) {
    return AppBar(
      title: titleWidget ??
          Text(
            title ?? '',
            maxLines: 1,
            style: TextStyle(fontWeight: fontWeight, color: titleColor),
          ),
      actions: actions,
      elevation: elevation,
      centerTitle: centerTitle,
      backgroundColor: bgColor,
      foregroundColor: foregroundColor,
      systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: bgColor, statusBarIconBrightness: Brightness.light),
    );
  }
}
