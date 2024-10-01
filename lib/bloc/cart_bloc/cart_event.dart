part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class AddToCart extends CartEvent {
  final Product product;

  const AddToCart(this.product);

  @override
  List<Object> get props => [product];
}

class CheckCartEvent extends CartEvent {
  final String productID;

  const CheckCartEvent(this.productID);

  @override
  List<Object> get props => [productID];
}

class RemoveFromCart extends CartEvent {
  final String cartItemId;

  const RemoveFromCart(this.cartItemId);

  @override
  List<Object> get props => [cartItemId];
}

class LoadCart extends CartEvent {}
