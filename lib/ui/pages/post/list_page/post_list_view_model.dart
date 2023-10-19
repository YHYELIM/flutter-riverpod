//로그인은 전역적으로 관리할 데이터-> 프로바이더
//화면에서 필요한 데이터 = 화면과 1:1 매칭 -> 뷰모델

import 'package:flutter/material.dart';
import 'package:flutter_blog/data/dto/post_request.dart';
import 'package:flutter_blog/data/dto/response_dto.dart';
import 'package:flutter_blog/data/model/post.dart';
import 'package:flutter_blog/data/provider/session_provider.dart';
import 'package:flutter_blog/data/repository/post_repository.dart';
import 'package:flutter_blog/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostListModel {
  List<Post> posts;
  PostListModel(this.posts);
}
//2. 창고

class PostListViewModel extends StateNotifier<PostListModel?> {
  //제일 첨에는 null이 옴
  //뷰모델은 무조건 extends
  PostListViewModel(super._state, this.ref); //PostListModel의 상태

  final mContext = navigatorKey.currentContext;

  Ref ref;

  Future<void> notifyInit() async {
    //컨벤션 : 프로바이더가 아닌 화면 변경 노티파이어 함수에는 노티파이 붙여줌
    // 야 나 화면 바꼈어 라고 알려줌

    //jwt 가져오기
    SessionUser sessionUser = ref.read(sessionProvider);

    //통신 코드 필요
    //응답을 디티오로 받음

    ResponseDTO responseDTO =
        await PostRepository().fetchPostList(sessionUser.jwt!);
    state = PostListModel(responseDTO.data);
  }

  //글쓰기
  Future<void> notifyAdd(PostSaveReqDTO dto) async {
    SessionUser sessionUser = ref.read(sessionProvider);

    ResponseDTO responseDTO =
        await PostRepository().savePost(sessionUser.jwt!, dto);

    if (responseDTO.code == 1) {
      Post newPost = responseDTO.data as Post; // 1. dynamic(Post) -> 다운캐스팅
      List<Post> newPosts = [
        newPost,
        ...state!.posts
      ]; // 2. 기존 상태에 데이터 추가 [전개연산자]
      state = PostListModel(
          newPosts); // 3. 뷰모델(창고) 데이터 갱신이 완료 -> watch 구독자는 rebuild됨.
      Navigator.pop(mContext!); // 4. 글쓰기 화면 pop
    } else {
      ScaffoldMessenger.of(mContext!).showSnackBar(
          SnackBar(content: Text("게시물 작성 실패 : ${responseDTO.msg}")));
    }
  }
  //
}

//3. 창고 관리자
//뷰가 빌드되기 직전에 생성되어 (ref.watch)
final postListProvider =
    StateNotifierProvider.autoDispose<PostListViewModel, PostListModel?>((ref) {
  return PostListViewModel(null, ref)..notifyInit();
});
