// import 'package:daprot_v1/bloc/location_bloc/user_locaion_events.dart';
// import 'package:daprot_v1/bloc/location_bloc/user_location_state.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:permission_handler/permission_handler.dart';

// class LocationBloc extends Bloc<LocationEvent, LocationState> {
//   LocationBloc() : super(LocationInitialState()) {
//     on<GetLocationEvent>((event, emit) async {
//       emit(LocationLoadingState());
//       await requestLocationPermission();
//       try {
//         Position position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high,
//         );
//         String? locality =
//             await fetchPlaceName(position.latitude, position.longitude);
//         emit(LocationLoadedState(locality));
//         // get the distance
//         debugPrint("${position.latitude} and ${position.longitude}");
//         double distance = await calculateDistance(
//           userLatitude: position.latitude,
//           userLongitude: position.longitude,
//           endLatitude: position.latitude,
//           endLongitude: position.longitude,
//         );
//         emit(GetDistanceState(distance));
//       } catch (e) {
//         emit(LocationErrorState('Error getting location: $e'));
//       }
//     });
//   }
//   // Fucntion to fetch the name of the place
//   Future<String?> fetchPlaceName(double latitude, double longitude) async {
//     String? name;
//     try {
//       List<Placemark> placemarks = await placemarkFromCoordinates(
//         latitude,
//         longitude,
//       );

//       if (placemarks.isNotEmpty) {
//         Placemark place = placemarks[0];
//         name = place.name;
//         debugPrint(
//             'Place Name: ${place.name}, ${place.locality}, ${place.country}');
//       } else {
//         debugPrint('No placemarks found');
//         name = '';
//       }
//     } catch (e) {
//       debugPrint(e.toString());
//     }
//     return name;
//   }

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

//   Future<double> calculateDistance({
//     required double userLatitude,
//     required double userLongitude,
//     required double endLatitude,
//     required double endLongitude,
//   }) async {
//     List<Placemark> startPlacemarks =
//         await placemarkFromCoordinates(userLatitude, userLongitude);
//     List<Placemark> endPlacemarks =
//         await placemarkFromCoordinates(endLatitude, endLongitude);
//     String startLocationName =
//         startPlacemarks.first.locality ?? 'Your Location';
//     String endLocationName =
//         endPlacemarks.first.locality ?? 'Restaurant Location';

//     double distance = Geolocator.distanceBetween(
//       userLatitude,
//       userLongitude,
//       endLatitude,
//       endLongitude,
//     );

//     debugPrint(
//         'Distance between $startLocationName and $endLocationName: $distance meters');

//     return distance / 1000;
//   }
// }
