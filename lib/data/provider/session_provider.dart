//1. 창고 데이터
import 'package:flutter/material.dart';
import 'package:flutter_blog/_core/constants/http.dart';
import 'package:flutter_blog/_core/constants/move.dart';
import 'package:flutter_blog/data/dto/response_dto.dart';
import 'package:flutter_blog/data/dto/user_request.dart';
import 'package:flutter_blog/data/model/user.dart';
import 'package:flutter_blog/data/repository/user_repository.dart';
import 'package:flutter_blog/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

class SessionUser {
  //1. 화면 컨텍스트에 접근하는 법 -> 로그인 후 메인페이지로 이동하려면 컨텍스트 필요
  //아까 컨텍스트 투두 근거로 적을수있음
  final mContext = navigatorKey.currentContext;
  User? user; //로그인 안하면 널
  String? jwt; //로그인 안하면 널, 토큰 시간 만료돼도 널
  bool isLogin; //최초값 false 해주는게 좋음
  SessionUser({this.user, this.jwt, this.isLogin = false});
  //비즈니스 로직상 으로 널이 될수없는 애들은 널값 허용 하면 안됨

  Future<void> join(JoinReqDTO requestDTO) async {
    Logger().d("join");
    ResponseDTO responseDTO = await UserRepository().fetchJoin(requestDTO);

    //2. 비지니스 로직
    if (responseDTO.code == 1) {
      Navigator.pushNamed(mContext!, Move.loginPage);
    } else {
      ScaffoldMessenger.of(mContext!)
          .showSnackBar(SnackBar(content: Text(responseDTO.msg)));
    }
  }

  Future<void> login(LoginReqDTO loginReqDTO) async {
    //에이싱크 붙으면 무조건 퓨처 보이드 리턴 하고 싶은것만 보이드 자리에 넣음
    //1. 통신 코드
    ResponseDTO responseDTO = await UserRepository().fetchLogin(loginReqDTO);

    //2. 비지니스 로직
    if (responseDTO.code == 1) {
      //로그인 성공
      //1.세션값 갱신
      this.user = responseDTO.data as User; // 다운 캐스팅
      this.jwt = responseDTO.token;
      this.isLogin = true;

      //2. 디바이스에 jwt 저장(자동 로그인)
      //TODO : 테스트 할때 항상 자동 로그인 해주는게 편함
      await secureStorage.write(key: "jwt", value: responseDTO.token);
      //await 안붙이면 토큰 저장 못하고 아래로 내려감

      Navigator.pushNamed(mContext!, Move.postListPage); //메이페이지
    } else {
      ScaffoldMessenger.of(mContext!)
          .showSnackBar(SnackBar(content: Text(responseDTO.msg)));
    }
  }

  Future<void> logout() async {
    this.jwt = null;
    //토큰 없애버림
    this.isLogin = false;
    this.user = null;

    await secureStorage.delete(key: "jwt");
    //awit 이유: io 발생하니까 이거 안기다려주면 자동 로그인 됨

    Navigator.pushNamedAndRemoveUntil(mContext!, "/login", (route) => false);
    //제일 마지막에 처리 돼야함
    //화면에 접근하는 mContext 들고옴
  }
}

//2. 창고
//뷰모델이 아니라서 창고 필요없다
//stateNotifierProvider 아니니까
//로그인을 했을때 페이지를 리빌드 할거 아니니까

//3. 창고관리자
//세션 유저를 관리하는 프로바이더
final sessionProvider = Provider<SessionUser>((ref) {
  return SessionUser();
});
