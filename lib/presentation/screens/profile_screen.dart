import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gozip/bloc/update_user_bloc/update_user_bloc.dart';
import 'package:gozip/bloc/update_user_bloc/update_user_state.dart';
import 'package:gozip/core/constants/app_icons.dart';
import 'package:gozip/core/routes/routes_manager.dart';
import 'package:gozip/core/theme/colors_manager.dart';
import 'package:gozip/domain/entities/user_model.dart';
import 'package:gozip/domain/repository/user_data_repo.dart';
import 'package:gozip/presentation/screens/orders_screen.dart';
import 'package:gozip/presentation/screens/update_profile_screen.dart';
import 'package:gozip/presentation/screens/wish_list_screen.dart';
import 'package:gozip/presentation/widgets/common_widgets/single_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
  }

  void _showLogoutDialog(BuildContext context, String imageUrl, String name) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: ColorsManager.whiteColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Goodbye, $name',
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                ClipOval(
                  child: Icon(
                    Icons.person_pin,
                    size: 66.sp,
                    color: ColorsManager.primaryColor,
                  ),
                ),
                SizedBox(height: 2.h),
                const Text(
                  'Are you sure you want to logout?',
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 2.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsManager.accentColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: Text(
                        'Logout',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: ColorsManager.whiteColor),
                      ),
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        final preferences =
                            await SharedPreferences.getInstance();
                        preferences.setBool('isAuthenticated', false);
                        Navigator.of(context).pop();
                        Navigator.of(context).pushReplacementNamed('/login');
                      },
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsManager.secondaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: Text(
                        'Stay',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: ColorsManager.whiteColor),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    UserModel? user;
    return BlocBuilder<UserUpdateBloc, UserUpdateState>(
      builder: (BuildContext context, UserUpdateState state) {
        return StreamBuilder<UserModel>(
            stream: UserDataManager().streamUser(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                user = snapshot.data;
              }
              if (snapshot.data == null) {
                debugPrint('!! Snapshot is not having data !!');
                user = UserModel(
                    name: 'name',
                    email: 'email',
                    phNo: 'phNo',
                    imgUrl: 'profilePhoto',
                    uid: FirebaseAuth.instance.currentUser!.uid);
              }
              return Scaffold(
                body: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      automaticallyImplyLeading: false,
                      pinned: true,
                      backgroundColor: ColorsManager.whiteColor,
                      expandedHeight: 8.h,
                      title: Padding(
                        padding: const EdgeInsets.only(top: 18.0),
                        child: Text(
                          'Profile',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 18.h,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: AnimationConfiguration.synchronized(
                            child: SlideAnimation(
                              duration: const Duration(milliseconds: 375),
                              child: Card(
                                color: ColorsManager.whiteColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                elevation: 1,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 22.w,
                                          height: 22.w,
                                          child: ClipOval(
                                            child: Icon(
                                              Icons.person_pin,
                                              size: 66.sp,
                                              color: ColorsManager.primaryColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20.h,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 5.w),
                                            child: SizedBox(
                                              width: 50.w,
                                              child: Text(
                                                user!.name,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: 14.sp,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 5.w, vertical: 1.h),
                                            child: StreamBuilder(
                                                stream: FirebaseFirestore
                                                    .instance
                                                    .collection('Users')
                                                    .doc(FirebaseAuth.instance
                                                        .currentUser!.uid)
                                                    .collection('Orders')
                                                    .snapshots(),
                                                builder: (context, snapshot) {
                                                  if (!snapshot.hasData) {
                                                    return Text(
                                                      "Will be Updated Soon",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium!
                                                          .copyWith(
                                                              fontSize: 10.sp,
                                                              color: ColorsManager
                                                                  .greyColor),
                                                    );
                                                  }
                                                  print(snapshot.data);
                                                  return Text(
                                                    "${snapshot.data!.size} orders in a year",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium!
                                                        .copyWith(
                                                            fontSize: 14.sp,
                                                            color: ColorsManager
                                                                .greyColor),
                                                  );
                                                }),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                        child: AnimationConfiguration.synchronized(
                      duration: const Duration(milliseconds: 375),
                      child: SlideAnimation(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 1.h,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UpdateProfileScreen(
                                      userId: user!.uid,
                                      userPhone: user!.phNo,
                                      userEmail: user!.email,
                                      userName: user!.name,
                                    ),
                                  ),
                                );
                              },
                              child: const DsingleChildCard(
                                  title: "Personal Info",
                                  image: AppIcons.profileIcon),
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                            InkWell(
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const WishlistScreen(),
                                ),
                              ),
                              child: const DsingleChildCard(
                                title: "My WishList",
                                image: AppIcons.favorite,
                              ),
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                            InkWell(
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const OrderScreen(),
                                ),
                              ),
                              child: const DsingleChildCard(
                                title: "My orders",
                                image: AppIcons.ordersIcon,
                              ),
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                            InkWell(
                              onTap: () => Navigator.of(context)
                                  .pushNamed(Routes.privacyRoute),
                              child: const DsingleChildCard(
                                title: "Privacy & Policy",
                                image: AppIcons.privacyIcon,
                              ),
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                            InkWell(
                              onTap: () => Navigator.of(context)
                                  .pushNamed(Routes.termsRoute),
                              child: const DsingleChildCard(
                                title: "Terms & Conditions",
                                image: AppIcons.termsIcon,
                              ),
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                            InkWell(
                              onTap: () => Navigator.of(context)
                                  .pushNamed(Routes.support),
                              child: const DsingleChildCard(
                                  title: "Customer support",
                                  image: AppIcons.customerSupport),
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                            InkWell(
                              onTap: () async {
                                _showLogoutDialog(
                                    context, user!.imgUrl, user!.name);
                              },
                              child: const DsingleChildCard(
                                  title: "Log Out", image: AppIcons.logoutIcon),
                            )
                          ],
                        ),
                      ),
                    ))
                  ],
                ),
              );
            });
      },
    );
  }
}
