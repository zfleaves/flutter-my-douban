import 'package:flutter/material.dart';
import 'package:flutter_douban/constant/constant.dart';


class PersonDetailPage extends StatefulWidget {
  final String id;
  final String personImgUrl;
  const PersonDetailPage(this.personImgUrl, this.id, {super.key});

  @override
  State<PersonDetailPage> createState() => _PersonDetailPageState();
}

class _PersonDetailPageState extends State<PersonDetailPage> {
  bool loading = true;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Container(
        padding: const EdgeInsets.all(10.0),
        alignment: Alignment.center,
        color: Colors.white,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          '${Constant.ASSETS_IMG}ic_arrow_back.png',
                          width: 25.0,
                          height: 25.0,
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      '个人页面',
                      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
              const Expanded(
                flex: 1,
                child: Center(
                  child: Text('暂无接口api，敬请期待'),
                ),
              )
            ],
          )
        ),
      ),
    );
  }
}