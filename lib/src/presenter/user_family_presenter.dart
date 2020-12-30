import 'package:ezayak/src/data/error_data.dart';
import 'package:ezayak/src/data/user_family/add_member.dart';
import 'package:ezayak/src/data/user_family/add_member_repository.dart';
import 'package:ezayak/src/data/user_family/edit_member_repository.dart';
import 'package:ezayak/src/data/user_family/get_cities.dart';
import 'package:ezayak/src/data/user_family/get_governorates.dart';

import '../../dependency_injection.dart';

abstract class UserFamilyContract {
  void onLoadCitiesComplete(List<GetCities> response);

  void onLoadCitiesError(ErrorResponse error);

  void onLoadGovernoratesComplete(List<GetGovernorates> response);

  void onLoadGovernoratesError(ErrorResponse error);

  void onLoadAddMemberComplete(int statusCode);

  void onLoadAddMemberError(ErrorResponse error);
}

abstract class UserFamilyEditContract {
  void onLoadEditMemberComplete(String modifyId);

  void onLoadEditMemberError(ErrorResponse error);
}
class UserFamilyPresenter {
  UserFamilyContract _view;
  AddMemberRepository _repository;

  UserFamilyPresenter(this._view) {
    _repository = new Injector().addMemberRepository;
  }

  void loadCities(int governoratesId) {
    _repository
        .fetchCities(governoratesId)
        .then((c) => _view.onLoadCitiesComplete(c))
        .catchError((onError) => _view.onLoadCitiesError(onError));
  }

  void loadGovernorates() {
    _repository
        .fetchGovernorates()
        .then((c) => _view.onLoadGovernoratesComplete(c))
        .catchError((onError) => _view.onLoadGovernoratesError(onError));
  }

  void loadAddMember(List<AddMember> addMember) {
    _repository
        .addMember(addMember)
        .then((c) => _view.onLoadAddMemberComplete(c))
        .catchError((onError) => _view.onLoadAddMemberError(onError));
  }
}

class UserFamilyEditPresenter {
  UserFamilyEditContract _viewEdit;
  EditMemberRepository _repositoryEdit;

  UserFamilyEditPresenter(this._viewEdit) {
    _repositoryEdit = new Injector().editMemberRepository;
  }

  void loadEditMember(AddMember addMember, int userId) {
    _repositoryEdit
        .editMember(addMember, userId)
        .then((c) => _viewEdit.onLoadEditMemberComplete(c))
        .catchError((onError) => _viewEdit.onLoadEditMemberError(onError));
  }
}
