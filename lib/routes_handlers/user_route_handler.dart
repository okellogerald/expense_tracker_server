import 'dart:convert';

import 'package:example_server/database.dart';
import 'package:example_server/utils/utils.dart';
import 'package:http/http.dart' as http;

import 'source.dart';

Future<Response> getUser(Request request) async {
  final params = request.requestedUri.queryParameters;
  final errors = Validator.validateParams(params, getUserFields);
  if (errors.isNotEmpty) return Response.ok('$errors');

  final query = {'email': params['email']};
  final response = await Database.match(query);
  if (response.hasError) {
    return Response.ok(response.error!.message);
  }
  return Response.ok(json.encode((response.data as List).first));
}

Future<Response> createUser(Request request) async {
  final body = await getBody(request);
  final errors = Validator.validateBody(body, createUserFields);
  if (errors.isNotEmpty) return Response.ok('$errors');

  //checking if the user already exists
  final query = {'email': body['email']};
  var response = await Database.match(query);
  if (response.hasError) {
    return Response.ok(response.error!.message);
  }
  if (response.data.isNotEmpty) {
    return Response.forbidden('User already exists');
  }

  //else add user
  response = await Database.add(userTable, body);
  if (response.hasError) {
    return Response.ok(response.error!.message);
  }
  print(response.data);
  return Response.ok(json.encode((response.data as List).first));
}

Future<Response> sendOTP(Request request) async {
  final body = await getBody(request);
  final errors = Validator.validateBody(body, justEmailOnBody);
  if (errors.isNotEmpty) return Response.ok('$errors');

  final email = body['email']!;
  final otp = Utils.generateOTP();

  ///checking if otp is already provided for this email.
  var response = await Database.match({'email': email}, table: otpTable);
  if (response.hasError) {
    return Response.ok(response.error!.message);
  }
  if ((response.data as List).isNotEmpty) {
    //email exists
    response = await Database.update(otpTable, {"email": email, "otp": otp});
    if (response.hasError) {
      return Response.ok(response.error!.message);
    }
  } else {
    //email does not exist
    response = await Database.add(otpTable, {"email": email, "otp": otp});
    if (response.hasError) {
      return Response.ok(response.error!.message);
    }
  }

  ///sending otp mail
  try {
    await _sendOTPEmail(email, otp);
    return Response.ok('succeeded creating otp & sending the email');
  } catch (e) {
    return Response.ok('Error while sending email: $e');
  }
}

Future<Response> validateOTP(Request request) async {
  final body = await getBody(request);
  final errors = Validator.validateBody(body, validateOTPFields);
  if (errors.isNotEmpty) return Response.ok('$errors');

  final response = await Database.match(body, table: otpTable);
  if (response.hasError) {
    return Response.ok(response.error!.message);
  }
  if ((response.data as List).isEmpty) return Response.notFound('INVALID OTP');
  return Response.ok('Success');
}

Future<void> _sendOTPEmail(String email, String otp) async {
  final headers = {
    'Accept': 'application/json',
    'Content-type': 'application/json'
  };

  var content = '''
Content-Type: text/html; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
to: $email
from: okellogeralddev@gmail.com
subject: Checking if mail works
Use this OTP to verify your email
$otp''';

  var bytes = utf8.encode(content);
  var base64 = base64Encode(bytes);
  var body = json.encode({'raw': base64});

  final url = "https://www.googleapis.com/gmail/v1/users/$email/messages/send";
  final response =
      await http.post(Uri.parse(url), headers: headers, body: body);
  print(response.body);
}
