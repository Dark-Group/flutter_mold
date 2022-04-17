class ScreenArgument {
  final dynamic argument;
  final Map<String, dynamic> _datas;

  ScreenArgument(dynamic argument)
      : this.argument = argument,
        this._datas = <String, dynamic>{};

  ScreenArgument put(String key, dynamic value) {
    this._datas[key] = value;
    return this;
  }

  ScreenArgument putObject(String key, dynamic value) => this.put(key, value);

  dynamic get(String key) {
    if (this._datas.containsKey(key)) {
      return this._datas[key];
    }
    return null;
  }

  R getObject<R>(String key) => (get(key) as R);
}
