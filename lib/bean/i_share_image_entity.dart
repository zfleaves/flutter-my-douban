class IShareImageEntity {
  late int success;
	late var image;

  IShareImageEntity();

  IShareImageEntity.fromMap(Map<String, dynamic> map) { 
    success = map['success'];
    image = map['image'].replaceAll('https://image.querydata.org/', 'https://img.wmdb.tv/');
  }
}