

import 'package:flutter_douban/constant/constant.dart';

class CelebrityEntity { 
  late String alt;
	late String birthday;
	late String born_place;
	late String constellation;
	late String gender;
	late String id;
	late String mobile_url;
	late String name;
	late String name_en;
	late String summary;
	late String website;
	late List<String> aka;
	late List<String> aka_en;
	late List<Photo> photos;
	late List<String> professions;
	late List<Work> works;
	late Avatars avatars;

  CelebrityEntity();

  CelebrityEntity.fromMap(Map<String, dynamic> map) {
    alt = map['alt'];
    birthday = map['birthday'];
    born_place = map['born_place'];
    constellation = map['constellation'];
    gender = map['gender'];
    id = map['id'];
    mobile_url = map['mobile_url'];
    name = map['name'];
    name_en = map['name_en'];
    summary = map['summary'];
    website = map['website'];
    aka = map['aka'].map<String>((item) => item).toList();
    aka_en = map['aka_en'].map<String>((item) => item).toList();
    photos = map['photos'].map<Photo>((item) => Photo.fromMap(item)).toList();
    professions = map['professions'].map<String>((item) => item).toList();
    avatars = map['avatars'].map<Avatars>((item) => Avatars.fromMap(item)).toList();
  }
}

class Photo {
  late String alt;
	late String cover;
	late String icon;
	late String id;
	late String image;
	late String thumb;

  Photo();

  Photo.fromMap(Map<String, dynamic> map) {
    alt = map['alt'];
    cover = Constant.urlStart + map['cover'];
    icon = map['icon'];
    id = map['id'];
    image = Constant.urlStart + map['image'];
    thumb = Constant.urlStart + map['thumb'];
  }
}

class Work {
  late List<String> roles;
  late WorkSubject subject;

  Work();

  Work.fromMap(Map<String, dynamic> map) {
    roles = map['roles'].map<String>((item) => item).toList();
    subject = WorkSubject.fromMap(map['subject']);
  }
}

class WorkSubject {
  late int collect_count;
	late bool has_video;
	late String alt;
	late String id;
	late String mainland_pubdate;
	late String original_title;
	late String subtype;
	late String title;
	late String year;
	late List<CastDict> casts;
	late List<dynamic> directors;
	late List<String> durations;
	late List<dynamic> genres;
	late List<String> pubdates;
	late _Image images;
	late Rating rating;

  WorkSubject();

  WorkSubject.fromMap(Map<String, dynamic> map) {
    collect_count = map['collect_count'];
    has_video = map['has_video'];
    alt = map['alt'];
    id = map['id'];
    mainland_pubdate = map['mainland_pubdate'];
    original_title = map['original_title'];
    subtype = map['subtype'];
    title = map['title'];
    year = map['year'];
    casts = map['casts'].map<CastDict>((item) => CastDict.fromMap(item)).toList();
    directors = map['directors'].map<dynamic>((item) => item).toList();
    durations = map['durations'].map<String>((item) => item).toList();
    genres = map['genres'].map<dynamic>((item) => item).toList();
    pubdates = map['pubdates'].map<String>((item) => item).toList();
    images = _Image.fromMap(map['images']);
    rating = Rating.fromMap(map['rating']);
  }
}

class CastDict {
  late String alt;
	late Avatars avatars;
	late String id;
	late String name;
	late String name_en;

  CastDict();

  CastDict.fromMap(Map<String, dynamic> map) {
    alt = map['alt'];
    avatars = map['avatars'].map<Avatars>((item) => Avatars.fromMap(item)).toList();
    id = map['id'];
    name = map['name'];
    name_en = map['name_en'];
  }
}

class _Image {
  late String large;
	late String medium;
	late String small;

  _Image();

  _Image.fromMap(Map<String, dynamic> map) {
    large = Constant.urlStart + map['large'];
    medium = Constant.urlStart + map['medium'];
    small = Constant.urlStart + map['small'];
  }
}

class Rating {
  late int max;
	late int min;
	late var average;
	late String stars;
	late Detail details;

  Rating();

  Rating.fromMap(Map<String, dynamic> map) {
    max = map['max'];
    min = map['min'];
    average = map['average'];
    stars = map['stars'];
    details = Detail.fromMap(map['details']);
  }
} 

class Detail {
  var d1;
	var d2;
	var d3;
	var d4;
	var d5;

  Detail();

  Detail.fromMap(Map<String, dynamic> map) {
    d1 = map['1'];
		d2 = map['2'];
		d3 = map['3'];
		d4 = map['4'];
		d5 = map['5'];
  }
}

class Avatars {
  late String large;
	late String medium;
	late String small;

  Avatars();

  Avatars.fromMap(Map<String, dynamic> map) {
    large = Constant.urlStart + map['large'];
    medium = Constant.urlStart + map['medium'];
    small = Constant.urlStart + map['small'];
  }
}
