import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../app_constants.dart';
import '../../AppLocalizations.dart';
import '../../app_utils.dart';
import 'loginTextFieldWidgets.dart';

Widget titleScreen(String title1, String title2,
    String title3, String title4, String title5, bool _isArabic) {
  return
    Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        margin:
        EdgeInsets.only(bottom: 8),
        child:
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: TITLE_FONT_SIZE,
              color: BLACK,
            ),
            children: <TextSpan>[
              TextSpan(
                  text: "$title1",
                  style:
                  TextStyle(
                      fontFamily: AR_VODAFONE_MID, fontSize: TITLE_FONT_SIZE)),
              TextSpan(
                  text: " $title2 ",
                  style: TextStyle(
                      fontFamily: _isArabic ? AR_VODAFONE_BOLD : ExBd,
                      fontSize: TITLE_FONT_SIZE)),
              TextSpan(
                  text: title3,
                  style:
                  TextStyle(
                      fontFamily: AR_VODAFONE_MID, fontSize: TITLE_FONT_SIZE)),
              TextSpan(
                  text: " $title4 ",
                  style:
                  TextStyle(
                      fontFamily: ExBd, fontSize: TITLE_FONT_SIZE)),
              TextSpan(
                  text: title5,
                  style:
                  TextStyle(
                      fontFamily: AR_VODAFONE_MID, fontSize: TITLE_FONT_SIZE)),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ),
    )
  ;
}

Widget textFieldLayoutNumber(
    BuildContext context,
    FocusNode currentFocusNode,
    FocusNode nextFocusNode,
    TextInputAction action,
    String detail, TextEditingController text,
    bool validate, TextInputType textInputType, dynamic length,
    bool isEmpty()) {
  return Container(
    child: Directionality(
      textDirection: TextDirection.rtl,
      child: TextField(
        cursorColor: VODA_RED,
        textInputAction: action,
        focusNode: currentFocusNode,
        onSubmitted: (term) => nextFocusNode != null ? {
          fieldFocusChange(context, currentFocusNode, nextFocusNode)
        }: null,
        controller: text,
        keyboardType: textInputType,
        onChanged: (val) {
          isEmpty();
        },
        maxLength: length,
        decoration: InputDecoration(
          labelText: detail,
          labelStyle: buildLabelTextStylevf(),
          enabledBorder:  buildUnderLineBorder(LITE_BLUE),
          errorText: validate
              ? AppLocalizations.of(context).translate(This_field_cannot_be_empty)
//              : text.text.trim().length < length && text.text.trim().length > 0
//                  ? 'Enter valid number'
              : null,
        ),
      ),
    ),
  );
}


Widget buttonSubmit(String buttonName,
    bool _isButtonDisabled, bool _isLoading, onCustomButtonPressed()) {
  return  RaisedButton(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(
          BUTTON_BORDER_RADIUS),
    ),
    child: _isLoading
        ? CircularProgressIndicator(
      backgroundColor: VODA_WHITE,
    )
        : FittedBox(
      fit: BoxFit.fitWidth,
      child: Text(
        buttonName,
        textDirection: TextDirection.rtl,
        style: TextStyle(
            fontSize: BUTTON_FONT_SIZE,
            color: VODA_WHITE,
            fontFamily:
            AR_VODAFONE_MID
        ),
      ),
    ),
    onPressed: !_isButtonDisabled ? null : onCustomButtonPressed,
    color: VODA_RED,
  );
}

Widget button(String buttonName,  onCustomButtonPressed(), {bool isButtonDisabled}) {
  return  RaisedButton(
    child: FittedBox(
      fit: BoxFit.fitWidth,
      child: Text(
        buttonName,
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: BUTTON_FONT_SIZE,
            color: VODA_WHITE,
            fontFamily:
            AR_VODAFONE_MID),
      ),
    ),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(
        BUTTON_BORDER_RADIUS),
  ),
    onPressed: null == isButtonDisabled || true == isButtonDisabled ? onCustomButtonPressed : null,
    color: VODA_RED,
  );
}

Widget buttonSkip(String buttonName, bool _isLoading, onCustomButtonPressed(),
    {bool isButtonDisabled}) {
  return RaisedButton(
    child: _isLoading
        ? CircularProgressIndicator(
      backgroundColor: VODA_WHITE,
    ) : FittedBox(
      fit: BoxFit.fitWidth,
      child: Text(
        buttonName,
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: BUTTON_FONT_SIZE,
            color: VODA_WHITE,
            fontFamily:
            AR_VODAFONE_MID),
      ),
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(
          BUTTON_BORDER_RADIUS),
    ),
    onPressed: null == isButtonDisabled || true == isButtonDisabled
        ? onCustomButtonPressed
        : null,
    color: VODA_RED,
  );
}
Widget twoButton(Widget widget1, Widget widget2) {
  return Container(
    margin: EdgeInsets.fromLTRB(2.0, 5.0, 2.0, 0.0),
    child: Row(
      textDirection: TextDirection.rtl,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[widget1, widget2],
    ),
  );
}

