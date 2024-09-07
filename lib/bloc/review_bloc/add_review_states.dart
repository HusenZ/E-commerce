abstract class ProductReviewState {}

class ProductReviewInitial extends ProductReviewState {}

class ProductReviewLoading extends ProductReviewState {}

class ProductReviewSuccess extends ProductReviewState {}

class ProductReviewFailure extends ProductReviewState {
  final String error;

  ProductReviewFailure(this.error);
}
