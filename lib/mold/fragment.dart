import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_mold/common/error_message.dart';
import 'package:flutter_mold/common/lazy_stream.dart';
import 'package:flutter_mold/common/text_style.dart';
import 'package:flutter_mold/localization/app_lang.dart';
import 'package:flutter_mold/log/logger.dart';
import 'package:flutter_mold/mold/mold.dart';
import 'package:flutter_mold/mold/mold_stateful_widget.dart';
import 'package:flutter_mold/widgets/icon.dart';
import 'package:flutter_mold/widgets/table.dart';
import 'package:flutter_mold/widgets/text.dart';
import 'package:flutter_mold/widgets/theme.dart';
import 'package:provider/provider.dart';

typedef OnProgressListener = void Function(bool progress);

enum EmergeType { DEFAULT, WARNING, EXCEPTION }

enum EmergeView { DEFAULT, CARD, DIALOG }

class EmergeTooltip {
  final String message;
  final String description;
  final EmergeType type;
  final EmergeView view;

  IconData _icon;

  Color _backgroundColor;
  Color _iconColor;
  Color _textColor;

  EmergeTooltip({
    IconData icon,
    this.message,
    this.description,
    this.type,
    this.view,
    Color backgroundColor,
    Color textColor,
    Color iconColor,
  }) {
    GTheme theme = GStyle.getTheme();
    switch (type) {
      case EmergeType.WARNING:
        this._icon = icon ?? Icons.warning_amber_rounded;
        this._backgroundColor = backgroundColor ?? theme.warningBackgroundColor;
        this._iconColor = iconColor ?? theme.warningIconColor;
        this._textColor = textColor ?? theme.warningTextColor;
        break;
      case EmergeType.EXCEPTION:
        this._icon = icon ?? Icons.warning_amber_rounded;
        this._backgroundColor = backgroundColor ?? theme.errorBackgroundColor;
        this._iconColor = iconColor ?? theme.errorIconColor;
        this._textColor = textColor ?? theme.errorTextColor;
        break;
      default:
        this._icon = icon ?? Icons.info_outline_rounded;
        this._backgroundColor = backgroundColor ?? theme.infoBackgroundColor;
        this._iconColor = iconColor ?? theme.infoIconColor;
        this._textColor = textColor ?? theme.infoTextColor;
    }
  }

  IconData get icon => _icon;

  Color get backgroundColor => this._backgroundColor;

  Color get textColor => this._textColor;

  Color get iconColor => this._iconColor;

  bool get isViewNotDefault => view != EmergeView.DEFAULT;

  bool get isViewNotCard => view != EmergeView.CARD;

  bool get isViewNotDialog => view != EmergeView.DIALOG;
}

abstract class ViewModule {}

abstract class ViewModel<A> {
  //------------------------------------------------------------------------------------------------

  LazyStream<EmergeTooltip> _emergeTooltip = new LazyStream();

  Stream<EmergeTooltip> get emergeTooltipStream => _emergeTooltip.stream;

  EmergeTooltip get emergeTooltipValue => _emergeTooltip.value;

  void setEmergeTooltip({
    IconData icon,
    String message,
    String description,
    EmergeType type,
    EmergeView view,
    Color backgroundColor,
    Color textColor,
    Color iconColor,
  }) {
    if (message == null || message.isEmpty) {
      throw Exception("message is null or empty");
    }
    final tooltip = new EmergeTooltip(
        icon: icon,
        message: message,
        description: description,
        type: type,
        view: view,
        backgroundColor: backgroundColor,
        textColor: textColor,
        iconColor: iconColor);
    _emergeTooltip.add(tooltip);
  }

  void setWarningMessage(
    dynamic message, [
    String description,
    EmergeView warningView = EmergeView.DEFAULT,
  ]) {
    String messageText;
    String descriptionText = description;
    if (message is ErrorMessage) {
      messageText = message.messageText;
      descriptionText = message.stacktrace;
    } else if (message is String) {
      messageText = message;
    } else {
      throw UnsupportedError("message type not support, you can use String or ErrorMessage");
    }
    setEmergeTooltip(
      message: messageText,
      description: descriptionText,
      type: EmergeType.WARNING,
      view: warningView,
    );
  }

