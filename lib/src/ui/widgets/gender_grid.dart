import 'package:ezayak/src/ui/widgets/user_family_utils.dart';
import 'package:flutter/material.dart';

import '../../../app_constants.dart';
import '../user_profile.dart';

class GenderGridUser extends StatefulWidget {
  GenderGridUser(this.userProfileState);

  final UserProfileState userProfileState;

  @override
  _GenderGridUserState createState() => _GenderGridUserState();
}

class _GenderGridUserState extends State<GenderGridUser> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Image.asset(MAN_SIGN),
              InkWell(
                  onTap: () {
                    dismissFoucs(context);
                    widget.userProfileState.setState(() {
                      widget.userProfileState.selectedGender = "M";
                      widget.userProfileState.isEmpty();
                    });
                  },
                  child: Image.asset(
                    MALE,
                    color: widget.userProfileState.selectedGender == "M"
                        ? VODA_RED
                        : GREY,
                  )),
              InkWell(
                  onTap: () {
                    dismissFoucs(context);
                    widget.userProfileState.setState(() {
                      widget.userProfileState.selectedGender = "OM";
                      widget.userProfileState.isEmpty();
                    });
                  },
                  child: Image.asset(
                    OLD_MAN,
                    color: widget.userProfileState.selectedGender == "OM"
                        ? VODA_RED
                        : GREY,
                  )),
              InkWell(
                  onTap: () {
                    dismissFoucs(context);
                    widget.userProfileState.setState(() {
                      widget.userProfileState.selectedGender = "WM";
                      widget.userProfileState.isEmpty();
                    });
                  },
                  child: Image.asset(
                    WHEELCHAIR,
                    color: widget.userProfileState.selectedGender == "WM"
                        ? VODA_RED
                        : GREY,
                  )),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Image.asset(WOMAN_SIGN),
              InkWell(
                  onTap: () {
                    dismissFoucs(context);
                    widget.userProfileState.setState(() {
                      widget.userProfileState.selectedGender = "F";
                      widget.userProfileState.isEmpty();
                    });
                  },
                  child: Image.asset(
                    FEMALE,
                    color: widget.userProfileState.selectedGender == "F"
                        ? VODA_RED
                        : GREY,
                  )),
              InkWell(
                  onTap: () {
                    dismissFoucs(context);
                    widget.userProfileState.setState(() {
                      widget.userProfileState.selectedGender = "P";
                      widget.userProfileState.isEmpty();
                    });
                  },
                  child: Image.asset(
                    PREGNANT,
                    color: widget.userProfileState.selectedGender == "P"
                        ? VODA_RED
                        : GREY,
                  )),
              InkWell(
                  onTap: () {
                    dismissFoucs(context);
                    widget.userProfileState.setState(() {
                      widget.userProfileState.selectedGender = "OF";
                      widget.userProfileState.isEmpty();
                    });
                  },
                  child: Image.asset(
                    ELDERLY,
                    color: widget.userProfileState.selectedGender == "OF"
                        ? VODA_RED
                        : GREY,
                  )),
              InkWell(
                  onTap: () {
                    dismissFoucs(context);
                    widget.userProfileState.setState(() {
                      widget.userProfileState.selectedGender = "WF";
                      widget.userProfileState.isEmpty();
                    });
                  },
                  child: Image.asset(
                    WHEELCHAIR,
                    color: widget.userProfileState.selectedGender == "WF"
                        ? VODA_RED
                        : GREY,
                  )),
            ],
          )
        ],
      ),
    );
  }
}
