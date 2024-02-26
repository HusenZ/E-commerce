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
        const Text(
          "Location",
          style: TextStyle(color: Colors.white),
        ),
        const SizedBox(width: 12),
        DropdownButton(
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
              .copyWith(color: ColorsManager.whiteColor),
          dropdownColor: ColorsManager.blackColor,
          borderRadius: BorderRadius.circular(10.sp),
          elevation: 2,
          iconEnabledColor: ColorsManager.whiteColor,
          iconDisabledColor: ColorsManager.hintTextColor,
        ),
        const SizedBox(
          width: 120,
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
