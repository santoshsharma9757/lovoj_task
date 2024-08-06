import 'package:lovoj_task/data/services/network_services.dart';

class AuthenticationRepo {
  NetworkServices networkServices = NetworkServices();

  Future getOtp(Map<String, dynamic> bodyTosend) async {
    try {
      final response = await networkServices.post(
          "https://b2b.lovoj.com/api/v1/auth/checkemail", bodyTosend);
      return response;
    } catch (error) {
      throw Exception('$error');
    }
  }

  Future signUp(Map<String, dynamic> bodyTosend) async {
    try {
      final response = await networkServices.post(
          "https://b2b.lovoj.com/api/v1/auth/createStore", bodyTosend);
      return response;
    } catch (error) {
      throw Exception('$error');
    }
  }

  Future signIn(Map<String, dynamic> bodyTosend) async {
    try {
      final response = await networkServices.post(
          "https://b2b.lovoj.com/api/v1/auth/login", bodyTosend);
      return response;
    } catch (error) {
      throw Exception('$error');
    }
  }


}
