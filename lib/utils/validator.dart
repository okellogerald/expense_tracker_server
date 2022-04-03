import 'dart:convert';

import 'package:shelf/shelf.dart';

const createUserFields = <String, Type>{
  'email': String,
  'password': String,
  'signup_option': String,
  'backup_option': String
};

const userSignInFields = <String, Type>{'password': String};

const updateUserFields = <String, Type>{
  'password': String,
  'signup_option': String,
  'backup_option': String,
  'currency': int,
  'display_name': String,
  'photo_url': String
};

const justEmailOnBody = <String, Type>{'email': String};

const validateOTPFields = <String, Type>{'email': String, 'otp': String};

const getUserParams = <String>['email'];

class Validator {
  static Future<Map<String, dynamic>> validateBody(
      Request request, Map<String, Type> fields) async {
    final errors = <String, String>{};
    final body = Map.from(await _getBody(request));

    for (int index = 0; index < fields.length; index++) {
      final requiredValue = fields.keys.toList()[index];
      final bodyValue = body[requiredValue];
      if (bodyValue == null) {
        errors[requiredValue] = '$requiredValue is required';
      } else {
        //value exists just checks for the correct type of each field.
        final requiredType = fields.values.toList()[index];
        if (bodyValue.runtimeType != requiredType) {
          final parsedValue = _getCorrectTypeValue(bodyValue, requiredType);
          if (parsedValue != null) {
            body[requiredValue] = parsedValue;
            continue;
          }
          final error =
              '$requiredValue is supposed to be $requiredType but you gave ${bodyValue.runtimeType}';
          errors[requiredValue] = error;
        }
      }
    }
    if (errors.isNotEmpty) body.clear();
    //returning a correct body as being type-specific for each field
    return {'errors': errors, 'body': body};
  }

  static Map<String, dynamic> validateParams(
      Map<String, String> body, List<String> fields) {
    final errors = <String, String>{};
    for (int index = 0; index < fields.length; index++) {
      final requiredValue = fields[index];
      final bodyValue = body[requiredValue];
      if (bodyValue == null) {
        errors[requiredValue] = '$requiredValue is missing on parameters';
      }
    }
    return errors;
  }

  //just checking for integers and doubles
  static dynamic _getCorrectTypeValue(dynamic value, Type type) {
    switch (type) {
      case int:
        final parsedValue = int.tryParse(value);
        return parsedValue;
      case double:
        final parsedValue = double.tryParse(value);
        return parsedValue;
      default:
        return null;
    }
  }

  static Future<Map<String, String>> _getBody(Request request) async {
    var content = await utf8.decoder.bind(request.read()).join();
    var body = Uri(query: content).queryParameters;
    return body;
  }
}
