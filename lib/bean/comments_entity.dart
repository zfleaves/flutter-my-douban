import 'package:flutter_douban/constant/constant.dart';

class CommentsEntity {
  late var total;
  late List<CommantsBeanCommants> comments;
  late var nextStart;
  late CommentsBeanSubject subject;
  late var count;
  late var start;
  CommentsEntity();

  CommentsEntity.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    List<CommantsBeanCommants> list = [];
    if (json['comments'] != null) {
      // List<CommantsBeanCommants> comments = [];
      json['comments'].forEach((v) {
        list.add(CommantsBeanCommants.fromJson(v));
      });
    } else {
      json['comments'] = [];
    }
    comments = list;
    nextStart = json['next_start'];
    subject = (json['subject'] != null
        ? CommentsBeanSubject.fromJson(json['subject'])
        : null)!;
    count = json['count'];
    start = json['start'];
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = <String, dynamic>{};
  //   data['total'] = total;
  //   if (comments != null) {
  //     data['comments'] = comments.map((v) => v.toJson()).toList();
  //   }
  //   data['next_start'] = nextStart;
  //   if (subject != null) {
  //     data['subject'] = subject.toJson();
  //   }
  //   data['count'] = count;
  //   data['start'] = start;
  //   return data;
  // }
}

/// 评论
class CommantsBeanCommants {
  late String subjectId;
  late CommentsBeanCommentsAuthor author;
  late CommentsBeanCommentsRating rating;
  late String createdAt;
  late String id;
  late var usefulCount;
  late String content;

  CommantsBeanCommants();

  CommantsBeanCommants.fromJson(Map<String, dynamic> json) {
    subjectId = json['subject_id'];
    author = (json['author'] != null
        ? CommentsBeanCommentsAuthor.fromJson(json['author'])
        : null)!;
    rating = (json['rating'] != null
        ? CommentsBeanCommentsRating.fromJson(json['rating'])
        : null)!;
    createdAt = json['created_at'];
    id = json['id'];
    usefulCount = json['useful_count'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['subject_id'] = subjectId;
    // if (author != null) {
    //   data['author'] = author.toJson();
    // }
    // if (rating != null) {
    //   data['rating'] = rating.toJson();
    // }
    data['created_at'] = createdAt;
    data['id'] = id;
    data['useful_count'] = usefulCount;
    data['content'] = content;
    return data;
  }
}

/// 评论作者
class CommentsBeanCommentsAuthor {
  late String uid;
  late String signature;
  late String alt;
  late String name;
  late String avatar;
  late String id;

  CommentsBeanCommentsAuthor();

  CommentsBeanCommentsAuthor.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    signature = json['signature'];
    alt = json['alt'];
    name = json['name'];
    avatar = Constant.urlStart + json['avatar'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = uid;
    data['signature'] = signature;
    data['alt'] = alt;
    data['name'] = name;
    data['avatar'] = avatar;
    data['id'] = id;
    return data;
  }
}

/// 评论评分
class CommentsBeanCommentsRating {
  late var min;
  late var max;
  late var value;
  CommentsBeanCommentsRating();

  CommentsBeanCommentsRating.fromJson(Map<String, dynamic> json) {
    min = json['min'];
    max = json['max'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['min'] = min;
    data['max'] = max;
    data['value'] = value;
    return data;
  }
}

/// 评论item
class CommentsBeanSubject {
  late CommentsBeanSubjectImages images;
  late String originalTitle;
  late String year;
  late List<CommantsBeanSubjectDirectors> directors;
  late CommentsBeanSubjectRating rating;
  late var alt;
  late String title;
  late var collectCount;
  late bool hasVideo;
  late List<String> pubdates;
  late List<CommantsBeanSubjectCasts> casts;
  late String subtype;
  late List<String> genres;
  late List<String> durations;
  late String mainlandPubdate;
  late String id;

  CommentsBeanSubject();

  CommentsBeanSubject.fromJson(Map<String, dynamic> json) {
    images = (json['images'] != null
        ? CommentsBeanSubjectImages.fromJson(json['images'])
        : null)!;
    originalTitle = json['original_title'];
    year = json['year'];
    List<CommantsBeanSubjectDirectors> list = [];
    if (json['directors'] != null) {
      json['directors'].forEach((v) {
        list.add(CommantsBeanSubjectDirectors.fromJson(v));
      });
    }
    directors = list;
    rating = (json['rating'] != null
        ? CommentsBeanSubjectRating.fromJson(json['rating'])
        : null)!;
    alt = json['alt'];
    title = json['title'];
    collectCount = json['collect_count'];
    hasVideo = json['has_video'];
    pubdates = json['pubdates'].cast<String>();
    List<CommantsBeanSubjectCasts> castsList = [];
    if (json['casts'] != null) {
      json['casts'].forEach((v) {
        castsList.add(CommantsBeanSubjectCasts.fromJson(v));
      });
    }
    casts = castsList;
    subtype = json['subtype'];
    genres = json['genres'].cast<String>();
    durations = json['durations'].cast<String>();
    mainlandPubdate = json['mainland_pubdate'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (images != null) {
      data['images'] = images.toJson();
    }
    data['original_title'] = originalTitle;
    data['year'] = year;
    if (directors != null) {
      data['directors'] = directors.map((v) => v.toJson()).toList();
    }
    if (rating != null) {
      data['rating'] = rating.toJson();
    }
    data['alt'] = alt;
    data['title'] = title;
    data['collect_count'] = collectCount;
    data['has_video'] = hasVideo;
    data['pubdates'] = pubdates;
    if (casts != null) {
      data['casts'] = casts.map((v) => v.toJson()).toList();
    }
    data['subtype'] = subtype;
    data['genres'] = genres;
    data['durations'] = durations;
    data['mainland_pubdate'] = mainlandPubdate;
    data['id'] = id;
    return data;
  }
}

/// 评论图片
class CommentsBeanSubjectImages {
  late String small;
  late String large;
  late String medium;

