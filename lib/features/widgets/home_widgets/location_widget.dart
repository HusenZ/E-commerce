import 'package:daprot_v1/config/theme/colors_manager.dart';
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
  // Initial Selected Value
  String dropdownvalue = 'Current';

  // List of items in our dropdown menu
  var items = [
    'Current',
    'select city',
  ];
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 3.h, left: 4.w),
          child: const Text(
            "Location",
            style: TextStyle(color: Colors.black),
          ),
        ),
        const SizedBox(width: 12),
        Padding(
          padding: EdgeInsets.only(top: 3.h),
          child: DropdownButton(
            value: dropdownvalue,
            icon: const Icon(Icons.keyboard_arrow_down),
            items: items.map((String items) {
              return DropdownMenuItem(
                value: items,
                child: Text(items),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                dropdownvalue = value!;
              });
            },
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: ColorsManager.primaryColor),
            dropdownColor: ColorsManager.whiteColor,
            borderRadius: BorderRadius.circular(10.sp),
            elevation: 2,
            iconEnabledColor: ColorsManager.blackColor,
            iconDisabledColor: ColorsManager.hintTextColor,
          ),
        ),
        SizedBox(
          width: 15.h,
        ),
        const CircleAvatar(
          backgroundImage: AssetImage(
            'assets/images/dp.png',
          ),
        )
      ],
    );
  }
}
