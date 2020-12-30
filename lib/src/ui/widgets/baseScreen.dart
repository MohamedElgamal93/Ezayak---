
import 'package:ezayak/src/ui/widgets/baseBackground.dart';
import 'package:flutter/material.dart';
import 'package:ezayak/app_constants.dart';

class BaseScreen extends StatefulWidget {


  final WillPopCallback onWillPop;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final PreferredSizeWidget topBar;
  final Widget bottomBar;
  final Widget child;
  final double bottomMargin;



  BaseScreen({@required this.topBar, this.bottomBar, @required this.child, this.onWillPop, this.scaffoldKey, this.bottomMargin});

  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: true,
        child: WillPopScope(
          onWillPop: widget.onWillPop != null ? widget.onWillPop : null
          ,
          child: Scaffold(
            key: widget.scaffoldKey != null ? widget.scaffoldKey : null,
            body: Stack(
              children: <Widget>[
                BaseBackGround(),
                Scaffold(
                    backgroundColor: Colors.transparent,
                    appBar: widget.topBar,
                    bottomNavigationBar: widget.bottomBar,
                    body: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          margin: EdgeInsets.only(bottom: widget.bottomMargin != null?widget.bottomMargin:0.0),
                            decoration: BoxDecoration(
                                border: Border.all(color: GREY),
                                color: VODA_WHITE),
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                            child: this.widget.child,),
                        ))),
              ],
            ),
          ),
        ));
  }
}
