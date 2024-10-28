import 'package:flutter/material.dart';
import 'package:flutter_douban/bean/subject_entity.dart';
import 'package:flutter_douban/constant/constant.dart';
import 'package:flutter_douban/http/API.dart';
import 'package:flutter_douban/http/mock_request.dart';
import 'package:flutter_douban/router.dart';
import 'package:flutter_douban/widgets/image/radius_img.dart';
import 'package:flutter_douban/widgets/loading_widget.dart';
import 'package:flutter_douban/widgets/search_text_field_widget.dart';

class GroupPage extends StatelessWidget {
  const GroupPage({super.key});

  @override
  Widget build(BuildContext context) {
    String hintText = '搜索书影音 小组 日记 用户等';
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Column(
        children: <Widget>[
          SearchTextFieldWidget(
            margin: const EdgeInsets.all(Constant.MARGIN_RIGHT),
            hintText: hintText,
            onTab: () {
              MyRouter.push(context, MyRouter.searchPage, hintText);
            },
          ),
          const Expanded(
            child: _GroupWidget(),
          )
        ],
      )),
    );
  }
}

class _GroupWidget extends StatefulWidget {
  const _GroupWidget({super.key});

  @override
  State<_GroupWidget> createState() => __GroupWidgetState();
}

class __GroupWidgetState extends State<_GroupWidget> {
  List<Subject> list = [];
  bool loading = true;

  var _mockRequest = MockRequest();

  @override
  void initState() {
    super.initState();
    _getTheaters();
  }

  Future _getTheaters() async {
    // _mockRequest.get(API.IN_THEATERS);
    var result = await _mockRequest.get(API.IN_THEATERS);
    var resultList = result['subjects'];
    setState(() {
      list = resultList.map<Subject>((item) => Subject.fromMap(item)).toList();
      loading = false;
    });
    // print(result);
  }

  Widget _getBody() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: list.length,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Image.asset('${Constant.ASSETS_IMG}ic_group_top.png');
        }
        Subject bean = list[index - 1];
        return Padding(
          padding: const EdgeInsets.only(
              right: Constant.MARGIN_RIGHT, left: 6.0, top: 13.0),
          child: _getItem(bean, index - 1),
        );
      },
    );
  }

  Widget _getItem(Subject bean, int index) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        MyRouter.push(context, MyRouter.movieDetailPage, {'doubanId': bean.id, 'name': bean.title});
      },
      child: Row(
        children: <Widget>[
          RadiusImg.get(bean.images?.small, 50.0, radius: 3.0),
          Expanded(
              child: Container(
            alignment: Alignment.topLeft,
            margin: const EdgeInsets.only(left: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  bean.title,
                  style: const TextStyle(
                      fontSize: 17.0, fontWeight: FontWeight.bold),
                ),
                Text(bean.pubdates != null ? bean.pubdates[0] : '',
                    style: const TextStyle(fontSize: 13.0))
              ],
            ),
          )),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Text(
              '${bean.collect_count}人',
              style: const TextStyle(fontSize: 13.0),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                list[index].tag = !list[index].tag;
              });
            },
            child: Image.asset(
              Constant.ASSETS_IMG +
                  (list[index].tag
                      ? 'ic_group_checked_anonymous.png'
                      : 'ic_group_check_anonymous.png'),
              width: 25.0,
              height: 25.0,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LoadingWidget.containerLoadingBody(_getBody(), loading: loading);
  }
}
