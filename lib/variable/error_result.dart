import 'dart:core';

import 'package:flutter_mold/flutter_mold.dart';

abstract class ErrorResult {
  bool isError();

  bool nonError() => !isError();

  String? getErrorMessage();

  Exception? getException();

  ErrorResult or(dynamic that) {
    if (this.isError()) {
      return this;
    } else if (that != null && that is ErrorResult) {
      return that;
    } else if (that != null && that is Variable) {
      return that.getError();
    }
    return ErrorResult.NONE;
  }

  static ErrorResult makeWithString(String? errorMessage) {
    if (errorMessage == null) {
      throw Exception("The error message cannot be null");
    }

    if (errorMessage.isEmpty) {
      throw Exception("Error message is empty");
    }
    return new Error(errorMessage, null);
  }

  static ErrorResult makeWithException(Exception? error) {
    if (error == null) {
      throw Exception("The error type cannot be null");
    }
    return new Error(error.toString(), error);
  }

  static ErrorResult make(dynamic error) {
    if (error == null) {
      throw Exception("The error type cannot be null");
    }

    if (error.runtimeType == Error) {
      String errorMessage = (error as Error).toString();
      return new Error(errorMessage, Exception(errorMessage));
    } else if (error.runtimeType == Exception) {
      Exception exception = error as Exception;
      return new Error(exception.toString(), exception);
    } else if (error.runtimeType == String) {
      return new Error(error, Exception(error));
    } else {
      return new Error(error.toString());
    }
  }

  static ErrorResult makeWithVariables(List<Variable> variables) {
    for (Variable e in variables) {
      ErrorResult error = e.getError();
      if (error.isError()) {
        return error;
      }
    }
    return ErrorResult.NONE;
  }

  // ignore: non_constant_identifier_names
  static ErrorResult get NONE => new _ErrorNone();
}

class _ErrorNone extends ErrorResult {
  @override
  String? getErrorMessage() => null;

  @override
  Exception? getException() => null;

  @override
  bool isError() => false;
}

class Error extends ErrorResult {
  final String errorMessage;
  final Exception? exception;

  Error(this.errorMessage, [this.exception]);

  @override
  String? getErrorMessage() => errorMessage;

  @override
  Exception? getException() => exception;

  @override
  bool isError() => true;
}
