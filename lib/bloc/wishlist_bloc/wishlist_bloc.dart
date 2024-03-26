// // wishlist_bloc.dart

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:daprot_v1/data/product.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class WishlistEvent {}

// class AddProductToWishlist extends WishlistEvent {
//   final Product product;

//   AddProductToWishlist(this.product);
// }

// class RemoveProductFromWishlist extends WishlistEvent {
//   final Product product;

//   RemoveProductFromWishlist(this.product);
// }

// class WishlistState {}

// class WishlistLoading extends WishlistState {}

// class WishlistLoaded extends WishlistState {
//   final List<Product> products;

//   WishlistLoaded(this.products);
// }

// class WishlistError extends WishlistState {
//   final String message;

//   WishlistError(this.message);
// }

// class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
//   final FirebaseFirestore _firestore;

//   WishlistBloc(this._firestore) : super(WishlistLoading()) {
//     on<AddProductToWishlist>((event, emit) async {
//       try {
//         _firestore.collection("WishList").doc(FirebaseAuth.instance.currentUser!.uid).set({});
//         emit(WishlistLoaded([state.products, event.product]));
//       } catch (e) {
//         emit(WishlistError(e.toString()));
//       }
//     });

//     on<RemoveProductFromWishlist>((event, emit) async {
//       try {
//         // Remove product from Firestore wishlist (implement logic here)
//         final products = state.products.where((p) => p != event.product).toList();
//         emit(WishlistLoaded(products));
//       } catch (e) {
//         emit(WishlistError(e.toString()));
//       }
//     });
//   }
// }
