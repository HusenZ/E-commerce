import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gozip/domain/entities/order_models.dart';
import 'package:gozip/domain/entities/shipping_address.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:gozip/domain/repository/new_fcm.dart';
import 'package:http/http.dart' as http;

class UserOrderRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String userId = FirebaseAuth.instance.currentUser!.uid;
  static FirebaseMessaging fmessaging = FirebaseMessaging.instance;

  static Future<bool> sendFcmMessage(
    String title,
    String message,
    String? sellerFcmToken,
  ) async {
    try {
      var url = 'https://fcm.googleapis.com/fcm/send';
      var header = {
        "Content-Type": "application/json",
        "Authorization":
            "key=AAAAMVCKqmI:APA91bGVWUfB8ixjD0S17O1g_f20vwmDjjvI4yRymNvOKmAVajqjQEox4UfFzYefq3o31fnt9k5ujyqA-SV8PNb5FWvvcNhe67vKa0Npa6FN2MSXHG8_yIZSimf3UWNrrQgU6G1n_j7r",
      };
      var request = {
        "notification": {
          "title": title,
          "body": message,
          "sound": "default",
          "color": "#990000",
        },
        "priority": "high",
        "to": "$sellerFcmToken",
      };

      var response = await http.post(Uri.parse(url),
          headers: header, body: json.encode(request));

      print(response.body);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> placeOrder(OrderModel order) async {
    String? sellerFcmToken;
    try {
      await _firestore.collection('orders').add(order.toMap());
      await _firestore
          .collection('Users')
          .doc(userId)
          .collection('Orders')
          .add({
        'orderId': order.orderId,
      });
      final shopdoc =
          await _firestore.collection('Shops').doc(order.shopId).get();

      sellerFcmToken = shopdoc['fcmToken'];

      await fmessaging.requestPermission();

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
      try {
        // sendFcmMessage(
        //   'New Order Arrived',
        //   'Hurry up!! Process the order, your customer is waiting.',
        //   sellerFcmToken,
        // );

        /// new method
        PushNotificationService.sendNotificationToSelectedUser(
            sellerFcmToken!,
            order.orderId,
            'New Order Arrived',
            'Hurry up!! Process the order, your customer is waiting.');
      } catch (e) {
        print("error in push notification :------> $e");
      }
    } catch (e) {
      print('Error placing order: $e');
    }
  }

  Future<void> requestCancel(
    String orderId,
    String shopId,
    String reason,
  ) async {
    String? sellerFcmToken;
    try {
      print("Order Id : $orderId..... Reason: $reason");
      try {
        var doc = await _firestore
            .collection('orders')
            .where('orderId', isEqualTo: orderId)
            .get();
        doc.docs.first.reference.update({"cancellationReason": reason});
      } catch (e) {
        print("Error is in placing the new doc------> $e");
      }

      final shopdoc = await _firestore.collection('Shops').doc(shopId).get();
      sellerFcmToken = shopdoc['fcmToken'];
      await fmessaging.requestPermission();

      final doc = await _firestore
          .collection('Users')
          .doc(userId)
          .collection('fcmToke')
          .get();
      print(doc.size);

      try {
        PushNotificationService.sendNotificationToSelectedUser(
            sellerFcmToken!,
            orderId,
            'Requested For Cancellation',
            'Process the order, your customer is waiting.');
      } catch (e) {
        print("error in push notification :------> $e");
      }
    } catch (e) {
      print('Error cancelling order: $e');
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

  Future<void> updateShippingAddress(Shipping address) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshots = await _firestore
          .collection("Users")
          .doc(userId)
          .collection('ShippingAddress')
          .get();
      snapshots.docs.first.reference.update(address.toMap());
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
