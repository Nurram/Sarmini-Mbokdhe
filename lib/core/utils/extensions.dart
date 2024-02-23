import '../../core_imports.dart';

extension ContextExtensions on BuildContext {
  showSnackbar({required String message}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}

extension DateTimeExtension on DateTime {
  int get firstDayOfMonth => DateTime(year, month, 1).day;
  DateTime get firstDateOfMonth => DateTime(year, month, 1);

  int get lastDayOfMonth => DateTime(year, month + 1, 0).day;
  DateTime get lastDateOfMonth => DateTime(year, month + 1, 0);
}
