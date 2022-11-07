import 'dart:async';

import 'package:flutterhw15/services/location_manager.dart';
import 'package:flutterhw15/services/shared_preference_manager.dart';

class LocationBloc {
  final _locationStreamController = StreamController<List<String>>.broadcast();
  Stream<List<String>> get locationStream => _locationStreamController.stream;
  List<String> locations = [];
  getLocation(String value) async {
    //locations.addAll();
    if(value==''){
      clearLocation();
    }
    clearLocation();
    sharedPrefs.init();
    var locs = await sharedPrefs.getStringList(value);
    print('locs $locs');
    if (locs == null) {
      clearLocation();
      locations.addAll(await locationManager.searchByText(value));
      sharedPrefs.setStringList(value, locations);
      _locationStreamController.add(locations);
    } else {
      clearLocation();
      locations.addAll(locs);
      _locationStreamController.add(locations);
    }
    //_locationStreamController.add(locations);
  }

  clearLocation() {
    locations.clear();
    _locationStreamController.add([]);
  }
}

var locationBloc = LocationBloc();
