import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

//http 통신
final dio = Dio(
  BaseOptions(
    baseUrl: "http://192.168.0.49:8080", // 내 IP 입력
    contentType: "application/json; charset=utf-8",
  ),
);

//휴대폰 로컬에 파일로 저장
const secureStorage = FlutterSecureStorage();
//jwt을 여기에 저장
//자동 로그인 가능
