import 'package:shelf/shelf.dart';

import 'routes_handlers/root_handler.dart';
import 'routes_handlers/user_route_handler.dart';

//dart run bin/server.dart

Future<Response> router(Request request) async {
  switch (request.url.path) {
    case '':
      return rootHandler(request);
    case 'user':
      return await getUser(request);
  }
  return Response.ok('Unknown endpoint: ${request.url.path}');
}
