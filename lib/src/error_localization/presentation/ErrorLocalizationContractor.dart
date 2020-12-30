import 'package:ezayak/dependency_injection.dart';
import 'package:ezayak/src/data/error_data.dart';
import 'package:ezayak/src/error_localization/data/ErrorLocalDataSource.dart';
import 'package:ezayak/src/error_localization/data/model/error_localization_data.dart';

abstract class ErrorLocalizationContractor {
  void onGetErrorLocalization(List<ErrorLocalization> errorLocalList);

  void onGetErrorLocalizationFailed(ErrorResponse err);
}

class ErrorLocalPresenter {
  ErrorLocalizationContractor _view;
  ErrorLocalDataSource _errorLocalDataSource;

  ErrorLocalPresenter(this._view) {
    _errorLocalDataSource = Injector().getErrorLocalizationRepProvider;
  }

  void getErrorLocalizationMessages() {
    _errorLocalDataSource
        .getErrorLocal()
        .then((errorMessages) => _view.onGetErrorLocalization(errorMessages))
        .catchError((err) => _view.onGetErrorLocalizationFailed(err));
  }
}
