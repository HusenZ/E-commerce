import 'package:cloud_firestore/cloud_firestore.dart' show DocumentSnapshot;

class Shop {
  final String cid;
  final String openTime;
  final String closeTime;
  final bool deliveryAvailable;
  final String location;
  final String shopName;
  final String ownerPhone;
  final String shopLogoPath;
  final String shopBannerPath;
  final double latitude;
  final double longitude;

  const Shop({
    required this.cid,
    required this.openTime,
    required this.closeTime,
    required this.deliveryAvailable,
    required this.location,
    required this.shopName,
    required this.ownerPhone,
    required this.shopLogoPath,
    required this.shopBannerPath,
    required this.latitude,
    required this.longitude,
  });

  // Create from a Firestore document
  factory Shop.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return Shop(
      cid: snapshot.get('cid'),
      openTime: snapshot.get('openTime'),
      closeTime: snapshot.get('closeTime'),
      deliveryAvailable: snapshot.get('dilivery'),
      location: snapshot.get('location'),
      shopName: snapshot.get('name'),
      ownerPhone: snapshot.get('phoneNo'),
      shopLogoPath: snapshot.get('shopLogo'),
      shopBannerPath: snapshot.get('shopImage'),
      latitude: snapshot.get('latitude'),
      longitude: snapshot.get('longitude'),
    );
  }
}
