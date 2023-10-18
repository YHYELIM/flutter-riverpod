import 'package:flutter/material.dart';

const double smallGap = 5.0;
const double mediumGap = 10.0;
const double largeGap = 20.0;
const double xlargeGap = 100.0;

double getScreenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}
//휴대폰의 높이는 안중요함 어차피 리스트뷰 해야하니까
//넓이는 매번 쓰지말고 미디어쿼리를 이용

double getDrawerWidth(BuildContext context) {
  return getScreenWidth(context) * 0.6;
}
//화면을 비율로 잡음
//원래는 안변하는 상수값들도 다
