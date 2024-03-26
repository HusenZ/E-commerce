import 'package:cached_network_image/cached_network_image.dart';
import 'package:daprot_v1/bloc/update_user_bloc/update_user_bloc.dart';
import 'package:daprot_v1/bloc/update_user_bloc/update_user_state.dart';
import 'package:daprot_v1/config/constants/app_images.dart';
import 'package:daprot_v1/config/theme/colors_manager.dart';
import 'package:daprot_v1/domain/model/user_model.dart';
import 'package:daprot_v1/domain/user_data_repo.dart';
import 'package:daprot_v1/features/screens/orders_screen.dart';
import 'package:daprot_v1/features/screens/update_profile_screen.dart';
import 'package:daprot_v1/features/widgets/common_widgets/single_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
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
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: 100,
                        height: 100,
                        color: Colors.white,
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Are you sure you want to logout?',
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: Text('Logout'),
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
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: Text('Stay'),
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
              if (!snapshot.hasData) {
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
                      leading: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 18, 0, 0),
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(Icons.arrow_back),
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 18.h,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: Card(
                            color: ColorsManager.whiteColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            elevation: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 22.w,
                                      height: 22.w,
                                      child: ClipOval(
                                        child: CachedNetworkImage(
                                          imageUrl: user!.imgUrl,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              Shimmer.fromColors(
                                            baseColor: Colors.grey[300]!,
                                            highlightColor: Colors.grey[100]!,
                                            child: Container(
                                              width: 17.w,
                                              color: Colors.white,
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5.w),
                                        child: Text(
                                          user!.name,
                                          style: TextStyle(
                                              fontSize: 24.sp,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5.w, vertical: 1.h),
                                        child: Text(
                                          "n orders in year",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                  fontSize: 14.sp,
                                                  color:
                                                      ColorsManager.greyColor),
                                        ),
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
                    SliverToBoxAdapter(
                        child: Column(
                      children: [
                        SizedBox(
                          height: 1.h,
                        ),
                        InkWell(
                          onTap: () {
                            print('UserName: ${user!.name}');
                            print('userPhone: ${user!.phNo}');
                            print('userEmail: ${user!.email}');
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdateProfileScreen(
                                  userId: user!.uid,
                                  profileImg: user!.imgUrl,
                                  userPhone: user!.phNo,
                                  userEmail: user!.email,
                                  userName: user!.name,
                                ),
                              ),
                            );
                          },
                          child: const DsingleChildCard(
                              title: "Personal Info",
                              image: AppImages.profileLogo),
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
                            image: AppImages.myOrdersLogo,
                          ),
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
                                title: "Log Out", image: AppImages.logoutLogo))
                      ],
                    ))
                  ],
                ),
              );
            });
      },
    );
  }
}
