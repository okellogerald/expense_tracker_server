import 'package:example_server/routes_handlers/user_route_handler.dart';
import 'package:shelf/shelf.dart';

part 'route_managers/user_routes_manager.dart';

Future<Response> router(Request request) async {
  final path = request.url.path;
  if (path.isEmpty) return Response.ok('Hi! Trust you\'re doing great');
  if (path.startsWith('user')) return handleUserRoutes(request);
  return Response.ok('Unknown endpoint: $path');
}
