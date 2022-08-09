import 'package:flutter/material.dart';

enum WidgetState {
  INIT,
  BUILD,
  DISPOSE,
}

abstract class MoldStatefulWidget extends StatefulWidget {
  BuildContext? _context;
  WidgetState? state;
  VoidCallback? _setState;

  @override
  _MoldStatefulWidgetState createState() => _MoldStatefulWidgetState();

  void _setContext(BuildContext context) {
    _context = context;
  }

  BuildContext? getContext() => _context;

  BuildContext requiredContext() => getContext()!;

  void onCreate() {}

  void reloadState() {
    this._setState?.call();
  }

  void onChangeAppLifecycleState(AppLifecycleState state) {}

  void onDestroy() {}

  Widget onCreateWidget(BuildContext context);
}

class _MoldStatefulWidgetState extends State<MoldStatefulWidget> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    /// set widget state init
    widget.state = WidgetState.INIT;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    widget.onChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    widget.onDestroy();
    super.dispose();

    /// set widget state dispose
    widget.state = WidgetState.DISPOSE;
  }

  @override
  Widget build(BuildContext context) {
    this.widget._setState = () {
      setState(() {});
    };

    widget._setContext(context);

    /// calling widget onCreate when widget instance new or reload
    if (widget.state == null || widget.state == WidgetState.INIT) {
      widget.onCreate();
    }

    try {
      return widget.onCreateWidget(context);
    } finally {
      /// set widget state build
      widget.state = WidgetState.BUILD;
    }
  }
}
