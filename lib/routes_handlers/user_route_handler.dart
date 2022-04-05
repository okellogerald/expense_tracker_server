import 'package:example_server/database.dart';
import 'source.dart';

Future<Response> getUser(Request request) async {
  final params = request.requestedUri.queryParameters;
  var errors = validateParams(params, getUserParams);
  if (errors.isNotEmpty) return errorResponse(errors);

  final values = await validateBody(request, userSignInFields);
  errors = values['errors'];
  if (errors.isNotEmpty) return errorResponse(errors);

  final query = (values['body'] as Map<String, dynamic>)..addAll(params);
  final response = await Database.match(query);
  if (response.hasError) return errorResponse(response.error!.message);
  return userResponse(response.data);
}

Future<Response> createUser(Request request) async {
  final values = await validateBody(request, createUserFields);
  final errors = values['errors'], body = values['body'];
  if (errors.isNotEmpty) return errorResponse(errors);

  //checking if the user already exists
  final query = {'email': body['email']};
  var response = await Database.match(query);
  if (response.hasError) return errorResponse(response.error!.message, 200);
  if (response.data.isNotEmpty) {
    return errorResponse('User with the same email address already exists');
  }

  //else add user
  response = await Database.add(userTable, body);
  if (response.hasError) return errorResponse(response.error?.message, 200);
  return userResponse(response.data, 201);
}

///has to pass whole user info except email which is to be passed as a parameter
Future<Response> updateUser(Request request) async {
  final params = request.requestedUri.queryParameters;
  var errors = validateParams(params, getUserParams);
  if (errors.isNotEmpty) return errorResponse(errors);

  final values = await validateBody(request, updateUserFields);
  errors = values['errors'];
  final body = values['body'];
  if (errors.isNotEmpty) return errorResponse(errors);
  body['email'] = params['email']!;

  var response = await Database.update(userTable, body);
  if (response.hasError) return errorResponse(response.error?.message, 200);
  return userResponse(response.data, 201);
}

Future<Response> deleteUser(Request request) async {
  final params = request.requestedUri.queryParameters;
  final errors = validateParams(params, getUserParams);
  if (errors.isNotEmpty) return errorResponse(errors);

  var response = await Database.delete(userTable, params['email']!);
  if (response.hasError) return errorResponse(response.error?.message, 200);
  return userResponse(response.data, 201);
}
