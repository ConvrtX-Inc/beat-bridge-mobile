// ignore_for_file: always_put_required_named_parameters_first, public_member_api_docs, diagnostic_describe_all_properties

import 'package:beatbridge/utils/approutes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// webview spotify login
class WebViewWidget extends StatelessWidget {
  ///Constructor
  const WebViewWidget(
      {Key? key,
      required this.initialUrl,
      required this.redirectUri,
      required this.onCountChanged})
      : super(key: key);

  final String initialUrl;
  final String redirectUri;
  final Function(String) onCountChanged;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: InkWell(
        child: Icon(
          Icons.arrow_back_ios,
          size: 30,
        ),
        onTap: () {
          AppRoutes.pop(context);
        },
      )),
      body: WebView(
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: initialUrl,
        navigationDelegate: (navReq) {
          if (navReq.url.startsWith(redirectUri)) {
            onCountChanged(navReq.url);
            Navigator.pop(context);
            return NavigationDecision.prevent;
          }

          return NavigationDecision.navigate;
        },
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('initialUrl', initialUrl));
  }
}
