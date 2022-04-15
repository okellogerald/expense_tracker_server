// ignore_for_file: constant_identifier_names

enum ResponseCode {
  user_exists,
  no_user_exists,
  invalid_credentials,
  database_error,
  validation_error,
  method_not_allowed,
  unknown_route_code
}

class ResponseMessage {
  static const user_exists_message =
      'User with the same email address already exists';
  static const no_user_exists_message =
      'No user exists with this email/password combination';
  static const invalid_login_credentials_message =
      'No user exists with this email-password combination';
  static const database_error_code = 'database-error';
  static const validation_error_code = 'validation-error';
  static const method_not_allowed_code = 'method-not-allowed';
  static const unknown_route_code = 'unknown-route';
}
