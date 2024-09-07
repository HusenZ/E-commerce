import 'package:equatable/equatable.dart';

abstract class LocationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetLocationEvent extends LocationEvent {}

class FetchNearbyShopsEvent extends LocationEvent {}
