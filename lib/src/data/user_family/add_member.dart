import 'dart:convert';

class AddMember {
  String fullName;
  int city;
  int governorate;
  String gender;
  int age;
  String phoneNumber;
  int memberType;
  double longitude;
  double latitude;
  int lastSelectedMood;

  AddMember({this.fullName,
    this.city,
    this.governorate,
    this.gender,
    this.age,
    this.phoneNumber,
    this.memberType,
    this.longitude,
    this.latitude,this.lastSelectedMood});

  AddMember.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    city = json['city'];
    governorate = json['governorate'];
    gender = json['gender'];
    age = json['age'];
    phoneNumber = json['phoneNumber'];
    memberType = json['memberType'];
    longitude = json['longitude'];
    latitude = json['latitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fullName'] = this.fullName;
    data['city'] = this.city;
    data['governorate'] = this.governorate;
    data['gender'] = this.gender;
    data['age'] = this.age;
    data['phoneNumber'] = this.phoneNumber;
    data['memberType'] = this.memberType;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    return data;
  }
}

String postAddMember(List<AddMember> data) {
  List jsonList = List();
  data.map((item) => jsonList.add(item.toJson())).toList();
  return json.encode(jsonList);
}

String putEditMember(AddMember data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}
