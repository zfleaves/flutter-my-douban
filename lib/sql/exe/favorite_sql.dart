import 'package:flutter_douban/bean/i_movie_favorite_entity.dart';
import 'package:flutter_douban/provider/favorite_provider.dart';
import 'package:flutter_douban/sql/dao/favorite_dao.dart';
import 'package:flutter_douban/tools/toastTool.dart';

///点击收藏按钮，将此item添加到数据库
///根据状态进行toast提示
exeFavoriteInsert(MovieFavorite entity, favoriteProvide) async {
  bool isExist = await FavoriteDao.getInstance().isExist(entity.doubanId);
  print(isExist);
  if(!isExist) {
    int flag = await FavoriteDao.getInstance().insert(entity);
    final List<MovieFavorite> list = [entity];
    favoriteProvide.setList = list;
    if (flag > 0) {
      showSuccessToast('收藏成功!');
    } else {
      showFailedToast('收藏失败!');
    }
  } else{
    showFailedToast('此影片已被收藏，请勿重复添加!');
  }
} 

isFavoriteInserted(String doubanId) async => await FavoriteDao.getInstance().isExist(doubanId);