import 'package:ezayak/app_constants.dart';
import 'package:flutter/cupertino.dart';

class BaseBackGround extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      VODAFONE_SPLASH,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      fit: BoxFit.cover,
    );
  }
}
