class PostSaveReqDTO {
  final String title;
  //파이널 : 변경할 일이 없으니까 변경 안할 값들은 파이널 붙여 놓음
  final String content;
  PostSaveReqDTO({required this.title, required this.content});
  Map<String, dynamic> toJson() => {"title": title, "content": content};
}

class PostUpdateReqDTO {
  final String title;
  final String content;

  PostUpdateReqDTO({required this.title, required this.content});

  Map<String, dynamic> toJson() => {"title": title, "content": content};
}
//보내는 거니까  toJson만 있으면 됨
