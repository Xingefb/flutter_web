import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class JobColor {
  /// white FFFFFF
  static final Color white = Colors.white;

  /// title black 39393A
  static final Color black = Color(0xFF39393A);

  ///  money red FD758D
  static final Color red = Color(0xFFFD758D);

  /// subtitle  969696
  static final Color grey = Color(0xFF969696);

  /// blue 5BD9FA
  static final Color blue = Color(0xFF5BD9FA);

  /// purple 7596FD
  static final Color purple = Color(0xFF7596FD);

  /// line #EBEAEA
  static final Color line = Color(0xFFEBEAEA);

}

class JobStyle {
  /// 17 Medium black
  static final headStyle = TextStyle(
      fontSize: 17, color: JobColor.black, fontWeight: FontWeight.w500);

  /// 15 Medium black
  static final titleStyle = TextStyle(
      fontSize: 16, color: JobColor.black, fontWeight: FontWeight.w500);

  /// 14 Regular grad
  static final subTitleStyle = TextStyle(
      fontSize: 14, color: JobColor.grey, fontWeight: FontWeight.w400);

  /// 17 money red
  static final moneyStyle =
      TextStyle(fontSize: 17, color: JobColor.red, fontWeight: FontWeight.w500);

  /// 14 money state red
  static final moneyStateStyle =
      TextStyle(fontSize: 14, color: JobColor.red, fontWeight: FontWeight.w400);
}
