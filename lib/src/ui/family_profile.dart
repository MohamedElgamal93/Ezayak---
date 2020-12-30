import 'package:ezayak/src/data/error_data.dart';
import 'package:ezayak/src/data/user_family/add_member.dart';
import 'package:ezayak/src/data/user_family/get_cities.dart';
import 'package:ezayak/src/data/user_family/get_governorates.dart';
import 'package:ezayak/src/presenter/user_family_presenter.dart';
import 'package:ezayak/src/ui/ProfilesHomePage.dart';
import 'package:ezayak/src/ui/widgets/baseScreen.dart';
import 'package:ezayak/src/ui/widgets/gender_grid_family.dart';
import 'package:ezayak/src/ui/widgets/myTopBar.dart';
import 'package:ezayak/src/ui/widgets/user_family_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app_constants.dart';
import '../AppLocalizations.dart';
import '../app_utils.dart';
import 'landingPage.dart';
import 'onBoardingPage.dart';

class FamilyProfile extends StatefulWidget {
  final String title1;
  final String title2;
  final String title3;
  final String title4;
  final String title5;
  final String buttonTitle;
  final AddMember addUserMember;
  final AddMember addMember;
  final List<AddMember> userAndFamilyList;
  final int id;
  final bool isEditing;
  final bool isAddPlus;

  FamilyProfile(
      {Key key,
      @required this.title1,
      @required this.title2,
      @required this.title3,
      @required this.title4,
      @required this.title5,
      @required this.buttonTitle,
      this.addUserMember,
      this.id,
      this.addMember,
      this.isEditing,
      this.isAddPlus,
      this.userAndFamilyList})
      : super(key: key);

  @override
  FamilyProfileState createState() => FamilyProfileState();
}