  void setErrorMessage(
    dynamic error, [
    dynamic stacktrace,
    EmergeView errorView = EmergeView.DEFAULT,
  ]) {
    ErrorMessage errorMessage;
    if (!(error is ErrorMessage)) {
      errorMessage = ErrorMessage.parseWithStacktrace(error, stacktrace);
    } else {
      errorMessage = error;
    }

    setEmergeTooltip(
      message: errorMessage.messageText,
      description: errorMessage.stacktrace,
      type: EmergeType.EXCEPTION,
      view: errorView,
    );
  }

  void resetError() {
    _emergeTooltip.add(null);
  }

  //------------------------------------------------------------------------------------------------

  LazyStream<Map<int, List<OnProgressListener>>> _progressListener = new LazyStream(() => {});

  LazyStream<Map<int, bool>> _progress = new LazyStream(() => {});

  Stream get progressStream => _progress.get().stream;

  bool _isProgressListens() {
    return _progress.value.keys.toList().where((e) => !_progressListener.value.containsKey(e)).isEmpty;
  }

  bool isProgress([int key]) {
    if (key != null) {
      return _progress.get().value.containsKey(key);
    }
    return _progress.get().value.isNotEmpty;
  }

  void setProgress(int key, bool progress) {
    final hasValue = _progress.get().value.containsKey(key);

    if (progress && !hasValue) {
      final data = _progress.get().value;
      data[key] = true;
      _progress.add(data);
      _progressListener.value[key]?.forEach((r) => r.call(true));
    } else if (!progress && hasValue) {
      final data = _progress.get().value;
      data.remove(key);
      _progress.add(data);
      _progressListener.value[key]?.forEach((r) => r.call(false));
    }
  }

  void setProgressListener(int key, OnProgressListener listener) {
    final onProgressListener = (bool progress) {
      try {
        listener.call(progress);
      } catch (e, st) {
        Log.error(e, st);
        setErrorMessage(e, st);
      }
    };

    var data = _progressListener.value;
    if (data.containsKey(key)) {
      var listenerList = data[key];
      if (listenerList == null) {
        listenerList = [onProgressListener];
      } else {
        listenerList.add(onProgressListener);
      }
      data[key] = listenerList;
    } else {
      data = {
        key: [onProgressListener]
      };
    }
    _progressListener.add(data);
  }

  //------------------------------------------------------------------------------------------------

  ViewModelFragment _content;

  A get argument => _content.argument as A;

  BuildContext get context => _content.getContext();

  void onCreate() {
    _progress.add({});
    _progressListener.add({});
    _emergeTooltip.add(null);
  }

  Future<ViewModule> onLoadViewModule() {
    return null;
  }

  void onDestroy() {
    _progress.close();
    _progressListener.close();
    _emergeTooltip.close();
  }
}

class Fragment extends StatelessWidget {
  final RootFragment fragment;

  Fragment(this.fragment);

  @override
  Widget build(BuildContext context) {
    return _FragmentState(fragment);
  }
}

class _FragmentState extends MoldStatefulWidget {
  final RootFragment fragment;

  _FragmentState(this.fragment);

  BuildContext get ctx => getContext();

  @override
  void onCreate() {
    super.onCreate();
    fragment.context = ctx;
    fragment.onCreate(ctx);
  }

  @override
  void onDestroy() {
    fragment.onDestroy();
    super.onDestroy();
  }

  @override
  Widget onCreateWidget(_) {
    fragment.context = ctx;
    return Material(
      child: fragment.onCreateWidget(ctx),
    );
  }
}

abstract class RootFragment {
  Fragment toFragment() => Mold.newInstance(this);

  BuildContext _context;
  Object _argument;
  GlobalKey<ScaffoldState> _scaffoldStateKey;

