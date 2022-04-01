import 'dart:convert';

import 'package:shelf/shelf.dart';

export 'package:example_server/utils/validator.dart';
export 'package:shelf/shelf.dart';

const userTable = 'users';
const otpTable = 'OTP';

//todo put in the validate method which returns proper body parameters, as well as checks errors
Future<Map<String, String>> getBody(Request request) async {
  var content = await utf8.decoder.bind(request.read()).join();
  var body = Uri(query: content).queryParameters;
  return body;
}
