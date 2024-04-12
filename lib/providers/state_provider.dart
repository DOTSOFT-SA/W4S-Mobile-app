import 'package:flutter/cupertino.dart';

class AppStateProvider extends ChangeNotifier {
  List isFetchingData = [];

  setFetchingDataState(state) {
    if (state) {
      isFetchingData.add(0);
    } else {
      isFetchingData.removeAt(isFetchingData.length - 1);
    }
    notifyListeners();
  }
}
