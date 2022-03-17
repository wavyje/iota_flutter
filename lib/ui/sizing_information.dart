import 'package:flutter/material.dart';
import 'package:iota_app/enum/device_screen_type.dart';

class SizingInformation {

  final Orientation orientation;
  final DeviceScreenType deviceScreenType;
  final Size screenSize;
  final Size localWidgetSize;

  SizingInformation({
    required this.orientation,
    required this.deviceScreenType,
    required this.screenSize,
    required this.localWidgetSize
  });

  @override
  String toString() {
    return 'Orientation:$orientation DeviceType:$deviceScreenType ScreenSize:$screenSize LocalWidgetSize:$localWidgetSize';
  }
}
