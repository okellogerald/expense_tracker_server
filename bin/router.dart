import 'package:example_server/response_handler.dart';
import 'package:example_server/routes_handlers/user_route_handler.dart';
import 'package:shelf/shelf.dart';

part 'route_managers/user_routes_manager.dart';

extension RequestExtension on Request {
  bool get isGet => method == "GET";
  bool get isPost => method == "POST";
  bool get isPut => method == "PUT";
  bool get isDelete => method == "DELETE";
}

Future<Response> router(Request request) async {
  final path = request.url.path;
  if (path.isEmpty) return Response.ok('Hi! Trust you\'re doing great');
  if (path.startsWith('user')) return handleUserRoutes(request);
  return notFoundResponse(request);
}
