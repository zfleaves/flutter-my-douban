

class NetPath {
  static const BaseUrl = 'https://api.wmdb.tv';

  ///获取豆瓣250榜单
  static String getTop250(int skip,int limit, String type) => '/api/v1/top?type=$type&skip=$skip&limit=$limit&lang=Cn';
  // static String getTop250(int skip,int limit, String type) => '/api/v1/top?type=Imdb&skip=$skip&limit=$limit&lang=Cn';

  ///根据豆瓣id获取单个电影详情
  static String getMovieDetail(String doubanid) => '/movie/api?id=$doubanid';

  ///根据关键字进行搜索
  
  // https://api.wmdb.tv/api/v1/movie/search?流浪地球=$key&limit=10&skip=0&lang=Cn
  static String getSearchContent(String key) =>'/api/v1/movie/search?q=$key&limit=10&skip=0&lang=Cn';

  ///生成分享图片
  static String getShareImage(String doubanId) => '/movie/api/generateimage?doubanId=$doubanId&lang=En';
}