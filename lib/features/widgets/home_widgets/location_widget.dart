import 'package:daprot_v1/config/constants/app_icons.dart';
import 'package:daprot_v1/domain/user_data_repo.dart';
import 'package:daprot_v1/features/screens/wish_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

class WishBarWidgets extends StatefulWidget {
  const WishBarWidgets({
    super.key,
  });

  @override
  State<WishBarWidgets> createState() => _WishBarWidgetsState();
}

class _WishBarWidgetsState extends State<WishBarWidgets> {
  UserDataManager userStream = UserDataManager();
  late String name;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        StreamBuilder(
            stream: userStream.streamUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Padding(
                  padding: EdgeInsets.all(8.sp),
                  child: Shimmer.fromColors(
                    baseColor: Colors.white,
                    highlightColor: Colors.grey,
                    child: Container(),
                  ),
                );
              }
              if (snapshot.data == null) {
                name = 'Sir';
              }
              return Padding(
                padding: EdgeInsets.all(8.sp),
                child: SizedBox(
                  width: 50.w,
                  child: Text(
                    "Hello ${snapshot.data!.name.split(' ').first}",
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontSize: 12.sp),
                  ),
                ),
              );
            }),
        const Spacer(),
        Container(
          height: 3.5.h,
          width: 3.5.h,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppIcons.notification),
            ),
          ),
        ),
        SizedBox(
          width: 2.h,
        ),
        Padding(
          padding: EdgeInsets.only(
            right: 3.w,
            left: 2.w,
          ),
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const WishlistScreen(),
              ));
            },
            child: Container(
              height: 3.5.h,
              width: 3.5.h,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AppIcons.favorite),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
