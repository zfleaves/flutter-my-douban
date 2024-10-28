import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_douban/bean/movie_detail_bean.dart';
import 'package:flutter_douban/widgets/video_widget.dart';

class VideoPlayPage extends StatefulWidget {
  final List<Blooper> beans;
  const VideoPlayPage(this.beans, {super.key});

  @override
  State<VideoPlayPage> createState() => _VideoPlayPageState();
}

class _VideoPlayPageState extends State<VideoPlayPage> {
  int _showPlayIndex = 0;
  late VideoWidget playWidget;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double mediumW = MediaQuery.of(context).size.width / 4;
    double mediumH = mediumW / 309 * 177;
    playWidget = VideoWidget(
      '${widget.beans[0].resource_url}',
      previewImgUrl: widget.beans[0].medium,
    );
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
          child: Column(
        children: <Widget>[
          Container(
            color: Colors.black,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    )),
                playWidget
              ],
            ),
          ),
          Expanded(
              child: Container(
            color: Colors.white,
            child: ListView.builder(
              itemCount: widget.beans.length - 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: <Widget>[
                        const Expanded(
                          child: Text(
                            '观看预告片/片段/花絮',
                            style: TextStyle(fontSize: 12.0),
                          ),
                        ),
                        Text(
                          '${widget.beans.length}',
                          style: const TextStyle(fontSize: 12.0),
                        )
                      ],
                    ),
                  );
                }
                return getItem(widget.beans[index - 1], index - 1);
              },
            ),
          ))
        ],
      )),
    );
  }

  Widget getItem(Blooper bean, int index) {
    double mediumW = MediaQuery.of(context).size.width / 4;
    double mediumH = mediumW / 309 * 177;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        setState(() {
          _showPlayIndex = index;
        });
        playWidget.updateUrl('${bean.resource_url}');
      },
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Stack(
                  children: <Widget>[
                    CachedNetworkImage(
                      imageUrl: '${bean.medium}',
                      width: mediumW,
                      height: mediumH,
                      fit: BoxFit.cover,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: getPlay(index, mediumW, mediumH),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Text(
                    '${bean.title}',
                    softWrap: true,
                    style: const TextStyle(fontSize: 15.0),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  getPlay(int index, double mediumW, double mediumH) {
    if (index == _showPlayIndex) {
      return Container(
        width: mediumW,
        height: mediumH,
        alignment: Alignment.center,
        child: const Icon(
          Icons.play_circle_outline,
          color: Colors.amber,
        ),
      );
    } else {
      return Container();
    }
  }
}
