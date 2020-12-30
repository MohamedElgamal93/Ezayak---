import 'package:ezayak/src/data/ResendPinCodeRepoSitory.dart';
import 'package:ezayak/src/data/ResendPinRepo.dart';
import 'package:ezayak/src/data/advice/advice.dart';
import 'package:ezayak/src/data/advice/advices_prod.dart';
import 'package:ezayak/src/data/authenticate_data.dart';
import 'package:ezayak/src/data/calendar/calednar_prod.dart';
import 'package:ezayak/src/data/calendar/calendar-mode.dart';
import 'package:ezayak/src/data/chatBotToken/chatBot_token.dart';
import 'package:ezayak/src/data/chatBotToken/chatBot_token_prod.dart';
import 'package:ezayak/src/data/familyData/family_data.dart';
import 'package:ezayak/src/data/familyData/family_data_mock.dart';
import 'package:ezayak/src/data/familyData/family_data_prod.dart';
import 'package:ezayak/src/data/login_data.dart';
import 'package:ezayak/src/data/login_repository.dart';
import 'package:ezayak/src/data/moods/mood.dart';
import 'package:ezayak/src/data/moods/moods_prod.dart';
import 'package:ezayak/src/data/user_family/add_member_repo.dart';
import 'package:ezayak/src/data/user_family/add_member_repository.dart';
import 'package:ezayak/src/data/user_family/edit_member_repo.dart';
import 'package:ezayak/src/data/user_family/edit_member_repository.dart';
import 'package:ezayak/src/data/webViewsModel/customWebView_data.dart';
import 'package:ezayak/src/data/webViewsModel/customWebView_data_mock.dart';
import 'package:ezayak/src/data/webViewsModel/customWebView_data_prod.dart';
import 'package:ezayak/src/error_localization/data/ErrorLocalRemoteDataSource.dart';
import 'package:ezayak/src/error_localization/data/ErrorLocalRepo.dart';
enum Flavor { MOCK, PROD }

//DI
class Injector {
  static final Injector _singleton = Injector._internal();
  static Flavor _flavor;

  static void configure(Flavor flavor) {
    _flavor = flavor;
  }

  factory Injector() {
    return _singleton;
  }

  Injector._internal();



  AuthenticateRepo get authenticateRepository {
    switch (_flavor) {
      default:
        return AuthenticateRepository();
    }
  }

  LoginRepo get loginRepository {
    switch (_flavor) {
      default:
        return LoginRepository();
    }
  }

  ResendPinRepo get resendPinRepository{
    switch (_flavor) {
      default:
        return ResendPinRepository();
    }
  }

  FamilyMemberRepository get familyMemberRepository {
     switch (_flavor) {
      case Flavor.MOCK:
        return new MockFamilyMemberRepository();
      default:
        return new ProdFamilyMemberRepository();
    }
   }
  CustomWebViewRepository get customWebViewRepository {
    switch (_flavor) {
      case Flavor.MOCK:
        return new MockCustomWebViewRepository();
      default:
        return new ProdCustomWebViewRepository();
    }
  }

  ErrorLocalRepo get getErrorLocalizationRepProvider {
    switch (_flavor) {
      default:
        return ErrorLocalRepo.getInstance(
            ErrorLocalRemoteDataSource.getInstance());
    }
  }

  AddMemberRepo get addMemberRepository {
    switch (_flavor) {
      default:
        return AddMemberRepository();
    }
  }

  EditMemberRepo get editMemberRepository {
    switch (_flavor) {
      default:
        return EditMemberRepository();
    }
  }

  AdvicesRepository get provideAdvicesRepo{
    switch(_flavor){
      default:
        return new ProdAdvicesRepository();
    }
  }

  MoodsRepository get provideMoodsRepo{
    switch(_flavor){
      default:
        return new ProdMoodsRepository();
    }
  }
   CalendarMoodRepository get provideCalendarMoodRepo{
    switch(_flavor){
      default:
        return  ProdCalendarMoodRepository();
    }
  }
  ChatBotTokenRepository get chatBotTokenRepo {
    switch(_flavor){
      default:
      return ProdChatBotTokenRepository();
    }
  }
}
