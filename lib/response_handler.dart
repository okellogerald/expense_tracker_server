import 'dart:convert';

import 'package:shelf/shelf.dart';

const headers = {'Content-Type': 'application/json'};

Response errorResponse(dynamic message, [int statusCode = 400]) {
  final data = <String, dynamic>{"error": message ?? 'unknown error'};
  return Response(statusCode, body: json.encode(data), headers: headers);
}

Response userResponse(List userList, [int statusCode = 200]) {
  if (userList.isEmpty) {
    return errorResponse('No user exists with that email address', 404);
  }
  final data = <String, dynamic>{"user": userList.first};
  return Response(statusCode, body: json.encode(data), headers: headers);
}

Response methodNotAllowedResponse(Request request) {
  final data = {
    "error": "Method not allowed: ${request.method} /${request.url.path}"
  };
  return Response(400, body: json.encode(data), headers: headers);
}

Response notFoundResponse(Request request) {
  final data = {"error": "Unknown Route: /${request.url.path}"};
  return Response.notFound(json.encode(data), headers: headers);
}
