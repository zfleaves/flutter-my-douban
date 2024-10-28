import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

typedef BoolCallback = void Function(bool markAdded);
//test http://img1.doubanio.com/view/photo/s_ratio_poster/public/p457760035.webp
///点击图片变成订阅状态的缓存图片控件
class SubjectMarkImageWidget extends StatefulWidget {
  final imgNetUrl;
  final BoolCallback? markAdd;
  final width;
  const SubjectMarkImageWidget(this.imgNetUrl, {super.key, this.markAdd, this.width = 150.0});

  // var height;

  @override
  State<SubjectMarkImageWidget> createState() => _SubjectMarkImageWidgetState();
}

class _SubjectMarkImageWidgetState extends State<SubjectMarkImageWidget> {
  var markAdded = false;
  late String imgLocalPath, imgNetUrl;
  var markAddedIcon, defaultMarkIcon;
  var loadImg;
  var imgWH = 28.0;
  var height;
  var width;

  @override
  void initState() {
    super.initState();
    // 接收传过来得值
    imgNetUrl = widget.imgNetUrl;
    width = widget.width;
    height = width / 150.0 * 210.0;

    markAddedIcon = Image(
      image: const AssetImage('assets/images/ic_subject_mark_added.png'),
      width: imgWH,
      height: imgWH,
    );
    defaultMarkIcon = ClipRRect(
      borderRadius: const BorderRadius.only(topLeft: Radius.circular(5.0), bottomRight: Radius.circular(5.0)),
      child: Image(
        image: const AssetImage('assets/images/ic_subject_rating_mark_wish.png'),
        width: imgWH,
        height: imgWH,
      ),
    );
    var defaultImg = Image.asset('assets/images/ic_default_img_subject_movie.9.png');
    loadImg = ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(5.0)),
      child: CachedNetworkImage(
        imageUrl: imgNetUrl,
        width: width,
        height: height,
        fit: BoxFit.fill,
        placeholder: (BuildContext context, String url){
          return defaultImg;
        },
        fadeInDuration: const Duration(milliseconds: 80),
        fadeOutDuration: const Duration(milliseconds: 80),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        loadImg,
        GestureDetector(
          child: markAdded ? markAddedIcon : defaultMarkIcon,
          onTap: () {
            if (widget.markAdd != null) {
              widget.markAdd!(markAdded);
            }
            setState(() {
              markAdded = !markAdded;
            });
          },
        )
      ],
    );
  }
}