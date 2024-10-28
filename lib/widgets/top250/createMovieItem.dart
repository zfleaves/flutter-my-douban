import 'package:flutter/material.dart';
import 'package:flutter_douban/bean/i_movie_favorite_entity.dart';
import 'package:flutter_douban/bean/i_top_entity.dart';
import 'package:flutter_douban/http/net_request.dart';
import 'package:flutter_douban/provider/favorite_provider.dart';
import 'package:flutter_douban/router.dart';
import 'package:flutter_douban/sql/exe/favorite_sql.dart';
import 'package:flutter_douban/widgets/rating_bar.dart';
import 'package:flutter_douban/widgets/top250/create_movie_banner.dart';
import 'package:flutter_douban/widgets/top250/create_movie_image.dart';
import 'package:provider/provider.dart';

class CreateMovieItem extends StatefulWidget {
  final ITopEntity entity;
  final int index;
  final double imageHeight;
  const CreateMovieItem(
      {super.key,
      required this.entity,
      required this.index,
      this.imageHeight = 150.0});

  @override
  State<CreateMovieItem> createState() => _CreateMovieItemState();
}

class _CreateMovieItemState extends State<CreateMovieItem> {

  @override
  void initState() {
    super.initState();
    // print(widget.entity.doubanId);
    // NetRequest.getShareImage(widget.entity.doubanId).then();
    // _getShareImage();
  }

  _getShareImage() async {
    var result = NetRequest.getShareImage(widget.entity.doubanId);
    print(result);
  }

  ///创建电影item左列图片+排名
  Widget createRank(String imgUrl, int rank) {
    return Stack(
      alignment: Alignment.topLeft,
      children: [
        CreateMovieImage(
          imgUrl: imgUrl,
          imageHeight: widget.imageHeight,
        ),
        Positioned(top: 0, left: 0, child: createRankMedal(rank))
      ],
    );
  }

  ///排名勋章
  Widget createRankMedal(int rank) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0)),
      child: Container(
        padding: const EdgeInsets.all(5.0),
        color: getRankColor(rank),
        child: Center(
          child: Text('${rank + 1}',
              style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
        ),
      ),
    );
  }

  ///创建电影名称和想看Icon,Row
  Widget createMovieName(ITopEntity entity) {
    return Container(
      margin: const EdgeInsets.only(top: 10, right: 10),
      child: Row(
        children: [
          const Icon(
            Icons.slow_motion_video,
            color: Colors.red,
          ),
          Text(
            entity.data[0].name,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.only(right: 10.0),
                child: const Align(
                  alignment: Alignment.topRight,
                  child: Icon(
                    Icons.add_reaction_outlined,
                    color: Colors.orange,
                  ),
                ),
              ))
        ],
      ),
    );
  }

  ///创建电影评分row
  Widget createMovieRating(ITopEntity entity, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 2.0),
      child: Row(
        children: <Widget>[
          RatingBar(
            double.parse(
                entity.doubanRating.isNotEmpty ? entity.doubanRating : '0'),
            color: Colors.orange,
          ),
          Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  final favoriteProvide = context.read<FavoriteProvider>();
                  exeFavoriteInsert(
                      MovieFavorite(
                          entity.doubanId,
                          entity.data[0].poster,
                          entity.data[0].name,
                          entity.data[0].country,
                          entity.data[0].language,
                          entity.data[0].genre,
                          entity.data[0].description),
                      favoriteProvide);
                },
                child: const Text(
                  '收藏',
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.orange,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  ///创建电影年/国家/类型
  Widget createMovieDescribe(ITopEntity entity) {
    return Align(
      alignment: Alignment.topLeft,
      child: Text(
        '${entity.year}/${entity.data[0].country}/${entity.data[0].genre}',
        textAlign: TextAlign.start,
        style: const TextStyle(fontSize: 14.0, color: Colors.grey),
      ),
    );
  }

  ///电影描述
  Widget createMovieAlias(String alias) {
    if (alias.isEmpty) {
      alias = 'unknown';
    }
    return Container(
      margin: const EdgeInsets.only(top: 10.0, bottom: 30.0, right: 10.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          alias,
          textAlign: TextAlign.start,
          maxLines: 2,
          style: const TextStyle(
            fontSize: 12.0,
            color: Colors.black,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // print(widget.entity.doubanId);
        // // Navigator.of(context).push(MaterialPageRoute(builder: (context) => MovieDetailPage(entity.doubanId,entity.data[0].name)));
        MyRouter.push(context, MyRouter.movieDetailPage,
            {'doubanId': widget.entity.doubanId, 'name': widget.entity.data[0].name});
      },
      child: SizedBox(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    flex: 2,
                    child:
                        createRank(widget.entity.data[0].poster, widget.index)),
                Expanded(
                    flex: 6,
                    child: CreateMovieBanner(
                      entity: widget.entity,
                      imageHeight: widget.imageHeight,
                    ))
              ],
            ),
            createMovieName(widget.entity),
            createMovieRating(widget.entity, context),
            createMovieDescribe(widget.entity),
            createMovieAlias(widget.entity.alias)
          ],
        ),
      ),
    );
  }

  ///排名颜色
  Color getRankColor(int rank) {
    if (rank == 0) {
      return Colors.amber;
    } else if (rank == 1) {
      return Colors.lightBlue;
    } else if (rank == 2) {
      return Colors.brown;
    }
    return Colors.grey;
  }
}
