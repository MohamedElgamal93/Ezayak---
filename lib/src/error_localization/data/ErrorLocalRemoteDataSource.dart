import 'package:ezayak/src/error_localization/Service/GetErrorLocalService.dart';
import 'package:ezayak/src/error_localization/data/ErrorLocalDataSource.dart';
import 'package:ezayak/src/error_localization/data/model/error_localization_data.dart';

class ErrorLocalRemoteDataSource implements ErrorLocalDataSource {
  static ErrorLocalRemoteDataSource instance;

  ErrorLocalRemoteDataSource._();

  static ErrorLocalRemoteDataSource getInstance() {
    if (instance == null) {
      return ErrorLocalRemoteDataSource._();
    } else {
      return instance;
    }
  }

  @override
  Future<List<ErrorLocalization>> getErrorLocal() {
    return GetErrorLocalService().getErrorLocalization();
  }
}
