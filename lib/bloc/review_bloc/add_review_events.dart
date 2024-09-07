abstract class ProductReviewEvent {}

class AddReviewEvent extends ProductReviewEvent {
  final String productId;
  final double rating;
  final String review;

  AddReviewEvent({
    required this.productId,
    required this.rating,
    required this.review,
  });
}
