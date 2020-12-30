import 'package:ezayak/src/ui/symptomsSlider.dart';
import 'package:ezayak/src/ui/widgets/baseBackground.dart';
import 'package:ezayak/src/ui/widgets/bottomBar.dart';
import 'package:ezayak/src/ui/widgets/myTopBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../app_constants.dart';
import '../app_utils.dart';
import 'chatbot.dart';
import 'landingPage.dart';
import 'package:ezayak/src/AppLocalizations.dart';

class ActivitiesWidget extends StatefulWidget {
  ActivitiesWidget(this.selectedMode, this.memberId, this.date,
      {this.landingPageState});

  final LandingPageState landingPageState;
  final int selectedMode;
  final int memberId;
  final int date;

  @override
  ActivitiesWidgetState createState() => ActivitiesWidgetState();
}

class ActivitiesWidgetState extends State<ActivitiesWidget> {
  List<int> selectedItems = List();
  int _type = 0;


  String hail = "هايل!";

  var selectedActivity;

  List<bool> isSelectedProblems = List.filled(5, false);
  List<bool> isSelectedActions = List.filled(11, false);
  List<Widget> removedImages = new List<Widget>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            BaseBackGround(),
            Scaffold(
                backgroundColor: Colors.transparent,
                appBar: MyTopBar(
                  showBack: true,
                ),
                bottomNavigationBar: BottomBar(
                  showProfile: true,
                  showSos: true,
                  showCovid: false,
                ),
                body: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                        decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(color: GREY),
                              right: BorderSide(color: GREY),
                              left: BorderSide(color: GREY),
                            ),
                            color: VODA_WHITE),
                        child: _buildPageView(context)))),
          ],
        ),
      ),
    );
  }

  Widget _buildPageView(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          widget.selectedMode == 1 || widget.selectedMode == 2
              ? Column(
                  children: <Widget>[
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: TITLE_FONT_SIZE,
                            color: BLACK,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                                text: hail,
                                style: TextStyle(
                                    fontFamily: AR_VODAFONE_MID,
                                    fontSize: EZYEK_FONT_SIZE)),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: TITLE_FONT_SIZE,
                            color: BLACK,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                                text: AppLocalizations.of(context).translate(What_are_you_going_to_do_today),
                                style: TextStyle(
                                    fontFamily: AR_VODAFONE_MID,
                                    fontSize: TITLE_FONT_SIZE)),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: SUBTITLE_FONT_SIZE,
                            color: BLACK,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                                text: AppLocalizations.of(context).translate(You_can_choose_more_than_1_activity),
                                style: TextStyle(
                                    fontFamily: AR_VODAFONE_MID,
                                    fontSize: BUTTON_FONT_SIZE)),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                )
              : widget.selectedMode == 3
                  ? Column(
                      children: <Widget>[
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: TITLE_FONT_SIZE,
                                color: BLACK,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                    text:AppLocalizations.of(context).translate(What_are_you_going_to_do_today),
                                    style: TextStyle(
                                        fontFamily: AR_VODAFONE_MID,
                                        fontSize: TITLE_FONT_SIZE)),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: SUBTITLE_FONT_SIZE,
                                color: BLACK,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                    text: AppLocalizations.of(context).translate(You_can_choose_more_than_1_activity),
                                    style: TextStyle(
                                        fontFamily: AR_VODAFONE_MID,
                                        fontSize: BUTTON_FONT_SIZE)),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: <Widget>[
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: TITLE_FONT_SIZE,
                                color: BLACK,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                    text: AppLocalizations.of(context).translate(What_is_wrong),
                                    style: TextStyle(
                                        fontFamily: AR_VODAFONE_MID,
                                        fontSize: EZYEK_FONT_SIZE)),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
          Expanded(
            child: widget.selectedMode == 1 ||
                    widget.selectedMode == 2 ||
                    widget.selectedMode == 3
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: <Widget>[
                            GridView.count(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                mainAxisSpacing: 15,
                                crossAxisCount: 3,
                                childAspectRatio: 40 / 45,
                                shrinkWrap: true,
                                primary: false,
                                children: activitiesGird()),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[...removedImages],
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: <Widget>[
                            GridView.count(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                mainAxisSpacing: 15,
                                crossAxisCount: 2,
                                childAspectRatio: 5 / 3.5,
                                shrinkWrap: true,
                                primary: false,
                                children: problemsGird()),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[...removedImages],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
          Container(
            width:
                MediaQuery.of(context).size.width * MID_BUTTON_WIDTH_PERCENTAGE,
            height: GENERAL_BUTTON_HEIGHT,
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(BUTTON_BORDER_RADIUS),
              ),
              child: Text(
               AppLocalizations.of(context).translate(Ok),
                style: TextStyle(
                    color: VODA_WHITE,
                    fontFamily: AR_VODAFONE_MID,
                    fontSize: BUTTON_FONT_SIZE),
              ),
              onPressed: isSelectedProblems.contains(true) || isSelectedActions.contains(true)
                  ? () => {
                        isSelectedProblems = List.filled(5, false),
                        isSelectedActions = List.filled(11, false),
                        if (selectedItems.contains(15))
                          {
                          Navigator.push(
                          context,
                          PageRouteBuilder(
                          pageBuilder: (_, __, ___) => ChatBot(
                          removeActions: () =>
                          {selectedItems = List()}),
                          transitionsBuilder: (_, anim, __, child) =>
                          Container(child: child),
                          transitionDuration: Duration(seconds: 1)))
                          }
                        else
                          {
                            Navigator.push(
                                context,
                                PageRouteBuilder(
                                    pageBuilder: (_, __, ___) => Symptoms(
                                        id: widget.memberId,
                                        actions: selectedItems,
                                        type: _type,
                                        removeActions: () =>
                                            {selectedItems = List()}),
                                    transitionsBuilder: (_, anim, __, child) =>
                                        Container(child: child),
                                    transitionDuration: Duration(seconds: 1)))
                          }
                      }
                  : null,
              color: VODA_RED,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> problemsGird() {
    List<Widget> images = new List<Widget>();

    images.add(buildProblemsWidget(AppLocalizations.of(context).translate(I_have_issues_at_home), 0, ISSUE_HOME, 11));
    images.add(buildProblemsWidget(AppLocalizations.of(context).translate(I_have_issues_at_work), 1, ISSUE_WORK, 12));
    images.add(buildProblemsWidget(AppLocalizations.of(context).translate(Iam_tired), 2, SAD2, 13));
    images.add(buildProblemsWidget(AppLocalizations.of(context).translate(Iam_stressed), 3, WORRY, 14));
    images.add(buildProblemsWidget(AppLocalizations.of(context).translate(Other), 4, QUESTION, 15));

    removedImages.clear();

    if (images.length % 2 == 1) {
      setState(() {
        removedImages.add(images.last);
        images.removeLast();
        logD('removedImages.length: ${removedImages.length}');
      });
    }
    return images;
  }

  List<Widget> activitiesGird() {
    List<Widget> images = new List<Widget>();

    images.add(buildActivitiesWidget(Staying_home, 0, SOFA, 1));
    images
        .add(buildActivitiesWidget(AppLocalizations.of(context).translate(Working_from_home), 1, WORKING_FROM_HOME, 2));
    images.add(buildActivitiesWidget(AppLocalizations.of(context).translate(Working_from_office), 2, WORKING_FROM_OFFICE, 21));
    images.add(buildActivitiesWidget(AppLocalizations.of(context).translate(Going_out), 3, CAR, 3));
    images.add(buildActivitiesWidget(AppLocalizations.of(context).translate(Exercising), 4, GYM, 4));
    images.add(buildActivitiesWidget(AppLocalizations.of(context).translate(Sleeping), 5, SLEEP, 5));
    images.add(buildActivitiesWidget(AppLocalizations.of(context).translate(Cooking), 6, COOK, 6));
    images.add(buildActivitiesWidget(AppLocalizations.of(context).translate(Schooling_from_home), 7, STUDYING, 7));
    images.add(buildActivitiesWidget(AppLocalizations.of(context).translate(Doing_house_chores), 8, GROUP, 8));
    images
        .add(buildActivitiesWidget(AppLocalizations.of(context).translate(Watching_TV), 9, WATCHING_TV, 9));
    images.add(buildActivitiesWidget(AppLocalizations.of(context).translate(Doing_my_hobby), 10, BOOK, 10));

    removedImages.clear();

    if (images.length % 3 == 1) {
      setState(() {
        removedImages.add(images.last);
        images.removeLast();
        logD('removedImages.length: ${removedImages.length}');
      });
    } else if (images.length % 3 == 2) {
      setState(() {
        removedImages.add(images.last);
        removedImages.add(images[images.length - 2]);
        images.removeLast();
        images.removeAt(images.length - 1);
      });
    }
    return images;
  }

  Widget buildProblemsWidget(String mood, int selected, String icon, int id) {
    return GestureDetector(
      onTap: () => {
        setState(() {
          _type = 2;
          if (selected == 4) {
            selectedItems.clear();
            if(selectedItems.contains(id)){
              selectedItems.removeWhere((item) => item == id);
            }else{
              selectedItems.add(id);
            }
            isSelectedProblems = List.filled(5, false);
            isSelectedProblems[selected] = getValue(isSelectedProblems[selected]);
          } else {
            isSelectedProblems[4] = false;
            if(selectedItems.contains(15)){
              selectedItems.remove(15);
            }
            if(selectedItems.contains(id)){
              selectedItems.removeWhere((item) => item == id);
            }else{
              selectedItems.add(id);
            }
            isSelectedProblems[selected] = getValue(isSelectedProblems[selected]);
          }
        })
      },
      child: Column(
        children: <Widget>[
          Image.asset(
            icon,
            height: 50,
            width: 50,
            color: true == isSelectedProblems[selected] ? VODA_RED : BLACK,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4.0),
            child: Center(
              child: Text(mood,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: true == isSelectedProblems[selected] ? VODA_RED : BLACK,
                      fontSize: ICON_FONT_SIZE,
                      fontFamily: AR_VODAFONE_MID)),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildActivitiesWidget(String mood, int selected, String icon, int id) {
    return GestureDetector(
      onTap: () => {
        setState(() {
          if (selectedItems.length < 5) {
            _type = 1;
            isSelectedActions[selected] = getValue(isSelectedActions[selected]);
            if(selectedItems.contains(id)){
              selectedItems.removeWhere((item) => item == id);
            }else{
              selectedItems.add(id);
            }
          } else {
            selectedItems.removeWhere((item) => item == id);
            isSelectedActions[selected] = false;
          }
        })
      },
      child: Column(
        children: <Widget>[
          Image.asset(
            icon,
            height: 50,
            width: 50,
            color: true == isSelectedActions[selected] ? VODA_RED : BLACK,
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Center(
              child: SizedBox(
                width: 80,
                child: Text(mood,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: true == isSelectedActions[selected] ? VODA_RED : BLACK,
                        fontSize: ICON_FONT_SIZE,
                        fontFamily: AR_VODAFONE_MID)),
              ),
            ),
          ),
        ],
      ),
    );
  }




  bool getValue(bool checked) {
    if (checked) {
      return false;
    }
    return true;
  }
}
