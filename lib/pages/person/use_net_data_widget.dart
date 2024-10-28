import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_douban/constant/cache_key.dart';
import 'package:flutter_douban/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UseNetDataWidget extends StatefulWidget {
  const UseNetDataWidget({super.key});

  @override
  State<UseNetDataWidget> createState() => _UseNetDataWidgetState();
}

class _UseNetDataWidgetState extends State<UseNetDataWidget> {
  bool mSelectNetData = false;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      mSelectNetData = prefs.getBool(CacheKey.USE_NET_DATA) ?? false;
    });
  }

  _setData(value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(CacheKey.USE_NET_DATA, value);
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
        child: Row(
          children: <Widget>[
            const Text('书影音数据是否来自网络', style: TextStyle(color: Colors.redAccent, fontSize: 17.0),),
            Expanded(child: Container()),
            CupertinoSwitch(
              value: mSelectNetData, 
              onChanged: (bool value) {
                mSelectNetData = value;
                _setData(value);
                String tmp = value ? '书影音数据 使用网络数据，重启APP后生效' : '书影音数据 使用本地数据，重启APP后生效';
                showDialog(
                  context: context, 
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('提示'),
                      content: Text(tmp),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          }, 
                          child: const Text('稍后我自己重启')
                        ),
                        TextButton(
                          onPressed: () {
                            RestartWidget.restartApp(context);
                            Navigator.of(context).pop();
                          }, 
                          child: const Text('现在重启')
                        )
                      ],
                    );
                  }
                );
              }
            )
          ],
        ),
      ),
    );
  }
}
