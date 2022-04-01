import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';

import 'router.dart';

void main(List<String> args) async {
  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  // Configure a pipeline that logs requests.
  final _handler = Pipeline().addMiddleware(logRequests()).addHandler(router);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '5050');
  final server = await serve(_handler, ip, port);
  print('Server listening on port ${server.port}');
}

///curl -X POST http://localhost:5050/user/sendOTP -H "Content-Type: application/x-www-form-urlencoded" -d "email=okellogerald126@gmail.com"
///curl -X POST http://localhost:5050/user/validateOTP -H "Content-Type: application/x-www-form-urlencoded" -d "email=okellogerald126@gmail.com&otp=12345"
///curl -X POST http://localhost:5050/user/create -H "Content-Type: application/x-www-form-urlencoded" -d "email=okellogerald126@gmail.com&password=126363&signup_option=email_password&backup_option=daily"
