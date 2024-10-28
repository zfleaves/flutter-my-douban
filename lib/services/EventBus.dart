import 'package:event_bus/event_bus.dart';

//Bus 初始化
EventBus eventBus = EventBus();

//商品详情广播数据
class LongCommentEvent {
  String str;
  LongCommentEvent(this.str);
}
