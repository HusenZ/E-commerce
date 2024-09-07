import 'package:equatable/equatable.dart';

class WishlistState extends Equatable {
  const WishlistState();

  @override
  List<Object?> get props => throw UnimplementedError();
}

class WishListLoading extends WishlistState {}

class WishListSuccess extends WishlistState {}

class ItemExists extends WishlistState {}

class WishListFailure extends WishlistState {}
