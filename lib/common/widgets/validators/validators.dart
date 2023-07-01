import 'package:flutter/material.dart';
class FormValidator {
  String? validateEmail(String? email) {
    if (email == null) return null;

    RegExp exp = new RegExp(
        r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?");
    Iterable<RegExpMatch> matches = exp.allMatches(email);

    if (email.isEmpty) {
      return "Email can't be empty";
    } else if (email.trim().length == 0) {
      return "Email can't contain only spaces";
    } else if (matches.length <= 0) {
      return "Email is invalid";
    } else {
      return null;
    }
  }

  String? validatePassword(String? password) {
    if (password == null) return null;

    if (password.isEmpty) {
      return "Password can't be empty";
    } else if (password.trim().length == 0) {
      return "Password can't contain only spaces";
    } else if (password.length > 25) {
      return "Password can't contain more than 25 characters";
    } else if (password.length < 8) {
      return "Password must contain at least 8 characters";
    } else {
      return null;
    }
  }

  String? validatePasswords(String? pass, String? confirmPass) {
    if (pass != confirmPass) {
      return "Passwords don't match";
    }

    return null;
  }

  String? validatePhone(String? phone) {
    return phone.isNotNullOrEmpty ? null : "Phone can't be empty";
  }

  String? validateName(String? name) {
    return name.isNotNullOrEmpty ? null : "Name can't be empty";
  }

  String? validateCity(String? c) {
    return c.isNotNullOrEmpty ? null : "City can't be empty";
  }

  String? validateZip(String? z) {
    return z.isNotNullOrEmpty ? null : "Postal Code can't be empty";
  }

  String? validateEmpty(String v) {
    return v.isNotNullOrEmpty ? null : "Field can't be empty";
  }
}
extension StringValidationExtension on String? {

  bool get isNotNullOrEmpty {
    var current = this;
    if (current != null) return current.isNotEmpty;

    return false;
  }
}