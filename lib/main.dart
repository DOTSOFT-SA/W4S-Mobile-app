import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wear4safe/helpers/colors.dart';
import 'package:wear4safe/pages/splash_page.dart';
import 'package:wear4safe/providers/alerts_provider.dart';
import 'package:wear4safe/providers/assigned_provider.dart';
import 'package:wear4safe/providers/menu_provider.dart';
import 'package:wear4safe/providers/profession_provider.dart';
import 'package:wear4safe/providers/sos_provider.dart';
import 'package:wear4safe/providers/state_provider.dart';
import 'package:wear4safe/providers/user_provider.dart';
import 'package:wear4safe/providers/weather_provider.dart';
import 'package:wear4safe/services/fetch_data_service.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestPermission();

  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.black,
  ));
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => UserProvider()),
    ChangeNotifierProvider(create: (_) => MenuProvider()),
    ChangeNotifierProvider(create: (_) => ProfessionProvider()),
    ChangeNotifierProvider(create: (_) => AssignedSensorsProvider()),
    ChangeNotifierProvider(create: (_) => AlertsProvider()),
    ChangeNotifierProvider(create: (_) => AppStateProvider()),
    ChangeNotifierProvider(create: (_) => WeatherProvider()),
    ChangeNotifierProvider(create: (_) => SOSProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    fetchData(context);
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        useInheritedMediaQuery: true,
        builder: (BuildContext context, Widget? child) {
          return MaterialApp(
            navigatorKey: navigatorKey, // important
            color: Palette.mainBlackColor,
            debugShowCheckedModeBanner: false,
            home: const Splash(),
          );
        });
  }
}
