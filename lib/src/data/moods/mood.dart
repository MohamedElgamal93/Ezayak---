
class Moods {
  int memberId;
  int lastMood;
  int memberType;
  String fullName;

  Moods({this.memberId, this.lastMood, this.fullName, this.memberType});

  Moods.fromJson(Map<String, dynamic> json) {
    memberId = json['memberId'];
    lastMood = json['lastMood'];
    memberType = json['memberType'];
    fullName = json['fullName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['memberId'] = this.memberId;
    data['lastMood'] = this.lastMood;
    data['memberType'] = this.memberType;
    data['fullName'] = this.fullName;
    return data;
  }
}

abstract class MoodsRepository {
  Future<List<Moods>> fetchMoods();
}