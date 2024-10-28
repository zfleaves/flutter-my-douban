class SearchRecord{
  late String searchKey;

  SearchRecord(this.searchKey);

  SearchRecord.fromJson(dynamic json){
    searchKey = json['SearchKey'];
  }

  Map<String,dynamic> toJson(){
    final map = <String,dynamic>{};
    map['SearchKey'] = searchKey;
    return map;
  }
}