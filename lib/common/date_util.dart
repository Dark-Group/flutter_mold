import 'package:flutter/material.dart';
import 'package:flutter_mold/common/getter.dart';
import 'package:flutter_mold/localization/app_lang.dart';
import 'package:intl/intl.dart';

class DateUtil {

  //----------------------------------------------------------------------------
  static final DateFormat formatAsNumber = DateFormat("yyyyMMdd");
  static final DateFormat formatAsDate = DateFormat("dd.MM.yyyy");
  static final DateFormat formatAsDatetime = DateFormat("dd.MM.yyyy HH:mm:ss");
  static final DateFormat formatAsTime = DateFormat("HH:mm:ss");
  static final DateFormat formatAsStorableDatetime = DateFormat("yyyy-MM-dd HH:mm:ss");
  static final DateFormat formatAsStorableDate = DateFormat("yyyy-MM-dd");

  static final DateFormat datetimeAsNumber = DateFormat("yyyyMMddHHmmss");

  static final DateFormat formatAsDDMMEEE = DateFormat("dd:MM:EEE");
  static final DateFormat formatAsDDMMYYYYHHMM = DateFormat("dd.MM.yyyy HH:mm");
  static final DateFormat formatAsHHMM = DateFormat("HH:mm");
  static final DateFormat formatAsEEEEDDMMYYYY = DateFormat("EEEE, dd.MM.yyyy");
  static final DateFormat formatAsDDMMMYYYY = DateFormat("dd MMM yyyy");
  static final DateFormat formatAsMMYYYY = DateFormat("MM.yyyy");
  static final DateFormat formatAsDDEEEE = DateFormat("dd EEEE");
  static final DateFormat formatAsYYYYMM = DateFormat("yyyy:MM");

  static final Getter<DateFormat> formatAsDayWeek =
      new Getter(() => DateFormat("EE", AppLang.getInstance().getLangCode()));
  static final Getter<DateFormat> formatAsDDMMMMYYYYEEE =
      new Getter(() => DateFormat("dd MMMM yyyy (EEE)", AppLang.getInstance().getLangCode()));
  static final Getter<DateFormat> formatAsDDMMMMYYYY =
      new Getter(() => DateFormat("dd MMMM yyyy", AppLang.getInstance().getLangCode()));
  static final Getter<DateFormat> formatAsDDMMMM =
      new Getter(() => DateFormat("dd MMMM", AppLang.getInstance().getLangCode()));
  static final Getter<DateFormat> formatAsDDMMM =
      new Getter(() => DateFormat("dd MMM", AppLang.getInstance().getLangCode()));

  static final Getter<DateFormat> formatAsHHMMDDMMM =
      new Getter((() => DateFormat("HH:mm, dd MMM", AppLang.getInstance().getLangCode())));
  static final Getter<DateFormat> formatAsHHMMDD = new Getter((() => DateFormat("HH:mm, dd")));

  static DateTime today() {
    final now = DateTime.now();
    final date = format(now, DateUtil.formatAsDate);
    return parse("$date 00:00:00");
  }

  static String getMonthYear(String langCode, {DateTime? dateTime}) {
    final date = dateTime ?? DateTime.now();
    final month = DateFormat.MMMM(langCode).format(date);
    final year = date.year.toString();
    return month + " " + year;
  }

  static bool equalsDate(String d1, String d2) {
    var date1 = formatAsDate.parse(d1);
    var date2 = formatAsDate.parse(d2);
    return date1.compareTo(date2) == 0;
  }

  static List<String> sortDates(List<String> dates) {
    List<DateTime> dateTimes = dates.map((e) => parse(e)).toList();
    dateTimes.sort();
    return dateTimes.map((e) => format(e, formatAsDatetime)).toList();
  }

  static DateTime switchDateTime(DateTime dateTime, int toMonth) {
    DateTime newDate = DateTime(dateTime.year, dateTime.month + toMonth, dateTime.day);
    return newDate;
  }

