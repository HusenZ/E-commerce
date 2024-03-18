part of 'cart_bloc.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];

  get products => null;
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartAddSuccessState extends CartState {}

class CartRemoveSuccessState extends CartState {}

class CartLoaded extends CartState {
  @override
  final List<Product> products;

  const CartLoaded(this.products);

  @override
  List<Object> get props => [products];
}

class CartError extends CartState {
  final String message;

  const CartError({required this.message});

  @override
  List<Object> get props => [message];
}
