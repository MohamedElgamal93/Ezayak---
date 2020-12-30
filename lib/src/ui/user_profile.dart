import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:ezayak/src/data/error_data.dart';
import 'package:ezayak/src/data/user_family/add_member.dart';
import 'package:ezayak/src/ui/ProfilesHomePage.dart';
import 'package:ezayak/src/ui/widgets/baseScreen.dart';
import 'package:ezayak/src/ui/widgets/gender_grid.dart';
import 'package:ezayak/src/ui/widgets/layoutBuilder.dart';
import 'package:ezayak/src/ui/widgets/myTopBar.dart';
import 'package:ezayak/src/ui/widgets/user_family_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app_constants.dart';
import '../AppLocalizations.dart';
import '../app_utils.dart';
import '../presenter/user_family_presenter.dart';
import 'family_profile.dart';
import 'widgets/loginTextFieldWidgets.dart';

class UserProfile extends StatefulWidget {
  final AddMember addUserMember;
  final bool isEditing;
  int locationEditing;
  final int id;
  final String title;

  UserProfile(
      {Key key,
      this.title,
      this.addUserMember,
      this.isEditing,
      this.id,
      this.locationEditing})
      : super(key: key);

  @override
  UserProfileState createState() => UserProfileState();
}

class UserProfileState extends State<UserProfile>
    implements UserFamilyEditContract {
  bool _validateName = false;
  bool _validateAge = false;
  double lat;
  double lng;
  int locationFlag = 0;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _textUserName = TextEditingController();
  TextEditingController _textPhone = TextEditingController();
  TextEditingController _textAge = TextEditingController();
  bool _isButtonEnabled = false;
  List<AddMember> addMemberList = [];
  UserFamilyEditPresenter _presenter;
  bool _isLoading = false;
  String selectedGender;
  final FocusNode userNameFocus = FocusNode();
  final FocusNode phoneFocus = FocusNode();
  final FocusNode ageFocus = FocusNode();
  bool isFirstLogin;
  var userFont;

  UserProfileState() {
    _presenter = new UserFamilyEditPresenter(this);
  }

  String phoneNumber;
  bool _enabled = false;
  final storage = FlutterSecureStorage();

  Future<String> getPhoneNumber() async {
    if (storage != null && storage.read(key: PHONENUMBER) != null) {
      phoneNumber = await storage.read(key: PHONENUMBER);
      setState(() {
        _textPhone.text = phoneNumber;
      });
      return phoneNumber;
    } else {
      return "";
    }
  }

  _getIsFirstLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isFirstLogin = prefs.getBool(FIRST_LOGIN);
    });
  }

  @override
  void initState() {
    _getIsFirstLogin();
    getPhoneNumber();
    if (widget.addUserMember != null) {
      setState(() {
        if (isArabicString(widget.addUserMember.fullName)) {
          userFont = AR_VODAFONE_LIGHT;
        } else {
          userFont = REGULAR_FONT;
        }
        _textUserName.text = widget.addUserMember.fullName;
        _textPhone.text = widget.addUserMember.phoneNumber;
        _textAge.text = widget.addUserMember.age.toString();
        lat = widget.addUserMember.latitude;
        lng = widget.addUserMember.longitude;
        selectedGender = widget.addUserMember.gender;
        locationFlag = 1;
      });
      isEmpty();
    }
    super.initState();
  }

  @override
  void dispose() {
    _textUserName.dispose();
    _textPhone.dispose();
    _textAge.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      scaffoldKey: scaffoldKey,
      topBar: MyTopBar(showBack: true),
      child: _buildPageView(),
      bottomMargin: 16.0,
    );

  }


  _buildPageView() {
    return Container(
        padding: EdgeInsets.all(16),
        width: double.infinity,
        height: double.infinity,
        child: LayoutBuilderGenerator(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          titleScreen(widget.title, '', '', '', '', true),
                          textFieldName(
                              context,
                              userNameFocus,
                              ageFocus,
                              TextInputAction.next,
                              AppLocalizations.of(context).translate(Your_name),
                              _textUserName,
                              _validateName,
                              TextInputType.text,
                              isEmpty,
                              userFont),
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextField(
                              cursorColor: VODA_RED,
                              textInputAction: TextInputAction.next,
                              style: TextStyle(color: BLACK),
                              focusNode: phoneFocus,
                              onSubmitted: (term) {
                                fieldFocusChange(context, phoneFocus, ageFocus);
                              },
                              controller: _textPhone,
                              keyboardType: TextInputType.phone,
                              enabled:
                                  phoneNumber != null ? _enabled : !_enabled,
                              maxLength: 11,
                              decoration: InputDecoration(
                                labelText:AppLocalizations.of(context).translate(Your_Mobile_number), 
                                labelStyle: buildLabelTextStylevf(),
                                enabledBorder: buildUnderLineBorder(LITE_BLUE),
                                errorText: _validateName
                                    ? AppLocalizations.of(context).translate(This_field_cannot_be_empty)
                                    : null,
                              ),
                            ),
                          ),
                          textFieldLayoutNumber(
                              context,
                              ageFocus,
                              null,
                              TextInputAction.done,
                             AppLocalizations.of(context).translate(Your_age) ,
                              _textAge,
                              _validateAge,
                              TextInputType.number,
                              2,
                              isEmpty),
                          GenderGridUser(this),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 8),
                                child: Text(
                                 AppLocalizations.of(context).translate(Your_location) ,
                                  style: buildLabelTextStylevf(),
                                ),
                              ),
                            ),
                          ),
                          if (locationFlag == 0 &&
                                  widget.locationEditing == 0 ||
                              locationFlag == 1 && widget.locationEditing == 0)
                            location(context, _getCurrentLocation),
                          if (locationFlag == 1 && widget.locationEditing == 1)
                            locationSuccess(context),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                                width: MediaQuery.of(context).size.width *
                                    BUTTON_WIDTH_PERCENTAGE,
                                height: GENERAL_BUTTON_HEIGHT,
                                margin: EdgeInsets.symmetric(vertical: 8),
                                child: RaisedButton(
                                  child: _isLoading
                                      ? CircularProgressIndicator(
                                          backgroundColor: VODA_WHITE,
                                        )
                                      : FittedBox(
                                        child: Text(
                                            AppLocalizations.of(context).translate(Proceed) ,
                                            textDirection: TextDirection.rtl,
                                            style: TextStyle(
                                                fontSize: BUTTON_FONT_SIZE,
                                                color: VODA_WHITE,
                                                fontFamily: AR_VODAFONE_MID),
                                          ),
                                      ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        BUTTON_BORDER_RADIUS),
                                  ),
                                  onPressed: !_isButtonEnabled || _isLoading
                                      ? null
                                      : addMember,
                                  color: VODA_RED,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ));
  }


  void addMember() {
    FocusScope.of(context).requestFocus(FocusNode());

    if (!widget.isEditing) {
      Navigator.push(
          context,
          PageRouteBuilder(
              pageBuilder: (_, __, ___) => FamilyProfile(
                    title1: AppLocalizations.of(context).translate(Family_member_added) ,
                    title2: AppLocalizations.of(context).translate(Registration),
                    title3: AppLocalizations.of(context).translate(Family_member),
                    title4: '',
                    title5: '',
                    buttonTitle:AppLocalizations.of(context).translate(Proceed_add_another_family_member),
                    isEditing: false,
                    isAddPlus: false,
                    addMember: AddMember(
                        fullName: _textUserName.text,
                        phoneNumber: _textPhone.text,
                        gender: selectedGender,
                        age: int.parse(_textAge.text),
                        memberType: 1,
                        longitude: lat,
                        latitude: lng),
                  ),
              transitionsBuilder: (_, anim, __, child) =>
                  Container(child: child),
              transitionDuration: Duration(seconds: 1)));
    }
    if (widget.isEditing && widget.addUserMember != null) {
      setState(() {
        _isLoading = true;
      });
      _presenter.loadEditMember(
          AddMember(
              fullName: _textUserName.text,
              phoneNumber: _textPhone.text,
              gender: selectedGender,
              age: int.parse(_textAge.text),
              memberType: 1,
              longitude: lat,
              latitude: lng),
          widget.id);
    }
  }

  void _showError(String error) {
    scaffoldKey.currentState.hideCurrentSnackBar();
    scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(error,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: isArabicString(error) ? AR_VODAFONE_MID : ExBd)),
      ),
    );
  }

  var error = '';
  Future<void> _getCurrentLocation() async {
    try {
      await Location().requestPermission();
      if(Platform.isAndroid){
        final status =  await Permission.location.request();
        if(status.isPermanentlyDenied){
          _showError(AppLocalizations.of(context).translate(Please_allow_Ezayak_to_access_your_location));
          Future.delayed(const Duration(milliseconds: 500), () {
            AppSettings.openAppSettings();
          });

        }

      }
      final locData = await Location().getLocation();
      logD('locData.latitude${locData.latitude}');
      logD('locData.longitude${locData.longitude}');
      setState(() {
        lat = locData.latitude;
        lng = locData.longitude;
        locationFlag = 1;
        if (widget.locationEditing != null) {
          widget.locationEditing = 1;
        }
        isEmpty();
        dismissFoucs(context);
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = AppLocalizations.of(context).translate(Please_allow_the_site_to_access_the_device_settings);
      } else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error =
            'Permission denied - please ask the user to enable it from the app settings';
      }
      if (Platform.isIOS)
        _showError(AppLocalizations.of(context).translate(Please_allow_the_site_to_access_the_device_settings));
    } catch (_) {
      if (Platform.isIOS)
        _showError(AppLocalizations.of(context).translate(Please_allow_the_site_to_access_the_device_settings));

      return;
    }
    // Use location.
  }

  bool isEmpty() {
    setState(() {
      if ((_textUserName.text.trim() != "") &&
          (_textPhone.text.trim() != "") &&
          (_textAge.text.trim() != "") &&
          (_textAge != null) &&
          (_textPhone != null) &&
          (_textUserName != null) &&
          (locationFlag == 1) &&
          selectedGender != null) {
        _isButtonEnabled = true;
      } else {
        _isButtonEnabled = false;
      }
    });
    return _isButtonEnabled;
  }

  @override
  void onLoadEditMemberComplete(String responseId) {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      _isLoading = false;
    });
    Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
            pageBuilder: (_, __, ___) => ProfilesHomePage(),
            transitionsBuilder: (_, anim, __, child) => Container(child: child),
            transitionDuration: Duration(seconds: 1)),
        (route) => false);
  }

  @override
  void onLoadEditMemberError(ErrorResponse errorResponse) {
    if (CODE_401 == errorResponse.code) {
      navigateToLogin(scaffoldKey, context);
    } else if (errorResponse.message == CODE_1) {
      _showError(AppLocalizations.of(context).translate(Make_sure_that_you_are_connected_to_the_internet));
    } else if (errorResponse.message == CODE_2) {
      _showError(AppLocalizations.of(context).translate(Server_error_please_try_again) +
          LINE_BREAK +
          errorResponse.error);
    } else {
      _showError(errorResponse.message != null
          ? errorResponse.message
          : errorResponse.key != null
              ? errorResponse.key
              : errorResponse.error != null ? errorResponse.error : "error");
    }

    setState(() {
      _isLoading = false;
    });
  }

}