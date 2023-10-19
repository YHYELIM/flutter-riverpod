import 'package:flutter/material.dart';
import 'package:flutter_blog/data/model/post.dart';
import 'package:flutter_blog/data/provider/param_store.dart';
import 'package:flutter_blog/ui/pages/post/detail_page/post_detail_page.dart';
import 'package:flutter_blog/ui/pages/post/list_page/post_list_view_model.dart';
import 'package:flutter_blog/ui/pages/post/list_page/wiegets/post_list_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostListBody extends ConsumerWidget {
  const PostListBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    PostListModel? model = ref.watch(postListProvider); //state ==null

    List<Post> posts = [];

    if (model != null) {
      posts = model.posts;
    }
    //널일때는 빈배열

    return ListView.separated(
      //리스트뷰에 줄그어줌
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return InkWell(
          //1. postId를 paramStore에 저장

          onTap: () {
//Detail 창고 관리자에게 post id 전달
            //싱글톤이라서 딱하나만 뜬다
            //객체 생성시점이 목록 보기
            ParamStore paramStore = ref.read(paramProvider); //파람스토어 사용
            paramStore.postDetailId = posts[index].id; //아이디 바뀜

            //창고에 게시글 넣어놓음 -> 포스트 디테일 프로바이더에 접근
            //init 메소드를 여기서 때려버리면 됨
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => PostDetailPage()));
            //
          },

          child: PostListItem(posts[index]),
        );
      },
      separatorBuilder: (context, index) {
        return const Divider();
        //구분선 : 리스트뷰 세퍼레이트 쓰면 안됨? 됨 컬럼으로 넣으면 되지
      },
    );
  }
}
