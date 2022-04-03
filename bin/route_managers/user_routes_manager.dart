part of '../router.dart';

Future<Response> handleUserRoutes(Request request) async {
  final path = request.url.path;
  if (request.mimeType != "application/x-www-form-urlencoded") {
    return unsupportedContentType();
  }

  if (path == 'user') {
    if (request.isPost) return await getUser(request);
  } else if (path == 'user/create') {
    if (request.isPost) return await createUser(request);
  } else if (path == 'user/update') {
    if (request.isPut) return await updateUser(request);
  } else if (path == 'user/delete') {
    if (request.isDelete) return await deleteUser(request);
  } else if (path == 'user/sendOTP') {
    if (request.isPost) return await sendOTP(request);
  } else if (path == 'user/validateOTP') {
    if (request.isPost) return await validateOTP(request);
  }
  return methodNotAllowedResponse(request);
}
