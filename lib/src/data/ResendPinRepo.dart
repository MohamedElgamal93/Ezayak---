import 'package:http/http.dart';

abstract class ResendPinRepo {
  Future<Response> fetchPin(String headerToken);
}