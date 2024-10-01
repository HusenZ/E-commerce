import 'package:gozip/domain/entities/shipping_address.dart';
import 'package:gozip/domain/entities/user_model.dart';
import 'package:gozip/data/repository/order_repo.dart';
import 'package:gozip/data/repository/user_data_repo.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class UserDetailsCard extends StatelessWidget {
  const UserDetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    UserModel? user;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<UserModel>(
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
                    uid: '');
              }
              return StreamBuilder<Shipping?>(
                  stream: UserOrderRepository().getShippingAddress(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (!snapshot.hasData) {
                      return const SizedBox();
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your Details',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8.0),
                        Text('Name: ${user!.name}'),
                        Text('Phone: ${user!.phNo}'),
                        const Divider(thickness: 1.0),
                        Text(
                          'Shipping Address',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        SizedBox(height: 1.h),
                        Text('PostalCode: ${snapshot.data!.postalCode}'),
                        SizedBox(height: 1.h),
                        Text('Country: ${snapshot.data!.country}'),
                        SizedBox(height: 1.h),
                        Text('City: ${snapshot.data!.city}'),
                        SizedBox(height: 1.h),
                        Text('Street Address: ${snapshot.data!.street}'),
                        SizedBox(height: 1.h),
                        Text('House n.o: ${snapshot.data!.houseNum}'),
                        SizedBox(height: 1.h),
                        Text('Phone n.o: ${snapshot.data!.phoneNumber}'),
                      ],
                    );
                  });
            }),
      ),
    );
  }
}
