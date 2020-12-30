import 'package:ezayak/src/data/user_family/add_member.dart';

abstract class EditMemberRepo {
  Future<String> editMember(AddMember addMember, int userId);
}