  CommentsBeanSubjectImages();

  CommentsBeanSubjectImages.fromJson(Map<String, dynamic> json) {
    small = json['small'];
    large = json['large'];
    medium = json['medium'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['small'] = small;
    data['large'] = large;
    data['medium'] = medium;
    return data;
  }
}

/// 主演、演员
class CommantsBeanSubjectDirectors {
  late String name;
  late String alt;
  late String id;
  late CommentsBeanSubjectDirectorsAvatars avatars;
  late String nameEn;

  CommantsBeanSubjectDirectors();

  CommantsBeanSubjectDirectors.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    alt = json['alt'];
    id = json['id'];
    avatars = (json['avatars'] != null
        ? CommentsBeanSubjectDirectorsAvatars.fromJson(json['avatars'])
        : null)!;
    nameEn = json['name_en'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['alt'] = alt;
    data['id'] = id;
    if (avatars != null) {
      data['avatars'] = avatars.toJson();
    }
    data['name_en'] = nameEn;
    return data;
  }
}

/// 主演、演员图片
class CommentsBeanSubjectDirectorsAvatars {
  late String small;
  late String large;
  late String medium;

  CommentsBeanSubjectDirectorsAvatars();

  CommentsBeanSubjectDirectorsAvatars.fromJson(Map<String, dynamic> json) {
    small = json['small'];
    large = json['large'];
    medium = json['medium'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['small'] = small;
    data['large'] = large;
    data['medium'] = medium;
    return data;
  }
}

/// 影片评分
class CommentsBeanSubjectRating {
  late var average;
  late var min;
  late var max;
  late CommentsBeanSubjectRatingDetails details;
  late String stars;

  CommentsBeanSubjectRating();

  CommentsBeanSubjectRating.fromJson(Map<String, dynamic> json) {
    average = json['average'];
    min = json['min'];
    max = json['max'];
    details = (json['details'] != null
        ? CommentsBeanSubjectRatingDetails.fromJson(json['details'])
        : null)!;
    stars = json['stars'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['average'] = average;
    data['min'] = min;
    data['max'] = max;
    if (details != null) {
      data['details'] = details.toJson();
    }
    data['stars'] = stars;
    return data;
  }
}

// 影片评分详情
class CommentsBeanSubjectRatingDetails {
  var d1;
  var d2;
  var d3;
  var d4;
  var d5;

  CommentsBeanSubjectRatingDetails();

  CommentsBeanSubjectRatingDetails.fromJson(Map<String, dynamic> json) {
    d1 = json['1'];
    d2 = json['2'];
    d3 = json['3'];
    d4 = json['4'];
    d5 = json['5'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['1'] = d1;
    data['2'] = d2;
    data['3'] = d3;
    data['4'] = d4;
    data['5'] = d5;
    return data;
  }
}

class CommantsBeanSubjectCasts {
  late String name;
  late String alt;
  late String id;
  late CommentsBeanSubjectCastsAvatars avatars;
  late String nameEn;

  CommantsBeanSubjectCasts();

  CommantsBeanSubjectCasts.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    alt = json['alt'];
    id = json['id'];
    avatars = (json['avatars'] != null
        ? CommentsBeanSubjectCastsAvatars.fromJson(json['avatars'])
        : null)!;
    nameEn = json['name_en'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['alt'] = alt;
    data['id'] = id;
    if (avatars != null) {
      data['avatars'] = avatars.toJson();
    }
    data['name_en'] = nameEn;
    return data;
  }
}

class CommentsBeanSubjectCastsAvatars {
  late String small;
  late String large;
  late String medium;

  CommentsBeanSubjectCastsAvatars();

  CommentsBeanSubjectCastsAvatars.fromJson(Map<String, dynamic> json) {
    small = json['small'];
    large = json['large'];
    medium = json['medium'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['small'] = small;
    data['large'] = large;
    data['medium'] = medium;
    return data;
  }
}
