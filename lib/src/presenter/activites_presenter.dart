import 'dart:ffi';

import 'package:ezayak/dependency_injection.dart';
import 'package:ezayak/src/data/advice/advice.dart';
import 'package:ezayak/src/data/error_data.dart';

abstract class ActivitiesContract {

  void onLoadAdvicesComplete(List<Advice> items);
  void onLoadAdvicesError(ErrorResponse err);
}


class ActivitiesPresenter {

  ActivitiesContract _view;
  AdvicesRepository _repository;

  ActivitiesPresenter(this._view) {
    _repository = new Injector().provideAdvicesRepo;
  }

  void loadAdvices(int memberId,int moodId,int date){
    _repository.fetchAdvices(memberId, moodId, date)
        .then((c) => _view.onLoadAdvicesComplete(c))
        .catchError(
            (onError) => _view.onLoadAdvicesError(onError));
  }

}