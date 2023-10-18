//view -> provider->repository(MVVM패턴)
//1. 전역 프로바이더 2. 뷰모델
import 'package:flutter_blog/_core/constants/http.dart';
import 'package:flutter_blog/data/dto/response_dto.dart';
import 'package:flutter_blog/data/dto/user_request.dart';
import 'package:flutter_blog/data/model/user.dart';

//여기서는 통신과 파싱만 할것임
//여긴 비즈니스 로직과 관련 없다 성공 실패 여부는 프로바이더에서 함
class UserRepository {
  //JoinReqDTO : 회원가입할때 인풋 필드에 받은 데이터 담겨있음
  Future<ResponseDTO> fetchJoin(JoinReqDTO requestDTO) async {
    //파싱을 해서 다시 리스펀스 디티오로 담음
    try {
      final response = await dio.post("/join",
          data: requestDTO.toJson()); //join주소 , 포스트 요청이라서 바디 필요
      //파싱
      ResponseDTO responseDTO = ResponseDTO.fromJson(response.data);
      //리스펀스디티오 파싱
      //유저로 응답됨 , 유저타입으로 바뀜
      // responseDTO.data = User.fromJson(responseDTO.data);
      //회원가입에는 의미 없는 코드
      return responseDTO;
      //유저 오브젝지만 다이나믹 타입임 -> 다운캐스팅 가능
    } catch (e) {
      return ResponseDTO(-1, "중복되는 유저명입니다", null);

      //디오는 200번대 안떨어지면 catch로 간다
      //통신은 무조건 try,catch 걸어준다
    }
    //정상일때는 1, 오류일때는 -1
    //통신해서 파싱하고 응답을  responseDTO
    //다이나믹이 오브젝트 타입에 들어감 타입이 바껴서 들어감
    //맵 타입을 오브젝트에 넣으면 다운캐스팅 불가능
    //맵 -> 유저 객체-> 오브젝트로 넣으면 다운캐스팅 가능
  }

  Future<ResponseDTO> fetchLogin(LoginReqDTO requestDTO) async {
    //파싱을 해서 다시 리스펀스 디티오로 담음
    try {
      final response = await dio.post("/login",
          data: requestDTO.toJson()); //join주소 , 포스트 요청이라서 바디 필요
      print(response.data); //리스펀스의 바디 데이터 찍어봄

      //파싱
      ResponseDTO responseDTO = ResponseDTO.fromJson(response.data);
      //리스펀스디티오 파싱
      //유저로 응답됨 , 유저타입으로 바뀜
      responseDTO.data = User.fromJson(responseDTO.data);

      final jwt = response.headers["Authorization"];

      if (jwt != null) {
        responseDTO.token = jwt.first;
        //0번지 토큰을 꺼냄
        //0번지 토큰 =.first
        //레이어 분리 = 책임 분리
      }
      return responseDTO;
      //응답을 디티오로 해줌
      //모든 비지니스 로직을 세션 프로바이더에서 함
    } catch (e) {
      return ResponseDTO(-1, "중복되는 유저명입니다", null);
    }
  }
}
