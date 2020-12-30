
import 'package:flutter/material.dart';

class TextStyleBuilder {
  static final TextStyleBuilder _singleton = TextStyleBuilder._internal();




  factory TextStyleBuilder() {
    return _singleton;
  }

  TextStyleBuilder._internal();


  static TextStyle getTextStyle({Color color,String fontFamily,double fontSize}){
    return TextStyle(color: color,fontFamily: fontFamily, fontSize: fontSize);
  }

}
