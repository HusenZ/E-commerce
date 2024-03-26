import 'package:daprot_v1/data/product.dart';
import 'package:flutter/material.dart';

class WishlistItemCard extends StatelessWidget {
  final Product product;
  final VoidCallback onRemoveFromWishlist;

  const WishlistItemCard({
    super.key,
    required this.product,
    required this.onRemoveFromWishlist,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 4.0,
      child: Stack(
        children: [
          // Product image with rounded corners
          ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 200.0,
            ),
          ),
          // Gradient overlay for text content
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Product name with slightly larger font
                  Text(
                    product.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  // Price with smaller font
                  Text(
                    product.price,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  // Remove from wishlist button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove_circle, color: Colors.red),
                        onPressed: onRemoveFromWishlist,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
