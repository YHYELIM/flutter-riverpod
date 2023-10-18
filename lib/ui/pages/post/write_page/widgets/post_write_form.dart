import 'package:flutter/material.dart';
import 'package:flutter_blog/_core/constants/size.dart';
import 'package:flutter_blog/_core/utils/validator_util.dart';
import 'package:flutter_blog/data/dto/post_request.dart';
import 'package:flutter_blog/ui/pages/post/list_page/post_list_view_model.dart';
import 'package:flutter_blog/ui/widgets/custom_elavated_button.dart';
import 'package:flutter_blog/ui/widgets/custom_text_area.dart';
import 'package:flutter_blog/ui/widgets/custom_text_form_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

class PostWriteForm extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _content = TextEditingController();

  PostWriteForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          CustomTextFormField(
            controller: _title,
            hint: "Title",
            funValidator: validateTitle(),
          ),
          const SizedBox(height: smallGap),
          CustomTextArea(
            controller: _content,
            hint: "Content",
            funValidator: validateContent(),
          ),
          const SizedBox(height: largeGap),
          CustomElevatedButton(
            text: "글쓰기",
            funPageRoute: () async {
              if (_formKey.currentState!.validate()) {
                //프로바이더에 접근해서 포스트 리스트 뷰 창고의 데이터 상태 바꿔야함
                //글쓰기를 함으로써 리스트 뷰 모델을 바꾸고 싶기때문에 글쓰기의 뷰모델은 필요없음
                Logger().d("title : ${_title.text}");
                Logger().d("title : ${_content.text}");
                PostSaveReqDTO dto =
                    PostSaveReqDTO(title: _title.text, content: _content.text);
                //컨텐트가 서버측에 값이 안들어오면? 컨트롤러 문제다

                ref.read(postListProvider.notifier).notifyAdd(dto);
                //구독할 필요없이 노티파이어만 하면 됨
                //팝을 하면 노티파이 이닛 실행안됨 = 뒤로가기 하면 요청안하고 그냥 뒤로 가기만함
                //노티파이 이닛 실행 = 다시 히스토리 남아있는 페이지를 다시 불러옴
                //근데 상태값을 추가하면 팝해도 히스토리 남아있는 페이지를 불러오기가 가능
                //상태가 변경됐으니까 갱신됨/
              }
            },
          ),
        ],
      ),
    );
  }
}
