import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UsefulFunction {
  static String getFormattedTime(int hour, int minute) {
    TimeOfDay timeOfDay = TimeOfDay(hour: hour, minute: minute);
    return _formatTime(timeOfDay);
  }

  static String _formatTime(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    final time = DateTime(
        now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
    final formatter = DateFormat('hh:mm a');
    return formatter.format(time);
  }

  static String toCamelCase(String input) {
    String output = '';
    List<String> list = input.split(' ');

    for (int i = 0; i < list.length; i++) {
      String temp = list[i].replaceFirst(list[i][0], list[i][0].toUpperCase());
      output += temp;
      output += ' ';
    }
    return output;
  }

  static String convertTimeTo24HourFormat(String timeIn12Hour) {
    List<String> splitList = timeIn12Hour.split(' ');
    String meridiem = splitList[1];
    String time = splitList[0];
    List<String> timeSplit = time.split(':');
    int hour = int.parse(timeSplit[0]);
    String hourString = hour.toString();

    if (meridiem == 'PM' && hour != 12) {
      hour += 12;
      hourString = hour.toString();
    } else if (meridiem == 'AM' && hour == 12) {
      hour = 0;
      hourString = '00';
    } else if (hour < 10) {
      hourString = '0$hour';
    }

    timeSplit[0] = hourString;
    time = timeSplit.join(':');

    return time;
  }
}

String removeWhiteSpaces(String input) {
  return input.replaceAll(' ', '');
}

String removeSpecialChars(String input) {
  return input.replaceAll(RegExp(r"[^\s\w]"), '');
}

String removeSpecificString(String input, String toRemove) {
  return input.replaceAll(toRemove, '');
}

String trimSpecialChars(String str) {
  str = str.trim();
  if (str.contains('|  |')) {
    str = str.replaceAll('|  |', ' | ').trim();
  }
  if (str[0] == '|') {
    str = str.replaceFirst('|', '').trim();
  }
  if (str.isNotEmpty && str[str.length - 1] == '|') {
    str = str.substring(0, str.length - 1).trim();
  }
  return str;
}
