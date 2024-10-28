import 'package:flutter/material.dart';
import 'package:flutter_douban/bean/i_search_entity.dart';
import 'package:flutter_douban/bean/i_top_entity.dart';
import 'package:flutter_douban/http/net_request.dart';
import 'package:flutter_douban/provider/search_provider.dart';
import 'package:flutter_douban/router.dart';
import 'package:flutter_douban/sql/exe/search_sql.dart';
import 'package:flutter_douban/tools/circularTool.dart';
import 'package:flutter_douban/tools/toastTool.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  final String searchHintContent;
  const SearchPage({super.key, this.searchHintContent = '用一部电影来形容你的2018'});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  String _searchContent = '';
  String _lastSearch = '';
  bool _isShowClear = false;
  late Widget? defaultContent;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      // if (_searchContent.text.isEmpty) {}
      if (_searchController.text.isEmpty) {
        _isShowClear = false;
        defaultContent = _buildHistory();
      } else {
        _isShowClear = true;
        _searchContent = _searchController.text.toString();
        defaultContent = _buildSearchListView(_searchContent);
        print(defaultContent);
      }
      setState(() {});
    });

    ///初始化默认显示内容
    defaultContent = _buildHistory();
  }

  Widget _buildSearchListView(String key) {
    if (key.isNotEmpty && key == _lastSearch) {
      return defaultContent!;
    } else {
      _lastSearch = key;
    }

    ///模糊搜索列表，添加富文本高亮显示
    // Widget displayContent = const Center(child: CircularProgressIndicator());
    Widget displayContent = const Center(child: Text('没有搜索到相关内容!'));
    List<ITopEntity> resultList = [];
    NetRequest.getSearchList(key)
        .then((value) => {
              if (value != null) {resultList = value}
            })
        .catchError(
            // ignore: invalid_return_type_for_catch_error
            (e) => {displayContent = const Center(child: Text('加载失败!'))})
        .whenComplete(() {
      displayContent = resultList.isNotEmpty
          ? ListView.builder(
              itemCount: resultList.length,
              itemBuilder: (context, index) {
                final searchProvider = context.read<SearchProvider>();
                return ListTile(
                  leading: const Icon(Icons.search, size: 20),
                  title: Transform(
                    transform: Matrix4.translationValues(-16, 0.0, 0.0),
                    child: RichText(
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                          text: resultList[index]
                              .data[0]
                              .name
                              .substring(0, key.length),
                          style: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                          children: [
                            TextSpan(
                              text: resultList[index]
                                  .data[0]
                                  .name
                                  .substring(key.length),
                              style: const TextStyle(color: Colors.grey),
                            )
                          ]),
                    ),
                  ),
                  onTap: () async {
                    await exeSearchInsert(SearchRecord(resultList[index].data[0].name.toString()),
                        searchProvider);
                    // ignore: use_build_context_synchronously
                    MyRouter.push(context, MyRouter.searchResultPage, resultList[index].data[0].name);
                  },
                );
              })
          : const Center(child: Text('没有搜索到相关内容!'));
      setState(() {
        if (resultList.isEmpty) {
          displayContent = const Center(child: Text('没有搜索到相关内容!'));
        } else {
          defaultContent = displayContent;
        }
      });
    });
    return displayContent;
  }

  ///历史记录删除按钮和历史记录列表
  Widget _buildHistory() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getText('历史记录',
                  color: Colors.black,
                  textSize: 16.0,
                  fontWeight: FontWeight.bold),
              const Icon(Icons.delete_forever, color: Colors.grey)
            ],
          ),
        ),
        Flexible(child: _buildHistoryList())
      ],
    );
  }

  ///构建搜索记录List列表
  Widget _buildHistoryList() {
    return Container(
      margin: const EdgeInsets.only(top: 10.0),
      child: Consumer<SearchProvider>(
        builder: (context, searchProvider, child) {
          return GridView.builder(
            itemCount: searchProvider.searchList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 3),
            itemBuilder: (ctx, index) {
              String key = searchProvider.searchList[index].searchKey;
              return GestureDetector(
                onTap: () {
                  MyRouter.push(context, MyRouter.searchResultPage, key);
                },
                child: Container(
                  padding: const EdgeInsets.all(5.0),
                  decoration: const BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      getText(key, color: Colors.white),
                      InkWell(
                          onTap: () {
                            exeSearchRemove(SearchRecord(key), searchProvider);
                          },
                          child: const Icon(Icons.clear,
                              color: Colors.white, size: 16))
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final searchProvider = context.read<SearchProvider>();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(left: 15.0),
            width: MediaQuery.of(context).size.width,
            alignment: AlignmentDirectional.center,
            height: 37.0,
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.black,
                    )),
                Expanded(
                    flex: 1,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 237, 236, 237),
                          borderRadius: BorderRadius.circular(24.0)),
                      child: Form(
                        key: _formKey,
                        child: TextFormField(
                          textAlign: TextAlign.start,
                          maxLines: 1,
                          controller: _searchController,
                          focusNode: _searchNode,
                          style: const TextStyle(
                              fontSize: 15.0, color: Colors.black),
                          decoration: InputDecoration(
                              icon: const Icon(Icons.search,
                                  color: Colors.grey, size: 25),
                              hintText: widget.searchHintContent,
                              hintStyle: const TextStyle(
                                  fontSize: 15.0, color: Colors.grey),
                              border: InputBorder.none,
                              suffixIcon: (_isShowClear)
                                  ? IconButton(
                                      onPressed: () {
                                        _searchController.clear();
                                        _searchContent = '';
                                      },
                                      icon: const Icon(Icons.clear,
                                          color: Colors.grey, size: 25))
                                  : null),
                          onChanged: (value) {
                            _searchContent = value.toString();
                          },
                          onSaved: (String? value) {
                            _searchContent = value.toString();
                          },
                        ),
                      ),
                    )),
                TextButton(
                    onPressed: () async {
                      if (_searchContent.isEmpty ||
                          _searchContent.length == 0) {
                        showFailedToast('搜索内容不能为空!');
                        return;
                      }
                      await exeSearchInsert(SearchRecord(_searchContent.toString()),
                          searchProvider);
                      MyRouter.push(context, MyRouter.searchResultPage,
                          _searchContent.toString());
                      _searchController.clear();
                      _searchContent = '';
                    },
                    child: getText('搜索',
                        color: Colors.green,
                        textSize: 16,
                        fontWeight: FontWeight.bold))
              ],
            ),
          ),
          const SizedBox(height: 20.0),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: defaultContent ?? _buildHistory(),
            ),
          )
        ],
      )),
    );
  }
}
