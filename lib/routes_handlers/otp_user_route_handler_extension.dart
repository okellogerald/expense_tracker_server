part of 'user_route_handler.dart';
//* FOR FUTURE USE

Future<Response> sendOTP(Request request) async {
  final values = await Validator.validateBody(request, justEmailOnBody);
  final errors = values['errors'], body = values['body'];
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
  final values = await Validator.validateBody(request, validateOTPFields);
  final errors = values['errors'], body = values['body'];
  if (errors.isNotEmpty) return Response.ok('$errors');

  var response = await Database.match(body, table: otpTable);
  if (response.hasError) {
    return Response.ok(response.error!.message);
  }
  if ((response.data as List).isEmpty) return Response.notFound('INVALID OTP');

  response = await Database.delete(otpTable, body['email']!);
  if (response.hasError) {
    return Response.ok(response.error!.message);
  }
  return Response.ok('Success');
}

Future<void> _sendOTPEmail(String email, String otp) async {
  final message = _getEmailVerificationMessage(otp);

  var response = await http.post(
      Uri.parse('https://mandrillapp.com/api/1.0/messages/send'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(message));
  print(response.body);
}

Map<String, dynamic> _getEmailVerificationMessage(String otp) {
  return {
    "key": mandrillKey,
    "message": {
      "from_email": "developer@okellogerald.dev",
      "subject": "Email Verification",
      "text":
          "Hi!\n\nUse the below OTP code to verify your account at Expense Tracker app.\n\n$otp\n\nPlease ignore this email if it was sent against your consent.",
      "to": [
        {"email": "hi@okellogerald.dev", "type": "to"}
      ]
    }
  };
}
