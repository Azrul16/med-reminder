import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import 'firebase_options.dart';
import 'global_bloc.dart';
import 'pages/auth/splash_screen.dart';
import 'constants.dart';
import 'local_notification.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future selectNotification(String? payload) async {

}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();


  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  // Initialize timezone data
  await LocalNotification.init();

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (details) {
      selectNotification(details.payload);
    },
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GlobalBloc? globalBloc;

  @override
  void initState() {
    globalBloc = GlobalBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Provider<GlobalBloc>.value(
      value: globalBloc!,
      child: Sizer(builder: (context, orientation, deviceType) {
        return MaterialApp(
          builder: EasyLoading.init(),
          debugShowCheckedModeBanner: false,
          title: 'MedFlicks',
          theme: ThemeData.dark().copyWith(
            primaryColor: kPrimaryColor,
            scaffoldBackgroundColor: kScaffoldColor,
            appBarTheme: AppBarTheme(
              toolbarHeight: 7.h,
              backgroundColor: kScaffoldColor,
              elevation: 0,
              iconTheme: IconThemeData(
                color: kSecondaryColor,
                size: 20.sp,
              ),
              titleTextStyle: GoogleFonts.mulish(
                color: kTextColor,
                fontWeight: FontWeight.w800,
                fontSize: 16.sp,
              ),
            ),
            textTheme: TextTheme(
              displayLarge: TextStyle(
                fontSize: 28.sp,
                color: kSecondaryColor,
                fontWeight: FontWeight.w500,
              ),
              headlineMedium: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w800,
                color: kTextColor,
              ),
              headlineSmall: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w900,
                color: kTextColor,
              ),
              titleLarge: GoogleFonts.poppins(
                fontSize: 13.sp,
                color: kTextColor,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.0,
              ),
              titleMedium:
              GoogleFonts.poppins(fontSize: 15.sp, color: kPrimaryColor),
              titleSmall:
              GoogleFonts.poppins(fontSize: 12.sp, color: kTextLightColor),
              bodySmall: GoogleFonts.poppins(
                fontSize: 9.sp,
                fontWeight: FontWeight.w400,
                color: kTextLightColor,
              ),
              labelMedium: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
                color: kTextColor,
              ),
            ),
            inputDecorationTheme: const InputDecorationTheme(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: kTextLightColor, width: 0.7),
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: kTextLightColor),
              ),
              focusedBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: kPrimaryColor)),
            ),
            timePickerTheme: TimePickerThemeData(
              backgroundColor: kScaffoldColor,
              hourMinuteColor: kTextColor,
              hourMinuteTextColor: kScaffoldColor,
              dayPeriodColor: kTextColor,
              dayPeriodTextColor: kScaffoldColor,
              dialBackgroundColor: kTextColor,
              dialHandColor: kPrimaryColor,
              dialTextColor: kScaffoldColor,
              entryModeIconColor: kOtherColor,
              dayPeriodTextStyle: GoogleFonts.aBeeZee(fontSize: 8.sp),
            ),
          ),
          home: const SplashOrHome(),
        );
      }),
    );
  }
}


class SplashOrHome extends StatelessWidget {
  const SplashOrHome({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) =>  SplashScreen()),
      );
    });

    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
