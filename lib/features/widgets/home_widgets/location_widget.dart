import 'package:daprot_v1/bloc/location_bloc/user_locaion_events.dart';
import 'package:daprot_v1/bloc/location_bloc/user_location_bloc.dart';
import 'package:daprot_v1/bloc/location_bloc/user_location_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  String locationText = 'Current';

  @override
  void initState() {
    super.initState();
    context.read<LocationBloc>().add(GetLocationEvent());
  }

  // List of items in our dropdown menu
  var items = [
    'Current',
    'select city',
  ];
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LocationBloc, LocationState>(
      listener: (context, state) {
        if (state is LocationLoadingState) {
          locationText = 'Loading...';
        }
        if (state is LocationLoadedState) {
          // Use the current location if available
          locationText = state.placeName!;
          debugPrint(locationText);
        }
      },
      builder: (context, state) {
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
              child: SizedBox(
                width: 12.w,
                child: Text(
                  locationText,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontSize: 12.sp),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            SizedBox(
              width: 5.h,
            ),
            const CircleAvatar(
              backgroundImage: AssetImage(
                'assets/images/dp.png',
              ),
            )
          ],
        );
      },
    );
  }
}
