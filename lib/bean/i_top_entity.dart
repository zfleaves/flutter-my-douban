class ITopEntity {

  late List<ITopData> data;
  late var createdAt;
	late var updatedAt;
	late var id;
	late var originalName;
	late var imdbVotes;
	late var imdbRating;
	late var rottenVotes;
	late var year;
	late var imdbId;
	late var alias;
	late var doubanId;
	late var type;
	late var doubanRating;
	late var doubanVotes;
	late var duration;
	late var dateReleased;

  ITopEntity();

  ITopEntity.fromMap(Map<String, dynamic> map) {
    // data = ITopData.fromMap(map[data]);
    var dataMap = map['data'];
    data = _converData(dataMap);
    createdAt = map['createdAt'];
    updatedAt = map['updatedAt'];
    id = map['id'];
    originalName = map['originalName'];
    imdbVotes = map['imdbVotes'];
    imdbRating = map['imdbRating'];
    rottenVotes = map['rottenVotes'];
    year = map['year'];
    imdbId = map['imdbId'];
    alias = map['alias'];
    doubanId = map['doubanId'];
    type = map['type'];
    doubanRating = map['doubanRating'];
    doubanVotes = map['doubanVotes'];
    duration = map['duration'];
    dateReleased = map['dateReleased'];
  }

  _converData(datas) {
    return datas.map<ITopData>((item) => ITopData.fromMap(item)).toList();
  }
}

class ITopData {
  late var createdAt;
	late var updatedAt;
	late var id;
	late var poster;
	late var shareImage;
	late var name;
	late var genre;
	late var description;
	late var language;
	late var country;
	late var lang;
	late var movie;

  ITopData();

  ITopData.fromMap(Map<String, dynamic> map) {
    createdAt = map['createdAt'];
    updatedAt = map['updatedAt'];
    id = map['id'];
    poster = map['poster'];
    shareImage = map['shareImage'] ?? '';
    name = map['name'];
    genre = map['genre'];
    description = map['description'];
    language = map['language'];
    country = map['country'];
    lang = map['lang'];
    movie = map['movie'];
  }
}


// 嵌套在 TopEntity 中的 MovieData 类
class MovieData {
  var createdAt;
  var updatedAt;
  var id;
  var poster;
  var name;
  var genre;
  var description;
  var language;
  var country;
  var lang;
  var shareImage;
  var movie;

  MovieData({
    required this.createdAt,
    required this.updatedAt,
    required this.id,
    required this.poster,
    required this.name,
    required this.genre,
    required this.description,
    required this.language,
    required this.country,
    required this.lang,
    required this.shareImage,
    required this.movie,
  });

  // 从 JSON 映射到 MovieData 对象
  factory MovieData.fromJson(Map<String, dynamic> json) {
    return MovieData(
      createdAt: json['createdAt']?.toString() ?? '',
      updatedAt: json['updatedAt']?.toString() ?? '',
      id: json['id']?.toString() ?? '',
      poster: json['poster']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      genre: json['genre']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      language: json['language']?.toString() ?? '',
      country: json['country']?.toString() ?? '',
      lang: json['lang']?.toString() ?? '',
      shareImage: json['shareImage']?.toString() ?? '',
      movie: json['movie']?.toString() ?? '',
    );
  }

  // 将 MovieData 对象转换回 JSON（可选）
  Map<String, dynamic> toJson() {
    return {
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'id': id,
      'poster': poster,
      'name': name,
      'genre': genre,
      'description': description,
      'language': language,
      'country': country,
      'lang': lang,
      'shareImage': shareImage,
      'movie': movie,
    };
  }
}

// 使用示例
// void main() {
//   String jsonString = '''
//   [
//     {
//       "visionRatings": 0,
//       "castRatings": 0,
//       "musicRatings": 0,
//       "plotRatings": 0,
//       "data": [
//         {
//           "createdAt": 1636266379327,
//           "updatedAt": 1654072111794,
//           "id": "6187718b4d6ad7466702226d",
//           "poster": "https://img.wmdb.tv/movie/poster/1636266379322-edf32a.jpg",
//           "name": "幸福",
//           // ... 其他字段
//           "movie": "6187718b4d6ad74667022269"
//         }
//       ],
//       // ... 其他字段
//       "type": "TVSeries",
//       // ... 其他字段
//     }
//   ]
//   ''';

//   List<TopEntity> topEntities = jsonDecode(jsonString)
//       .map((item) => TopEntity.fromJson(item as Map<String, dynamic>))
//       .toList();

//   print(topEntities.first.data.first.name); // 输出: 幸福
// }