Widget dropDown(String dropdownValue, _onChange, List<String> items,
    String title, BuildContext context) {
  return Directionality(
    textDirection: TextDirection.rtl,
    child: Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width *
          BUTTON_WIDTH_PERCENTAGE,
      decoration: BoxDecoration(border: Border.all(color: Colors.yellow)),
      child: FittedBox(
        child: DropdownButton<String>(
          value: dropdownValue,
          icon: Icon(
            Icons.keyboard_arrow_down,
            textDirection: TextDirection.rtl,
          ),
          underline: Container(),
          hint: Text(title, style: TextStyle(fontSize: ICON_FONT_SIZE, fontFamily: AR_VODAFONE_LIGHT),),
          style: TextStyle(color: BLACK, fontFamily: AR_VODAFONE_LIGHT, fontSize: ICON_FONT_SIZE),
          onChanged: _onChange,
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(

              value: value,
              child: Align(alignment:Alignment.center,child: Text(value)),
            );
          }).toList(),
        ),
      ),
    ),
  );
}

Widget twoDropDwon(Widget widget1, Widget widget2) {
  return Container(
    margin: EdgeInsets.fromLTRB(0, 10.0, 0, 20.0),
    child: Row(
      textDirection: TextDirection.rtl,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        widget1,
        widget2,
      ],
    ),
  );
}

Widget locationSuccess(BuildContext context,) {
  return Directionality(
    textDirection: TextDirection.rtl,
    child: Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      height: GENERAL_BUTTON_HEIGHT,
      width:
      MediaQuery
          .of(context)
          .size
          .width * XLARGE_BUTTON_WIDTH_PERCENTAGE,
      child: RaisedButton(
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Center(
                child: FittedBox(
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: BUTTON_FONT_SIZE,
                        color: BLACK,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                            text: AppLocalizations.of(context).translate(Your_location_is_saved_successfully),
                            style: TextStyle(
                                fontFamily: AR_VODAFONE_BOLD,
                                fontSize: BUTTON_FONT_SIZE))
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Image.asset(CORRECT),
            )
          ],
        ),
        color: VODA_WHITE,
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.green),
            borderRadius: BorderRadius.circular(BUTTON_BORDER_RADIUS)),
        onPressed: () {},
      ),
    ),
  );
}

Widget location(BuildContext context, void _getCurrentLocation()) {
  return Directionality(
    textDirection: TextDirection.rtl,
    child: Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      height: GENERAL_BUTTON_HEIGHT,
      width:
      MediaQuery
          .of(context)
          .size
          .width * XLARGE_BUTTON_WIDTH_PERCENTAGE,
      child: RaisedButton(
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Center(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: BUTTON_FONT_SIZE,
                      color: BLACK,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text:AppLocalizations.of(context).translate(Select_your_location) ,
                          style: TextStyle(
                              fontFamily: AR_VODAFONE_BOLD,
                              fontSize: BUTTON_FONT_SIZE))
                    ],
                  ),
                ),
              ),
            ),
            VerticalDivider(
              thickness: 2,
              color: Colors.yellow,
            ),
            Icon(
              Icons.location_on,
              color: VODA_RED,
              size: 30,
            ),
          ],
        ),
        color: VODA_WHITE,
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.yellow),
            borderRadius: BorderRadius.circular(BUTTON_BORDER_RADIUS)),
        onPressed: _getCurrentLocation,
      ),
    ),
  );
}


void dismissFoucs(BuildContext context) {
  FocusScope.of(context).requestFocus(FocusNode());
}

Widget textFieldName(BuildContext context,
    FocusNode currentFocusNode,
    FocusNode nextFocusNode,
    TextInputAction action,
    String detail,
    TextEditingController text,
    bool validate,
    TextInputType textInputType,
    bool isEmpty(),
    var userFont) {
  return Container(
    child: Directionality(
      textDirection: TextDirection.rtl,
      child: TextField(
        cursorColor: VODA_RED,
        textInputAction: action,
        focusNode: currentFocusNode,
        style: TextStyle(color: BLACK, fontFamily: userFont),
        onSubmitted: (term) =>
        nextFocusNode != null
            ? {fieldFocusChange(context, currentFocusNode, nextFocusNode)}
            : null,
        controller: text,
        keyboardType: textInputType,
        onChanged: (val) {
          isEmpty();
          isArabicString(text.value.text)
              ? userFont = AR_VODAFONE_LIGHT
              : userFont = REGULAR_FONT;
        },
        decoration: InputDecoration(
          labelText: detail,
          labelStyle: buildLabelTextStylevf(),
          enabledBorder: buildUnderLineBorder(LITE_BLUE),
          errorText: validate ? AppLocalizations.of(context).translate(This_field_cannot_be_empty) : null,
        ),
      ),
    ),
  );
}


