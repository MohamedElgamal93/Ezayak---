import 'package:ezayak/src/error_localization/data/model/error_localization_data.dart';

abstract class ErrorLocalDataSource {
  Future<List<ErrorLocalization>> getErrorLocal();
}
