import 'package:intl/intl.dart';

class User {
  int id;
  String username;
  String email;
  DateTime created; //회원가입 날짜
  DateTime updated; //회원 수정 날짜

  User(
      {required this.id,
      required this.username,
      required this.email,
      required this.created,
      required this.updated});

  // 1. Dart 객체를 통신을 위한 Map 형태로 변환합니다.
  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
        "created": created,
        "updated": updated
      };

  User.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        username = json["username"],
        email = json["email"],
        created = DateFormat("yyyy-mm-dd").parse(json["created"]),
        updated = DateFormat("yyyy-mm-dd").parse(json["updated"]);
}
