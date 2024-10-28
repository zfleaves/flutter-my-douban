import 'package:flutter/material.dart';
import 'package:flutter_douban/bean/comments_entity.dart';
import 'package:flutter_douban/bean/movie_detail_bean.dart';
import 'package:flutter_douban/bean/movie_long_comments_entity.dart';
import 'package:flutter_douban/http/API.dart';
import 'package:flutter_douban/http/mock_request.dart';
import 'package:flutter_douban/pages/detail/bottom_drag_widget.dart';
import 'package:flutter_douban/pages/detail/detail_body.dart';
import 'package:flutter_douban/pages/detail/drag_container.dart';
import 'package:flutter_douban/pages/detail/long_comment_widget.dart';
import 'package:flutter_douban/widgets/loading_widget.dart';
import 'package:palette_generator/palette_generator.dart';

class DetailPage extends StatefulWidget {
  final String doubanId;
  final String name;
  const DetailPage({super.key, required this.doubanId, required this.name});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  double get screenH => MediaQuery.of(context).size.height;
  late String subjectId;
  Color pickColor = const Color(0xffffffff); //默认主题色
  late CommentsEntity commentsEntity;
  late MovieLongCommentsEntity movieLongCommentReviews;
  bool loading = true;
  late MovieDetailBean _movieDetailBean;
  final MockRequest _mockRequest = MockRequest();

  @override
  void initState() {
    super.initState();
    requestAPI();
  }

  void requestAPI() async {
    Future(() {
      return _mockRequest.mock2('subject_26266893');
    }).then((result) {
      // print(result);
      _movieDetailBean = MovieDetailBean.fromJson(result);
      var images = _movieDetailBean.images;
      var large = images?.large;
      return PaletteGenerator.fromImageProvider(NetworkImage(large!));
    }).then((paletteGenerator) {
      if (paletteGenerator != null && paletteGenerator.colors.isNotEmpty) {
        pickColor = paletteGenerator.colors
            .toList()[paletteGenerator.colors.toList().length - 1];
        // print(paletteGenerator.colors.toList());
      }
      return _mockRequest.mock2("comments");
    }).then((result2) {
      commentsEntity = CommentsEntity.fromJson(result2);
      // print(result2);
    }).then((_) {
      //使用模拟数据
      return _mockRequest.get(API.REIVIEWS);
    }).then((result3) {
      movieLongCommentReviews = MovieLongCommentsEntity.fromJson(result3);
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pickColor,
      body: SafeArea(
          child: loading
              ? CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverAppBar(
                      title: const Text('电影'),
                      centerTitle: true,
                      pinned: true,
                      backgroundColor: pickColor,
                    ),
                    SliverToBoxAdapter(
                        child: SizedBox(
                      height: screenH * 0.8,
                      width: double.infinity,
                      child: LoadingWidget.getLoading(
                          backgroundColor: Colors.transparent),
                    )),
                  ],
                )
              : BottomDragWidget(
                  body: DetailBody(
                    movieDetailBean: _movieDetailBean,
                    pickColor: pickColor,
                    commentsEntity: commentsEntity,
                  ),
                  dragContainer: DragContainer(
                      drawer: Container(
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 243, 244, 248),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0))),
                        child: OverscrollNotificationWidget(
                          child: LongCommentWidget(
                              movieLongCommentsEntity: movieLongCommentReviews),
                        ),
                      ),
                      defaultShowHeight: screenH * 0.1,
                      height: screenH * 0.8))),
    );
  }
}
