import 'package:lovoj_task/core/constant/end_point.dart';
import 'package:lovoj_task/data/services/network_services.dart';

class AuthenticationRepo {
  NetworkServices networkServices = NetworkServices();

  Future getOtp(Map<String, dynamic> bodyTosend) async {
    try {
      final response =
          await networkServices.post(ApiEndPoint.checkEmail, bodyTosend);
      return response;
    } catch (error) {
      throw Exception('$error');
    }
  }

  Future signUp(Map<String, dynamic> bodyTosend) async {
    try {
      final response =
          await networkServices.post(ApiEndPoint.createStore, bodyTosend);
      return response;
    } catch (error) {
      throw Exception('$error');
    }
  }

  Future signIn(Map<String, dynamic> bodyTosend) async {
    try {
      final response =
          await networkServices.post(ApiEndPoint.login, bodyTosend);
      return response;
    } catch (error) {
      throw Exception('$error');
    }
  }
}
