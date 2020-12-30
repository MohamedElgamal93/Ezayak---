import 'dart:convert';

class ChatBotToken {
  String token;
  String chatBotUrl;

  ChatBotToken({
    this.token,
  });
  ChatBotToken.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    chatBotUrl = json['chatBotUrl'];
  }
}

ChatBotToken getChatBotToken(String data) {
  if (json.decode(data) == null) {
    return null;
  }

  final dyn = json.decode(data);
  return ChatBotToken.fromJson(dyn);
}

abstract class ChatBotTokenRepository {
  Future<ChatBotToken> fetchChatBotToken();
}
