import 'package:sarmini_mbokdhe/core_imports.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ProfileWeb extends StatelessWidget {
  final String url;
  ProfileWeb({
    super.key,
    required this.url,
  });

  final controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted);
  @override
  Widget build(BuildContext context) {
    controller.loadRequest(Uri.parse(url));

    return Scaffold(
      appBar: AppBar(title: const Text('')),
      body: WebViewWidget(controller: controller),
    );
  }
}
