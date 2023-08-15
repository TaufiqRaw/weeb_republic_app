import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthService {
  final dio = Dio();
  User? user;
  /// private constructor
  AuthService._();
  /// the one and only instance of this singleton
  static final instance = AuthService._();

  login({required String refreshToken, required String accessToken}){
    Map<String, dynamic> decoded = JwtDecoder.decode(accessToken);
    user = User(id: decoded['sub'], username: decoded['username'], accessToken: accessToken, refreshToken: refreshToken);
  }

  logout(){
    user = null;
  }

  refresh() async{
    try{
      Response res = await dio.post(
          Uri.http(dotenv.env['BACKEND_URL']!, 'auth/refresh').toString(),
          data: jsonEncode({
            'refreshToken' : user?.refreshToken
          }), options: Options(
          contentType: Headers.jsonContentType
      ));
      login(refreshToken: res.data['rt'], accessToken: res.data['at']);
    } catch (err){
      print(err);
      user = null;
    }
  }
}

class User{
  int id;
  String username;
  String accessToken = "";
  String refreshToken = "";
  User({required this.id,required this.username, this.accessToken = "", this.refreshToken=""});
}