  set argument(Object newValue) {
    _argument = newValue;
  }

  get argument => _argument ?? ModalRoute.of(getContext()).settings.arguments;

  set context(BuildContext newValue) {
    _context = newValue;
  }

  BuildContext getContext() => _context;

  set drawerScaffoldKey(GlobalKey<ScaffoldState> newValue) {
    _scaffoldStateKey = newValue;
  }

  get drawerScaffoldKey => _scaffoldStateKey;

  void onCreate(BuildContext context) {}

  String getString(String code, {List<String> args}) => code.translate(args: args);

  void onDestroy() {}

  Widget onCreateWidget(BuildContext context);
}

abstract class ViewModelFragment<VM extends ViewModel> extends RootFragment {
  ViewModelFragmentBloc _bloc = new ViewModelFragmentBloc();

  ViewModel _viewmodel;

  VM get viewmodel => _viewmodel;

  ViewModule _module;

  ViewModule get module => _module;

  VM onCreateViewModel(BuildContext buildContext) => null;

  @override
  void onCreate(BuildContext context) {
    if (this._viewmodel == null) {
      this._viewmodel = onCreateViewModel(context);
    }

    this._viewmodel._content = this;
    this._viewmodel.onCreate();
  }

  @override
  Widget onCreateWidget(BuildContext context) {
    if (_bloc._isWithModule && this._module == null) {
      this._viewmodel.onLoadViewModule().then((module) {
        this._module = module;
        this._bloc.reload();
      });
    }

    //@Problem
    //ChangeNotifierProvider not updating the UI that is why i change

    //@Solution
    //If you already have an instance of ChangeNotifier and want to expose it,
    // you should use ChangeNotifierProvider.value instead of the default constructor.
    //Failing to do so may dispose the ChangeNotifier when it is still in use.
    //you can read more complete this link: https://pub.dev/documentation/provider/latest/provider/ChangeNotifierProvider-class.html
    return new ChangeNotifierProvider<ViewModelFragmentBloc>.value(
      value: this._bloc,
      child: new Consumer<ViewModelFragmentBloc>(builder: (_, model, child) {
        final ctx = getContext();
        final bloc = model;

        Widget bodyWidget = onBuildBodyWidget(ctx);
        if (bloc._scrollable) {
          bodyWidget = Expanded(
            child: SingleChildScrollView(child: bodyWidget),
          );
        } else {
          bodyWidget = Expanded(child: bodyWidget, flex: 1);
        }
        return Stack(
          children: [
            Scaffold(
              backgroundColor: bloc._backgroundColor,
              appBar: onBuildAppBarWidget(ctx),
              body: MyTable.vertical([
                _ErrorMessageWidget(
                  _viewmodel.emergeTooltipStream,
                  onCloseTap: () => viewmodel.resetError(),
                ),
                bodyWidget,
              ]),
              floatingActionButton: bloc._floatActionButton,
            ),
            _ErrorMessageCardWidget(
              _viewmodel.emergeTooltipStream,
              onCloseTap: () => viewmodel.resetError(),
            ),
            _ProgressBarWidget(_viewmodel)
          ],
        );
      }),
    );
  }

  void setFragmentWithModule(bool withModule) {
    this._bloc.withModule = withModule;
  }

  void setBackgroundColor(Color color) {
    this._bloc.backgroundColor = color;
  }

  void setFragmentScrollable(bool scrollable) {
    this._bloc.scrollable = scrollable;
  }

  void setFloatActionButton(Widget floatActionButton) {
    this._bloc.floatActionButton = floatActionButton;
  }

  PreferredSizeWidget onBuildAppBarWidget(BuildContext context) {
    return null;
  }

  Widget onBuildBodyWidget(BuildContext context) {
    return null;
  }

  @override
  void onDestroy() {
    this._viewmodel?.onDestroy();
    this._viewmodel = null;
  }
}

class ViewModelFragmentBloc extends ChangeNotifier {
  void reload() {
    notifyListeners();
  }

  Color _backgroundColor;

