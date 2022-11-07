import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart';

class LocationManager {
  static final _manager = LocationManager._internal();
  factory LocationManager() => _manager;
  List<String> locations = [];
  StreamSubscription<Position>? subscription;
  GoogleMapsPlaces? places;

  LocationManager._internal(){
    const apiKey = 'AIzaSyCkd5yqcwf6eHR42WreN867H4VKdKoxaW0';
    places = GoogleMapsPlaces(apiKey: apiKey );
  }

  Future<Position> getCurrent() async {
    bool serviceEnable;
    LocationPermission permission;

    serviceEnable = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnable) {
      return Future.error('Location services are disable.');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location services are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions');
    }
    return await Geolocator.getCurrentPosition();
  }

  Future getDetailPosition(double lat, double long) async{
    final detail = await places?.searchNearbyWithRadius(Location(lat: lat, lng: long), 10);
    print(detail?.status);
    print(detail?.isDenied);
    print(detail?.isOverQueryLimit);
    print(detail?.isOkay);
    if(detail?.status == 'OK'){
      for(PlacesSearchResult result in detail?.results ?? []){
        print(result);
      }
    }else{

    }
  }

  Future<List<String>>searchByText(String text) async{
    final detail = await places?.searchByText(text,language: 'vi',region: 'vn');
    print(detail?.status);
    print(detail?.isDenied);
    print(detail?.isOverQueryLimit);
    print(detail?.isOkay);
    //locations.clear();
    List<String> loc = [];
    if(detail?.status == 'OK'){
      for(PlacesSearchResult result in detail?.results ?? []){
        print(result.name);
        //locations.add(result.name);
        loc.add(result.name);
        return loc;
      }
    }else{
      return [];
    }
    return [];
  }

  void listen(){
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );
    subscription = Geolocator.getPositionStream(locationSettings: locationSettings).listen((Position? position) {
      if(position==null){
        print('Unknown');
      }else{
        print('${position.latitude.toString()} ${position.longitude.toString()}');
      }
    });
  }

  void stop(){
    subscription?.cancel();
    subscription = null;
  }

}

final locationManager = LocationManager();
