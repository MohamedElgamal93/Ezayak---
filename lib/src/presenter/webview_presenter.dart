import 'package:ezayak/app_constants.dart';
import 'package:ezayak/src/data/error_data.dart';
import 'package:ezayak/src/data/webViewsModel/customWebView_data.dart';
import 'package:ezayak/dependency_injection.dart';
import 'package:ezayak/src/ui/symptomsSlider.dart';
import 'package:li_webview/li_webview.dart';
import 'package:ezayak/src/app_utils.dart';
abstract class CustomWebViewListContract {

  //void onLoadCustomWebViewListComplete(List<CustomWebView> items);
 // void onLoadCustomWebViewListError(ErrorResponse err);
}


class CustomWebViewListPresenter {

  CustomWebViewListContract _view;
  CustomWebViewRepository _repository;

  CustomWebViewListPresenter(this._view) {
    _repository = new Injector().customWebViewRepository;
  }

  void loadCustomWebViews(int userId,SymptomsState state){

    if(state.widget.removeActions != null){
      state.widget.removeActions();
    }

    String actionToString = state.widget.actions.map((i) => i.toString()).join(",");
    logD( "actions : $actionToString");

    if (state.widget.type == 2) {
      state.widget.shouldShow = true;
    } else {
      state.widget.shouldShow = false;
    }

    state.isLoading = true;

    _repository.fetchCustomWebViewList(userId, actionToString)
        .then((c) => onLoadCustomWebViewListComplete(c,state))
        .catchError(
            (onError) => onLoadCustomWebViewListError(onError,state));
  }


  void onLoadCustomWebViewListError(ErrorResponse error,SymptomsState state) {
    state.setState(() {
      state.isLoading = false;
    });
    if (CODE_401 == error.code) {
      navigateToLogin(state.scaffoldKey, state.context);
    } else if (error.message == CODE_1) {
      state.showError('اتأكد انك واصل بالانترنت');
    } else if (error.message == CODE_2) {
      state.showError(
          'مشكلة في الوصول للسيرفر حاول مرة تانية' + LINE_BREAK + error.error);
    } else {
      state.showError(error.message != null
          ? error.message
          : error.key != null
          ? error.key
          : error.error != null ? error.error : "error");
    }
  }

  void onLoadCustomWebViewListComplete(List<CustomWebView> items,SymptomsState state) {
    state.setState(() {
      state.webviewsList = items;
      state.isLoading = false;
      logD("slider url: ${state.webviewsList[0].url}");

      for (var i = 0; i <= state.webviewsList.length; i++) {
        state.myItems.add(
            LiWebView(
              onWebCreated: (webController) {
                state.webController = webController;
                state.webController.loadUrl(state.webviewsList[i].url);
              },
            ));

      }
    });
  }

}