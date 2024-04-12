import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wear4safe/pages/sensors_info_page.dart';
import '../globals/app_bar.dart';
import '../globals/side_menu.dart';
import '../helpers/assets.dart';
import '../helpers/colors.dart';
import '../helpers/sizer_utils.dart';
import '../models/sensor_model.dart';
import '../providers/user_provider.dart';
import '../providers/weather_provider.dart';

class SensorsPage extends StatefulWidget {
  const SensorsPage({super.key});

  @override
  State<SensorsPage> createState() => _SensorsPageState();
}

class _SensorsPageState extends State<SensorsPage> {
  @override
  void initState() {
    callWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: LayoutBuilder(builder: (BuildContext, BoxConstraints) {
          screenWidth = BoxConstraints.maxWidth;
          screenHeight = BoxConstraints.maxHeight;
          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Scaffold(
                backgroundColor: Palette.mainGreyColor,
                resizeToAvoidBottomInset: false,
                body: SizedBox(
                  child: Stack(
                    children: [
                      customAppBar(context, 'Εξοπλισμός'),
                      Padding(
                        padding: EdgeInsets.only(top: screenHeight * 0.12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            sideMenu(),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // SizedBox(
                                  //   height: screenHeight * 0.05,
                                  // ),
                                  // Center(
                                  //   child: SizedBox(
                                  //     child: Text(
                                  //       'Λίστα Εξοπλισμού',
                                  //       style: TextStyle(
                                  //           color: Palette.mainBlackColor,
                                  //           fontSize: 7.sp,
                                  //           fontWeight: FontWeight.w600),
                                  //     ),
                                  //   ),
                                  // ),
                                  // SizedBox(
                                  //   height: screenHeight * 0.005,
                                  // ),
                                  // Center(
                                  //   child: Padding(
                                  //     padding: EdgeInsets.only(
                                  //         left: screenWidth * 0.02,
                                  //         right: screenWidth * 0.02),
                                  //     child: SizedBox(
                                  //       width: screenWidth,
                                  //       child: const Divider(
                                  //         thickness: 1,
                                  //         color: Palette.mainBlackColor,
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                  context
                                          .watch<UserProvider>()
                                          .user
                                          .sensors
                                          .isEmpty
                                      ? Expanded(
                                          child: SizedBox(
                                            child: Center(
                                              child: Text(
                                                'Δεν υπάρχουν διαθέσιμος Εξοπλισμός',
                                                style: TextStyle(
                                                    color:
                                                        Palette.mainBlackColor,
                                                    fontSize: 5.sp,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                          ),
                                        )
                                      : getSensorsList(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
          );
        }),
      ),
    );
  }

  getSensorsList() {
    List<Sensor> sensors = context.read<UserProvider>().user.sensors;
    return Expanded(
        child: SizedBox(
      child: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
                top: screenHeight * 0.05,
                bottom: screenHeight * 0.05,
                left: screenWidth * 0.02,
                right: screenWidth * 0.02),
            child: Wrap(
              alignment: WrapAlignment.start,
              runAlignment: WrapAlignment.start,
              runSpacing: screenHeight * 0.03,
              spacing: screenWidth * 0.02,
              children:
                  sensors.map<Widget>((sensor) => getSensor(sensor)).toList(),
            ),
          ),
        ),
      ),
    ));
  }

  getSensor(Sensor sensor) {
    return InkWell(
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SensorsInfo(
                    sensor: sensor,
                  )),
        );
      },
      child: Container(
        width: screenWidth * 0.27,
        constraints: BoxConstraints(minHeight: screenHeight * 0.34),
        decoration: BoxDecoration(
            color: Palette.mainWhiteColor,
            borderRadius: BorderRadius.circular(4.sp),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.25),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 1), // changes position of shadow
              ),
            ]),
        child: Padding(
          padding: EdgeInsets.only(
              left: screenWidth * 0.02,
              right: screenWidth * 0.02,
              top: screenHeight * 0.03,
              bottom: screenHeight * 0.03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: screenWidth * 0.03,
                    child: Image.asset(Assets.equipment),
                  ),
                  SizedBox(
                    width: screenWidth * 0.02,
                  ),
                  SizedBox(
                    width: screenWidth * 0.18,
                    child: Text(
                      sensor.name,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Palette.mainBlackColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 4.sp),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: screenHeight * 0.03,
              ),
              Center(
                child: SizedBox(
                  width: screenWidth * 0.2,
                  child: const Divider(
                    thickness: 1,
                    color: Palette.mainBlackColor,
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              SizedBox(
                width: screenWidth * 0.25,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: SizedBox(
                      child: Text(
                        'Είναι Διαθέσιμος:',
                        style: TextStyle(
                            color: Palette.mainBlackColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 4.sp),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                child: Text(
                  sensor.hasAssigned ? "Όχι" : 'Ναι',
                  style: TextStyle(
                      color: sensor.hasAssigned
                          ? Palette.mainRedColor
                          : Palette.mainGreenColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 4.sp),
                ),
              ),
              sensor.hasAssigned
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: screenHeight * 0.02,
                        ),
                        SizedBox(
                          width: screenWidth * 0.25,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: SizedBox(
                                child: Text(
                                  'Είναι Ενεργός:',
                                  style: TextStyle(
                                      color: Palette.mainBlackColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 4.sp),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          child: Text(
                            sensor.isActive ? "Ναι" : 'Όχι',
                            style: TextStyle(
                                color: !sensor.isActive
                                    ? Palette.mainRedColor
                                    : Palette.mainGreenColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 4.sp),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  void callWeather() {
    // Future.delayed(Duration(milliseconds: 200)).then((value) =>
    //     Provider.of<WeatherProvider>(context, listen: false)
    //         .fetchWeather(context));
  }
}
