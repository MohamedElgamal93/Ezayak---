import 'package:flutter/material.dart';
import 'package:ezayak/app_constants.dart';
import 'package:ezayak/src/app_utils.dart';
import 'package:ezayak/src/ui/login.dart';

import '../../AppLocalizations.dart';

enum LoginDecorationType { LoginUserNameTextFiled, PasswordTextFiled }

TextField buildLoginTextFiled(BuildContext context, LoginState state) {
  return TextField(
    textDirection: TextDirection.ltr,
    cursorColor: VODA_RED,
    textInputAction: TextInputAction.next,
    focusNode: state.userNameFocus,
    onSubmitted: (term) {
      fieldFocusChange(context, state.userNameFocus, state.passwordFocus);
    },
    style: buildTextStyle(),
    controller: state.userNameController,
    decoration: buildTextFiledDecoration(
        context, state, LoginDecorationType.LoginUserNameTextFiled),
  );
}

TextField buildPasswordLoginTextFiled(BuildContext context, LoginState state) {
  return TextField(
    textDirection: TextDirection.ltr,
    textInputAction: TextInputAction.done,
    focusNode: state.passwordFocus,
    onSubmitted: (term) {
      state.presenter.handleLoginButton();
    },
    style: buildTextStyle(),
    obscureText: state.obscureText,
    controller: state.passwordController,
    decoration: buildTextFiledDecoration(
        context, state, LoginDecorationType.PasswordTextFiled),
  );
}

TextStyle buildTextStyle() =>
    TextStyle(color: BLACK, fontFamily: REGULAR_FONT);

UnderlineInputBorder buildUnderLineBorder(Color color) {
  return UnderlineInputBorder(
      borderSide: BorderSide(
        color: color,
      ));
}

TextStyle buildLabelTextStyle() {
  return TextStyle(
      fontFamily: ExBd, fontSize: LABEL_FONT_SIZE, color: BLACK);
}
TextStyle buildLabelTextStylevf() {
  return TextStyle(
      fontFamily: AR_VODAFONE_MID, fontSize: LABEL_FONT_SIZE, color: BLACK);
}

InputDecoration buildTextFiledDecoration(BuildContext context, LoginState state,
    LoginDecorationType type) {
  switch (type) {
    case LoginDecorationType.LoginUserNameTextFiled:
      return InputDecoration(
          labelText:
              AppLocalizations.of(context).translate(Username) ,
          labelStyle: buildLabelTextStyle(),
          enabledBorder: buildUnderLineBorder(LITE_BLUE));
      break;
    case LoginDecorationType.PasswordTextFiled:
      return InputDecoration(
          labelStyle: buildLabelTextStyle(),
          labelText: AppLocalizations.of(context).translate(Password),
          enabledBorder: buildUnderLineBorder(LITE_BLUE));
      break;
    default:
      return InputDecoration(
          labelStyle: buildLabelTextStyle(),
          labelText: AppLocalizations.of(context).translate(Password),
          enabledBorder: buildUnderLineBorder(LITE_BLUE));
  }
}
