import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class ShopWebview extends StatefulWidget {
  final String url;
  const ShopWebview({super.key, required this.url});

  @override
  State<ShopWebview> createState() => _ShopWebviewState();
}

class _ShopWebviewState extends State<ShopWebview>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  String url = '';

  @override
  void initState() {
    super.initState();
    url = widget.url;
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey webViewKey = GlobalKey();
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
              child: InAppWebView(
            key: webViewKey,
            initialUrlRequest: URLRequest(
              url: Uri.parse(widget.url),
              // url: Uri.parse('https://www.baidu.com'),
            ),
            initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(
              useShouldInterceptAjaxRequest: true,
            )),
            onProgressChanged:
                (InAppWebViewController controller, int progress) {},
            // onLoadError: () {},
          ))
        ],
      ),
    );
  }
}
