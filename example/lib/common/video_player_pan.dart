import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
// import 'package:screen/screen.dart';

//import 'package:screen/screen.dart';
import 'package:video_player/video_player.dart';

import 'after_layout.dart';
import 'controller_widget.dart';
import 'video_player_control.dart';

class VideoPlayerPan extends StatefulWidget {
  const VideoPlayerPan({
    super.key,
    required this.child,
  });

//  final GlobalKey<VideoPlayerControlState> controlKey;
  final Widget child;

  @override
  _VideoPlayerPanState createState() => _VideoPlayerPanState();
}

class _VideoPlayerPanState extends State<VideoPlayerPan>
    with AfterLayoutMixin<VideoPlayerPan> {
  late Offset startPosition; // 起始位置
  late double movePan; // 偏移量累计总和
  late double layoutWidth; // 组件宽度
  late double layoutHeight; // 组件高度
  String volumePercentage = ''; // 组件位移描述
  double playDialogOpacity = 0.0;
  bool allowHorizontal = false; // 是否允许快进
  Duration position = const Duration(); // 当前时间
  double brightness = 0.0; //亮度
  bool brightnessOk = false; // 是否允许调节亮度

  VideoPlayerController get controller =>
      ControllerWidget.of(context).controller;
  bool get videoInit => ControllerWidget.of(context).videoInit;
  String get title => ControllerWidget.of(context).title;

  @override
  void afterFirstLayout(BuildContext context) {
    _reset(context);
  }

  @override
  void dispose() {
    super.dispose();
    brightnessOk = false;
    allowHorizontal = false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragStart: _onVerticalDragStart,
      onVerticalDragUpdate: _onVerticalDragUpdate,
      onVerticalDragEnd: _onVerticalDragEnd,
      onHorizontalDragStart: _onHorizontalDragStart,
      onHorizontalDragUpdate: _onHorizontalDragUpdate,
      onHorizontalDragEnd: _onHorizontalDragEnd,
      child: Stack(
        children: <Widget>[
          widget.child,
          Center(
            child: AnimatedOpacity(
              opacity: playDialogOpacity,
              duration: const Duration(milliseconds: 500),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 6.0),
                decoration: const BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
                child: Text(
                  volumePercentage,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          ),
          VideoPlayerControl(
            key: ControllerWidget.of(context).controlKey,
          )
        ],
      ),
    );
  }

  Future<void> _onVerticalDragStart(details) async {
    _reset(context);
    startPosition = details.globalPosition;
    if (startPosition.dx < (layoutWidth / 2)) {
      /// 左边触摸
      // brightness = await Screen.brightness;
      brightnessOk = true;
    }
  }

  void _onVerticalDragUpdate(details) {
    if (!videoInit) {
      return;
    }

    /// 累计计算偏移量(下滑减少百分比，上滑增加百分比)
    movePan += -details.delta.dy;
    if (startPosition.dx < (layoutWidth / 2)) {
      /// 左边触摸
      if (brightnessOk = true) {
        setState(() {
          volumePercentage = '亮度：${(_setBrightnessValue() * 100).toInt()}%';
          playDialogOpacity = 1.0;
        });
      }
    } else {
      /// 右边触摸
      setState(() {
        volumePercentage = '音量：${(_setVerticalValue(num: 2) * 100).toInt()}%';
        playDialogOpacity = 1.0;
      });
    }
  }

  Future<void> _onVerticalDragEnd(_) async {
    if (!videoInit) {
      return;
    }
    if (startPosition.dx < (layoutWidth / 2)) {
      if (brightnessOk) {
        // await Screen.setBrightness(_setBrightnessValue());
        brightnessOk = false;
        // 左边触摸
        setState(() {
          playDialogOpacity = 0.0;
        });
      }
    } else {
      // 右边触摸
      await controller.setVolume(_setVerticalValue());
      setState(() {
        playDialogOpacity = 0.0;
      });
    }
  }

  double _setBrightnessValue() {
    // 亮度百分控制
    var value =
        double.parse((movePan / layoutHeight + brightness).toStringAsFixed(2));
    if (value >= 1.00) {
      value = 1.00;
    } else if (value <= 0.00) {
      value = 0.00;
    }
    return value;
  }

  double _setVerticalValue({int num = 1}) {
    // 声音亮度百分控制
    var value = double.parse((movePan / layoutHeight + controller.value.volume)
        .toStringAsFixed(num));
    if (value >= 1.0) {
      value = 1.0;
    } else if (value <= 0.0) {
      value = 0.0;
    }
    return value;
  }

  void _reset(BuildContext context) {
    startPosition = const Offset(0, 0);
    movePan = 0;
    layoutHeight = context.size!.height;
    layoutWidth = context.size!.width;
    volumePercentage = '';
  }

  Future<void> _onHorizontalDragStart(DragStartDetails details) async {
    _reset(context);
    if (!videoInit) {
      return;
    }
    // 获取当前时间
    position = controller.value.position;
    // 暂停成功后才允许快进手势
    allowHorizontal = true;
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    if (!videoInit && !allowHorizontal) {
      return;
    }
    // 累计计算偏移量
    movePan += details.delta.dx;
    final value = _setHorizontalValue();
    // 用百分比计算出当前的秒数
    final currentSecond = DateUtil.formatDateMs(
      (value * controller.value.duration.inMilliseconds).toInt(),
      format: 'mm:ss',
    );
    if (value >= 0) {
      setState(() {
        volumePercentage = '快进至：$currentSecond';
        playDialogOpacity = 1.0;
      });
    } else {
      setState(() {
        volumePercentage = '快退至：${(value * 100).toInt()}%';
        playDialogOpacity = 1.0;
      });
    }
  }

  Future<void> _onHorizontalDragEnd(DragEndDetails details) async {
    if (!videoInit && !allowHorizontal) {
      return;
    }
    final value = _setHorizontalValue();
    final current = (value * controller.value.duration.inMilliseconds).toInt();
    await controller.seekTo(Duration(milliseconds: current));
    allowHorizontal = false;
    setState(() {
      playDialogOpacity = 0.0;
    });
  }

  double _setHorizontalValue() {
    // 进度条百分控制
    final valueHorizontal =
        double.parse((movePan / layoutWidth).toStringAsFixed(2));
    // 当前进度条百分比
    final currentValue =
        position.inMilliseconds / controller.value.duration.inMilliseconds;
    var value =
        double.parse((currentValue + valueHorizontal).toStringAsFixed(2));
    if (value >= 1.00) {
      value = 1.00;
    } else if (value <= 0.00) {
      value = 0.00;
    }
    return value;
  }
}
