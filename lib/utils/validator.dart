const createUserFields = <String, Type>{
  'email': String,
  'password': String,
  'signup_option': String,
  'backup_option': String
};

const justEmailOnBody = <String, Type>{'email': String};

const validateOTPFields = <String, Type>{'email': String, 'otp': String};

const getUserFields = <String>['email'];

class Validator {
  static Set<String> validateBody(
      Map<String, String> body, Map<String, Type> fields) {
    final errors = <String>{};
    for (int index = 0; index < fields.length; index++) {
      final requiredValue = fields.keys.toList()[index];
      final bodyValue = body[requiredValue];
      if (bodyValue == null) {
        errors.add('$requiredValue is required');
      } else {
        final requiredType = fields.values.toList()[index];
        if (bodyValue.runtimeType != requiredType) {
          final error =
              '$requiredValue is supposed to be $requiredType but you gave ${bodyValue.runtimeType}';
          errors.add(error);
        }
      }
    }
    return errors;
  }

  static Set<String> validateParams(
      Map<String, String> body, List<String> fields) {
    final errors = <String>{};
    for (int index = 0; index < fields.length; index++) {
      final requiredValue = fields[index];
      final bodyValue = body[requiredValue];
      if (bodyValue == null) {
        errors.add('$requiredValue is required');
      }
    }
    return errors;
  }
}
