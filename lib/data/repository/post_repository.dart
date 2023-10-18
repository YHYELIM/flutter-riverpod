//view -> provider->repository(MVVM패턴)
//1. 전역 프로바이더 2. 뷰모델
import 'package:dio/dio.dart';
import 'package:flutter_blog/_core/constants/http.dart';
import 'package:flutter_blog/data/dto/post_request.dart';
import 'package:flutter_blog/data/dto/response_dto.dart';
import 'package:flutter_blog/data/dto/user_request.dart';
import 'package:flutter_blog/data/model/post.dart';
import 'package:flutter_blog/data/model/user.dart';

//여기서는 통신과 파싱만 할것임
//여긴 비즈니스 로직과 관련 없다 성공 실패 여부는 프로바이더에서 함
class PostRepository {
  Future<ResponseDTO> fetchPostList(String jwt) async {
    try {
      //1. 통신
      final response = await dio.get("/post",
          options: Options(headers: {"Authorization": "${jwt}"}));
      //내가 달라는거니까 바디데이터 필요없음
      //토큰은 세션프로바이더가 들고있음 프로바이더에 접근하려면 ref 필요
      //여기서 ref적지말고! 전달 받음

      //2. ResponseDTO 파싱
      ResponseDTO responseDTO = ResponseDTO.fromJson(response.data);

      //3. ResponseDTO의 data 파싱
      List<dynamic> mapList = responseDTO.data as List<dynamic>;
      //리스펀스 디티오 들고 있는 거 : 리스트
      List<Post> postList = mapList.map((e) => Post.fromJson(e)).toList();

      //4. 파싱된 데이터를 다시 공통 DTO로 덮어씌우기
      responseDTO.data = postList;

      return responseDTO;
    } catch (e) {
      return ResponseDTO(-1, "게시글 목록 불러오기 실패", null);

      //디오는 200번대 안떨어지면 catch로 간다
      //통신은 무조건 try,catch 걸어준다
    }
    //정상일때는 1, 오류일때는 -1
    //통신해서 파싱하고 응답을  responseDTO
  }

  Future<ResponseDTO> fetchLogin(LoginReqDTO requestDTO) async {
    //파싱을 해서 다시 리스펀스 디티오로 담음
    try {
      final response = await dio.post("/login",
          data: requestDTO.toJson()); //join주소 , 포스트 요청이라서 바디 필요
      // print(response.data); //리스펀스의 바디 데이터 찍어봄

      //파싱
      ResponseDTO responseDTO = ResponseDTO.fromJson(response.data);
      //리스펀스디티오 파싱
      // 유저로 응답됨 , 유저타입으로 바뀜저
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
      return ResponseDTO(-1, "유저네임 혹은 비번틀림", null);
    }
  }

  Future<ResponseDTO> fetchPost(String jwt, PostSaveReqDTO dto) async {
    try {
      // 1. 통신
      final response = await dio.post("/post",
          data: dto.toJson(),
          options: Options(headers: {"Authorization": "${jwt}"}));

      // 2. ResponseDTO 파싱
      ResponseDTO responseDTO = ResponseDTO.fromJson(response.data);

      // 3. ResponseDTO의 data 파싱
      Post post = Post.fromJson(responseDTO.data);

      // 4. 파싱된 데이터를 다시 공통 DTO로 덮어씌우기
      responseDTO.data = post;

      return responseDTO;
    } catch (e) {
      return ResponseDTO(-1, "게시글 작성 실패", null);
    }
  }
}
