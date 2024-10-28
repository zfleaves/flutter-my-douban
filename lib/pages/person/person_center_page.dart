import 'package:flutter/material.dart';
import 'package:flutter_douban/constant/constant.dart';
import 'package:flutter_douban/http/net_request.dart';
import 'package:flutter_douban/pages/person/use_net_data_widget.dart';
import 'package:flutter_douban/pages/person/use_top_source_widget.dart';
import 'package:flutter_douban/pages/person/video_book_music_book.dart';
import 'package:flutter_douban/router.dart';
import 'package:flutter_douban/tools/toastTool.dart';
import 'package:flutter_douban/widgets/image/heart_img_widget.dart';

typedef VoidCallback = void Function();

///个人中心
// class PersonCenterPage extends StatelessWidget {
//   const PersonCenterPage({super.key});

//   SliverToBoxAdapter _divider() {
//     return SliverToBoxAdapter(
//       child: Container(
//         height: 10.0,
//         color: const Color.fromARGB(255, 247, 247, 247),
//       ),
//     );
//   }

//   SliverToBoxAdapter _personItem(String imgAsset, String title,
//       {VoidCallback? onTab}) {
//     return SliverToBoxAdapter(
//       child: GestureDetector(
//         onTap: () {
//           if (onTab == null) {
//             showFailedToast('敬请期待');
//             return;
//           }
//           onTab();
//         },
//         behavior: HitTestBehavior.translucent,
//         child: Row(
//           children: <Widget>[
//             Padding(
//               padding: const EdgeInsets.all(10.0),
//               child: Image.asset(
//                 Constant.ASSETS_IMG + imgAsset,
//                 width: 25.0,
//                 height: 25.0,
//               ),
//             ),
//             Expanded(
//               child: Text(
//                 title,
//                 style: const TextStyle(fontSize: 15.0),
//               ),
//             ),
//             _rightArrow()
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _rightArrow() {
//     return const Icon(
//       Icons.chevron_right,
//       color: Color.fromARGB(255, 204, 204, 204),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//           child: Padding(
//         padding: const EdgeInsets.only(top: 10.0),
//         child: CustomScrollView(
//           physics: const BouncingScrollPhysics(),
//           shrinkWrap: false,
//           slivers: <Widget>[
//             SliverAppBar(
//               backgroundColor: Colors.transparent,
//               flexibleSpace: HeartImgWidget(Image.asset(
//                   '${Constant.ASSETS_IMG}doubanbg.png')),
//               expandedHeight: 200.0,
//             ),
//             SliverToBoxAdapter(
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: <Widget>[
//                   Padding(
//                     padding: const EdgeInsets.only(
//                         left: 10.0, top: 15.0, bottom: 20.0, right: 10.0),
//                     child: Image.asset(
//                       '${Constant.ASSETS_IMG}ic_notify.png',
//                       width: 30.0,
//                       height: 30.0,
//                     ),
//                   ),
//                   const Expanded(
//                     child: Text(
//                       '提醒',
//                       style: TextStyle(fontSize: 17.0),
//                     ),
//                   ),
//                   _rightArrow()
//                 ],
//               ),
//             ),
//             SliverToBoxAdapter(
//               child: Container(
//                 height: 100.0,
//                 alignment: Alignment.center,
//                 child: const Text(
//                   '暂无新提醒',
//                   style: TextStyle(color: Colors.grey),
//                 ),
//               ),
//             ),
//             _divider(),
//             const SliverToBoxAdapter(
//               child: VideoBookMusicBookWidget(),
//             ),
//             _divider(),
//             const UseNetDataWidget(),
//             // 接口只有douban数据源了
//             // const UseTopSourceWidget(),
//             _divider(),
//             _personItem('ic_me_doulist.png', '我的收藏', onTab: () {
//               MyRouter.pushNoParams(context, MyRouter.myFavorite);
//             }),
//             _personItem(
//               'ic_me_journal.png',
//               '我的发布',
//             ),
//             _personItem('ic_me_follows.png', '我的关注'),
//             _personItem('ic_me_photo_album.png', '相册'),
//             _divider(),
//             _personItem('ic_me_wallet.png', '钱包'),
//           ],
//         ),
//       )),
//     );
//   }
// }

class PersonCenterPage extends StatefulWidget {
  const PersonCenterPage({super.key});

  @override
  State<PersonCenterPage> createState() => _PersonCenterPageState();
}

class _PersonCenterPageState extends State<PersonCenterPage> {

  // 右侧数据
  List _rightCateData = [];

  @override
  void initState() {
    super.initState();
    requestApi();
  }

  requestApi() async {
    var res = await NetRequest.getCartList();
    setState(() {
      _rightCateData = res['result'];
      // print(_rightCateData);
    });
  }

  SliverToBoxAdapter _divider() {
    return SliverToBoxAdapter(
      child: Container(
        height: 10.0,
        color: const Color.fromARGB(255, 247, 247, 247),
      ),
    );
  }

  SliverToBoxAdapter _personItem(String imgAsset, String title,
      {VoidCallback? onTab}) {
    return SliverToBoxAdapter(
      child: GestureDetector(
        onTap: () {
          if (onTab == null) {
            showFailedToast('敬请期待');
            return;
          }
          onTab();
        },
        behavior: HitTestBehavior.translucent,
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.asset(
                Constant.ASSETS_IMG + imgAsset,
                width: 25.0,
                height: 25.0,
              ),
            ),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 15.0),
              ),
            ),
            _rightArrow()
          ],
        ),
      ),
    );
  }

  Widget _rightArrow() {
    return const Icon(
      Icons.chevron_right,
      color: Color.fromARGB(255, 204, 204, 204),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: false,
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: Colors.transparent,
              flexibleSpace: HeartImgWidget(
                  Image.asset('${Constant.ASSETS_IMG}doubanbg.png')),
              expandedHeight: 200.0,
            ),
            SliverToBoxAdapter(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, top: 15.0, bottom: 20.0, right: 10.0),
                    child: Image.asset(
                      '${Constant.ASSETS_IMG}ic_notify.png',
                      width: 30.0,
                      height: 30.0,
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      '提醒',
                      style: TextStyle(fontSize: 17.0),
                    ),
                  ),
                  _rightArrow()
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                height: 100.0,
                alignment: Alignment.center,
                child: const Text(
                  '暂无新提醒',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            _divider(),
            const SliverToBoxAdapter(
              child: VideoBookMusicBookWidget(),
            ),
            _divider(),
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(10.0),
                child: Text('${_rightCateData.length}条数据'),
              ),
            ),
            _divider(),
            const UseNetDataWidget(),
            // 接口只有douban数据源了
            // const UseTopSourceWidget(),
            _divider(),
            _personItem('ic_me_doulist.png', '我的收藏', onTab: () {
              MyRouter.pushNoParams(context, MyRouter.myFavorite);
            }),
            _personItem(
              'ic_me_journal.png',
              '我的发布',
            ),
            _personItem('ic_me_follows.png', '我的关注'),
            _personItem('ic_me_photo_album.png', '相册'),
            _divider(),
            _personItem('ic_me_wallet.png', '钱包'),
          ],
        ),
      )),
    );
  }
}
