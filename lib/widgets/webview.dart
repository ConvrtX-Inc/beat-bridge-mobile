import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewWidget extends StatelessWidget {
  const WebViewWidget({Key? key, required this.initialUrl}) : super(key: key);

  final String initialUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebView(
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: initialUrl,
        // navigationDelegate: (NavigationDecision navigationDecision) {
        //   return NavigationDecision.navigate;
        // },
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('initialUrl', initialUrl));
  }
}
