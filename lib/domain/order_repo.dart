import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daprot_v1/domain/model/order_models.dart';
import 'package:daprot_v1/domain/model/shipping_address.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserOrderRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String userId = FirebaseAuth.instance.currentUser!.uid;

  Future<void> placeOrder(OrderModel order) async {
    try {
      await _firestore.collection('orders').add(order.toMap());
      await _firestore
          .collection('Users')
          .doc(userId)
          .collection('Orders')
          .add({
        'orderId': order.orderId,
      });
      await _firestore
          .collection('Users')
          .doc(userId)
          .collection('Cart')
          .where('productId', isEqualTo: order.productId)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.delete();
        });
      });
    } catch (e) {
      print('Error placing order: $e');
    }
  }

  Future<String?> getOrderId() async {
    try {
      var orderIdDoc = await _firestore
          .collection('Users')
          .doc(userId)
          .collection('Orders')
          .doc("PendingOrder")
          .get();
      String orderId = orderIdDoc['orderId'];
      print(orderId);
      return orderId;
    } catch (e) {
      return null;
    }
  }

  Future<void> putShippingAddress(Shipping address) async {
    try {
      await _firestore
          .collection("Users")
          .doc(userId)
          .collection('ShippingAddress')
          .add(address.toMap());
    } catch (e) {
      print('Error placing order: $e');
    }
  }

  Stream<String?> getOrderStatusStream(String orderId) {
    return FirebaseFirestore.instance
        .collection('orders')
        .where('orderId', isEqualTo: orderId)
        .snapshots()
        .map((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first['orderStatus'] as String?;
      } else {
        return null;
      }
    });
  }

  Stream<Shipping?> getShippingAddress() {
    return _firestore
        .collection("Users")
        .doc(userId)
        .collection('ShippingAddress')
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return null; // Return null if no shipping address found
      }
      final docData = snapshot.docs.first.data();
      return Shipping.fromMap(docData); // Convert to ShippingAddress
    });
  }
}
