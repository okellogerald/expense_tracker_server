part of '../router.dart';

Future<Response> handleUserRoutes(Request request) async {
  switch (request.url.path) {
    case 'user':
      return await getUser(request);
    case 'user/create':
      return await createUser(request);
    case 'user/sendOTP':
      return await sendOTP(request);
    case 'user/validateOTP':
      return await validateOTP(request);
  }
  return Response.ok('unknown root: ${request.url.path}');
}
