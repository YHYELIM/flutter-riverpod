//상태를 가지고 있는 뷰모델

import 'package:flutter_blog/data/dto/response_dto.dart';
import 'package:flutter_blog/data/provider/param_store.dart';
import 'package:flutter_blog/data/provider/session_provider.dart';
import 'package:flutter_blog/data/repository/post_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import '../../../../data/model/post.dart';

// 창고 데이터
class PostDetailModel {
  Post post;
  PostDetailModel(this.post);
}

// 창고
class PostDetailViewModel extends StateNotifier<PostDetailModel?> {
  PostDetailViewModel(super._state, this.ref);
  Ref ref;

  Future<void> notifyInit(int id) async {
    Logger().d("notifyInit");

    SessionUser sessionUser = ref.read(sessionProvider);
    ResponseDTO responseDTO =
        await PostRepository().fetchPost(sessionUser.jwt!, id);

    state = PostDetailModel(responseDTO.data);
  }
}

// 창고 관리자
final postDetailProvider =
    StateNotifierProvider.autoDispose<PostDetailViewModel, PostDetailModel?>(
        (ref) {
  Logger().d("나실행됨? postDetailProvider");
  int postId = ref.read(paramProvider).postDetailId!;
  return PostDetailViewModel(null, ref)..notifyInit(postId);
});
