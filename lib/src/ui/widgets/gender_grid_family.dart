import 'package:ezayak/src/ui/widgets/user_family_utils.dart';
import 'package:flutter/material.dart';

import '../../../app_constants.dart';
import '../family_profile.dart';

class GenderGridFamily extends StatefulWidget {
  GenderGridFamily(this.familyProfileState);

  final FamilyProfileState familyProfileState;

  @override
  _GenderGridFamilyState createState() => _GenderGridFamilyState();
}

class _GenderGridFamilyState extends State<GenderGridFamily> {
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
                    widget.familyProfileState.setState(() {
                      widget.familyProfileState.selectedGender = "M";
                      widget.familyProfileState.isEmpty();
                    });
                  },
                  child: Image.asset(
                    MALE,
                    color: widget.familyProfileState.selectedGender == "M"
                        ? VODA_RED
                        : GREY,
                  )),
              InkWell(
                  onTap: () {
                    dismissFoucs(context);
                    widget.familyProfileState.setState(() {
                      widget.familyProfileState.selectedGender = "OM";
                      widget.familyProfileState.isEmpty();
                    });
                  },
                  child: Image.asset(
                    OLD_MAN,
                    color: widget.familyProfileState.selectedGender == "OM"
                        ? VODA_RED
                        : GREY,
                  )),
              InkWell(
                  onTap: () {
                    dismissFoucs(context);
                    widget.familyProfileState.setState(() {
                      widget.familyProfileState.selectedGender = "WM";
                      widget.familyProfileState.isEmpty();
                    });
                  },
                  child: Image.asset(
                    WHEELCHAIR,
                    color: widget.familyProfileState.selectedGender == "WM"
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
                    widget.familyProfileState.setState(() {
                      widget.familyProfileState.selectedGender = "F";
                      widget.familyProfileState.isEmpty();
                    });
                  },
                  child: Image.asset(
                    FEMALE,
                    color: widget.familyProfileState.selectedGender == "F"
                        ? VODA_RED
                        : GREY,
                  )),
              InkWell(
                  onTap: () {
                    dismissFoucs(context);
                    widget.familyProfileState.setState(() {
                      widget.familyProfileState.selectedGender = "P";
                      widget.familyProfileState.isEmpty();
                    });
                  },
                  child: Image.asset(
                    PREGNANT,
                    color: widget.familyProfileState.selectedGender == "P"
                        ? VODA_RED
                        : GREY,
                  )),
              InkWell(
                  onTap: () {
                    dismissFoucs(context);
                    widget.familyProfileState.setState(() {
                      widget.familyProfileState.selectedGender = "OF";
                      widget.familyProfileState.isEmpty();
                    });
                  },
                  child: Image.asset(
                    ELDERLY,
                    color: widget.familyProfileState.selectedGender == "OF"
                        ? VODA_RED
                        : GREY,
                  )),
              InkWell(
                  onTap: () {
                    dismissFoucs(context);
                    widget.familyProfileState.setState(() {
                      widget.familyProfileState.selectedGender = "WF";
                      widget.familyProfileState.isEmpty();
                    });
                  },
                  child: Image.asset(
                    WHEELCHAIR,
                    color: widget.familyProfileState.selectedGender == "WF"
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
