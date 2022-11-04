import 'dart:core';

import 'package:intl/intl.dart';


/**
 * 时间工具类
 */

class DateTimeUtil {

  static String YYYY = "yyyy";
  static String MM = "MM";
  static String DD = "dd";
  static String YYYY_MM_DD = "yyyy-MM-dd";
  static String YYYY_MM = "yyyy-MM";
  static String HH_MM_SS = "HH:mm:ss";
  static String YYYY_MM_DD_HH_MM_SS = "yyyy-MM-dd HH:mm:ss";
  static String formatStr_yyyyMMddHHmmssS = "yyyy-MM-dd HH:mm:ss.S";
  static String formatStr_yyyyMMddHHmmss = "yyyy-MM-dd HH:mm:ss";
  static String formatStr_yyyyMMddHHmm = "yyyy-MM-dd HH:mm";
  static String formatStr_yyyyMMddHH = "yyyy-MM-dd HH";
  static String formatStr_yyyyMMdd = "yyyy-MM-dd";

  static int currentTimeMillis() {
    return new DateTime.now().millisecondsSinceEpoch;
  }


  /**
   * 获取当前时间
   */
  static DateTime getDateTimeNew() {
    DateTime dateTime = new DateTime.now();
    return dateTime;
  }

  /**
   * 获取当前时间时间戳
   * 当前13位毫秒时间戳
   */
  static int getDateTimeNewTimeStamp13() {
    return getDateTimeNew().millisecondsSinceEpoch;
  }

  /**
   * 获取当前时间时间戳
   * 当前16位微秒数
   */
  static int getDateTimeNewTimeStamp16() {
    return getDateTimeNew().microsecondsSinceEpoch;
  }

  /**
   * 将时间转换成时间字符串
   */
  static String getDateTimeSwitchString(DateTime date,String type) {
    String dateString = DateFormat(type).format(date).toString();
    return dateString;
  }

  /**
   * 将时间字符串转换成时间
   */
  static DateTime getStringSwitchDateTime(String str) {
    DateTime dateTime = DateTime.parse(str);
    return dateTime;
  }


  /**
   * 将时间戳转换成时间
   */
  static DateTime getTimeStampSwitchDateTime(int stamp) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(stamp);
    return dateTime;
  }


  /**
   * 可以给某个时间增加或减少多少天
   *
   * 正数 为加   负数 为减
   */
  static DateTime getDayDuration(int day) {
    DateTime time = DateTime.now();
    time = time.add(new Duration(days: day));
    return time;
  }


  /**
   * 可以给某个时间增加或减少多少小时
   *
   * 正数 为加   负数 为减
   */
  static DateTime getHoursDuration(int hours) {
    DateTime time = DateTime.now();
    time = time.add(new Duration(hours: hours));
    return time;
  }


  /**
   * 两个日期的间隔 返回天数
   *
   * @param startDate
   * @param endDate
   * @return
   */
  static int dateDiffDays(DateTime startDate, DateTime endDate) {
    var difference = startDate.difference(endDate);
    return difference.inDays;
  }

  /**
   * 两个日期的间隔 返回小时
   *
   * @param startDate
   * @param endDate
   * @return
   */
  static int dateDiffHours(DateTime startDate, DateTime endDate) {
    var difference = startDate.difference(endDate);
    if(difference.inHours > 0){
      return difference.inHours;
    }else {
      return -difference.inHours;
    }
  }

  /**
   * 两个日期的间隔 返回分钟数
   *
   * @param startDate
   * @param endDate
   * @return
   */
  static int dateDiffMinutes(DateTime startDate, DateTime endDate) {
    var difference = startDate.difference(endDate);
    return difference.inMinutes;
  }


}