import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wear4safe/globals/app_bar.dart';
import 'package:wear4safe/globals/side_menu.dart';
import 'package:wear4safe/helpers/colors.dart';
import 'package:wear4safe/helpers/sizer_utils.dart';
import 'package:wear4safe/models/assigned_model.dart';
import 'package:wear4safe/providers/user_provider.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
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
                      customAppBar(context, 'Ιστορικό Αναθέσεων Εξοπλισμού'),
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
                                  SizedBox(
                                    height: screenHeight * 0.05,
                                  ),
                                  // Center(
                                  //   child: SizedBox(
                                  //     child: Text(
                                  //       'Ιστορικό Αναθέσεων Εξοπλισμού',
                                  //       style: TextStyle(
                                  //           color: Palette.mainBlackColor,
                                  //           fontSize: 6.sp,
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
                                  // SizedBox(
                                  //   height: screenHeight * 0.02,
                                  // ),
                                  getHistory(),
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

  getHistory() {
    List<AssignedSensor> availableSensors = [];

    availableSensors = context.watch<UserProvider>().user.assignedSensors;

    return availableSensors.isNotEmpty
        ? Expanded(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: screenWidth * 0.15,
                          child: Text(
                            'Επόπτης',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Palette.mainBlackColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 5.sp),
                          ),
                        ),
                        SizedBox(
                          width: screenWidth * 0.02,
                        ),
                        SizedBox(
                          width: screenWidth * 0.15,
                          child: Text('Εργαζόμενος',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Palette.mainBlackColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 5.sp)),
                        ),
                        SizedBox(
                          width: screenWidth * 0.02,
                        ),
                        SizedBox(
                          width: screenWidth * 0.15,
                          child: Text('Εξοπλισμός',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Palette.mainBlackColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 5.sp)),
                        ),
                        SizedBox(
                          width: screenWidth * 0.02,
                        ),
                        SizedBox(
                          width: screenWidth * 0.15,
                          child: Text('Ημ/νια. Ανάθεσης',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Palette.mainBlackColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 5.sp)),
                        ),
                        SizedBox(
                          width: screenWidth * 0.02,
                        ),
                        SizedBox(
                          width: screenWidth * 0.15,
                          child: Text('Ημ/νια. Επιστροφής',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Palette.mainBlackColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 5.sp)),
                        ),
                      ],
                    ),
                  ),
                ),
                // Padding(
                //   padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                //   child: const Divider(
                //     color: Palette.mainBlackColor,
                //     thickness: 1,
                //   ),
                // ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.02,
                        vertical: screenHeight * 0.02),
                    decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.25),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 1), // changes position of shadow
                          ),
                        ],
                        color: Palette.mainWhiteColor,
                        borderRadius: BorderRadius.circular(8.sp)),
                    child: ScrollConfiguration(
                      behavior:
                          const ScrollBehavior().copyWith(overscroll: false),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: screenHeight * 0.02,
                            ),
                            SizedBox(
                              height: screenHeight,
                              child: ListView.builder(
                                itemCount: availableSensors.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return getPastAssignedSensor(
                                      availableSensors[index]);
                                },
                              ),
                            ),
                            SizedBox(
                              height: screenHeight * 0.05,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        : SizedBox(
            height: screenHeight * 0.6,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Δεν υπάρχουν καταγεγραμμένες αναθέσεις εξοπλισμού για αυτόν τον οργανισμό',
                style: TextStyle(
                    color: Palette.mainBlackColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 4.sp),
              ),
            ),
          );
  }

  getPastAssignedSensor(AssignedSensor sensor) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
      child: Column(
        children: [
          SizedBox(
            height: screenHeight * 0.04,
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: screenWidth * 0.15,
                  child: Text(
                    sensor.userName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Palette.mainBlackColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 5.sp),
                  ),
                ),
                SizedBox(
                  width: screenWidth * 0.02,
                ),
                SizedBox(
                  width: screenWidth * 0.15,
                  child: Text(
                    sensor.employeeName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Palette.mainBlackColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 5.sp),
                  ),
                ),
                SizedBox(
                  width: screenWidth * 0.02,
                ),
                SizedBox(
                  width: screenWidth * 0.15,
                  child: Text(
                    sensor.sensorName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Palette.mainBlackColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 5.sp),
                  ),
                ),
                SizedBox(
                  width: screenWidth * 0.02,
                ),
                SizedBox(
                  width: screenWidth * 0.15,
                  child: Text(
                    sensor.assignedDate,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Palette.mainBlackColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 5.sp),
                  ),
                ),
                SizedBox(
                  width: screenWidth * 0.02,
                ),
                SizedBox(
                  width: screenWidth * 0.15,
                  child: Text(
                    sensor.returnedDate.isEmpty ? '-' : sensor.returnedDate,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Palette.mainBlackColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 5.sp),
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: SizedBox(
              width: screenWidth,
              child: const Divider(
                thickness: 1,
                color: Palette.mainBlackColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
