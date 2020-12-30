import 'package:ezayak/src/error_localization/data/ErrorLocalDataSource.dart';
import 'package:ezayak/src/error_localization/data/model/error_localization_data.dart';

class ErrorLocalRepo implements ErrorLocalDataSource {
  static ErrorLocalRepo _instance;
  ErrorLocalDataSource _errorLocalDataSource;

  ErrorLocalRepo._(this._errorLocalDataSource);

  static ErrorLocalRepo getInstance(ErrorLocalDataSource errorLocalDataSource) {
    if (_instance == null){
      return ErrorLocalRepo._(errorLocalDataSource);
  } else{
      return _instance;
    }
  }

  @override
  Future<List<ErrorLocalization>> getErrorLocal() {
    return _errorLocalDataSource.getErrorLocal();
  }
}
