import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gozip/core/constants/app_icons.dart';
import 'package:gozip/core/constants/app_images.dart';
import 'package:gozip/core/theme/colors_manager.dart';
import 'package:gozip/utils/connectivity_helper.dart';
import 'package:gozip/utils/shop_data_repo.dart';
import 'package:gozip/presentation/screens/cart_screen.dart';
import 'package:gozip/presentation/screens/home_view.dart';
import 'package:gozip/presentation/screens/profile_screen.dart';
import 'package:gozip/presentation/screens/shops_screen.dart';
import 'package:gozip/presentation/widgets/common_widgets/welocme_dailog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedOption = "All";
  int _selectedIndex = 0;
  bool isConnected = false;
  ProductStream repo = ProductStream();
  TextEditingController locaitonController = TextEditingController();
  TextEditingController locality = TextEditingController();

  void notificationService() async {
    FirebaseMessaging fmessaging = FirebaseMessaging.instance;
    await fmessaging.requestPermission();
    await fmessaging.getToken().then(
      (value) {
        String userId = FirebaseAuth.instance.currentUser!.uid;
        var tokenValue = {'token': value};
        FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .collection('fcmToken')
            .doc('fcmdoc')
            .set(
              tokenValue,
              SetOptions(merge: true),
            );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    notificationService();
    checkConnecivity();
    checkUserVisit();
    getLocation();
  }

  void checkConnecivity() async {
    isConnected = await ConnectivityHelper.checkConnection();
  }

  void checkUserVisit() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool isNewUser = preferences.getBool('isNewUser') ?? false;
    if (!isNewUser) {
      WelcomeDailogue.showWelcomeDialog(context);
      preferences.setBool('isNewUser', true);
    }
  }

  void getLocation() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      locality.text = preferences.getString('location') ?? "Belagavi";
    });
  }

  /*Home section */

  final List _pages = [
    const HomeScreen(),
    const ShopsScreen(),
    const CartScreen(),
    const ProfileScreen(),
  ];

  // Handle bottom navigation item selection
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _selectedIndex == 0
          ? HomeView(locality: locality)
          : _pages[_selectedIndex],
      /*BOTTOM NAVIGATION BAR */
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage(AppIcons.home),
              color: ColorsManager.primaryColor,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage(AppIcons.shops),
              color: ColorsManager.primaryColor,
            ),
            label: 'Shops',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage(AppImages.cartLogo),
              color: ColorsManager.primaryColor,
            ),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outline_rounded,
              color: ColorsManager.primaryColor,
            ),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: ColorsManager.primaryColor,
        unselectedItemColor: ColorsManager.secondaryColor,
        unselectedLabelStyle:
            const TextStyle(color: ColorsManager.secondaryColor),
        onTap: _onItemTapped,
      ),
    );
  }
}
