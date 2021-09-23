import 'package:flutter/material.dart';
import 'package:mobility_one/util/my_localization.dart';

class MyFieldValidations {
  static String? validateEmail(BuildContext context, String? email) {
    if (email!.isEmpty) {
      return MyLocalization.of(context)!.emailEmptyError;
    }
    var p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    var regExp = RegExp(p);
    if(regExp.hasMatch(email)) {
      return null;
    }
    return MyLocalization.of(context)!.emailNotValidFormat;
  }

  static String? validatePassword(BuildContext context, String? password) {
    if (password!.isEmpty) {
      return MyLocalization.of(context)!.passwordEmptyError;
    }
    return null;
  }

  static String? validateRequiredField(BuildContext context, String? value) {
    if (value!.isNotEmpty) {
      return null;
    }
    return MyLocalization.of(context)!.requiredFieldError;
  }

  static String? validateIsNumber(BuildContext context, String? value) {
    if (double.tryParse(value!) != null) {
      return null;
    }
    return MyLocalization.of(context)!.shouldBeNumberError;
  }
}