part of '../router.dart';

Future<Response> handleUserRoutes(Request request) async {
  final path = request.url.path;

  if (path == 'user') {
    if (request.isPost) return await getUser(request);
    if (request.isPut) return await updateUser(request);
    if (request.isDelete) return await deleteUser(request);
    return methodNotAllowedResponse(request);
  } else if (path == 'user/create') {
    if (request.isPost) return await createUser(request);
    return methodNotAllowedResponse(request);
  }

  return notFoundResponse(request);
}
