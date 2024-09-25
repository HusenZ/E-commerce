import 'package:cloud_firestore/cloud_firestore.dart' show DocumentSnapshot;

class Shop {
  final String cid;
  final String openTime;
  final String closeTime;
  final bool deliveryAvailable;
  final String location;
  final String shopName;
  final String shopLogoPath;
  final String shopBannerPath;
  final String address;

  const Shop({
    required this.cid,
    required this.openTime,
    required this.closeTime,
    required this.deliveryAvailable,
    required this.location,
    required this.shopName,
    required this.shopLogoPath,
    required this.shopBannerPath,
    required this.address,
  });

  // Create from a Firestore document
  factory Shop.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return Shop(
      cid: snapshot.get('cid'),
      openTime: snapshot.get('openTime'),
      closeTime: snapshot.get('closeTime'),
      deliveryAvailable: snapshot.get('dilivery'),
      location: snapshot.get('address'),
      shopName: snapshot.get('name'),
      shopLogoPath: snapshot.get('shopLogo'),
      shopBannerPath: snapshot.get('shopImage'),
      address: snapshot.get('location'),
    );
  }
}
