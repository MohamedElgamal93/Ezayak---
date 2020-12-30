class CustomWebView {
  int id;
  String url;
  int actionId;

  CustomWebView({this.id, this.url, this.actionId});

  CustomWebView.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
    actionId = json['actionId'];
  }

}

abstract class CustomWebViewRepository {
  Future<List<CustomWebView>> fetchCustomWebViewList(int userId,String actions);
}

class FetchDataExeption implements Exception {
  final _message;

  FetchDataExeption([this._message]);

  String toString() {
    if (_message == null) return "Exception";
    return "Exception: $_message";
  }
}