import 'package:flutter/material.dart';
import 'package:flutter_douban/util/screen_utils.dart';
import 'package:flutter_douban/widgets/shop_webview.dart';
String url1 = 'https://flutterchina.club/';
String url2 = 'http://flutterall.com/';
bool _closed = false;
bool _isShow = true;

class ShopPageWidget extends StatelessWidget {
  const ShopPageWidget({super.key});

  void setShowState(bool isShow) {
    _isShow = isShow;
    if (!isShow) {
      _closed = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return const WebViewPageWidget();
  }
}

class WebViewPageWidget extends StatefulWidget {
  const WebViewPageWidget({super.key});

  @override
  State<WebViewPageWidget> createState() => _WebViewPageWidgetState();
}

class _WebViewPageWidgetState extends State<WebViewPageWidget>
    with SingleTickerProviderStateMixin {
  var list = ['豆芽豆品', '豆芽时间'];
  int selectIndex = 0;
  late Color selectColor, unselectColor;
  late TextStyle selectStyle, unselectedStyle;
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: list.length, vsync: this);
    selectColor = Colors.green;
    unselectColor = const Color.fromARGB(255, 117, 117, 117);
    selectStyle = const TextStyle(fontSize: 18);
    unselectedStyle = const TextStyle(fontSize: 18);
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isShow) {
      return Container();
    }
    return Container(
      color: Colors.white,
      child: SafeArea(
          child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(flex: 1, child: Container()),
              Expanded(
                  flex: 3,
                  child: Container(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: TabBar(
                      tabs: list.map((item) => Text(item)).toList(),
                      isScrollable: false,
                      controller: tabController,
                      indicatorColor: selectColor,
                      labelColor: selectColor,
                      labelStyle: selectStyle,
                      unselectedLabelColor: unselectColor,
                      unselectedLabelStyle: unselectedStyle,
                      indicatorSize: TabBarIndicatorSize.label,
                      onTap: (value) {
                        setState(() {
                          selectIndex = selectIndex;
                          // _webviewReference.reloadUrl(selectIndex == 0 ? url1 : url2);
                        });
                      },
                    ),
                  )),
              Expanded(
                flex: 1,
                child: Container(),
              )
            ],
          ),
          Expanded(
            child: selectIndex == 0 ? ShopWebview(url: url1) : Text('data')
          )
        ],
      )),
    );
  }
}
