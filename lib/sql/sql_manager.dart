import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBManager {
  final int _version = 4; //版本号
  final String _databaseName = 'Movie.db'; //数据库名称

  ///收藏表
  static const String favoriteTable = 'FavoriteTable'; //表名
  static const String doubanId = 'doubanId'; //primary key
  static const String _moviePoster = 'MoviePoster'; //电影海报
  static const String _movieName = 'MovieName'; //电影名称
  static const String _movieCountry = 'MovieCountry'; //电影国家
  static const String _movieLanguage = 'MovieLanguage'; //电影语言
  static const String _movieGenre = 'MovieGenre'; //电影类型(可能为空)
  static const String _movieDescription = 'MovieDescription'; //电影描述

  ///搜索记录表
  static const String searchTable = 'SearchTable'; //表名
  static const String searchKey = 'SearchKey';

  static DBManager? _instance;
  static DBManager getInstance() => _instance ?? DBManager();

  static Database? _database;
  Future<Database> get getDatabase async => _database ??= await _initSQl();

  ///初始化数据库
  Future<Database> _initSQl() async {
    var dbPath = await getDatabasesPath();
    var path = join(dbPath, _databaseName);
    return await openDatabase(path, version: _version, onCreate: _onCreate);
  }

  ///创建表
  Future _onCreate(Database db, int version) async {
    String favoriteSQL = '''
      CREATE TABLE $favoriteTable(
      $doubanId TEXT PRIMARY KEY,
      $_moviePoster TEXT,
      $_movieName TEXT,
      $_movieCountry TEXT,
      $_movieLanguage TEXT,
      $_movieGenre TEXT,
      $_movieDescription TEXT
      )
      ''';

    String searchSQL = '''
      CREATE TABLE $searchTable(
      $searchKey TEXT PRIMARY KEY
      )
      ''';

    await db.execute(favoriteSQL);
    await db.execute(searchSQL);
  }
}
