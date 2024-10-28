import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_douban/bean/i_movie_detail_entity.dart';
import 'package:flutter_douban/http/net_request.dart';
import 'package:flutter_douban/pages/movieDetail/movie_detail_body.dart';
import 'package:flutter_douban/widgets/custom_shimmer.dart';
import 'package:flutter_douban/widgets/loading_widget.dart';
import 'package:palette_generator/palette_generator.dart';

class MovieDetailPage extends StatefulWidget {
  final String doubanId;
  final String name;
  const MovieDetailPage(
      {super.key, required this.doubanId, required this.name});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  double get screenH => MediaQuery.of(context).size.height;
  bool loading = true;
  Color pickColor = const Color(0xffffffff); //默认主题色
  late IMovieDetailEntity movieDetailEntity;

  @override
  void initState() {
    super.initState();
    requestAPI();
  }

  void requestAPI() async {
    Future(() {
      return NetRequest.getMovieDetail(widget.doubanId);
    }).then((result) {
      movieDetailEntity = result;
      var images = movieDetailEntity.data[0].poster;
      return PaletteGenerator.fromImageProvider(NetworkImage(images));
    }).then(
      (paletteGenerator) {
        if (paletteGenerator.colors.isNotEmpty) {
          pickColor = paletteGenerator.colors
              .toList()[0];
          print(pickColor);
        }
        setState(() {
          loading = false;
        });
      },
    );
  }

  Future<IMovieDetailEntity> getMovieDetailInfo(doubanId) async {
    return NetRequest.getMovieDetail(widget.doubanId);
  }

  Future getPickColor(url) async {
    PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(NetworkImage(url));
    if (paletteGenerator.colors.isNotEmpty) {
      pickColor = paletteGenerator.colors
          .toList()[paletteGenerator.colors.toList().length - 1];
      // print(paletteGenerator.colors.toList());
    }
    return pickColor;
  }

  _getbody(child) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          title: Text(widget.name),
          centerTitle: true,
          pinned: true,
          backgroundColor: pickColor,
        ),
        child
      ],
    );
  }

  SliverToBoxAdapter loadingItem() {
    return SliverToBoxAdapter(
        child: SizedBox(
      height: screenH * 0.8,
      width: double.infinity,
      child: LoadingWidget.getLoading(backgroundColor: Colors.transparent),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pickColor,
      body: SafeArea(
        child: loading ? _getbody(loadingItem()) : MovieDetailBody(
          movieDetailEntity: movieDetailEntity,
          name: widget.name,
          pickColor: pickColor,
          doubanId: widget.doubanId
        )
      )
    );
  }
}
