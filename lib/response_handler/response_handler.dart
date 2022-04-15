import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'response_keys.dart';

const headers = {'Content-Type': 'application/json'};

Response errorResponse(ResponseCode code,
    {dynamic message, int statusCode = 400}) {
  final data = _error(code, message);
  print(data);
  return Response(statusCode, body: json.encode(data), headers: headers);
}

Response userResponse(List userList, [int statusCode = 200]) {
  if (userList.isEmpty) {
    return errorResponse(ResponseCode.no_user_exists, statusCode: 404);
  }
  final data = <String, dynamic>{"user": userList.first}..remove('password');
  return Response(statusCode, body: json.encode(data), headers: headers);
}

Response methodNotAllowedResponse(Request request) {
  final data = _error(ResponseCode.method_not_allowed,
      "Method not allowed: ${request.method} /${request.url.path}");
  return Response(400, body: json.encode(data), headers: headers);
}

Response notFoundResponse(Request request) {
  final data = _error(
      ResponseCode.unknown_route_code, "Unknown Route: /${request.url.path}");
  return Response.notFound(json.encode(data), headers: headers);
}

Map<String, dynamic> _error(ResponseCode code, [String? message]) {
  String errorMessage = 'unknown error';

  if (message == null) {
    if (code == ResponseCode.no_user_exists) {
      errorMessage = ResponseMessage.no_user_exists_message;
    } else if (code == ResponseCode.user_exists) {
      errorMessage = ResponseMessage.user_exists_message;
    } else if (code == ResponseCode.invalid_credentials) {
      errorMessage = ResponseMessage.invalid_login_credentials_message;
    }
  }
  return {
    "error": {"code": code.name, "message": message ?? errorMessage}
  };
}
