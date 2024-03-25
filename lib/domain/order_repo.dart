import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daprot_v1/domain/model/order_models.dart';

class UserOrderRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> placeOrder(OrderModel order) async {
    try {
      await _firestore.collection('orders').add(order.toMap());
    } catch (e) {
      print('Error placing order: $e');
    }
  }

  Stream<String?> getOrderStatusStream(String productId) {
    return FirebaseFirestore.instance
        .collection('orders')
        .where('productId', isEqualTo: productId)
        .snapshots()
        .map((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first['orderStatus'] as String?;
      } else {
        return null;
      }
    });
  }
}
