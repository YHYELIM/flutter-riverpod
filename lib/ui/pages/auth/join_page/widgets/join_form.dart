import 'package:flutter/material.dart';
import 'package:flutter_blog/_core/constants/size.dart';
import 'package:flutter_blog/_core/utils/validator_util.dart';
import 'package:flutter_blog/data/dto/user_request.dart';
import 'package:flutter_blog/ui/widgets/custom_auth_text_form_field.dart';
import 'package:flutter_blog/ui/widgets/custom_elavated_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import '../../../../../data/provider/session_provider.dart';

class JoinForm extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  JoinForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomAuthTextFormField(
            text: "Username",
            obscureText: false, //-> 패스워드 아님
            funValidator: validateUsername(),
            controller: _username,
          ),
          const SizedBox(height: mediumGap),
          CustomAuthTextFormField(
            text: "Email",
            obscureText: false, //-> 패스워드 아님
            funValidator: validateEmail(),
            controller: _email,
          ),
          const SizedBox(height: mediumGap),
          CustomAuthTextFormField(
            text: "Password",
            obscureText: true, //-> 패스워드 맞음
            funValidator: validatePassword(),
            controller: _password,
          ),
          const SizedBox(height: largeGap),
          CustomElevatedButton(
              text: "회원가입",
              funPageRoute: () {
                //이 버튼은 폼태그 안에 있음
                //밸리데이션 체크하고 넘어가야함
                if (_formKey.currentState!.validate()) {
                  JoinReqDTO joinReqDTO = JoinReqDTO(
                      username: _username.text,
                      password: _password.text,
                      email: _email.text);
                  ref.read(sessionProvider).join(joinReqDTO);
                  Logger().d("회원가입 성공");
                  // Navigator.popAndPushNamed(context, Move.postListPage);
                }
              }),
        ],
      ),
    );
  }
}
