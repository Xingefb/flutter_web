import 'package:event_bus/event_bus.dart';

EventBus eventBus = EventBus();

// 登录成功后
class RefreshUserInfoEventBus {
  bool isRefresh;
  RefreshUserInfoEventBus(bool isRefresh) {
    this.isRefresh = isRefresh;
  }
}

// 报名成功后 消息列表刷新
class ApplySuccess {
  bool isApplied;
  ApplySuccess(bool isApplied) {
    this.isApplied = isApplied;
  }
}

// 取消报名列表刷新
class CancleApply {
  bool isCancle;
  CancleApply(bool isCancle) {
    this.isCancle = isCancle;
  }
}