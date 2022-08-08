class Timer {
  DateTime? startTime;

  int start() {
    startTime = new DateTime.now();
    return startTime!.millisecondsSinceEpoch;
  }

  int stop(String message) {
    DateTime endTime = new DateTime.now();
    print("===========================SMARTUP5X TIMER========================\n"
        "started()=$startTime\n"
        "ended()=$endTime\n"
        "running time = ${endTime.millisecondsSinceEpoch - startTime!.millisecondsSinceEpoch} ms\n"
        "$message\n"
        "====================================================================");
    return endTime.millisecondsSinceEpoch - startTime!.millisecondsSinceEpoch;
  }
}
