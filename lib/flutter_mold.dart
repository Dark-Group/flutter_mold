library flutter_mold;

import 'flutter_mold_platform_interface.dart';

export 'package:flutter_mold/widgets/theme.dart';

export 'common/date_util.dart';
export 'common/error_message.dart';
export 'common/extensions.dart';
export 'common/lazy.dart';
export 'common/lazy_stream.dart';
export 'common/list_extension.dart';
export 'common/timer.dart';
export 'common/util.dart';
export 'localization/app_lang.dart';
export 'localization/pref.dart';
export 'log/logger.dart';
export 'mold/mold.dart';
export 'mold/mold_application.dart';
export 'mold/mold_navigation_history_observer.dart';
export 'mold/mold_stateful_widget.dart';
export 'mold/style.dart';
export 'mold2/bundle.dart';
export 'mold2/screen_scaffold.dart';
export 'mold2/window.dart';
export 'network/mime_type.dart';
export 'network/network.dart';
export 'variable/error_result.dart';
export 'variable/quantity.dart';
export 'variable/text_value.dart';
export 'variable/value_array.dart';
export 'variable/value_bool.dart';
export 'variable/value_string.dart';
export 'variable/variable.dart';
export 'variable/variable_like.dart';
export 'variable/variable_notifier.dart';
export 'variable/variable_util.dart';
export 'widgets/button.dart';
export 'widgets/edit_text.dart';
export 'widgets/widgets.dart';

class FlutterMold {
  Future<String?> getPlatformVersion() {
    return FlutterMoldPlatform.instance.getPlatformVersion();
  }
}
