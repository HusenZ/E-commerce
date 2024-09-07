import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:gozip/bloc/cart_bloc/cart_bloc.dart';
import 'package:gozip/bloc/google_auth_bloc/googe_auth_bloc.dart';
import 'package:gozip/bloc/review_bloc/add_review_bloc.dart';
import 'package:gozip/bloc/update_user_bloc/update_user_bloc.dart';
import 'package:gozip/bloc/wish_list_bloc/wish_list_bloc.dart';
import 'package:gozip/config/app.dart';
import 'package:gozip/firebase_options.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  String? title = message.notification!.title;
  String? body = message.notification!.body;
  print("$title, $body");
  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 123,
      channelKey: 'high_importance_channel_userapp',
      color: Colors.white,
      category: NotificationCategory.Event,
      wakeUpScreen: true,
    ),
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await FirebaseAppCheck.instance.activate();
  AwesomeNotifications().initialize(null, [
    NotificationChannel(
      channelKey: 'high_importance_channel_userapp',
      channelName: 'default_notification_channel_id',
      channelDescription: 'channelDescription',
      importance: NotificationImportance.Max,
      locked: true,
      ledColor: Colors.white,
      defaultRingtoneType: DefaultRingtoneType.Notification,
      channelShowBadge: true,
      enableVibration: true,
      onlyAlertOnce: true,
    )
  ]);

  final preferences = await SharedPreferences.getInstance();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Color.fromARGB(0, 218, 40, 40),
    statusBarIconBrightness: Brightness.dark,
  ));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) => UserUpdateBloc()),
      BlocProvider(create: (context) => GoogleSignInBloc(preferences)),
      BlocProvider(create: (context) => CartBloc()),
      BlocProvider(create: (context) => WishlistBloc()),
      BlocProvider(create: (context) => ProductReviewBloc()),
    ],
    child: MyApp(),
  ));
}