  static String getTimeHour(String? time) {
    if (time == null || time.isEmpty) {
      return "00";
    }
    final minutes = int.parse(time);
    final String hours =
        minutes ~/ 60 > 9 ? (minutes ~/ 60).toString() : "0" + (minutes ~/ 60).toString();
    final String min =
        minutes % 60 > 9 ? (minutes % 60).toString() : "0" + (minutes % 60).toString();
    return hours + ":" + min;
  }

  static DateTime? tryParse(String s) {
    try {
      return parse(s);
    } catch (ignore) {
      return null;
    }
  }

  static DateTime parse(String date) {
    if (date.length == 0) {
      throw Exception("parameter date could not be empty");
    }

    switch (date.length) {
      case 8:
        return DateTime.parse(date);
      case 10:
        return formatAsDate.parse(date);
      case 14:
        String dateWithT = date.substring(0, 8) + 'T' + date.substring(8);
        return DateTime.parse(dateWithT);
      case 16:
        return formatAsDDMMYYYYHHMM.parse(date);
    }
    return formatAsDatetime.parse(date);
  }

  ///@nullable
  static TimeOfDay? tryParseTime(String time) {
    try {
      return parseTime(time);
    } catch (ignore) {
      return null;
    }
  }

  static TimeOfDay parseTime(String time) {
    if (time.length == 0) {
      throw Exception("parameter time could not be empty");
    }
    switch (time.length) {
      case 5:
        return TimeOfDay.fromDateTime(formatAsHHMM.parse(time));
      case 14:
        final dateWithT = time.substring(0, 8) + 'T' + time.substring(8);
        final parseDate = DateTime.parse(dateWithT);
        return TimeOfDay.fromDateTime(parseDate);
      case 16:
        return TimeOfDay.fromDateTime(formatAsDDMMYYYYHHMM.parse(time));
    }
    return TimeOfDay.fromDateTime(formatAsTime.parse(time));
  }

  static String? tryFormat(DateTime date, DateFormat fmt) {
    try {
      return format(date, fmt);
    } catch (ignore) {
      return null;
    }
  }

  static String format(DateTime date, DateFormat fmt) {
    return fmt.format(date);
  }

  static DateTime? tryFormatDateTime(DateTime date, DateFormat fmt) {
    try {
      return fmt.parse(format(date, fmt));
    } catch (ignore) {
      return null;
    }
  }

  static DateTime formatDateTime(DateTime date, DateFormat fmt) {
    return fmt.parse(format(date, fmt));
  }

  static String? tryConvert(String s, DateFormat fmt) {
    try {
      return convert(s, fmt);
    } catch (ignore) {
      return null;
    }
  }

  static String? convert(String date, DateFormat fmt) {
    if (date.length == 0) {
      throw Exception("parameter date could not be empty");
    }
    return format(parse(date), fmt);
  }

  static String convertToTime(String time, DateFormat fmt) {
    if (time.length == 0) {
      throw Exception("parameter time could not be empty");
    }
    if (time.contains(":")) return time;
    final timeInMillisecond = int.parse(time) * 60 * 1000;
    final t = today();
    final date = DateTime.fromMillisecondsSinceEpoch(t.millisecondsSinceEpoch + timeInMillisecond);
    return format(date, fmt);
  }

  static String convertMinuteToTimeText(String minute) {
    if (minute.length == 0) {
      return "mold:date_util:minute %1s".translate(args: ["0"]);
    }
    final minuteInt = int.parse(minute);
    final h = (minuteInt ~/ 60).toString();
    final m = (minuteInt % 60).toInt().toString();
    if (minuteInt % 60 == 0) {
      return "mold:date_util:hour %1s".translate(args: [h]);
    } else if (minuteInt ~/ 60 == 0) {
      return "mold:date_util:minute %1s".translate(args: [m]);
    } else {
      return "mold:date_util:hour_minute %1s %2s".translate(args: [h, m]);
    }
  }
}
