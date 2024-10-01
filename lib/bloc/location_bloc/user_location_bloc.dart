import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gozip/bloc/location_bloc/user_locaion_events.dart';
import 'package:gozip/bloc/location_bloc/user_location_state.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  SharedPreferences preferences;
  LocationBloc(this.preferences) : super(LocationInitialState()) {
    on<GetLocationEvent>((event, emit) async {
      bool granted = await _requestLocationPermission();
      emit(LocationLoadingState());
      if (!granted) {
        emit(LocationErrorState("Allow the permission to location"));
      }
      try {
        Position? position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low,
        );

        Placemark? locality =
            await fetchPlaceName(position.latitude, position.longitude);

        emit(LocationLoadedState(locality));
        preferences.setString('location', locality!.locality ?? "Belagavi");
      } catch (e) {
        emit(LocationErrorState('Error getting location: $e'));
      }
    });
  }
  // Fucntion to fetch the name of the place
  Future<Placemark?> fetchPlaceName(double latitude, double longitude) async {
    Placemark? place;
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isNotEmpty) {
        place = placemarks[0];
      } else {
        Position? lastPosition = await getLastKnownLocation();
        if (lastPosition != null) {
          placemarks = await placemarkFromCoordinates(
              lastPosition.latitude, lastPosition.longitude);
          place = placemarks[0];
        } else {
          place = const Placemark(locality: 'Belagavi', country: 'India');
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return place;
  }

  Future<bool> _requestLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Fluttertoast.showToast(msg: 'Please enable your Location Service');
      return false;
    }

    PermissionStatus status = await Permission.location.status;
    if (status == PermissionStatus.denied) {
      status = await Permission.location.request();
    }

    if (status == PermissionStatus.granted) {
      return true;
    } else {
      Fluttertoast.showToast(msg: 'Location permission denied.');
      return false;
    }
  }

  Future<Position?> getLastKnownLocation() async {
    try {
      Position? position = await Geolocator.getLastKnownPosition();
      return position;
    } catch (e) {
      // Handle errors, such as when location services are disabled or permissions are denied
      print('Error getting last known location: $e');
      return null;
    }
  }
}


/*
pub.dev

location
geocoding
geolocator

flutter toast
*/