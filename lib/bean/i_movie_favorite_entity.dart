class MovieFavorite {
  late String doubanId;//豆瓣id
  late String moviePoster;//电影海报
  late String movieName;//电影名称
  late String movieCountry;//电影国家
  late String movieLanguage;//电影语言
  late String movieGenre;//电影类型
  late String movieDescription; //电影描述

  MovieFavorite(
    this.doubanId,
    this.moviePoster,
    this.movieName,
    this.movieCountry,
    this.movieLanguage,
    this.movieGenre,
    this.movieDescription
  );

  MovieFavorite.fromMap(Map<String, dynamic> map) {
    doubanId = map['doubanId'];
    moviePoster = map['moviePoster'];
    movieName = map['movieName'];
    movieCountry = map['movieCountry'];
    movieLanguage = map['movieLanguage'];
    movieGenre = map['movieGenre'];
    movieDescription = map['movieDescription'];
  }

  MovieFavorite.fromJson(dynamic json){
    doubanId = json['doubanId'];
    moviePoster = json['MoviePoster'];
    movieName = json['MovieName'];
    movieCountry = json['MovieCountry'];
    movieLanguage = json['MovieLanguage'];
    movieGenre = json['MovieGenre'];
    movieDescription = json['MovieDescription'];
  }

  Map<String,dynamic> toJson(){
    final map = <String,dynamic>{};
    map['doubanId'] = doubanId;
    map['MoviePoster'] = moviePoster;
    map['MovieName'] = movieName;
    map['MovieCountry'] = movieCountry;
    map['MovieLanguage'] = movieLanguage;
    map['MovieGenre'] = movieGenre;
    map['MovieDescription'] = movieDescription;
    return map;
  }
}