import 'dart:async';

class FamilyMember {
  int id;
  String fullName;
  Map<String,dynamic>  city;
  Map<String,dynamic> governorate;
  String gender;
  int age;
  String phoneNumber;
  int memberType;
  double longitude;
  double latitude;
  int lastSelectedMood;

  FamilyMember({
    this.id,
    this.fullName,
    this.city,
    this.governorate,
    this.gender,
    this.age,
    this.phoneNumber,
    this.memberType,
    this.longitude,
    this.latitude});

//  FamilyMember.fromMap(Map<String,dynamic> map)
//  :
//        fullName = map['fullName'],
//  city = map['city'],
//  governorate = map['governorate'],
//  gender = map['gender'],
//  age = map['age'],
//  phoneNumber = map['phoneNumber'],
//  memberType = map['memberType'],
//  longitude = map['longitude'],
//  latitude = map['latitude'];

  FamilyMember.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    id = json['id'];
    city = json['city'];
    governorate = json['governorate'];
    gender = json['gender'];
    age = json['age'];
    phoneNumber = json['phoneNumber'];
    memberType = json['memberType'];
    longitude = json['longitude'];
    latitude = json['latitude'];
  }

}

abstract class FamilyMemberRepository {
  Future<List<FamilyMember>> fetchFamilyMembers();
  Future<int> deleteMember(int memberId);
  Future<dynamic> deleteProfile(int memberId);
}

class FetchDataExeption implements Exception {
  final _message;

  FetchDataExeption([this._message]);

  String toString() {
    if (_message == null) return "Exception";
    return "Exception: $_message";
  }
}



class Governorate {

int govId;
String governorateName;


}

class City {

  int cityId;
  String cityName;




}
