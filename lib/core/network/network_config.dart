

class NetworkConfig {
  static const String physicalBaseUrl = 'http://127.0.0.1:8000/api/';


  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);

  static const Map<String, String> defaultHeaders = {
    'accept': 'application/json',
    'Content-Type': 'application/json',
  };
}
