import 'package:sarmini_mbokdhe/core_imports.dart';
import 'package:sarmini_mbokdhe/features/history/history_widget.dart';
import 'package:sarmini_mbokdhe/features/home/home_widget.dart';
import 'package:sarmini_mbokdhe/features/products/products_screen.dart';
import 'package:sarmini_mbokdhe/features/profile/profile_widget.dart';

class DashboardController extends BaseController {
  final pageIndex = 0.obs;
  final _pages = <Widget>[
    const HomeWidget(),
    const ProductsScreen(),
    const HistoryWidget(),
    const ProfileWidget(),
  ];

  Widget getCurrentPage() => _pages[pageIndex.value];
}
