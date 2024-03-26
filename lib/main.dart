import 'package:daprot_v1/bloc/auth_bloc/auth_bloc.dart';
import 'package:daprot_v1/bloc/cart_bloc/cart_bloc.dart';
import 'package:daprot_v1/bloc/location_bloc/user_location_bloc.dart';
import 'package:daprot_v1/bloc/update_user_bloc/update_user_bloc.dart';
import 'package:daprot_v1/bloc/wish_list_bloc/wish_list_bloc.dart';
import 'package:daprot_v1/config/app.dart';
import 'package:daprot_v1/firebase_options.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate();
  final preferences = await SharedPreferences.getInstance();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Color.fromARGB(0, 218, 40, 40),
    statusBarIconBrightness: Brightness.dark,
  ));
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) => AppBloc(preferences)),
      BlocProvider(create: (context) => UserUpdateBloc()),
      BlocProvider(create: (context) => LocationBloc()),
      BlocProvider(create: (context) => CartBloc()),
      BlocProvider(create: (context) => WishlistBloc()),
    ],
    child: MyApp(),
  ));
}
