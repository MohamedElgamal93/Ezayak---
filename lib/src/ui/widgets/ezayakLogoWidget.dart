import 'package:ezayak/app_constants.dart';
import 'package:flutter/widgets.dart';

class EzayakLogo extends StatelessWidget {

  final double height;
  final double width;

  EzayakLogo({this.height,this.width});
  @override
  Widget build(BuildContext context) {
    return  Image.asset(
      EZYEAK_LOGO,
      fit: BoxFit.cover,
      height: height,
      width: height,
    );
  }
}
