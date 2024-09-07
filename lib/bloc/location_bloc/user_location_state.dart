// import 'package:daprot_v1/domain/model/shop_model.dart';
// import 'package:equatable/equatable.dart';
// import 'package:geocoding/geocoding.dart';

// abstract class LocationState extends Equatable {
//   @override
//   List<Object?> get props => [];
// }

// class LocationInitialState extends LocationState {}

// class LocationLoadingState extends LocationState {}

// class LocationLoadedState extends LocationState {
//   final Placemark? placeName;

//   LocationLoadedState(this.placeName);

//   @override
//   List<Object?> get props => [placeName];
// }

// class LocationErrorState extends LocationState {
//   final String error;

//   LocationErrorState(this.error);

//   @override
//   List<Object?> get props => [error];
// }

// class GetDistanceState extends LocationState {
//   final double distance;

//   GetDistanceState(this.distance);

//   @override
//   List<Object?> get props => [distance];
// }

// class NearbyShopsLoadingState extends LocationState {}

// class NearbyShopsLoadedState extends LocationState {
//   final List<Shop> nearbyShops;
//   NearbyShopsLoadedState(this.nearbyShops);
// }

// class NearbyShopsErrorState extends LocationState {
//   final String errorMessage;
//   NearbyShopsErrorState(this.errorMessage);
// }
