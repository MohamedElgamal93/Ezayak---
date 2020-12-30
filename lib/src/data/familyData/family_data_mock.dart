import 'dart:async';
import 'package:ezayak/src/data/user_family/add_member.dart';

import 'family_data.dart';

class MockFamilyMemberRepository implements  FamilyMemberRepository {
  @override
  Future<List<FamilyMember>> fetchFamilyMembers() {

    return new Future.value(familyMembersArray);
  }

  @override
  Future<int> deleteMember(int memberId) {
    // TODO: implement deleteMember
    return null;
  }

  @override
  Future<dynamic> deleteProfile(int memberId) {
    // TODO: implement deleteProfile
    return null;
  }

}

var familyMembersArray = <FamilyMember>[
//
//  FamilyMember(name: "eslam",age: 22,gender: "male",phoneNumber: 01000245800),
//  FamilyMember(name: "ali",age: 24,gender: "male",phoneNumber: 01000101010),
//  FamilyMember(name: "osama",age: 26,gender: "male",phoneNumber: 01000121212),

];