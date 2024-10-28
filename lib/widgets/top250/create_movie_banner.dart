import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_douban/bean/i_top_entity.dart';
import 'package:flutter_douban/http/net_request.dart';
import 'package:flutter_douban/widgets/top250/create_movie_image.dart';

class CreateMovieBanner extends StatelessWidget {
  final ITopEntity entity;
  final double imageHeight;
  const CreateMovieBanner(
      {super.key, required this.entity, this.imageHeight = 150.0});

  @override
  Widget build(BuildContext context) {
    var shareImage = entity.data[0].shareImage;
    if (shareImage != '') {
      shareImage = shareImage.replaceAll(
          'https://image.querydata.org/', 'https://img.wmdb.tv/');
    } else {
      // NetRequest.getShareImage(entity.doubanId).then((value) {
      //   if (value != null) {
      //     shareImage = value.image;
      //   } else {
      //     shareImage = entity.data[0].poster;
      //   }
      // });
      shareImage = entity.data[0].poster;
    }
    var images = [shareImage, entity.data[0].poster];
    return Swiper(
      itemCount: images.length,
      itemHeight: imageHeight,
      itemWidth: double.infinity,
      layout: SwiperLayout.TINDER,
      autoplay: true,
      itemBuilder: (context, index) {
        return CreateMovieImage(
          imgUrl: images[index],
          imageHeight: imageHeight,
          fit: BoxFit.fill,
        );
      },
    );
  }
}
