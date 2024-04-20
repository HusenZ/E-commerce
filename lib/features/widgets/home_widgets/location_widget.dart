import 'package:daprot_v1/config/constants/app_icons.dart';
import 'package:daprot_v1/features/screens/wish_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class LocationWidget extends StatefulWidget {
  const LocationWidget({
    super.key,
  });

  @override
  State<LocationWidget> createState() => _LocationWidgetState();
}

class _LocationWidgetState extends State<LocationWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.all(8.sp),
          child: Text(
            "Hello",
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontSize: 14.sp),
          ),
        ),
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
