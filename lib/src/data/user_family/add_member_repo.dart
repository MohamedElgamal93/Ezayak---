import 'package:ezayak/src/data/user_family/add_member.dart';
import 'package:ezayak/src/data/user_family/get_cities.dart';
import 'package:ezayak/src/data/user_family/get_governorates.dart';

abstract class AddMemberRepo {
  Future<List<GetGovernorates>> fetchGovernorates();

  Future<List<GetCities>> fetchCities(int governoratesId);

  Future<int> addMember(List<AddMember> addMember);
}
