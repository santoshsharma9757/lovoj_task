import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:lovoj_task/data/services/app_exception.dart';

class NetworkServices {
  Future get(String url) async {
    dynamic responseJson;
    try {
      final response =
          await http.get(Uri.parse(url)).timeout(const Duration(seconds: 30));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  Future post(String url, var data) async {
    log("dataToSend DATA $data");
    dynamic responseJson;
    try {
      final response = await http.post(Uri.parse(url),
          body: jsonEncode(data),
          headers: {"Content-Type": "application/json"});
      log("dataToSend DATAsss ${response.body}");
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 400:
      case 401:
        dynamic responseJson = jsonDecode(response.body);
        throw BadRequestException(responseJson['message'].toString());
      case 404:
        throw BadRequestException("Page not found".toString());
      case 500:
        throw InvalidInputException("Internal Server Error".toString());
      default:
        throw FetchDataException(
            'Error accured while communicating with server' +
                'with status code' +
                response.statusCode.toString());
    }
  }
}
