import 'dart:convert';

import 'package:shelf/shelf.dart';

Future<Map<String, dynamic>> validateBody(
    Request request, Map<String, Type> fields) async {
  if (request.mimeType != "application/x-www-form-urlencoded") {
    return {'errors': unsupportedMimeTypeErrorMessage, 'body': {}};
  }

  final errors = <String, String>{};
  final body = Map<String, dynamic>.from(await _getBody(request));

  for (int index = 0; index < fields.length; index++) {
    final requiredValue = fields.keys.toList()[index];
    final bodyValue = body[requiredValue];
    //recovery email & photo_url can be null
    if (bodyValue == null && !canBeNullFieldsList.contains(requiredValue)) {
      errors[requiredValue] = '$requiredValue is required';
    } else {
      if (canBeNullFieldsList.contains(requiredValue)) continue;

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

Map<String, String> validateParams(
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
dynamic _getCorrectTypeValue(dynamic value, Type type) {
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

//todo determine if it's correct MIME type from here
Future<Map<String, String>> _getBody(Request request) async {
  var content = await utf8.decoder.bind(request.read()).join();
  var body = Uri(query: content).queryParameters;
  return body;
}

const unsupportedMimeTypeErrorMessage =
    'Unsupported content type. Set Content-Type as application/x-www-form-urlencoded in request headers';

const createUserFields = <String, Type>{
  'email': String,
  'password': String,
  'signup_option': String,
  'backup_option': String,
  'recovery_email': String
};

const userSignInFields = <String, Type>{'password': String};

const updateUserFields = <String, Type>{
  'password': String,
  'signup_option': String,
  'backup_option': String,
  'currency': int,
  'display_name': String,
  'photo_url': String,
  'recovery_email': String
};

const justEmailOnBody = <String, Type>{'email': String};

const validateOTPFields = <String, Type>{'email': String, 'otp': String};

const getUserParams = <String>['email'];

const canBeNullFieldsList = ['recovery_email', 'photo_url'];