  set backgroundColor(Color newValue) {
    _backgroundColor = newValue;
    notifyListeners();
  }

  bool _scrollable = true;

  set scrollable(bool newValue) {
    this._scrollable = newValue;
    notifyListeners();
  }

  Widget _floatActionButton;

  set floatActionButton(Widget newValue) {
    this._floatActionButton = newValue;
    notifyListeners();
  }

  bool _isWithModule = false;

  set withModule(bool newValue) {
    this._isWithModule = newValue;
    notifyListeners();
  }
}

class _ErrorMessageWidget extends StatelessWidget {
  _ErrorMessageWidget(this.errorStream, {this.onCloseTap});

  final VoidCallback onCloseTap;

  final Stream<EmergeTooltip> errorStream;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EmergeTooltip>(
      stream: errorStream,
      builder: (_, st) {
        EmergeTooltip error = st.data;
        if (error == null || error.isViewNotDefault) {
          return Container();
        }
        return MyTable.horizontal(
          [
            MyIcon.icon(
              error.icon,
              size: 20,
              padding: EdgeInsets.only(left: 16, right: 8),
              color: error.iconColor,
            ),
            MyText(
              error.message,
              style: TS_ErrorText(textColor: error.textColor),
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              flex: 1,
            ),
            if (onCloseTap != null)
              MyIcon.icon(
                Icons.close_rounded,
                padding: EdgeInsets.all(8),
                color: error.iconColor,
                onTap: onCloseTap,
              )
          ],
          width: double.infinity,
          background: error.backgroundColor,
          crossAxisAlignment: CrossAxisAlignment.center,
          onTapCallback: () => showErrorDialog(context, error.message),
        );
      },
    );
  }

  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: MyText(message, style: TS_ErrorText(fontSize: 14.0)),
        actions: <Widget>[
          TextButton(
            child: MyText("OK", style: TS_Button()),
            onPressed: () => Mold.onBackPressed(context),
          )
        ],
      ),
    );
  }
}

class _ErrorMessageCardWidget extends StatelessWidget {
  _ErrorMessageCardWidget(this.errorStream, {this.onCloseTap});

  final VoidCallback onCloseTap;

  final Stream<EmergeTooltip> errorStream;

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder<EmergeTooltip>(
        stream: errorStream,
        builder: (_, st) {
          EmergeTooltip error = st.data;
          if (error == null || error.isViewNotCard) {
            return Container();
          }
          return SafeArea(
            child: MyTable(
              [_buildMessage(error)],
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
              margin: EdgeInsets.all(16),
              borderRadius: BorderRadius.circular(8),
              elevation: 8,
              background: error.backgroundColor,
            ),
          );
        });
  }

  Widget _buildMessage(EmergeTooltip tooltip) {
    return MyTable.horizontal(
      [
        MyIcon.icon(
          tooltip.icon,
          size: 20,
          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          color: tooltip.iconColor,
        ),
        MyText(
          tooltip.message,
          style: TS_ErrorText(textColor: tooltip.textColor, fontSize: 16),
          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          flex: 1,
        ),
        if (onCloseTap != null)
          MyIcon.icon(
            Icons.close_rounded,
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            color: tooltip.iconColor,
            onTap: onCloseTap,
          )
      ],
    );
  }
}

class _ProgressBarWidget extends StatelessWidget {
  _ProgressBarWidget(this.viewmodel);

  final ViewModel viewmodel;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: viewmodel.progressStream,
        builder: (_, st) {
          if (st.data == null || viewmodel._isProgressListens()) {
            return Container();
          }
          final indicatorWidget = CircularProgressIndicator(
            backgroundColor: Colors.black12,
          );
          return Container(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: Align(
                child: MyTable(
                  [indicatorWidget],
                  borderRadius: BorderRadius.circular(8),
                  background: Colors.black87.withAlpha((255 * 0.7).toInt()),
                  padding: EdgeInsets.all(16),
                ),
                alignment: Alignment.center,
              ),
            ),
          );
        });
  }
}
