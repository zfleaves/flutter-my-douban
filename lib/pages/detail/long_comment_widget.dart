import 'package:flutter/material.dart';
import 'package:flutter_douban/bean/movie_long_comments_entity.dart';
import 'package:flutter_douban/constant/constant.dart';
import 'package:flutter_douban/services/EventBus.dart';
import 'package:flutter_douban/widgets/expandable_text%20.dart';
import 'package:flutter_douban/widgets/rating_bar.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class LongCommentWidget extends StatefulWidget {
  final MovieLongCommentsEntity movieLongCommentsEntity;
  const LongCommentWidget({super.key, required this.movieLongCommentsEntity});

  @override
  State<LongCommentWidget> createState() => _LongCommentWidgetState();
}

class _LongCommentWidgetState extends State<LongCommentWidget>
    with SingleTickerProviderStateMixin {
  final List<String> list = ['影评', '话题', '讨论'];
  late TabController tabController;
  late Color selectColor, unselectedColor;
  late TextStyle selectStyle, unselectedStyle;

  @override
  void initState() {
    tabController = TabController(length: list.length, vsync: this);
    selectColor = Colors.black;
    unselectedColor = const Color.fromARGB(255, 117, 117, 117);
    selectStyle = TextStyle(fontSize: 15, color: selectColor);
    unselectedStyle = TextStyle(fontSize: 15, color: selectColor);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            eventBus.fire(LongCommentEvent('收起'));
          },
          child: Container(
            height: 12.0,
            width: 45.0,
            margin: const EdgeInsets.only(top: 10.0),
            decoration: const BoxDecoration(
                color: Color.fromARGB(255, 218, 214, 217),
                borderRadius: BorderRadius.all(Radius.circular(5.0))),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 15.0),
          alignment: Alignment.centerLeft,
          child: TabBar(
            controller: tabController,
            tabs: list
                .map((item) => Padding(
                      padding:
                          const EdgeInsets.only(bottom: Constant.TAB_BOTTOM),
                      child: Text(item),
                    ))
                .toList(),
            isScrollable: true,
            indicatorColor: selectColor,
            labelColor: selectColor,
            labelStyle: selectStyle,
            unselectedLabelColor: unselectedColor,
            unselectedLabelStyle: unselectedStyle,
            indicatorSize: TabBarIndicatorSize.label,
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: <Widget>[
              ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: widget.movieLongCommentsEntity.reviews.length,
                itemBuilder: (context, index) {
                  List<MovieLongCommentReviews> reviews =
                      widget.movieLongCommentsEntity.reviews;
                  return Column(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(
                            left: Constant.MARGIN_LEFT,
                            right: Constant.MARGIN_RIGHT),
                        color: Colors.white,
                        child: getItem(reviews[index]),
                      ),
                    ],
                  );
                },
              ),
              const Text('话题，暂无数据~'),
              const Text('讨论，暂无数据~')
            ],
          ),
        )
      ],
    );
  }

  Widget getItem(MovieLongCommentReviews review) {
    return GestureDetector(
      onTap: () {
        String url1 = 'https://flutterchina.club/';
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.green,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10.0, bottom: 7.0, right: 5.0),
                    child: CircleAvatar(
                      radius: 10.0,
                      backgroundImage: NetworkImage(review.author.avatar),
                      backgroundColor: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: Text(review.author.name),
                  ),
                ],
              ),
            ),
            body: Column(
              children: [
                Expanded(
                    child: InAppWebView(
                  initialUrlRequest: URLRequest(
                    url: Uri.parse(url1),
                  ),
                  initialOptions: InAppWebViewGroupOptions(
                      crossPlatform: InAppWebViewOptions(
                    useShouldInterceptAjaxRequest: true,
                  )),
                  onProgressChanged:
                      (InAppWebViewController controller, int progress) {},
                ))
              ],
            ),
          );
        }));
      },
      behavior: HitTestBehavior.translucent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.only(top: 10.0, bottom: 7.0, right: 5.0),
                child: CircleAvatar(
                  radius: 10.0,
                  backgroundImage: NetworkImage(review.author.avatar),
                  backgroundColor: Colors.white,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: Text(review.author.name),
              ),
              RatingBar(
                ((review.rating.value * 1.0) / (review.rating.max * 1.0)) *
                    10.0,
                size: 11.0,
                fontSize: 0.0,
              )
            ],
          ),
          Text(
            review.title,
            style: const TextStyle(
                fontSize: 16.0,
                color: Colors.black,
                fontWeight: FontWeight.bold),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: ExpandableText(
                  text: review.content,
                  maxLines: 3,
                  textStyle: const TextStyle(
                      fontSize: 14.0, color: Color(0xff333333)))),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Text(
                '${getUsefulCount(review.commentsCount)}回复 · ${getUsefulCount(review.usefulCount)} 有用'),
          ),
        ],
      ),
    );
  }

  ///将34123转成3.4k
  getUsefulCount(int usefulCount) {
    double a = usefulCount / 1000;
    if (a < 1.0) {
      return usefulCount;
    } else {
      return '${a.toStringAsFixed(1)}k'; //保留一位小数
    }
  }
}
