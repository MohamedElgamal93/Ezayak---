import 'dart:async';
import 'dart:ffi';
import 'package:app_settings/app_settings.dart';
import 'package:ezayak/src/data/error_data.dart';
import 'package:ezayak/src/data/chatBotToken/chatBot_token.dart';
import 'package:ezayak/src/presenter/chatBot_token.dart';
import 'package:ezayak/src/ui/widgets/baseBackground.dart';
import 'package:ezayak/src/ui/widgets/baseScreen.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ezayak/src/ui/widgets/bottomBar.dart';
import 'package:ezayak/src/ui/widgets/myTopBar.dart';
import 'package:flutter/cupertino.dart';
import '../../app_constants.dart';
import '../AppLocalizations.dart';
import '../app_utils.dart';
import 'dart:io';
import 'package:dio/dio.dart';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class ChatBot extends StatefulWidget {
  final Set<void> Function() removeActions;

  ChatBot({this.removeActions});

  @override
  ChatBotState createState() => ChatBotState();
}

class ChatBotState extends State<ChatBot> implements ChatBotTokenContract {
 // InAppWebViewController webView;
  var isLoading = true;
  ChatBotTokenPresenter _presenter;
  ChatBotToken chatBotToken;

  String chatBotUrl;
  bool downloading = false;
  var progressString = "0%";
  String downloadStart = "...جاري التنزيل";

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  String downloadableUrl;

  String filePath;

  ChatBotState() {
    _presenter = ChatBotTokenPresenter(this);
  }

  @override
  void initState() {
    super.initState();
    if (widget.removeActions != null) {
      widget.removeActions();
    }


    _presenter.loadChatBotToken(this);
  }

  var error = '';

  Future<void> requestPermission() async {
    try {
      final status =  await Permission.storage.request();
      PermissionStatus _permissionStatus = status;
      if(_permissionStatus.isGranted){
        _openFile(downloadableUrl);
      }else if(_permissionStatus.isDenied){
        showError('من فضلك اسمح بالدخول للمساحة الداخلية من اعدادت الجهاز');
      }else if(_permissionStatus.isPermanentlyDenied){
          showError('من فضلك اسمح بالدخول للمساحة الداخلية من اعدادت الجهاز');
          AppSettings.openAppSettings();
      }
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'من فضلك اسمح للمساحة الداخلية بالدخول من اعدادت الجهاز';
      } else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error =
            'Permission denied - please ask the user to enable it from the app settings';
      }
      if (Platform.isIOS)
        showError('من فضلك اسمح للمساحة الداخلية بالدخول من اعدادت الجهاز');
    } catch (_) {
      if (Platform.isIOS)
        showError('من فضلك اسمح للمساحة الداخلية بالدخول من اعدادت الجهاز');

      return;
    }
  }

  Future<void> downloadFile(String url) async {
    Dio dio = Dio();
    setState(() {
      progressString = "0%";
      downloadStart = AppLocalizations.of(context).translate(Loading);
      downloading = true;
      _isDownloadContainerVisible = true;
    });
    try {
      await dio.download(url, filePath, onReceiveProgress: (rec, total) {
        logD("Rec: $rec , Total: $total");
        setState(() {
          progressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
        });
      });
    } catch (e) {
      logD(e);
    }

    setState(() {
      downloading = false;
      progressString = "";
      downloadStart = "";
      isBtnVisible = true;
    });
    logD("Download completed");
  }

  @override
  Widget build(BuildContext context) {
    return
      BaseScreen(
        bottomMargin: 0,

        scaffoldKey: scaffoldKey,
        topBar: MyTopBar(
          showBack: true,
        ),
        bottomBar: BottomBar(
          showProfile: true,
          showSos: true,
          callEmergency: true,
        ),
        child: _buildPageView(),
      );

  }

  double progress = 0;
  bool isBtnVisible = false;
  var _isDownloadContainerVisible = false;

  _buildPageView() {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Container(
            height: double.infinity,
            child: Column(
              children: <Widget>[
                Flexible(
                    child: Stack(
                  children: <Widget>[
                    Container(
                      child: chatBotUrl != null
                          ? buildChatbotWebView()
                          : Container(),
                    ),
                    ShowOrHideDownloadDialog()
                  ],
                )),
              ],
            ));
  }

  Widget buildChatbotWebView() {
/*
    return InAppWebView(
                            initialUrl: chatBotUrl,
                            initialHeaders: {},
                            initialOptions: InAppWebViewGroupOptions(
                              crossPlatform: InAppWebViewOptions(
                                  debuggingEnabled: true,
                                  useOnDownloadStart: true),
                            ),
                            onWebViewCreated:
                                (InAppWebViewController controller) {
                              webView = controller;
                            },
                            onLoadStart: (InAppWebViewController controller,
                                String url) {},
                            onLoadStop: (InAppWebViewController controller,
                                String url) {},
                            onProgressChanged:
                                (InAppWebViewController controller,
                                    int progress) {},
                            onDownloadStart: (controller, url) async {
                              if (mounted)
                                setState(() {
                                  downloadableUrl = url;
                                });
                              logD("onDownloadStart $url");

                              requestPermission();
                              //_openFile(downloadableUrl);
                            },
                          );
*/
                          
  }

  Widget ShowOrHideDownloadDialog() {
    return Visibility(
                    visible: _isDownloadContainerVisible,
                    child: Center(
                      child: Container(
                        height: 120,
                        width: 200,
                        child: Card(
                          color: VODA_WHITE,
                          child: Column(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.end,
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(Icons.close),
                                    onPressed: () {
                                      setState(() {
                                        _isDownloadContainerVisible =
                                            false;
                                        isBtnVisible = false;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              Expanded(
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      downloading
                                          ? Column(
                                              children: <Widget>[
                                                SizedBox(
                                                    height: 35,
                                                    width: 35,
                                                    child:
                                                        CircularProgressIndicator()),
                                                SizedBox(height: 8),
                                                RichText(
                                                  text: TextSpan(children: <
                                                      TextSpan>[
                                                    TextSpan(
                                                      text: "$progressString",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontFamily:
                                                              REGULAR_FONT),
                                                    ),
                                                    TextSpan(
                                                      text: downloadStart,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontFamily:
                                                              AR_VODAFONE_LIGHT),
                                                    ),
                                                  ]),
                                                ),
                                              ],
                                            )
                                          : Container(),
                                      Visibility(
                                        visible: isBtnVisible,
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              SMALL_BUTTON_WIDTH_PERCENTAGE,
                                          child: RaisedButton(
                                            color: VODA_RED,
                                            child: FittedBox(
                                              fit: BoxFit.fitWidth,
                                              child: Text(
                                                "افتح",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily:
                                                        AR_VODAFONE_MID),
                                              ),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _isDownloadContainerVisible =
                                                    false;
                                              });
                                              logD(filePath);
                                              _openFile(downloadableUrl);
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
  }

  void _openFile(String url) async {
    var dir;
    if (Platform.isAndroid) {
      dir = (await getExternalStorageDirectory())
          .path;
    } else {
      dir =
          (await getApplicationDocumentsDirectory())
              .path;
    }
    filePath =
    "$dir/${url.substring(url.lastIndexOf('/') + 1)}";
    logD("file path $filePath");
    File file = new File(filePath);
    var isExist = await file.exists();
    if (isExist) {
      logD('file exists----------');
      await OpenFile.open(filePath);
      setState(() {
        _isDownloadContainerVisible = false;
        isBtnVisible = false;
      });
    } else {
      logD('file does not exist----------');
      downloadFile(url);
    }
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
}
