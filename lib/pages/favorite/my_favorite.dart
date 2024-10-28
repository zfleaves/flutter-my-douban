import 'package:flutter/material.dart';
import 'package:flutter_douban/bean/i_movie_favorite_entity.dart';
import 'package:flutter_douban/main.dart';
import 'package:flutter_douban/pages/search/movie_item.dart';
import 'package:flutter_douban/provider/favorite_provider.dart';
import 'package:flutter_douban/sql/dao/favorite_dao.dart';
import 'package:flutter_douban/tools/circularTool.dart';
import 'package:flutter_douban/tools/toastTool.dart';
import 'package:provider/provider.dart';

class MyFavoritePage extends StatefulWidget {
  const MyFavoritePage({super.key});

  @override
  State<MyFavoritePage> createState() => _MyFavoritePageState();
}

class _MyFavoritePageState extends State<MyFavoritePage> {
  @override
  void initState() {
    super.initState();
    _loadFavoriteList();
  }

  Future _loadFavoriteList() async {
    await FavoriteDao.getInstance().queryAll().then((value) {
      print(value);
      final favoriteProvider = context.read<FavoriteProvider>();
      if (value != null) {
        favoriteProvider.initFavoriteList(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('我的收藏'),
        ),
        backgroundColor: Colors.white,
        body: Consumer<FavoriteProvider>(
          builder: (context, favoriteProvider, child) {
            if (favoriteProvider.favoriteList.isEmpty) {
              return const Center(child: Text('暂未收藏任何影片!'));
            }
            return ListView.builder(
              itemCount: favoriteProvider.favoriteList.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(favoriteProvider.favoriteList[index].movieName),
                  background: Container(
                    alignment: Alignment.center,
                    color: Colors.blue,
                    child: ListTile(
                        leading: const Icon(
                          Icons.tag_faces_rounded,
                          color: Colors.white,
                        ),
                        title: getText('就不让你删，气死你!!!', color: Colors.white)),
                  ),

                  ///从右到左的背景颜色
                  secondaryBackground: Container(
                    alignment: Alignment.center,
                    color: Colors.red,
                    child: ListTile(
                        leading: const Icon(Icons.delete_forever,
                            color: Colors.white),
                        title: getText('删就删咯，反正不爱了...', color: Colors.white)),
                  ),

                  ///从左到右的背景颜色
                  confirmDismiss: (direction) async {
                    switch (direction) {
                      case DismissDirection.endToStart:
                        return await _showDeleteDialog(
                                context,
                                favoriteProvider.favoriteList[index],
                                index,
                                favoriteProvider) ==
                            true;
                      case DismissDirection.vertical:
                      case DismissDirection.horizontal:
                      case DismissDirection.startToEnd:
                      case DismissDirection.up:
                      case DismissDirection.down:
                      case DismissDirection.none:
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    // child: Text('data'),
                    child: MovieItem(favoriteProvider.favoriteList[index]),
                  ),
                );
              },
            );
          },
        ));
  }

  ///删除提示框
  Future<bool?> _showDeleteDialog(BuildContext context, MovieFavorite bean, int index, FavoriteProvider provider) {
    return showDialog<bool>(
      context: context, 
      builder: (BuildContext context) {
        return AlertDialog(
          title: getText('系统提示',textAlign: TextAlign.center,fontWeight: FontWeight.bold,textSize: 20),
          content: getText('是否要从收藏列表中删除影片《${bean.movieName}》?',textSize: 14,maxLine: 2),
          actions: <Widget>[
            TextButton(
              child: getText('确定',color: Colors.red),
              onPressed: () async{
                await FavoriteDao.getInstance().delete(bean.doubanId);
                provider.removeItem = index;
                showSuccessToast('删除成功!');
                Navigator.pop(context,true);
              },
            ),
            TextButton(
              child: getText('取消',color: Colors.blue),
              onPressed: () {
                showSuccessToast('取消删除!');
                Navigator.pop(context,false);
              },
            ),
          ],
        );
      }
    );
  }
}
