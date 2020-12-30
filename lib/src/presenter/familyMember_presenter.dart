import 'package:ezayak/app_constants.dart';
import 'package:ezayak/src/app_utils.dart';
import 'package:ezayak/src/data/error_data.dart';
import 'package:ezayak/src/data/familyData/family_data.dart';
import 'package:ezayak/dependency_injection.dart';
import 'package:ezayak/src/ui/ProfilesHomePage.dart';
abstract class FamilyMemberListViewContract {


 // void onLoadFamilyMembersComplete(List<FamilyMember> items);
 // void onLoadFamilyMembersError(ErrorResponse err);
  //void onDeleteFamilyMemberSuccess();
  //void onDeleteFamilyMemberError(ErrorResponse err);
 // void onDeleteProfileSuccess();
  //void onDeleteProfileError(ErrorResponse err);
}


class FamilyMemberListPresenter {

  FamilyMemberListViewContract _view;
  FamilyMemberRepository _repository;

  FamilyMemberListPresenter(this._view) {
    _repository = new Injector().familyMemberRepository;
  }

  void loadFamilyMembers(ProfilesHomePageState state){
    state.isLoading = true;
    state.deleted = false;
    state.isBtnDisable = true;
    _repository.fetchFamilyMembers()
              .then((c) => onLoadFamilyMembersComplete(c,state))
              .catchError(
            (onError) => onLoadFamilyMembersError(onError,state));
  }

  void onLoadFamilyMembersComplete(List<FamilyMember> items,ProfilesHomePageState state) {
   state.setState(() {
     state.isLoading = false;
     state.isBtnDisable = false;
     state.familyMemberList = items;
      for (var i = 0; i < state.familyMemberList.length; i++) {
        if (state.familyMemberList[i].memberType == 2) {
          state.membersArray.add(state.familyMemberList[i]);
        } else if (state.familyMemberList[i].memberType == 1) {
          state.memberId = state.familyMemberList[i].id;
          state.myProfile = state.familyMemberList[i];
        }
      }
    });
  }

  void onLoadFamilyMembersError(ErrorResponse error,ProfilesHomePageState state) {
    state.setState(() {
      state.isLoading = false;
    });
    if (CODE_401 == error.code) {
      navigateToLogin(state.scaffoldKey, state.context);
    } else if (error.message == CODE_1) {
      state.showError('اتأكد انك واصل بالانترنت');
    } else if (error.message == CODE_2) {
      state.showError(
          'مشكلة في الوصول للسيرفر حاول مرة تانية' + LINE_BREAK + error.error);
    } else {
      state.showError(error.message != null
          ? error.message
          : error.key != null
              ? error.key
              : error.error != null ? error.error : "error");
    }
  }


    void deleteFamilyMember(int memberId,ProfilesHomePageState state){
    _repository.deleteMember(memberId)
        .then((c) => onDeleteFamilyMemberSuccess(state))
        .catchError(
            (onError) => onDeleteFamilyMemberError(onError,state));
  }
  void onDeleteFamilyMemberSuccess(ProfilesHomePageState state) {
    state.setState(() {
      state.membersArray.clear();
    });
    loadFamilyMembers(state);
  }

  void onDeleteFamilyMemberError(ErrorResponse err,ProfilesHomePageState state) {
    state.showError(err.message);
  }

  void deleteProfile(int memberId,ProfilesHomePageState state){
    _repository.deleteProfile(memberId)
        .then((c) => onDeleteProfileSuccess(state))
        .catchError(
            (onError) => onDeleteProfileError(onError,state));
  }

  void onDeleteProfileError(ErrorResponse err,ProfilesHomePageState state) {
    state.showError(err.message);
  }


  void onDeleteProfileSuccess(ProfilesHomePageState state) {
    state.showSnackBar();
  }



}