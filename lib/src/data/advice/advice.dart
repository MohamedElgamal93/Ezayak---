class Advice{
  int id;
  String name;
  String icon;
  int type;

  Advice({this.id, this.name, this.icon,this.type});

  Advice.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    icon = json['icon'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['icon'] = this.icon;
    data['type'] = this.type;
    return data;
  }
}

abstract class AdvicesRepository {
  Future<List<Advice>> fetchAdvices(int memberId,int moodId,int date);
}