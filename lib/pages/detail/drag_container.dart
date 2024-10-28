import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_douban/services/EventBus.dart';

typedef DragListener = void Function(
    double dragDistance, ScrollNotificationListener isDragEnd);

class DragController {
  late DragListener _dragListener;

  setDrag(DragListener l) {
    _dragListener = l;
  }

  void updateDragDistance(
      double dragDistance, ScrollNotificationListener isDragEnd) {
    if (_dragListener != null) {
      _dragListener(dragDistance, isDragEnd);
    }
  }
}

late DragController _controller;

class DragContainer extends StatefulWidget {
  final Widget drawer;
  final double defaultShowHeight;
  final double height;
  DragContainer(
      {super.key,
      required this.drawer,
      required this.defaultShowHeight,
      required this.height})
      : assert(drawer != null),
        assert(defaultShowHeight != null),
        assert(height != null) {
    _controller = DragController();
  }

  @override
  State<DragContainer> createState() => _DragContainerState();
}

class _DragContainerState extends State<DragContainer>
    with TickerProviderStateMixin {
  late AnimationController animalController;

  ///滑动位置超过这个位置，会滚到顶部；小于，会滚动底部。
  late double maxOffsetDistance;
  late bool onResetControllerValue = false;
  late Animation<double> animation;
  bool offstage = false;
  bool _isFling = false;
  double get defaultOffsetDistance => widget.height - widget.defaultShowHeight;
  late double offsetDistance = defaultOffsetDistance;
  @override
  void initState() {
    super.initState();
    animalController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
    maxOffsetDistance = (widget.height + widget.defaultShowHeight) * 0.5;
    _controller
        .setDrag((double value, ScrollNotificationListener notification) {
      if (notification != ScrollNotificationListener.edge) {
        _handleDragEnd(null);
      } else {
        setState(() {
          offsetDistance = offsetDistance + value;
        });
      }
    });
    eventBus.on<LongCommentEvent>().listen((event) {
      // print(event);
      _setDistance();
    });
  }

  _setDistance() {
    offsetDistance = defaultOffsetDistance;
    setState(() {});
    /// 自己滚动
    animalController.forward();
  }

  GestureRecognizerFactoryWithHandlers<MyVerticalDragGestureRecognizer> getRecognizer() {
    return GestureRecognizerFactoryWithHandlers<
        MyVerticalDragGestureRecognizer>(
      () => MyVerticalDragGestureRecognizer(flingListener: (bool isFling) {
            _isFling = isFling;
          }), //constructor
      (MyVerticalDragGestureRecognizer instance) {
        //initializer
        instance
          ..onStart = _handleDragStart
          ..onUpdate = _handleDragUpdate
          ..onEnd = _handleDragEnd;
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    animalController.dispose();
  }

  double get screenH => MediaQuery.of(context).size.height;

  ///当拖拽结束时调用
  void _handleDragEnd(DragEndDetails? details) {
    onResetControllerValue = true;

    ///很重要！！！动画完毕后，controller.value = 1.0， 这里要将value的值重置为0.0，才会再次运行动画
    ///重置value的值时，会刷新UI，故这里使用[onResetControllerValue]来进行过滤。
    animalController.value = 0.0;
    onResetControllerValue = false;
    double start;
    double end;
    if (offsetDistance <= maxOffsetDistance) {
      ///这个判断通过，说明已经child位置超过警戒线了，需要滚动到顶部了
      start = offsetDistance;
      end = 0.0;
    } else {
      start = offsetDistance;
      end = defaultOffsetDistance;
    }
    if (_isFling &&
        details != null &&
        details.velocity != null &&
        details.velocity.pixelsPerSecond != null &&
        details.velocity.pixelsPerSecond.dy < 0) {
      ///这个判断通过，说明是快速向上滑动，此时需要滚动到顶部了
      start = offsetDistance;
      end = 0.0;
    }

    final CurvedAnimation curve =
        CurvedAnimation(parent: animalController, curve: Curves.easeInOut);
    animation = Tween(begin: start, end: end).animate(curve)
      ..addListener(() {
        if (!onResetControllerValue) {
          // print(animation.value);
          offsetDistance = animation.value;
          setState(() {});
        }
      });
    /// 自己滚动
    animalController.forward();
  }

  ///当拖拽时更新
  void _handleDragUpdate(DragUpdateDetails details) {
    offsetDistance = offsetDistance + details.delta.dy;
    setState(() {});
  }
  ///当拖拽开始时调用
  void _handleDragStart(DragStartDetails details) {
    _isFling = false;
  }

  @override
  Widget build(BuildContext context) {
    if (offsetDistance == null || onResetControllerValue) {
      ///说明是第一次加载,由于BottomDragWidget中 alignment: Alignment.bottomCenter,故直接设置
      offsetDistance = defaultOffsetDistance;
    }
    ///偏移值在这个范围内
    offsetDistance = offsetDistance.clamp(0.0, defaultOffsetDistance);
    offstage = offsetDistance < maxOffsetDistance;
    return Transform.translate(
      offset: Offset(0.0, offsetDistance),
      child: RawGestureDetector(
        gestures: {MyVerticalDragGestureRecognizer: getRecognizer()},
        child: Stack(
          children: <Widget>[
            SizedBox(
              height: widget.height,
              child: widget.drawer,
            ),
            Offstage(
              offstage: offstage,
              child: Container(
                ///使用图层来解决当抽屉露出头时，上拉抽屉上移。解决的方案最佳
                color: Colors.transparent,
                height: widget.height,
              ),
            )
          ],
        ),
      ),
    );
  }
}

enum ScrollNotificationListener {
  ///滑动开始
  start,

  ///滑动结束
  end,

  ///滑动时，控件在边缘（最上面显示或者最下面显示）位置
  edge
}

typedef FlingListener = void Function(bool isFling);
///MyVerticalDragGestureRecognizer 负责任务
///1.监听child的位置更新
///2.判断child在手松的那一刻是否是出于fling状态
class  MyVerticalDragGestureRecognizer extends VerticalDragGestureRecognizer {
  final FlingListener flingListener;
  MyVerticalDragGestureRecognizer({super.debugOwner, required this.flingListener});

  final Map<int, VelocityTracker> _velocityTrackers = <int, VelocityTracker>{};

  @override
  void handleEvent(PointerEvent event) {
    super.handleEvent(event);
    if (!event.synthesized &&
        (event is PointerDownEvent || event is PointerMoveEvent)) {
      final VelocityTracker? tracker = _velocityTrackers[event.pointer];
      assert(tracker != null);
      tracker?.addPosition(event.timeStamp, event.position);
    }
  }

  @override
  void addPointer(PointerDownEvent event) {
    super.addPointer(event);
    _velocityTrackers[event.pointer] = VelocityTracker.withKind(PointerDeviceKind.touch);
  }

   ///来检测是否是fling
  @override
  void didStopTrackingLastPointer(int pointer) {
    final double minVelocity = minFlingVelocity ?? kMinFlingVelocity;
    final double minDistance = minFlingDistance ?? kTouchSlop;
    final VelocityTracker? tracker = _velocityTrackers[pointer];

    ///VelocityEstimate 计算二维速度的
    final VelocityEstimate? estimate = tracker!.getVelocityEstimate();
    bool isFling = false;
    if (estimate != null && estimate.pixelsPerSecond != null) {
      isFling = estimate.pixelsPerSecond.dy.abs() > minVelocity &&
          estimate.offset.dy.abs() > minDistance;
    }
    _velocityTrackers.clear();
    if (flingListener != null) {
      flingListener(isFling);
    }

    ///super.didStopTrackingLastPointer(pointer) 会调用[_handleDragEnd]
    ///所以将[lingListener(isFling);]放在前一步调用
    super.didStopTrackingLastPointer(pointer);
  }

  @override
  void dispose() {
    _velocityTrackers.clear();
    super.dispose();
  }
}


class OverscrollNotificationWidget extends StatefulWidget {
  final Widget child;
  const OverscrollNotificationWidget({super.key, required this.child});

  @override
  State<OverscrollNotificationWidget> createState() => _OverscrollNotificationWidgetState();
}

class _OverscrollNotificationWidgetState
    extends State<OverscrollNotificationWidget>
    with TickerProviderStateMixin<OverscrollNotificationWidget> {
  final GlobalKey _key = GlobalKey();

  ///[ScrollStartNotification] 部件开始滑动
  ///[ScrollUpdateNotification] 部件位置发生改变
  ///[OverscrollNotification] 表示窗口小部件未更改它的滚动位置，因为更改会导致滚动位置超出其滚动范围
  ///[ScrollEndNotification] 部件停止滚动
  ///之所以不能使用这个来build或者layout，是因为这个通知的回调是会有延迟的。
  ///Any attempt to adjust the build or layout based on a scroll notification would
  ///result in a layout that lagged one frame behind, which is a poor user experience.

  @override
  Widget build(BuildContext context) {
    print('NotificationListener build');
    final Widget child = NotificationListener<ScrollStartNotification>(
      key: _key,
      child: NotificationListener<ScrollUpdateNotification>(
        child: NotificationListener<OverscrollNotification>(
          child: NotificationListener<ScrollEndNotification>(
            child: widget.child,
            onNotification: (ScrollEndNotification notification) {
              _controller.updateDragDistance(
                  0.0, ScrollNotificationListener.end);
              return false;
            },
          ),
          onNotification: (OverscrollNotification notification) {
            if (notification.dragDetails != null &&
                notification.dragDetails?.delta != null) {
              _controller.updateDragDistance(notification.dragDetails!.delta.dy,
                  ScrollNotificationListener.edge);
            }
            return false;
          },
        ),
        onNotification: (ScrollUpdateNotification notification) {
          return false;
        },
      ),
      onNotification: (ScrollStartNotification scrollUpdateNotification) {
        _controller.updateDragDistance(0.0, ScrollNotificationListener.start);
        return false;
      },
    );

    return child;
  }
}