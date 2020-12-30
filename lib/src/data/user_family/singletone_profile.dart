import 'package:ezayak/src/data/user_family/add_member.dart';

class Session {
  // singleton
  static final Session _singleton = Session._internal();

  Session._internal();

  static Session get shared => _singleton;

  List<AddMember> memberList;

  factory Session(List<AddMember> memberList) {
    _singleton.memberList = memberList;
    return _singleton;
  }
}
