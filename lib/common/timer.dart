import 'package:flutter_mold/flutter_mold.dart';

class Timer {
  DateTime? startTime;

  int? start() {
    startTime = new DateTime.now();
    return startTime?.millisecondsSinceEpoch;
  }

  int stop(String message) {
    if (startTime == null) {
      Log.debug("startTime not initialized");
      return -1;
    }

    DateTime endTime = new DateTime.now();
    print("===========================TIMER========================\n"
        "started()=$startTime \nended()=$endTime \n"
        "running time = ${endTime.millisecondsSinceEpoch - startTime!.millisecondsSinceEpoch} ms\n"
        "$message\n====================================================================");
    return endTime.millisecondsSinceEpoch - startTime!.millisecondsSinceEpoch;
  }
}
