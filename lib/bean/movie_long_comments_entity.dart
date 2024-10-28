import 'package:flutter_douban/constant/constant.dart';

class MovieLongCommentsEntity {
	late var total;
	late var nextStart;
	late List<MovieLongCommentReviews> reviews;
	late MovieLongCommentsSubject subject;
	late var count;
	late var start;

	MovieLongCommentsEntity();

	MovieLongCommentsEntity.fromJson(Map<String, dynamic> json) {
		total = json['total'];
		nextStart = json['next_start'];
    List<MovieLongCommentReviews> list = [];
		if (json['reviews'] != null) {
			json['reviews'].forEach((v) { list.add(MovieLongCommentReviews.fromJson(v)); });
		}
    reviews = list;
		subject = (json['subject'] != null ? MovieLongCommentsSubject.fromJson(json['subject']) : null)!;
		count = json['count'];
		start = json['start'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = <String, dynamic>{};
		data['total'] = total;
		data['next_start'] = nextStart;
		if (reviews != null) {
      data['reviews'] = reviews.map((v) => v.toJson()).toList();
    }
		if (subject != null) {
      data['subject'] = subject.toJson();
    }
		data['count'] = count;
		data['start'] = start;
		return data;
	}
}

class MovieLongCommentReviews {
	late String summary;
	late String subjectId;
	late MovieLongCommentsReviewsAuthor author;
	late MovieLongCommentsReviewsRating rating;
	late String alt;
	late String createdAt;
	late String title;
	late var uselessCount;
	late String content;
	late String updatedAt;
	late String shareUrl;
	late var commentsCount;
	late String id;
	late var usefulCount;

	MovieLongCommentReviews();

	MovieLongCommentReviews.fromJson(Map<String, dynamic> json) {
		summary = json['summary'];
		subjectId = json['subject_id'];
		author = (json['author'] != null ? MovieLongCommentsReviewsAuthor.fromJson(json['author']) : null)!;
		rating = (json['rating'] != null ? MovieLongCommentsReviewsRating.fromJson(json['rating']) : null)!;
		alt = json['alt'];
		createdAt = json['created_at'];
		title = json['title'];
		uselessCount = json['useless_count'];
		content = json['content'];
		updatedAt = json['updated_at'];
		shareUrl = json['share_url'];
		commentsCount = json['comments_count'];
		id = json['id'];
		usefulCount = json['useful_count'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = <String, dynamic>{};
		data['summary'] = summary;
		data['subject_id'] = subjectId;
		if (author != null) {
      data['author'] = author.toJson();
    }
		if (rating != null) {
      data['rating'] = rating.toJson();
    }
		data['alt'] = alt;
		data['created_at'] = createdAt;
		data['title'] = title;
		data['useless_count'] = uselessCount;
		data['content'] = content;
		data['updated_at'] = updatedAt;
		data['share_url'] = shareUrl;
		data['comments_count'] = commentsCount;
		data['id'] = id;
		data['useful_count'] = usefulCount;
		return data;
	}
}

class MovieLongCommentsReviewsAuthor {
	late String uid;
	late String signature;
	late String alt;
	late String name;
	late String avatar;
	late String id;

	MovieLongCommentsReviewsAuthor({uid, signature, alt, name, avatar, id});

