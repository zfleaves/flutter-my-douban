import 'package:flutter/material.dart';
import 'package:flutter_douban/constant/constant.dart';
import 'package:video_player/video_player.dart';

class VideoWidget extends StatefulWidget {
  final state = _VideoWidgetState();

  final String url;
  final String? previewImgUrl; //预览图片的地址
  final bool showProgressBar; //是否显示进度条
  final bool showProgressText; //是否显示进度文本
  VideoWidget(this.url,
      {super.key,
      this.previewImgUrl,
      this.showProgressBar = true,
      this.showProgressText = true});


  @override
  State<VideoWidget> createState() {
    return state;
  }

  void updateUrl(String url) {
    state.setUrl(url);
  }
}

class _VideoWidgetState extends State<VideoWidget> {
  late VideoPlayerController _controller;
  // late VoidCallback listener;
  bool _showSeekBar = true;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url));
    _controller.addListener(() {
      setState(() {});
    });
    // _controller.setLooping(true);
    _controller.initialize().then((_) => setState(() {}));
    // _controller.play();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose(); //释放播放器资源
  }

  ///更新播放的URL
  void setUrl(String url) {
    if (mounted) {
      print('updateUrl');
      if (_controller != null) {
        _controller.removeListener(() {
          if (mounted) {
            setState(() {});
          }
        });
        _controller.pause();
        _controller.dispose(); //释放播放器资源
      }
      _controller = VideoPlayerController.networkUrl(Uri.parse(url));
      _controller.addListener(() {
        setState(() {});
      });
      // _controller.setLooping(true);
      _controller.initialize().then((_) => setState(() {}));
    }
  }

  // FadeAnimation imageFadeAnim;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[
      GestureDetector(
        onTap: () {
          setState(() {
            _showSeekBar = !_showSeekBar;
          });
        },
        child: VideoPlayer(_controller),
      ),
      getPlayController(),
    ];
    return AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: Stack(
        fit: StackFit.passthrough,
        children: children,
      ),
    );
  }

  Widget getPlayController() {
    return Offstage(
      offstage: !_showSeekBar,
      // offstage: _showSeekBar,
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: IconButton(
                onPressed: () {
                  if (_controller.value.isPlaying) {
                    _controller.pause();
                  } else {
                    _controller.play();
                  }
                },
                iconSize: 55.0,
                icon: Image.asset(Constant.ASSETS_IMG +
                    (_controller.value.isPlaying
                        ? 'ic_pause.png'
                        : 'ic_playing.png'))),
          ),
          getProgressContent(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Center(
              child: _controller.value.isBuffering
                  ? const CircularProgressIndicator()
                  : null,
            ),
          )
        ],
      ),
    );
  }

  Widget getProgressContent() {
    return (widget.showProgressBar || widget.showProgressText)
        ? Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Container(
                  height: 13.0,
                  margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Offstage(
                    offstage: !widget.showProgressBar,
                    child: VideoProgressIndicator(
                      _controller,
                      allowScrubbing: true,
                      colors: const VideoProgressColors(
                        playedColor: Colors.amberAccent,
                        backgroundColor: Colors.grey,
                      ),
                    ),
                  ),
                )),
                Offstage(
                  offstage: !widget.showProgressText,
                  child: getDurationText(),
                )
              ],
            ),
          )
        : Container();
  }

  getMinuteSeconds(int inSeconds) {
    if (inSeconds == null || inSeconds <= 0) {
      return '00:00';
    }
    var tmp = inSeconds ~/ Duration.secondsPerMinute;
    var minute;
    if (tmp < 10) {
      minute = '0$tmp';
    } else {
      minute = '$tmp';
    }

    var tmp1 = inSeconds % Duration.secondsPerMinute;
    var seconds;
    if (tmp1 < 10) {
      seconds = '0$tmp1';
    } else {
      seconds = '$tmp1';
    }
    return '$minute:$seconds';
  }

  Widget getDurationText() {
    String txt = '';
    if (_controller.value.position == null ||
        _controller.value.duration == null) {
      txt = '00:00/00:00';
    } else {
      txt =
          '${getMinuteSeconds(_controller.value.position.inSeconds)}/${getMinuteSeconds(_controller.value.duration.inSeconds)}';
    }
    return Text(txt,
        style: const TextStyle(color: Colors.white, fontSize: 14.0));
  }
}

class FadeAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  const FadeAnimation(
      {super.key,
      required this.child,
      this.duration = const Duration(milliseconds: 1500)});

  @override
  State<FadeAnimation> createState() => _FadeAnimationState();
}

class _FadeAnimationState extends State<FadeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: widget.duration, vsync: this);
    animationController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    animationController.forward(from: 0.0);
  }

  @override
  void deactivate() {
    animationController.stop();
    super.deactivate();
  }

  @override
  void didUpdateWidget(covariant FadeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.child != widget.child) {
      animationController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return animationController.isAnimating
        ? Opacity(
            opacity: 1.0 - animationController.value,
            child: widget.child,
          )
        : Container();
  }
}
