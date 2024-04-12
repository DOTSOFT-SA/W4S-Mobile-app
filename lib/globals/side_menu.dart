import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wear4safe/helpers/colors.dart';
import 'package:wear4safe/helpers/sizer_utils.dart';
import 'package:wear4safe/main.dart';
import 'package:wear4safe/pages/alerts_page.dart';
import 'package:wear4safe/pages/sos_page.dart';
import 'package:wear4safe/pages/weather_page.dart';
import 'package:wear4safe/pages/workers_page.dart';
import 'package:wear4safe/providers/menu_provider.dart';
import 'package:wear4safe/providers/state_provider.dart';
import 'package:wear4safe/providers/user_provider.dart';

import '../helpers/assets.dart';
import '../pages/assignment_history_page.dart';
import '../pages/sensors_page.dart';

Function logOut = (index, context) {
  Provider.of<MenuProvider>(context, listen: false).setCurrentMenuIndex(index);
  Provider.of<MenuProvider>(context, listen: false).logOutScreen(context);
};

Function navWorkers = (index, context) {
  Provider.of<MenuProvider>(context, listen: false).setCurrentMenuIndex(index);
  navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const WorkersPage()),
      (Route<dynamic> route) => false);
};

Function navWeather = (index, context) {
  Provider.of<MenuProvider>(context, listen: false).setCurrentMenuIndex(index);
  if (Provider.of<AppStateProvider>(context, listen: false)
      .isFetchingData
      .isNotEmpty) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const Weather()));
  } else {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Weather()),
        (Route<dynamic> route) => false);
  }
};

Function navSensors = (index, context) {
  Provider.of<MenuProvider>(context, listen: false).setCurrentMenuIndex(index);
  if (Provider.of<AppStateProvider>(context, listen: false)
      .isFetchingData
      .isNotEmpty) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const SensorsPage()));
  } else {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const SensorsPage()),
        (Route<dynamic> route) => false);
  }
};

Function navHistory = (index, context) {
  Provider.of<MenuProvider>(context, listen: false).setCurrentMenuIndex(index);
  if (Provider.of<AppStateProvider>(context, listen: false)
      .isFetchingData
      .isNotEmpty) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const History()));
  } else {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const History()),
        (Route<dynamic> route) => false);
  }
};

Function navAlerts = (index, context) {
  Provider.of<MenuProvider>(context, listen: false).setCurrentMenuIndex(index);
  if (Provider.of<AppStateProvider>(context, listen: false)
      .isFetchingData
      .isNotEmpty) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const AlertsPage()));
  } else {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const AlertsPage()),
        (Route<dynamic> route) => false);
  }
};

Function navSOS = (index, context) {
  Provider.of<MenuProvider>(context, listen: false).setCurrentMenuIndex(index);
  if (Provider.of<AppStateProvider>(context, listen: false)
      .isFetchingData
      .isNotEmpty) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const SOSPage()));
  } else {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const SOSPage()),
        (Route<dynamic> route) => false);
  }
};

Widget sideMenu() {
  return Hero(
    tag: 'menu',
    child: Builder(builder: (context) {
      return Column(
        children: [
          Container(
            height: screenHeight * 0.88,
            width: screenWidth * 0.08,
            decoration: BoxDecoration(
                border: Border(
                    right: BorderSide(
                        color: Palette.mainBlackColor.withOpacity(0.25))),
                color: Palette.mainGreyColor),
            child: Column(
              children: [
                SizedBox(
                  height: screenHeight * 0.03,
                ),
                Provider.of<UserProvider>(context, listen: false).scope == 0
                    ? Column(
                        children: [
                          getMenuOption(1, Assets.sensors, navSensors),
                          SizedBox(
                            height: screenHeight * 0.03,
                          ),
                        ],
                      )
                    : const SizedBox(),
                getMenuOption(2, Assets.workers, navWorkers),
                Provider.of<UserProvider>(context, listen: false).scope == 0
                    ? Column(
                        children: [
                          SizedBox(
                            height: screenHeight * 0.03,
                          ),
                          // getMenuOption(3, Assets.weather, navWeather),
                          // SizedBox(
                          //   height: screenHeight * 0.03,
                          // ),
                          getMenuOption(4, Assets.alert, navAlerts),
                          SizedBox(
                            height: screenHeight * 0.03,
                          ),
                          getMenuOption(5, Assets.sos, navSOS),
                          //  SizedBox(
                          //   height: screenHeight * 0.03,
                          // ),
                          // getMenuOption(6, Assets.history, navHistory),
                        ],
                      )
                    : const SizedBox(),
                const Expanded(child: SizedBox()),
                // const Expanded(child: SizedBox()),
                getMenuOption(0, Assets.logout, logOut),
                SizedBox(
                  height: screenHeight * 0.03,
                ),
              ],
            ),
          ),
        ],
      );
    }),
  );
}

getMenuOption(index, asset, Function iconIsPressed) {
  return Builder(builder: (context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        onTap: () =>
            Provider.of<MenuProvider>(context, listen: false).index != index
                ? iconIsPressed(index, context)
                : null,
        child: SizedBox(
          width: screenWidth * 0.05,
          child: Container(
            decoration: const BoxDecoration(boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.25),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 1), // changes position of shadow
              ),
            ], shape: BoxShape.circle, color: Palette.mainWhiteColor),
            child: Padding(
              padding: EdgeInsets.all(3.0.sp),
              child: Image.asset(
                asset,
                color: context.watch<MenuProvider>().index == index
                    ? Palette.mainGreenColor
                    : null,
              ),
            ),
          ),
        ),
      ),
    );
  });
}
