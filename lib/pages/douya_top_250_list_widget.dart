import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_douban/bean/subject_entity.dart';
import 'package:flutter_douban/http/API.dart';
import 'package:flutter_douban/router.dart';
import 'package:flutter_douban/widgets/rating_bar.dart';

class DouBanListView extends StatefulWidget {
  const DouBanListView({super.key});

  @override
  State<DouBanListView> createState() => _DouBanListViewState();
}

class _DouBanListViewState extends State<DouBanListView>
    with AutomaticKeepAliveClientMixin {
  List<Subject> subjects = [];
  double itemHeight = 150.0;

  @override
  void initState() {
    super.initState();
    API().top250((datas) {
      setState(() {
        subjects = datas;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: getListViewContainer(),
    );
  }

  Widget numberWidget(index) {
    return Container(
      decoration: const BoxDecoration(
          color: Color.fromARGB(255, 255, 201, 129),
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      margin: const EdgeInsets.only(left: 12, top: 10, bottom: 5),
      child: Text(
        'No.$index',
        style: const TextStyle(color: Color.fromARGB(255, 133, 66, 0)),
      ),
    );
  }

  Widget getItemContainerView(Subject subject) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: getMovieInfoView(subject),
          )
        ],
      ),
    );
  }

  // 电影标题，星标评分，演员简介Container
  Widget getMovieInfoView(Subject subject) {
    return Container(
      // height: itemHeight,
      alignment: Alignment.topLeft,
      child: Column(
        children: <Widget>[
          getTitleView(subject),
          const SizedBox(height: 5,),
          RatingBar(subject.rating?.average),
          DescWidget(subject)
        ],
      ),
    );
  }

  //肖申克的救赎(1993) View
  getTitleView(Subject subject) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Row(
            children: [
              const Icon(
                Icons.play_circle_outline,
                color: Colors.redAccent,
              ),
              Text(
                subject.title,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              Text('(${subject.year})',
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey))
            ],
          ),
        ),
      ],
    );
  }

  //圆角图片
  Widget getImage(var imgUrl) {
    return Container(
      // width: 300,
      width: double.infinity,
      height: itemHeight,
      decoration: BoxDecoration(
          image:
              DecorationImage(image: NetworkImage(imgUrl), fit: BoxFit.cover),
          borderRadius: const BorderRadius.all(Radius.circular(5.0))),
      margin: const EdgeInsets.only(left: 8, top: 3, right: 8, bottom: 3),
      // color: Colors.red,
      // child: Text('1111'),
    );
  }

  Widget getListViewContainer() {
    if (subjects.isEmpty) {
      return const CupertinoActivityIndicator();
    }
    return ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: subjects.length,
        itemBuilder: (BuildContext context, int index) {
          Subject bean = subjects[index];
          return GestureDetector(
            onTap: () {
              MyRouter.push(context, MyRouter.movieDetailPage, {'doubanId': bean.id, 'name': bean.title});
              
            },
            //Flutter 手势处理
            child: Container(
              color: Colors.transparent,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  numberWidget(index + 1),
                  getImage(bean.images?.medium),
                  getItemContainerView(bean),
                  //下面的灰色分割线
                  Container(
                    height: 10,
                    width: double.infinity,
                    color: const Color.fromARGB(255, 234, 233, 234),
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  bool get wantKeepAlive => true;
}

class DescWidget extends StatelessWidget {
  final Subject subject;
  const DescWidget(this.subject, {super.key});

  @override
  Widget build(BuildContext context) {
    var casts = subject.casts;
    var sb = StringBuffer();
    var genres = subject.genres;
    for (var i = 0; i < genres.length; i++) {
      sb.write('${genres[i]}  ');
    }
    sb.write("/ ");
    List<String> list = List.generate(casts!.length, (int index) => casts[index].name.toString());
    for (var i = 0; i < list.length; i++) {
      sb.write('${list[i]} ');
    }
    return Container(
      alignment: Alignment.topLeft,
      child: Text(
        sb.toString(),
        softWrap: true,
        textDirection: TextDirection.ltr,
        style:
            const TextStyle(fontSize: 16, color: Color.fromARGB(255, 118, 117, 118))
      ),
    );
  }
}
