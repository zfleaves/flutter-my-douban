import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_douban/constant/cache_key.dart';
import 'package:flutter_douban/main.dart';
import 'package:shared_preferences/shared_preferences.dart';


class UseTopSourceWidget extends StatefulWidget {
  const UseTopSourceWidget({super.key});

  @override
  State<UseTopSourceWidget> createState() => _UseTopSourceWidget();
}

class _UseTopSourceWidget extends State<UseTopSourceWidget> {
  bool mSelectNetData = false;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      mSelectNetData = prefs.getBool(CacheKey.USE_SOURCE_DATA) ?? false;
    });
  }

  _setData(value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(CacheKey.USE_SOURCE_DATA, value);
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
        child: Row(
          children: <Widget>[
            const Text('TOP数据来源于douban', style: TextStyle(color: Colors.redAccent, fontSize: 17.0),),
            Expanded(child: Container()),
            CupertinoSwitch(
              value: mSelectNetData, 
              onChanged: (bool value) {
                mSelectNetData = value;
                _setData(value);
                String tmp = value ? '书影音数据 使用douban，重启APP后生效' : '书影音数据 使用Imdb，重启APP后生效';
                showDialog(
                  context: context, 
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('提示'),
                      content: Text('$tmp,目前api 接口只有douban数据源了'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          }, 
                          child: const Text('取消')
                        ),
                        TextButton(
                          onPressed: () {
                            RestartWidget.restartApp(context);
                            Navigator.of(context).pop();
                          }, 
                          child: const Text('确定')
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
