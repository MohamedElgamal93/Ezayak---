import 'dart:io';

import 'package:ezayak/src/data/error_data.dart';
import 'package:ezayak/src/data/familyData/family_data.dart';
import 'package:ezayak/src/presenter/familyMember_presenter.dart';
import 'package:ezayak/src/ui/calendar.dart';
import 'package:ezayak/src/ui/family_profile.dart';
import 'package:ezayak/src/ui/user_profile.dart';
import 'package:ezayak/src/ui/widgets/bottomBar.dart';
import 'package:ezayak/src/ui/widgets/myTopBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../app_utils.dart';

import '../../app_constants.dart';
import '../data/user_family/add_member.dart';
import 'landingPage.dart';
import 'package:ezayak/src/ui/widgets/baseScreen.dart';
import '../AppLocalizations.dart';

class ProfilesHomePage extends StatefulWidget {
  @override
  ProfilesHomePageState createState() => ProfilesHomePageState();
}

class ProfilesHomePageState extends State<ProfilesHomePage>
    implements FamilyMemberListViewContract {
  FamilyMemberListPresenter _presenter;
  List<FamilyMember> familyMemberList = [];

  FamilyMember myProfile;
  bool isBtnDisable;

  List<FamilyMember> membersArray = [];

  bool isLoading;
  bool deleted;
  int memberId;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  ProfilesHomePageState() {
    _presenter = new FamilyMemberListPresenter(this);
  }

  @override
  void initState() {
    super.initState();
    _presenter.loadFamilyMembers(this);
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      onWillPop: _onWillPop,
      bottomMargin: 0,
      scaffoldKey: scaffoldKey,
      topBar: MyTopBar(
        showBack: true,
        navToLandingPage: true,
      ),
      bottomBar: BottomBar(showProfile: false, showSos: true),
      child: _buildPageView(),
    );
  }

  _buildPageView() {
    return Container(
      padding: const EdgeInsets.all(16),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
          buildHeader(),
          buildMiddleContent(),
          buildFooter()
        ]));
  }

  Widget buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: TITLE_FONT_SIZE,
            color: BLACK,
          ),
          children: <TextSpan>[
            TextSpan(
                text: AppLocalizations.of(context).translate(Profiles),
                style: TextStyle(
                    fontFamily: AR_VODAFONE_MID, fontSize: EZYEK_FONT_SIZE)),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget buildMiddleContent() {
    return isLoading
        ? Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Flexible(
            child: Center(
              child: ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        height: GENERAL_BUTTON_HEIGHT,
                        width: MediaQuery.of(context).size.width *
                            S_MID_BUTTON_WIDTH_PERCENTAGE,
                        child: buildRaisedButton(
                            isBtnDisable ? GREY : VODA_RED,AppLocalizations.of(context).translate(My_profile), () {
                          onPressMyProfile();
                        }),
                      ),

                      //SizedBox(width: 50),
                      Container(
                          height: GENERAL_BUTTON_HEIGHT,
                          width: MediaQuery.of(context).size.width *
                              V_SMALL_BUTTON_WIDTH_PERCENTAGE,
                          child: IconButton(
                              icon: Image.asset("assets/edit.png"),
                              onPressed: () {
                                onPressEditMyProfile();
                              })),
                      Visibility(
                        visible: true,
                        child: Container(
                            child: IconButton(
                                icon: Image.asset("assets/bin.png"),
                                onPressed: () {
                                 // _showDeleteProfileDialog(memberId);
                                })),
                      ),

                    ],
                  ),
                  SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    primary: true,
                    itemCount: membersArray.length,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      final FamilyMember member = membersArray[index];
                      return Column(
                        children: <Widget>[
                          _getListItemUi(member, index),
                          SizedBox(height: 10)
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          );
  }

  void onPressMyProfile() {
    isBtnDisable
        ? null
        : Navigator.push(
            context,
            PageRouteBuilder(
                pageBuilder: (_, __, ___) => MyCalendar(
                      member: myProfile,
                    ),
                transitionsBuilder:
                    (_, anim, __, child) =>
                        Container(child: child),
                transitionDuration:
                    Duration(seconds: 1)));
  }

  void onPressEditMyProfile() {
    isBtnDisable
        ? null
        : Navigator.push(
            context,
            PageRouteBuilder(
                pageBuilder: (_, __, ___) =>
                    UserProfile(
                      title:
                         AppLocalizations.of(context).translate(Update_your_profile_information) ,
                      addUserMember: AddMember(
                          fullName:
                              myProfile.fullName,
                          age: myProfile.age,
                          gender: myProfile.gender,
                          city: null,
                          governorate: null,
                          phoneNumber: myProfile
                              .phoneNumber,
                          memberType:
                              myProfile.memberType,
                          latitude:
                              myProfile.latitude,
                          longitude:
                              myProfile.longitude),
                      id: myProfile.id,
                      isEditing: true,
                      locationEditing: 0,
                    ),
                transitionsBuilder:
                    (_, anim, __, child) =>
                        Container(child: child),
                transitionDuration:
                    Duration(seconds: 1)));
  }

  Widget buildRaisedButton(Color color, String text, Function onPress) {
    return RaisedButton(
        color: color,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(BUTTON_BORDER_RADIUS)),
        child: Text(
          text,
          style: TextStyle(
              fontSize: BUTTON_FONT_SIZE,
              color: VODA_WHITE,
              fontFamily: isArabicString(text) ? AR_VODAFONE_BOLD : ExBd),
        ),
        onPressed: onPress);
  }

  Widget buildFooter() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8),
            child: Container(
              height: GENERAL_BUTTON_HEIGHT,
              width: MediaQuery.of(context).size.width *
                  LARGE_BUTTON_WIDTH_PERCENTAGE,
              child: buildRaisedButton(VODA_RED, AppLocalizations.of(context).translate(Add_a_new_family_member), () {
                onPressAddNewPerson();
              }),
            ),
          ),
        ],
      ),
    );
  }

  void onPressAddNewPerson() {
      Navigator.push(
        context,
        PageRouteBuilder(
            pageBuilder: (_, __, ___) => FamilyProfile(
                  title1:  AppLocalizations.of(context).translate(Add_the_new_members_information),
                  title2: '',
                  title3: '',
                  title4: '',
                  title5: '',
                  buttonTitle: AppLocalizations.of(context).translate(Next),
                  isEditing: true,
                  isAddPlus: true,
                ),
            transitionsBuilder: (_, anim, __, child) =>
                Container(child: child),
            transitionDuration: Duration(seconds: 1)));
  }

  Widget _getListItemUi(FamilyMember member, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[

        Container(
          height: GENERAL_BUTTON_HEIGHT,
          width:
          MediaQuery.of(context).size.width * S_MID_BUTTON_WIDTH_PERCENTAGE,
          child: buildRaisedButton(VODA_RED, member.fullName, () {
            onPressFamilyMember(member);
          }),
        ),
        Container(
            width: MediaQuery.of(context).size.width *
                V_SMALL_BUTTON_WIDTH_PERCENTAGE,
            child: IconButton(
                icon: Image.asset("assets/edit.png"),
                onPressed: () {
                  onPressEditFamilyMember(member);
                })),
        Container(
            padding: EdgeInsets.all(1),
            child: IconButton(
                icon: Image.asset("assets/bin.png"),
                onPressed: () {
                  deleteFamilyMember(member.fullName, index, member.id);

                  //  _showDialog(member.fullName, index, member.id);
                })),
      ],
    );
  }

  void onPressFamilyMember(FamilyMember member) {
    isBtnDisable
        ? null
        : Navigator.push(
            context,
            PageRouteBuilder(
                pageBuilder: (_, __, ___) => MyCalendar(
                      member: member,
                    ),
                transitionsBuilder: (_, anim, __, child) =>
                    Container(child: child),
                transitionDuration: Duration(seconds: 1)));
  }

  void onPressEditFamilyMember(FamilyMember member) {
    logD("memberCity: ${member.city["cityId"]}");

    Navigator.push(
        context,
        PageRouteBuilder(
            pageBuilder: (_, __, ___) => FamilyProfile(
                  addUserMember: AddMember(
                      fullName: member.fullName,
                      age: member.age,
                      gender: member.gender,
                      city: member.city['cityId'],
                      governorate: member.governorate['govId'],
                      phoneNumber: member.phoneNumber,
                      memberType: member.memberType,
                      latitude: member.latitude,
                      longitude: member.longitude),
                  id: member.id,
                  title1: AppLocalizations.of(context).translate(Update_your_profile_information),
                  title2: '',
                  title3: '',
                  title4: '',
                  title5: '',
                  buttonTitle: AppLocalizations.of(context).translate(Next),
                  isEditing: true,
                  isAddPlus: false,
                ),
            transitionsBuilder: (_, anim, __, child) =>
                Container(child: child),
            transitionDuration: Duration(seconds: 1)));
  }


  void showError(String error) {
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

  void deleteFamilyMember(String name, int index, int memberId){
    showCustomDialog(context: this.context,index:index,memberId: memberId, message: AppLocalizations.of(context).translate(Are_you_sure_you_want_to_delete_names_profile),
        message2: name,message3: ' ؟',
        button1: AppLocalizations.of(context).translate(Yes),button2: AppLocalizations.of(context).translate(No),buttonAction1: () {
          Navigator.of(context).pop();
          setState(() {
            _presenter.deleteFamilyMember(memberId,this);
          });

          scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(
              AppLocalizations.of(context).translate(Proceed),
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: AR_VODAFONE_MID),
            ),
            backgroundColor: Colors.green,
          ));
        },buttonAction2: () {
          Navigator.of(context).pop();
        } );
  }


  void _showDeleteProfileDialog(int memberId) {

    showCustomDialog(context: this.context,message: AppLocalizations.of(context).translate(Are_you_sure_you_want_to_delete_your_account),message3: ' ؟',
        memberId: memberId,buttonAction1: () {
          Navigator.of(context).pop();
          _presenter.deleteProfile(memberId,this);
        },buttonAction2: () {
          Navigator.of(context).pop();
        },button1:AppLocalizations.of(context).translate(Yes),button2: AppLocalizations.of(context).translate(No) );

  }


  Future<bool> _onWillPop() {
    Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
            pageBuilder: (_, __, ___) => LandingPage(),
            transitionsBuilder: (_, anim, __, child) => Container(child: child),
            transitionDuration: Duration(seconds: 1)),
        (route) => false);
    return Future(() => false);
  }


  void showSnackBar() {
     scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(
       AppLocalizations.of(context).translate(Next),  
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20, fontFamily: AR_VODAFONE_MID),
      ),
      backgroundColor: Colors.green,
      duration: Duration(seconds: 1),
    ));

    exit(0);
  }
}
