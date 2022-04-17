import 'package:dio/dio.dart';
import 'package:flutter_mold/common/util.dart';
import 'package:flutter_mold/localization/app_lang.dart';

class ErrorMessage {
  static String t(String key) => "gwslib:error:$key".translate();

  static final ErrorMessage NULL = ErrorMessage(null);

  static final String CONNECTION_FAIL = "Connection failed".toLowerCase();
  static final String CONNECTION_REFUSED = "Connection refused".toLowerCase();
  static final String HTTP_NOT_FOUND = "Status 404".toLowerCase();
  static final String HTTP_NOT_FOUND2 = "Http status error [404]".toLowerCase();
  static final String CONNECTION_TIMEOUT = "Connecting timed out".toLowerCase();
  static final String NUMERIC_OR_VALUE = "numeric or value".toLowerCase();
  static final String NO_DATA_FOUND = "no data found".toLowerCase();

  static final String OAUTH_NUMERIC_OR_VALUE = "numeric or value".toLowerCase();
  static final String OAUTH_NO_DATA_FOUND = "no data found".toLowerCase();

  static String? getMessage(String? error, {bool isOauth = false}) {
    if (error == null) return null;
    String err = error.toLowerCase();
    if (err.contains(CONNECTION_FAIL)) {
      return t("error_conection_fail");
    } else if (err.contains(CONNECTION_REFUSED)) {
      return t("error_conection_refused");
    } else if (err.contains(HTTP_NOT_FOUND) || err.contains(HTTP_NOT_FOUND2)) {
      return t("error_http_not_found");
    } else if (err.contains(CONNECTION_TIMEOUT)) {
      return t("error_connection_timeout");
    } else if (isOauth &&
        (err.contains(OAUTH_NUMERIC_OR_VALUE) || err.contains(OAUTH_NO_DATA_FOUND))) {
      return t("error_incorrect_login_or_password");
    } else if (err.contains(NO_DATA_FOUND)) {
      return t("error_no_data_found");
    } else if (err.contains(NUMERIC_OR_VALUE)) {
      return t("error_numeric_or_value");
    }
    return err;
  }

  final String? messageText;
  final String? stacktrace;
  final String? httpCode;

  ErrorMessage(String? message, {String? stacktrace, String? httpCode})
      : this.messageText = nvl(
          getMessage(message, isOauth: httpCode == "401"),
          "unknown error message:$message",
        ),
        this.stacktrace = nvl(stacktrace, ""),
        this.httpCode = nvl(httpCode, "");

  factory ErrorMessage.parse(dynamic error) {
    return ErrorMessage.parseWithStacktrace(error, "");
  }

  factory ErrorMessage.parseWithStacktrace(dynamic error, dynamic stacktrace) {
    String message = error?.toString() ?? "unknown error data";
    String httpCode = "-1";
    if (error is DioError) {
      if (error.type == DioErrorType.response) {
        message = error.response?.data?.toString() ?? "";
        if (message.isEmpty) {
          message = error.message;
        }
        httpCode = error.response?.statusCode?.toString() ?? "";
      }
    }
    return ErrorMessage(message.trim(), stacktrace: stacktrace.toString(), httpCode: httpCode);
  }

  bool get isNotEmptyMessage => messageText?.isNotEmpty == true;

  @override
  String toString() {
    if (stacktrace?.trim().isNotEmpty != true) {
      return messageText ?? "unknown error data";
    }
    return "$messageText\n$stacktrace";
  }
}
