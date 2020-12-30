
import 'package:ezayak/app_constants.dart';
import 'package:ezayak/dependency_injection.dart';
import 'package:ezayak/src/app_utils.dart';
import 'package:ezayak/src/data/chatBotToken/chatBot_token.dart';
import 'package:ezayak/src/data/error_data.dart';
import 'package:ezayak/src/ui/chatbot.dart';

abstract class ChatBotTokenContract {

  //void onLoadChatBotTokenComplete(ChatBotToken items);
 // void onLoadChatBotTokenError(ErrorResponse err);
}


class ChatBotTokenPresenter {

  ChatBotTokenContract _view;
  ChatBotTokenRepository _repository;

  ChatBotTokenPresenter(this._view) {
    _repository = new Injector().chatBotTokenRepo;
  }

  void loadChatBotToken(ChatBotState state){
    _repository.fetchChatBotToken()
        .then((c) => onLoadChatBotTokenComplete(c,state))
        .catchError(
            (onError) => onLoadChatBotTokenError(onError,state));
  }

  void onLoadChatBotTokenComplete(ChatBotToken items,ChatBotState state) {
    if (items != null) {
      state.chatBotToken = items;
    }
    logD('chatBotUrl is:'
        " ${state.chatBotToken.chatBotUrl}?uuid=${state.chatBotToken.token}");
    state.setState(() {
      state.isLoading = false;
      state.chatBotUrl = "${state.chatBotToken.chatBotUrl}?uuid=${state.chatBotToken.token}";
    });
  }

  void onLoadChatBotTokenError(ErrorResponse error,ChatBotState state) {
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

}