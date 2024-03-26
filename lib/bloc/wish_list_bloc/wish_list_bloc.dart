import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daprot_v1/data/product.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WishlistEvent {}

class AddProductEvent extends WishlistEvent {
  final Product product;

  AddProductEvent({required this.product});
}

class RemoveProductEvent extends WishlistEvent {
  final Product product;

  RemoveProductEvent({required this.product});
}

class WishlistState {
  final List<Product> wishlist;
  final bool loading;
  final bool error;

  WishlistState({
    this.wishlist = const [],
    this.loading = false,
    this.error = false,
  });

  WishlistState copyWith({
    List<Product>? wishlist,
    bool? loading,
    bool? error,
  }) {
    return WishlistState(
      wishlist: wishlist ?? this.wishlist,
      loading: loading ?? this.loading,
      error: error ?? this.error,
    );
  }
}

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  WishlistBloc() : super(WishlistState()) {
    on<AddProductEvent>((event, emit) async {
      print("Enter in the wish list bloc");
      emit(state.copyWith(loading: true));
      try {
        await _addToWishlist(event.product);
        emit(state.copyWith(wishlist: [...state.wishlist, event.product]));
      } catch (e) {
        print("Error Ocred $e");
        emit(state.copyWith(error: true));
      } finally {
        emit(state.copyWith(loading: false));
      }
    });

    on<RemoveProductEvent>((event, emit) async {
      emit(state.copyWith(loading: true));
      try {
        await _removeFromWishlist(event.product);
        final updatedWishlist = state.wishlist
            .where((p) => p.productId != event.product.productId)
            .toList();
        emit(state.copyWith(wishlist: updatedWishlist));
      } catch (e) {
        emit(state.copyWith(error: true));
      } finally {
        emit(state.copyWith(loading: false));
      }
    });
  }

  Future<void> _addToWishlist(Product product) async {
    final docRef = _firestore.collection('wishlists').doc(userId);
    final currentWishlist = await docRef.get();
    List<String> productIds = currentWishlist.exists
        ? (currentWishlist.data()!['products'] as List<String>).toList()
        : [];
    productIds.add(product.productId);
    await docRef.update({'products': productIds});
  }

  Future<void> _removeFromWishlist(Product product) async {
    final docRef = _firestore.collection('wishlists').doc(userId);
    final currentWishlist = await docRef.get();
    List<String> productIds =
        (currentWishlist.data()!['products'] as List<String>).toList();
    productIds.remove(product.productId);
    await docRef.update({'products': productIds});
  }
}
