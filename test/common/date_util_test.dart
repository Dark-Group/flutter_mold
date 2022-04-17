import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mold/common/date_util.dart';
import 'package:flutter_mold/flutter_mold.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:mockito/mockito.dart';

import '../mock/mock_app_lang.dart';

void main() {
  group("test constants pattern", () {
    test("pattern dd:MM:EEE", () {
      expect(DateUtil.formatAsDDMMEEE.pattern, equals("dd:MM:EEE"));
    });

    test("pattern yyyyMMdd", () {
      expect(DateUtil.formatAsNumber.pattern, equals("yyyyMMdd"));
    });

    test("pattern dd.MM.yyyy", () {
      expect(DateUtil.formatAsDate.pattern, equals("dd.MM.yyyy"));
    });

    test("pattern dd.MM.yyyy HH:mm:ss", () {
      expect(DateUtil.formatAsDatetime.pattern, equals("dd.MM.yyyy HH:mm:ss"));
    });

    test("pattern HH:mm:ss", () {
      expect(DateUtil.formatAsTime.pattern, equals("HH:mm:ss"));
    });

    test("pattern yyyy-MM-dd HH:mm:ss", () {
      expect(DateUtil.formatAsStorableDatetime.pattern, equals("yyyy-MM-dd HH:mm:ss"));
    });

    test("pattern yyyy-MM-dd", () {
      expect(DateUtil.formatAsStorableDate.pattern, equals("yyyy-MM-dd"));
    });

    test("pattern yyyyMMddHHmmss", () {
      expect(DateUtil.datetimeAsNumber.pattern, equals("yyyyMMddHHmmss"));
    });

    test("pattern dd.MM.yyyy HH:mm", () {
      expect(DateUtil.formatAsDDMMYYYYHHMM.pattern, equals("dd.MM.yyyy HH:mm"));
    });

    test("pattern HH:mm", () {
      expect(DateUtil.formatAsHHMM.pattern, equals("HH:mm"));
    });

    test("pattern EEEE, dd.MM.yyyy", () {
      expect(DateUtil.formatAsEEEEDDMMYYYY.pattern, equals("EEEE, dd.MM.yyyy"));
    });

    test("pattern dd MMM yyyy", () {
      expect(DateUtil.formatAsDDMMMYYYY.pattern, equals("dd MMM yyyy"));
    });

    test("pattern MM.yyyy", () {
      expect(DateUtil.formatAsMMYYYY.pattern, equals("MM.yyyy"));
    });

    test("pattern dd EEEE", () {
      expect(DateUtil.formatAsDDEEEE.pattern, equals("dd EEEE"));
    });

    test("pattern yyyy:MM", () {
      expect(DateUtil.formatAsYYYYMM.pattern, equals("yyyy:MM"));
    });

    test("pattern MM.yyyy", () {
      expect(DateUtil.formatAsMMYYYY.pattern, equals("MM.yyyy"));
    });
  });

  group("test get today function", () {
    test("test with correct time", () {
      final now = DateTime.now();
      DateTime time = DateUtil.parse("${DateUtil.format(now, DateUtil.formatAsDate)} 00:00:00");
      expect(DateUtil.today(), equals(time));
    });

    test("test with incorrect time", () {
      final now = DateTime.now();
      DateTime time = DateUtil.parse("${DateUtil.format(now, DateUtil.formatAsDate)} 01:00:00");
      expect(DateUtil.today(), isNot(equals(time)));
    });
  });

  group("test get month year function", () {
    test("test with english language time", () {
      when(AppLang.instance.getLangCode())
          .thenAnswer((realInvocation) => Locale.fromSubtags(languageCode: "en_US").languageCode);
      expect(DateUtil.getMonthYear(AppLang.instance.getLangCode(), dateTime: DateTime(2021, 2)),
          equals("February 2021"));
    });
/*    test("test with russian language time", () {
      when(appLang.getLangCode())
          .thenAnswer((realInvocation) => Locale.fromSubtags(languageCode: "ru_RU").languageCode);
      expect(DateUtil.getMonthYear(dateTime: DateTime(2021, 2)), equals("февраль 2021"));
    });*/
  });

  group("test  theSameDay function", () {
    test("test with correct time", () {
      expect(DateUtil.equalsDate("21.11.2021", "21.11.2021"), isTrue);
    });
    test("test with incorrect time", () {
      expect(DateUtil.equalsDate("21.11.2021", "27.04.2015"), isFalse);
    });
  });

  group("test  sortDates function", () {
    test("test with correct order", () {
      expect(DateUtil.sortDates(["21.11.2021 21:55:50", "21.11.2021 13:55:50", "21.10.2021"]),
          equals(["21.10.2021 00:00:00", "21.11.2021 13:55:50", "21.11.2021 21:55:50"]));
    });
    test("test with incorrect order", () {
      expect(DateUtil.sortDates(["21.11.2021 21:55:50", "21.11.2021 13:55:50", "21.10.2021"]),
          isNot(equals(["21.11.2021", "21.11.2021", "21.10.2021"])));
    });
  });

  group("test  switchDateTime function", () {
    test("test with correct time", () {
      expect(DateUtil.switchDateTime(DateTime(2021, 12, 25, 16, 25, 46), 5),
          equals(DateTime(2022, 5, 25)));
    });

    test("test with incorrect time", () {
      expect(DateUtil.switchDateTime(DateTime(2021, 12, 25, 16, 25, 46), 5),
          isNot(equals(DateTime(2022, 5, 25, 16))));
    });
  });

  group("test  getTimeHour function", () {
    test("test when time is empty", () {
      expect(DateUtil.getTimeHour(""), equals("00"));
    });

    test("test with normal time", () {
      expect(DateUtil.getTimeHour("375"), equals("06:15"));
    });
    test("test with normal time", () {
      expect(DateUtil.getTimeHour("675"), equals("11:15"));
    });
  });

  group("test  tryParse function", () {
    // test("test when time is null", () {
    //   expect(DateUtil.tryParse(null), isNull);
    // });

    test("test when time is empty", () {
      expect(DateUtil.tryParse(""), isNull);
    });

    test("test with not supported format", () {
      expect(DateUtil.tryParse("15:24"), isNull);
    });

    test("test with yyyyMMdd format time", () {
      expect(DateUtil.tryParse("20210102"), equals(DateTime(2021, 01, 02)));
    });

    test("test with dd.MM.yyyy format time", () {
      expect(DateUtil.tryParse("02.01.2021"), equals(DateTime(2021, 01, 02)));
    });

    test("test with yyyyMMddTHHmmss format time", () {
      expect(DateUtil.tryParse("20210102152436"), equals(DateTime(2021, 01, 02, 15, 24, 36)));
    });

    test("test with dd.MM.yyyy HH:mm format time", () {
      expect(DateUtil.tryParse("02.01.2021 15:24"), equals(DateTime(2021, 01, 02, 15, 24)));
    });
  });

  group("test  tryParseTime function", () {
    // test("test when time is null", () {
    //   expect(DateUtil.tryParseTime(null), isNull);
    // });

    test("test when time is empty", () {
      expect(DateUtil.tryParseTime(""), isNull);
    });

    test("test with not supported format", () {
      expect(DateUtil.tryParseTime("not supported test here"), isNull);
    });

    test("test with HH:mm format time", () {
      expect(DateUtil.tryParseTime("22:06"), equals(TimeOfDay(hour: 22, minute: 06)));
    });

    test("test with yyyyMMddTHHmmss format time", () {
      expect(DateUtil.tryParseTime("20210102152436"), equals(TimeOfDay(hour: 15, minute: 24)));
    });

    test("test with HH:mm:ss format time", () {
      expect(DateUtil.tryParseTime("22:06:55"), equals(TimeOfDay(hour: 22, minute: 06)));
    });

    test("test with dd.MM.yyyy HH:mm format time", () {
      expect(DateUtil.tryParseTime("21.06.2021 22:06"), equals(TimeOfDay(hour: 22, minute: 06)));
    });
  });

  group("test  tryFormat function", () {
    // test("test when time and date format are null", () {
    //   expect(DateUtil.tryFormat(null, null), isNull);
    // });
    //
    // test("test when time is null and date format is not null", () {
    //   expect(DateUtil.tryFormat(null, DateUtil.DD_MM_EEE), isNull);
    // });
    //
    // test("test when time is not null and date format is  null", () {
    //   expect(DateUtil.tryFormat(DateTime.now(), null), isNull);
    // });

    test("test with not supported date format", () {
      expect(DateUtil.tryFormat(DateTime.now(), DateFormat("qqqqq")), equals("qqqqq"));
    });

    test("test with correct format", () {
      expect(
          DateUtil.tryFormat(DateTime(2021, 02, 23), DateUtil.formatAsDate), equals("23.02.2021"));
    });
  });

  group("test  formatDateTime function", () {
    // test("test when time and date format are null", () {
    //   expect(DateUtil.formatDateTime(null, null), isNull);
    // });
    //
    // test("test when time is null and date format is not null", () {
    //   expect(DateUtil.formatDateTime(null, DateUtil.DD_MM_EEE), isNull);
    // });
    //
    // test("test when time is not null and date format is  null", () {
    //   expect(DateUtil.formatDateTime(DateTime.now(), null), isNull);
    // });

    test("test with correct format", () {
      expect(DateUtil.formatDateTime(DateTime(2021, 02, 23), DateUtil.formatAsDate),
          DateTime(2021, 02, 23));
    });
  });

  group("test  tryConvert function", () {
    // test("test when time and date format are null", () {
    //   expect(DateUtil.tryConvert(null, null), isNull);
    // });
    //
    // test("test when time is empty and date format is not null", () {
    //   expect(DateUtil.tryConvert("", null), isNull);
    // });
    //
    // test("test when time is null and date format is not null", () {
    //   expect(DateUtil.tryConvert(null, DateUtil.DD_MM_EEE), isNull);
    // });

    test("test when time is empty and date format is not null", () {
      expect(DateUtil.tryConvert("", DateUtil.formatAsDDMMEEE), isNull);
    });

    test("test with correct format and correct time", () {
      expect(DateUtil.tryConvert("23.02.2021", DateUtil.formatAsDatetime), "23.02.2021 00:00:00");
    });
  });

  group("test  convertToTime function", () {
    // test("test when minute is null", () {
    //   expect(DateUtil.convertMinuteToTimeText(null), isNull);
    // });

    test("test when minute is empty", () {
      expect(DateUtil.convertMinuteToTimeText(""), isNull);
    });

    test("test when minute is just text", () {
      expect(() => DateUtil.convertMinuteToTimeText("dsf"), throwsA(isA()));
    });

    test("test when time is only minute", () {
      when(AppLang.getInstance().translate("gwslib:date_util:minute %1s", args: ["36"]))
          .thenAnswer((realInvocation) => "36 мин");
      expect(DateUtil.convertMinuteToTimeText("36"), equals("36 мин"));
    });

    test("test when time is only hour", () {
      when(AppLang.getInstance().translate("gwslib:date_util:hour %1s", args: ["2"]))
          .thenAnswer((realInvocation) => "2 ч");
      expect(DateUtil.convertMinuteToTimeText("120"), equals("2 ч"));
    });

    test("test when time is hour and minute", () {
      when(AppLang.getInstance().translate("gwslib:date_util:hour_minute %1s %2s", args: ["2", "6"]))
          .thenAnswer((realInvocation) => "2 ч 6 мин");
      expect(DateUtil.convertMinuteToTimeText("126"), equals("2 ч 6 мин"));
    });
  });

  group("test convertToTime function", () {
    // test("test convertToTime with null time text", () {
    //   expect(DateUtil.convertToTime(null, DateUtil.FORMAT_AS_HH_MM), isNull);
    // });

    test("test convertToTime with empty time text", () {
      expect(DateUtil.convertToTime("", DateUtil.formatAsHHMM), isNull);
    });

    test("test convertToTime with formatted value", () {
      expect(DateUtil.convertToTime("10:22", DateUtil.formatAsHHMM), "10:22");
    });

    test("test convertToTime with calculated time value", () {
      expect(DateUtil.convertToTime("432", DateUtil.formatAsHHMM), "07:12");
    });

    test("test convertToTime with zero value", () {
      expect(DateUtil.convertToTime("0", DateUtil.formatAsHHMM), "00:00");
    });
  });
}
