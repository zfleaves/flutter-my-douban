import 'package:flutter_douban/constant/constant.dart';

class IMovieDetailEntity {
  late List<IMovieDetailData> data;
	late List<IMovieDetailWriter> writer;
	late List<IMovieDetailActor> actor;
	late List<IMovieDetailDirector> director;
	late int createdAt;
	late int updatedAt;
	late var id;
	late var originalName;
	late int imdbVotes;
	late var imdbRating;
	late var year;
	late var imdbId;
	late var alias;
	late var doubanId;
	late var type;
	late var doubanRating;
	late int doubanVotes;
	late int duration;
	late var dateReleased;

  IMovieDetailEntity();

  IMovieDetailEntity.fromMap(Map<String, dynamic> map) {
    data = map['data'].map<IMovieDetailData>((item) => IMovieDetailData.fromMap(item)).toList();
    writer = map['writer'].map<IMovieDetailWriter>((item) => IMovieDetailWriter.fromMap(item)).toList();
    actor = map['actor'].map<IMovieDetailActor>((item) => IMovieDetailActor.fromMap(item)).toList();
    director = map['director'].map<IMovieDetailDirector>((item) => IMovieDetailDirector.fromMap(item)).toList();
    createdAt = map['createdAt'];
    updatedAt = map['updatedAt'];
    id = map['id'];
    originalName = map['originalName'];
    imdbVotes = map['imdbVotes'];
    imdbRating = map['imdbRating'];
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
}

class IMovieDetailData {
  late int createdAt;
	late int updatedAt;
	late var id;
	late var poster;
	late var name;
	late var genre;
	late var description;
	late var language;
	late var country;
	late var lang;
	late var movie;

  IMovieDetailData();

  IMovieDetailData.fromMap(Map<String, dynamic> map) {
    createdAt = map['createdAt'];
    updatedAt = map['updatedAt'];
    id = map['id'];
    poster = Constant.urlStart + map['poster'];
    name = map['name'];
    genre = map['genre'];
    description = map['description'];
    language = map['language'];
    country = map['country'];
    lang = map['lang'];
    movie = map['movie'] ?? '';
  }
}

class IMovieDetailWriter {
  late List<IMovieDetailWriterData> data;
	late int createdAt;
	late int updatedAt;
	late var id;

  IMovieDetailWriter();

  IMovieDetailWriter.fromMap(Map<String, dynamic> map) {
    data = map['data'].map<IMovieDetailWriterData>((item) => IMovieDetailWriterData.fromMap(item)).toList();
    createdAt = map['createdAt'];
    updatedAt = map['updatedAt'];
    id = map['id'];
  }
}

class IMovieDetailWriterData {
  late int createdAt;
	late int updatedAt;
	late var id;
	late var name;
	late var lang;
	late var person;

  IMovieDetailWriterData();

  IMovieDetailWriterData.fromMap(Map<String, dynamic> map) {
    createdAt = map['createdAt'];
    updatedAt = map['updatedAt'];
    id = map['id'];
    name = map['name'];
    lang = map['lang'];
    person = map['person'];
  }
}

class IMovieDetailActor {
  late List<IMovieDetailActorData> data;
	late int createdAt;
	late int updatedAt;
	late var id;

  IMovieDetailActor();

  IMovieDetailActor.fromMap(Map<String, dynamic> map) {
    data = map['data'].map<IMovieDetailActorData>((item) => IMovieDetailActorData.fromMap(item)).toList();
    createdAt = map['createdAt'];
    updatedAt = map['updatedAt'];
    id = map['id'];
  }
}

class IMovieDetailActorData {
  late int createdAt;
	late int updatedAt;
	late var id;
	late var name;
	late var lang;
	late var person;

  IMovieDetailActorData();

  IMovieDetailActorData.fromMap(Map<String, dynamic> map) {
    createdAt = map['createdAt'];
    updatedAt = map['updatedAt'];
    id = map['id'];
    name = map['name'];
    lang = map['lang'];
    person = map['person'];
  }

}

class IMovieDetailDirector {
  late List<IMovieDetailDirectorData> data;
	late int createdAt;
	late int updatedAt;
	late var id;

  IMovieDetailDirector();

  IMovieDetailDirector.fromMap(Map<String, dynamic> map) {
    data = map['data'].map<IMovieDetailDirectorData>((item) => IMovieDetailDirectorData.fromMap(item)).toList();
    createdAt = map['createdAt'];
    updatedAt = map['updatedAt'];
    id = map['id'];
  } 
}

class IMovieDetailDirectorData {
  late int createdAt;
	late int updatedAt;
	late var id;
	late var name;
	late var lang;
	late var person;

  IMovieDetailDirectorData();

  IMovieDetailDirectorData.fromMap(Map<String, dynamic> map) {
    createdAt = map['createdAt'];
    updatedAt = map['updatedAt'];
    id = map['id'];
    name = map['name'];
    lang = map['lang'];
    person = map['person'];
  }
}