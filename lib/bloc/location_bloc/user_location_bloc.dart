// import 'package:flutter/foundation.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import 'package:daprot_v1/bloc/location_bloc/user_locaion_events.dart';
// import 'package:daprot_v1/bloc/location_bloc/user_location_state.dart';
//
// class LocationBloc extends Bloc<LocationEvent, LocationState> {
//   SharedPreferences preferences;
//   LocationBloc(
//     this.preferences,
//   ) : super(LocationInitialState()) {
//     on<GetLocationEvent>((event, emit) async {
//       await requestLocationPermission();
//       emit(LocationLoadingState());
//       try {
//         Position position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high,
//         );
//         Placemark? locality =
//             await fetchPlaceName(position.latitude, position.longitude);
//         emit(LocationLoadedState(locality));
//         preferences.setString('location', locality!.locality ?? "Belagavi");
//       } catch (e) {
//         emit(LocationErrorState('Error getting location: $e'));
//       }
//     });
//   }
//   // Fucntion to fetch the name of the place
//   Future<Placemark?> fetchPlaceName(double latitude, double longitude) async {
//     Placemark? place;
//     try {
//       List<Placemark> placemarks = await placemarkFromCoordinates(
//         latitude,
//         longitude,
//       );
//
//       if (placemarks.isNotEmpty) {
//         place = placemarks[0];
//       } else {
//         place = const Placemark(locality: 'Belagavi', country: 'India');
//       }
//     } catch (e) {
//       debugPrint(e.toString());
//     }
//     return place;
//   }
//
//   Future<void> requestLocationPermission() async {
//     PermissionStatus status = await Permission.location.status;
//     bool serviceEnabled;
//     LocationPermission? permission;
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (permission == LocationPermission.deniedForever) {
//       Fluttertoast.showToast(
//           msg:
//               'Location permissions are permanently denied, we cannot request permissions.');
//     }
//     if (!serviceEnabled) {
//       Fluttertoast.showToast(msg: 'Please enable Your Location Service');
//     }
//     if (status != PermissionStatus.granted) {
//       // Request location permission
//       status = await Permission.location.request();
//       if (status != PermissionStatus.granted) {
//         throw Exception('Location permission denied');
//       }
//     }
//   }
// }
