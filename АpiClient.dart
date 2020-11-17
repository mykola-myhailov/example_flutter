
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const checkMobile = "user/check-mobile?";

Future getRequest(String url, String path) async {

  final String baseUrl = "some url";
  final response = await http.get(baseUrl + url + path);
  dynamic result;
  if (response.statusCode == 200 ) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    BaseResponse baseResponse = BaseResponse.fromJson(json.decode(response.body));
    return  baseResponse.result;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed');
  }
}

Map<String, dynamic> processing (){}


class BaseResponse{
  final int code;
  final Map<String, dynamic> result;
  final String errorCode;

  BaseResponse(this.code, this.result, this.errorCode);

  BaseResponse.fromJson(Map<String, dynamic> json):
        code = json['code'],
        result = json['result'],
        errorCode = json['errorCode'];

  Map<String, dynamic> toJson() =>
      {
        'code': code,
        'result': result,
        'errorCode': errorCode
      };
}

class BaseListResponse{
  final int code;
  final List<dynamic> result;
  final String errorCode;

  BaseListResponse(this.code, this.result, this.errorCode);

  BaseListResponse.fromJson(Map<String, dynamic> json):
        code = json['code'],
        result = json['result'],
        errorCode = json['errorCode'];

  Map<String, dynamic> toJson() =>
      {
        'code': code,
        'result': result,
        'errorCode': errorCode
      };
}


