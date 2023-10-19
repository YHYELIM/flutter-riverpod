//1. 창고 데이터
import 'package:flutter_blog/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RequestParam {
  int? postDetailId;
  // int? commentId;

  RequestParam({this.postDetailId});
}

//2. 창고
//창고에는 비지니스 로직이 들어간다
// class ParamStore extends RequestParam {
//   final mContext = navigatorKey.currentContext;
//   void addPostDetailId(int postId) {
//     this.postDetailId = postId;
//     //자기 자신이라서 this라고 해됨, super도 상관 없음
//     //메소드 굳이 안만들어됨
//   }
// }
class ParamStore extends RequestParam {
  final mContext = navigatorKey.currentContext;
}

//3. 창고 관리자
final paramProvider = Provider<ParamStore>((ref) {
  return ParamStore();
});
