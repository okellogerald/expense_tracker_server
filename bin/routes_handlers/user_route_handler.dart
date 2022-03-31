import 'dart:convert';

import 'source.dart';

Future<Response> getUser(Request request) async {
  final params = request.requestedUri.queryParameters;
  final emailId = params['emailId'];
  if (emailId == null) {
    return Response.ok('Email must be provided');
  }
  final response =
      await client.from('users').select().match({'email': emailId}).execute();

  if (response.hasError) {
    return Response.ok(response.error!.message);
  }

  return Response.ok(json.encode(response.data));
}
