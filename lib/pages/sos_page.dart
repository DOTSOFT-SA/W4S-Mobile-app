import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:provider/provider.dart';
import 'package:wear4safe/helpers/assets.dart';
import 'package:wear4safe/models/employee_model.dart';
import 'package:wear4safe/providers/user_provider.dart';

import '../globals/app_bar.dart';
import '../globals/side_menu.dart';
import '../helpers/colors.dart';
import '../helpers/sizer_utils.dart';
import '../models/alerts_model.dart';
import '../providers/alerts_provider.dart';

class SOSPage extends StatefulWidget {
  const SOSPage({super.key});

  @override
  State<SOSPage> createState() => _SOSState();
}

class _SOSState extends State<SOSPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: LayoutBuilder(builder: (BuildContext, BoxConstraints) {
          screenWidth = BoxConstraints.maxWidth;
          screenHeight = BoxConstraints.maxHeight;
          return Scaffold(
              backgroundColor: Palette.mainGreyColor,
              resizeToAvoidBottomInset: false,
              body: SizedBox(
                child: Stack(
                  children: [
                    customAppBar(context, 'Ειδοποιήσεις Έκτακτης Ανάγκης'),
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
                                context.watch<AlertsProvider>().alerts.isEmpty
                                    ? const Expanded(
                                        child: SizedBox(
                                          child: Center(
                                              child: CircularProgressIndicator(
                                            color: Palette.mainBlackColor,
                                          )),
                                        ),
                                      )
                                    : getSOSGrid(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ));
        }),
      ),
    );
  }

  getSOSGrid() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          context.watch<AlertsProvider>().hasData
              ? context.watch<AlertsProvider>().essentialsAlerts.isNotEmpty
                  ? SizedBox(
                      height: screenHeight * 0.78,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: context
                            .watch<AlertsProvider>()
                            .essentialsAlerts
                            .length,
                        itemBuilder: (BuildContext context, int index) {
                          return getPastAlerts(context
                              .watch<AlertsProvider>()
                              .essentialsAlerts[index]);
                        },
                      ),
                    )
                  : SizedBox(
                      width: screenWidth,
                      child: Column(
                        children: [
                          SizedBox(
                            height: screenHeight * 0,
                          ),
                          SizedBox(
                            child: Text(
                              'Το ιστορικό ειδοποιήσεων είναι κενό',
                              style: TextStyle(
                                  color: Palette.mainBlackColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 4.sp),
                            ),
                          ),
                        ],
                      ),
                    )
              : SizedBox(
                  width: screenWidth,
                  child: Column(
                    children: [
                      SizedBox(
                        height: screenHeight * 0.3,
                      ),
                      const SizedBox(
                        child: CircularProgressIndicator(
                          color: Palette.mainBlackColor,
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  getPastAlerts(AlertsModel availableAlert) {
    var index = Provider.of<UserProvider>(context, listen: false)
        .user
        .employees
        .indexWhere((element) => element.id == availableAlert.employeeID);
    late Employee employee;
    if (index != -1) {
      employee = Provider.of<UserProvider>(context, listen: false)
          .user
          .employees[index];
    }
    return index != -1
        ? Padding(
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.02, vertical: screenHeight * 0.01),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Container(
                width: screenWidth * 0.25,
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
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.015,
                      vertical: screenHeight * 0.02),
                  child: Column(
                    children: [
                      SizedBox(
                        width: screenWidth * 0.06,
                        child: Image.asset(
                          Assets.alert,
                          color: Palette.mainRedColor,
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.02,
                      ),
                      FittedBox(
                        child: Text(
                          'Έκτακτη Ανάγκη',
                          style: TextStyle(
                              color: Palette.mainRedColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 6.sp),
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.05,
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Στάλθηκε Σήμα Έκτακτης Ανάγκης',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Palette.mainBlackColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 5.sp),
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.03,
                      ),
                      Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: SizedBox(
                              child: Text(
                                'Ημερομηνία',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: Palette.mainBlackColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 4.5.sp),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.005,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                availableAlert.date,
                                style: TextStyle(
                                    color: Palette.mainBlackColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 4.5.sp),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.02,
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: SizedBox(
                              child: Text(
                                'Εργαζόμενος',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: Palette.mainBlackColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 4.5.sp),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.005,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                availableAlert.employeeName,
                                style: TextStyle(
                                    color: Palette.mainBlackColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 4.5.sp),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.02,
                          )
                        ],
                      ),
                      employee != null && employee.phone.isNotEmpty
                          ? Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: SizedBox(
                                    child: Text(
                                      'Στοιχεία Επικοινωνίας',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: Palette.mainBlackColor,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 4.sp),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: screenHeight * 0.005,
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      employee.phone,
                                      style: TextStyle(
                                          color: Palette.mainBlackColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 4.5.sp),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: screenHeight * 0.02,
                                )
                              ],
                            )
                          : const SizedBox(),
                      employee != null
                          ? Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: SizedBox(
                                    child: Text(
                                      'Ειδικότητα',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: Palette.mainBlackColor,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 4.5.sp),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: screenHeight * 0.005,
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      employee.professionName,
                                      style: TextStyle(
                                          color: Palette.mainBlackColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 4.5.sp),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox(),
                      SizedBox(
                        height: screenHeight * 0.05,
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Εντοπισμός Έκτακτης Ανάγκης',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Palette.mainBlackColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 5.sp),
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.02,
                      ),
                      InkWell(
                        splashFactory: NoSplash.splashFactory,
                        highlightColor: Colors.transparent,
                        onTap: () => availableAlert.lat.isNotEmpty &&
                                availableAlert.long.isNotEmpty
                            ? openMap(availableAlert)
                            : null,
                        child: Container(
                          decoration: BoxDecoration(
                              color: availableAlert.lat.isNotEmpty &&
                                      availableAlert.long.isNotEmpty
                                  ? Colors.blueAccent
                                  : Colors.blueAccent.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(6.sp),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.25),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: Offset(
                                      0, 1), // changes position of shadow
                                ),
                              ]),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.02,
                                vertical: screenHeight * 0.01),
                            child: Center(
                                child: Text(
                              'Χάρτης',
                              style: TextStyle(
                                  color: availableAlert.lat.isNotEmpty &&
                                          availableAlert.long.isNotEmpty
                                      ? Palette.mainWhiteColor
                                      : Palette.mainWhiteColor
                                          .withOpacity(0.75),
                                  fontSize: 4.5.sp,
                                  fontWeight: FontWeight.bold),
                            )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        : SizedBox();
  }

  openMap(AlertsModel availableAlert) {
    AlertsModel alert = availableAlert;
    MapsLauncher.launchCoordinates(
        double.parse(alert.lat), double.parse(alert.long));
  }
}
