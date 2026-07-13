import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  const AppConfig();

  String get apiBaseUrl =>
      dotenv.env['API_BASE_URL']?.trim() ?? 'http://10.0.2.2:4000';

  String get socketUrl =>
      dotenv.env['SOCKET_URL']?.trim() ?? apiBaseUrl;

  String get socketPath =>
      dotenv.env['SOCKET_PATH']?.trim() ?? '/socket.io';
}
