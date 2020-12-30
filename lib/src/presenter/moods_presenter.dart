import 'package:ezayak/dependency_injection.dart';
import 'package:ezayak/src/data/advice/advice.dart';
import 'package:ezayak/src/data/error_data.dart';
import 'package:ezayak/src/data/moods/mood.dart';

abstract class MoodsContract {

  void onLoadMoodsComplete(List<Moods> items);
  void onLoadMoodsError(ErrorResponse err);
}


class MoodsPresenter {

  MoodsContract _view;
  MoodsRepository _repository;

  MoodsPresenter(this._view) {
    _repository = new Injector().provideMoodsRepo;
  }

  void loadMoods(){
    _repository.fetchMoods()
        .then((c) => _view.onLoadMoodsComplete(c))
        .catchError(
            (onError) => _view.onLoadMoodsError(onError));
  }

}