class FamilyProfileState extends State<FamilyProfile>
    implements UserFamilyContract, UserFamilyEditContract {
  bool _validateName = false;
  bool _validateAge = false;
  bool _validateMobile = false;
  bool _isArabic;
  String dropdownValue1;
  String dropdownValue2;
  List<AddMember> addMemberList = [];
  List<AddMember> addUserList = [];
  List<AddMember> allMemberList = [];
  bool _isButtonDisabled = false;
  String selectedGender;
  var _isLoadingSubmit = false;
  var _isLoadingSkip = false;
  Map<int, String> mapGov = Map();
  Map<int, String> mapCity = Map();
  List<String> itemGov = [];
  List<String> itemsCity = [];
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _textUserName = TextEditingController();
  TextEditingController _textAge = TextEditingController();
  TextEditingController _textMobile = TextEditingController();
  final FocusNode userNameFocus = FocusNode();
  final FocusNode ageFocus = FocusNode();
  final FocusNode mobileFocus = FocusNode();
  UserFamilyEditPresenter _presenterEdit;
  int govId;
  int cityId;
  String headerToken;
  UserFamilyPresenter _presenter;
  bool isFirstLogin;
  FamilyProfileState _familyProfileState;
  bool isGovEdited = false;

  var userFont;

  FamilyProfileState() {
    _presenter = new UserFamilyPresenter(this);
    _presenterEdit = new UserFamilyEditPresenter(this);
  }

  @override
  void initState() {
    super.initState();
    _getIsFirstLogin();
    setState(() {
      _isArabic = isArabicString(widget.title2);
    });
    if (widget.addMember != null) {
      addUserList.insert(0, widget.addMember);
    }
    if (widget.addUserMember != null) {
      setState(() {
        if (isArabicString(widget.addUserMember.fullName)) {
          userFont = AR_VODAFONE_LIGHT;
        } else {
          userFont = REGULAR_FONT;
        }
        _textUserName.text = widget.addUserMember.fullName;
        _textAge.text = widget.addUserMember.age.toString();
        _textMobile.text = widget.addUserMember.phoneNumber;
        govId = widget.addUserMember.governorate;
        selectedGender = widget.addUserMember.gender;
      });
      isEmpty();
    }

    setState(() {
      itemGov.clear();
      mapGov.values.forEach((v) => itemGov.add(v));
    });
    if (widget.addUserMember != null) {
      _presenter.loadGovernorates();
      _presenter.loadCities(govId);
    } else {
      _presenter.loadGovernorates();
    }
  }

  @override
  void dispose() {
    _textUserName.dispose();
    _textAge.dispose();
    _textMobile.dispose();
    super.dispose();
  }

  void _onChangeGov(String newValue) {
    dropdownValue2 = null;
    itemsCity.clear();
    setState(() {
      if (widget.addUserMember != null) {
        isGovEdited = true;
        dropdownValue2 = null;
//        dropdownValue2 = 'المنطقة';
      }
      dropdownValue1 = newValue;
      govId = mapGov.keys
          .firstWhere((k) => mapGov[k] == dropdownValue1, orElse: () => null);
      _presenter.loadCities(govId);
      dismissFoucs(context);
      isEmpty();
    });
  }

  void _onChangeArea(String newValue) {
    setState(() {
      dropdownValue2 = newValue;
      cityId = mapCity.keys
          .firstWhere((k) => mapCity[k] == dropdownValue2, orElse: () => null);
      dismissFoucs(context);
      isEmpty();
    });
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
        padding: EdgeInsets.all(16.0),
        width: double.infinity,
        height: double.infinity,
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: constraints.copyWith(
                minHeight: constraints.maxHeight,
                maxHeight: double.infinity,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          if (!widget.isEditing || widget.isEditing == null)
                            Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                padding: EdgeInsets.only(bottom: 5.0),
                                width: MediaQuery.of(context).size.width *
                                    BUTTON_WIDTH_PERCENTAGE,
                                height: GENERAL_BUTTON_HEIGHT,
                                child: buttonSkip(
                                  AppLocalizations.of(context).translate(Not_now), _isLoadingSkip, _skip),
                              ),
                            ),
                          titleScreen(
                              widget.title1,
                              widget.title2,
                              widget.title3,
                              widget.title4,
                              widget.title5,
                              _isArabic),
                          textFieldName(
                              context,
                              userNameFocus,
                              mobileFocus,
                              TextInputAction.next,
                             AppLocalizations.of(context).translate(Name) ,
                              _textUserName,
                              _validateName,
                              TextInputType.text,
                              isEmpty,
                              userFont),
                          textFieldLayoutNumber(
                              context,
                              mobileFocus,
                              ageFocus,
                              TextInputAction.next,
                             AppLocalizations.of(context).translate(Mobile_number),
                              _textMobile,
                              _validateMobile,
                              TextInputType.phone,
                              11,
                              isEmpty),
                          textFieldLayoutNumber(
                              context,
                              ageFocus,
                              null,
                              TextInputAction.done,
                            AppLocalizations.of(context).translate(Age),
                              _textAge,
                              _validateAge,
                              TextInputType.phone,
                              2,
                              isEmpty),
                          GenderGridFamily(this),
                          twoDropDwon(
                              dropDown(dropdownValue1, _onChangeGov, itemGov,
                                 AppLocalizations.of(context).translate(Governorate) , context),
                              dropDown(dropdownValue2, _onChangeArea, itemsCity,
                                  AppLocalizations.of(context).translate(Area), context)),
                          if (!widget.isEditing || widget.isEditing == null)
                            twoButton(
                                Container(
                                  width: MediaQuery.of(context).size.width *
                                      M_SMALL_BUTTON_WIDTH_PERCENTAGE,
                                  height: GENERAL_BUTTON_HEIGHT,
                                  child: buttonSubmit(
                                      AppLocalizations.of(context).translate(Proceed),
                                      _isButtonDisabled,
                                      _isLoadingSubmit,
                                      addMember),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width *
                                      MID_BUTTON_WIDTH_PERCENTAGE,
                                  height: GENERAL_BUTTON_HEIGHT,
                                  child: button(
                                      widget.buttonTitle, _navigateAgain,
                                      isButtonDisabled: _isButtonDisabled),
                                )),
                          if (widget.isEditing && widget.isEditing != null)
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                  width: MediaQuery.of(context).size.width *
                                      BUTTON_WIDTH_PERCENTAGE,
                                  height: GENERAL_BUTTON_HEIGHT,
                                  margin: EdgeInsets.symmetric(vertical: 8),
                                  child: RaisedButton(
                                    child: _isLoadingSubmit
                                        ? CircularProgressIndicator(
                                            backgroundColor: VODA_WHITE,
                                          )
                                        : FittedBox(
                                          child: Text(
                                              AppLocalizations.of(context).translate(Proceed),
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
                                    onPressed:
                                        !_isButtonDisabled || _isLoadingSubmit
                                            ? null
                                            : editMember,
                                    color: VODA_RED,
                                  )),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }));
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

  void _navigateAgain() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    allMemberList.clear();
    if (widget.userAndFamilyList != null) {
      addMemberList.add(AddMember(
          fullName: _textUserName.text,
          city: cityId,
          governorate: govId,
          gender: selectedGender,
          age: int.parse(_textAge.text),
          phoneNumber: _textMobile.text,
          memberType: 2,
          longitude: null,
          latitude: null));
      allMemberList =
          [addMemberList, widget.userAndFamilyList].expand((x) => x).toList();
      Navigator.push(
          context,
          PageRouteBuilder(
              pageBuilder: (_, __, ___) => FamilyProfile(
                    title1: AppLocalizations.of(context).translate(Family_member_added) ,
                    title2: "(${_textUserName.text})",
                    title3: AppLocalizations.of(context).translate(Would_you_like_to),
                    title4: AppLocalizations.of(context).translate(Registration),
                    title5:  AppLocalizations.of(context).translate(Family_member),
                    buttonTitle: AppLocalizations.of(context).translate(Proceed_add_another_family_member),
                    isEditing: false,
                    addMember: widget.addMember,
                    userAndFamilyList: allMemberList,
                  ),
              transitionsBuilder: (_, anim, __, child) =>
                  Container(child: child),
              transitionDuration: Duration(seconds: 1)));
    }
    if (widget.userAndFamilyList == null) {
      addMemberList.add(AddMember(
          fullName: _textUserName.text,
          city: cityId,
          governorate: govId,
          gender: selectedGender,
          age: int.parse(_textAge.text),
          phoneNumber: _textMobile.text,
          memberType: 2,
          longitude: null,
          latitude: null));

      Navigator.push(
          context,
          PageRouteBuilder(
              pageBuilder: (_, __, ___) => FamilyProfile(
                    title1: AppLocalizations.of(context).translate(Family_member_added) ,
                    title2: "(${_textUserName.text})",
                    title3: AppLocalizations.of(context).translate(Would_you_like_to),
                    title4: AppLocalizations.of(context).translate(Registration),
                    title5: AppLocalizations.of(context).translate(Family_member),
                    buttonTitle: AppLocalizations.of(context).translate(Proceed_add_another_family_member),
                    isEditing: false,
                    addMember: widget.addMember,
                    userAndFamilyList: addMemberList,
                  ),
              transitionsBuilder: (_, anim, __, child) =>
                  Container(child: child),
              transitionDuration: Duration(seconds: 1)));
    }
  }

  void _skip() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      _isLoadingSkip = true;
    });
    addUserList.clear();
    if (widget.addMember != null && widget.userAndFamilyList != null) {
      addUserList.insert(0, widget.addMember);
      allMemberList =
          [addUserList, widget.userAndFamilyList].expand((x) => x).toList();
      logD("addmember list${allMemberList.length}");
      _presenter.loadAddMember(allMemberList);
    }
    if (widget.addMember != null && widget.userAndFamilyList == null) {
      addUserList.insert(0, widget.addMember);
      logD("addmember list${addUserList.length}");
      _presenter.loadAddMember(addUserList);
    }

  }

  void addMember() {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      _isLoadingSubmit = true;
    });
    addUserList.clear();
    allMemberList.clear();
    if (widget.addMember != null && widget.userAndFamilyList != null) {
      addUserList.insert(0, widget.addMember);

      allMemberList =
          [addUserList, widget.userAndFamilyList].expand((x) => x).toList();
      allMemberList.add(AddMember(
          fullName: _textUserName.text,
          city: cityId,
          governorate: govId,
          gender: selectedGender,
          age: int.parse(_textAge.text),
          phoneNumber: _textMobile.text,
          memberType: 2,
          longitude: null,
          latitude: null));
      logD("addmember allMemberList${allMemberList.length}");
      _presenter.loadAddMember(allMemberList);
    }
    if (widget.addMember != null && widget.userAndFamilyList == null) {
      addUserList.insert(0, widget.addMember);
      addUserList.add(AddMember(
          fullName: _textUserName.text,
          city: cityId,
          governorate: govId,
          gender: selectedGender,
          age: int.parse(_textAge.text),
          phoneNumber: _textMobile.text,
          memberType: 2,
          longitude: null,
          latitude: null));
      logD("addmember list${addUserList.length}");
      _presenter.loadAddMember(addUserList);
    }
  }

  void editMember() {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      _isLoadingSubmit = true;
    });
    addMemberList.clear();
    addMemberList.add(AddMember(
        fullName: _textUserName.text,
        city: cityId,
        governorate: govId,
        gender: selectedGender,
        age: int.parse(_textAge.text),
        phoneNumber: _textMobile.text,
        memberType: 2,
        longitude: null,
        latitude: null));
    if (widget.isAddPlus && widget.addUserMember == null) {
      _presenter.loadAddMember(addMemberList);
    } else {
      _presenterEdit.loadEditMember(
          AddMember(
              fullName: _textUserName.text,
              city: cityId,
              governorate: govId,
              gender: selectedGender,
              age: int.parse(_textAge.text),
              phoneNumber: _textMobile.text,
              memberType: 2,
              longitude: null,
              latitude: null),
          widget.id);
    }
  }

  @override
  void onLoadAddMemberComplete(int statusCode) {
    logD('status code$statusCode');
    setState(() {
      _isLoadingSubmit = false;
      _isLoadingSkip = false;
    });
    if (true == widget.isAddPlus) {
      Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
              pageBuilder: (_, __, ___) => ProfilesHomePage(),
              transitionsBuilder: (_, anim, __, child) =>
                  Container(child: child),
              transitionDuration: Duration(seconds: 1)),
          (route) => false);
    } else if (isFirstLogin == null && false == widget.isAddPlus) {
      Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
              pageBuilder: (_, __, ___) => OnBoardingPage(),
              transitionsBuilder: (_, anim, __, child) =>
                  Container(child: child),
              transitionDuration: Duration(seconds: 1)),
          (route) => false);
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
              pageBuilder: (_, __, ___) => LandingPage(),
              transitionsBuilder: (_, anim, __, child) =>
                  Container(child: child),
              transitionDuration: Duration(seconds: 1)),
          (route) => false);
    }
  }

  @override
  void onLoadAddMemberError(ErrorResponse error) {
    setState(() {
      _isLoadingSubmit = false;
      _isLoadingSkip = false;
    });
    if (CODE_401 == error.code) {
      navigateToLogin(scaffoldKey, context);
    } else if (error.message == CODE_1) {
      _showError(AppLocalizations.of(context).translate(Make_sure_that_you_are_connected_to_the_internet));
    } else if (error.message == CODE_2) {
      _showError(
          AppLocalizations.of(context).translate(Server_error_please_try_again) + LINE_BREAK + error.error);
    } else {
      _showError(error.message != null
          ? error.message
          : error.key != null
              ? error.key
              : error.error != null ? error.error : "error");
    }
  }

  @override
  void onLoadCitiesComplete(List<GetCities> response) {
    Map<int, String> map = Map();
    for (GetCities model in response) {
      map.putIfAbsent(model.cityId, () => model.cityName);
    }
    setState(() {
      mapCity = map;
      mapCity.values.forEach((v) => itemsCity.add(v));

      if (widget.addUserMember != null && !isGovEdited) {
        cityId = widget.addUserMember.city;
        dropdownValue2 = mapCity[cityId];
        isEmpty();
      }
    });
  }

  @override
  void onLoadCitiesError(ErrorResponse error) {
    if (CODE_401 == error.code) {
      navigateToLogin(scaffoldKey, context);
    } else if (error.message == CODE_1) {
      _showError(AppLocalizations.of(context).translate(Make_sure_that_you_are_connected_to_the_internet));
    } else if (error.message == CODE_2) {
      _showError(
          AppLocalizations.of(context).translate(Server_error_please_try_again) + LINE_BREAK + error.error);
    } else {
      _showError(error.message != null
          ? error.message
          : error.key != null
              ? error.key
              : error.error != null ? error.error : "error");
    }
  }

  @override
  void onLoadGovernoratesComplete(List<GetGovernorates> response) {
    Map<int, String> map = Map();
    for (GetGovernorates model in response) {
      map.putIfAbsent(model.govId, () => model.governorateName);
    }
    setState(() {
      mapGov = map;
      mapGov.values.forEach((v) => itemGov.add(v));

      if (widget.addUserMember != null) {
        govId = widget.addUserMember.governorate;
        dropdownValue1 = mapGov[govId];
        isEmpty();
      }
    });
  }

  @override
  void onLoadGovernoratesError(ErrorResponse error) {
    if (CODE_401 == error.code) {
      navigateToLogin(scaffoldKey, context);
    } else if (error.message == CODE_1) {
      _showError(AppLocalizations.of(context).translate(Make_sure_that_you_are_connected_to_the_internet));
    } else if (error.message == CODE_2) {
      _showError(
          AppLocalizations.of(context).translate(Server_error_please_try_again) + LINE_BREAK + error.error);
    } else {
      _showError(error.message != null
          ? error.message
          : error.key != null
              ? error.key
              : error.error != null ? error.error : "error");
    }
  }

  bool isEmpty() {
    setState(() {
      if ((_textUserName.text.isNotEmpty) &&
          (_textAge.text.isNotEmpty) &&
          (_textMobile.text.isNotEmpty) &&
          (_textUserName != null) &&
          (_textAge != null) &&
          (_textMobile != null) &&
          (_textMobile.text.trim().length == 11) &&
          (selectedGender != null) &&
          (govId != null) &&
          (cityId != null)) {
        _isButtonDisabled = true;
      } else {
        _isButtonDisabled = false;
      }
    });
    return _isButtonDisabled;
  }

  _getIsFirstLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isFirstLogin = prefs.getBool(FIRST_LOGIN);
    });
  }


  @override
  void onLoadEditMemberComplete(String modifyId) {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      _isLoadingSubmit = false;
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
  void onLoadEditMemberError(ErrorResponse error) {
    if (CODE_401 == error.code) {
      navigateToLogin(scaffoldKey, context);
    } else if (error.message == CODE_1) {
      _showError(AppLocalizations.of(context).translate(Make_sure_that_you_are_connected_to_the_internet));
    } else if (error.message == CODE_2) {
      _showError(
          AppLocalizations.of(context).translate(Server_error_please_try_again)+ LINE_BREAK + error.error);
    } else {
      _showError(error.message != null
          ? error.message
          : error.key != null
              ? error.key
              : error.error != null ? error.error : "error");
    }

    setState(() {
      _isLoadingSubmit = false;
    });
  }
}