	MovieLongCommentsReviewsAuthor.fromJson(Map<String, dynamic> json) {
		uid = json['uid'];
		signature = json['signature'];
		alt = json['alt'];
		name = json['name'];
		avatar = Constant.urlStart +  json['avatar'];
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

class MovieLongCommentsReviewsRating {
	late var min;
	late var max;
	late var value;

	MovieLongCommentsReviewsRating({min, max, value});

	MovieLongCommentsReviewsRating.fromJson(Map<String, dynamic> json) {
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

class MovieLongCommentsSubject {
	late MovieLongCommentsSubjectImages images;
	late String originalTitle;
	late String year;
	late List<MovieLongCommantsSubjectDirectors> directors;
	late MovieLongCommentsSubjectRating rating;
	late String alt;
	late String title;
	late var collectCount;
	late bool hasVideo;
	late List<String> pubdates;
	late List<MovieLongCommantsSubjectCasts> casts;
	late String subtype;
	late List<String> genres;
	late List<String> durations;
	late String mainlandPubdate;
	late String id;

	MovieLongCommentsSubject({images, originalTitle, year, directors, rating, alt, title, collectCount, hasVideo, pubdates, casts, subtype, genres, durations, mainlandPubdate, id});

	MovieLongCommentsSubject.fromJson(Map<String, dynamic> json) {
		images = (json['images'] != null ? MovieLongCommentsSubjectImages.fromJson(json['images']) : null)!;
		originalTitle = json['original_title'];
		year = json['year'];
    List<MovieLongCommantsSubjectDirectors> directorsList = [];
		if (json['directors'] != null) {
			// List<MovieLongCommantsSubjectDirectors> directors = [];
			json['directors'].forEach((v) { directorsList.add(MovieLongCommantsSubjectDirectors.fromJson(v)); });
		}
    directors = directorsList;
		rating = (json['rating'] != null ? MovieLongCommentsSubjectRating.fromJson(json['rating']) : null)!;
		alt = json['alt'];
		title = json['title'];
		collectCount = json['collect_count'];
		hasVideo = json['has_video'];
		pubdates = json['pubdates'].cast<String>();
    List<MovieLongCommantsSubjectCasts> castsList = [];
		if (json['casts'] != null) {
			// List<MovieLongCommantsSubjectCasts> casts = [];
			json['casts'].forEach((v) { castsList.add(MovieLongCommantsSubjectCasts.fromJson(v)); });
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

class MovieLongCommentsSubjectImages {
	late String small;
	late String large;
	late String medium;

	MovieLongCommentsSubjectImages({small, large, medium});

	MovieLongCommentsSubjectImages.fromJson(Map<String, dynamic> json) {
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

class MovieLongCommantsSubjectDirectors {
	late String name;
	late String alt;
	late String id;
	late MovieLongCommentsSubjectDirectorsAvatars avatars;
	late String nameEn;

	MovieLongCommantsSubjectDirectors({name, alt, id, avatars, nameEn});

	MovieLongCommantsSubjectDirectors.fromJson(Map<String, dynamic> json) {
		name = json['name'];
		alt = json['alt'];
		id = json['id'];
		avatars = (json['avatars'] != null ? MovieLongCommentsSubjectDirectorsAvatars.fromJson(json['avatars']) : null)!;
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

class MovieLongCommentsSubjectDirectorsAvatars {
	late String small;
	late String large;
	late String medium;

	MovieLongCommentsSubjectDirectorsAvatars({small, large, medium});

	MovieLongCommentsSubjectDirectorsAvatars.fromJson(Map<String, dynamic> json) {
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

class MovieLongCommentsSubjectRating {
	late double average;
	late var min;
	late var max;
	late MovieLongCommentsSubjectRatingDetails details;
	late String stars;

	MovieLongCommentsSubjectRating({average, min, max, details, stars});

	MovieLongCommentsSubjectRating.fromJson(Map<String, dynamic> json) {
		average = json['average'];
		min = json['min'];
		max = json['max'];
		details = (json['details'] != null ? MovieLongCommentsSubjectRatingDetails.fromJson(json['details']) : null)!;
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

class MovieLongCommentsSubjectRatingDetails {
	late double d1;
	late double d2;
	late double d3;
	late double d4;
	late double d5;

	MovieLongCommentsSubjectRatingDetails({d1, d2, d3, d4, d5});

	MovieLongCommentsSubjectRatingDetails.fromJson(Map<String, dynamic> json) {
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

class MovieLongCommantsSubjectCasts {
	late String name;
	late String alt;
	late String id;
	late MovieLongCommentsSubjectCastsAvatars avatars;
	late String nameEn;

	MovieLongCommantsSubjectCasts({name, alt, id, avatars, nameEn});

	MovieLongCommantsSubjectCasts.fromJson(Map<String, dynamic> json) {
		name = json['name'];
		alt = json['alt'];
		id = json['id'];
		avatars = (json['avatars'] != null ? MovieLongCommentsSubjectCastsAvatars.fromJson(json['avatars']) : null)!;
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

class MovieLongCommentsSubjectCastsAvatars {
	late String small;
	late String large;
	late String medium;

	MovieLongCommentsSubjectCastsAvatars({small, large, medium});

	MovieLongCommentsSubjectCastsAvatars.fromJson(Map<String, dynamic> json) {
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
