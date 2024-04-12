// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:provider/provider.dart';
import 'package:wear4safe/globals/app_bar.dart';
import 'package:wear4safe/globals/side_menu.dart';
import 'package:wear4safe/helpers/colors.dart';
import 'package:wear4safe/helpers/sizer_utils.dart';
import 'package:wear4safe/models/assigned_model.dart';
import 'package:wear4safe/models/employee_model.dart';
import 'package:wear4safe/providers/user_provider.dart';

import '../main.dart';
import '../models/sensor_model.dart';
import '../models/user_model.dart';
import '../services/api_calls.dart';
import '../services/shared_prefs_service.dart';

class SensorsInfo extends StatefulWidget {
  SensorsInfo({super.key, required this.sensor});
  Sensor sensor;

  @override
  State<SensorsInfo> createState() => _SensorsInfoState();
}

class _SensorsInfoState extends State<SensorsInfo> {
  bool isLoading = false;
  bool assignmentIsActive = false;
  bool isBeingAssigned = false;

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
                      customAppBar(context, 'Στοιχεία Εξοπλισμού'),
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
                                    height: screenHeight * 0.03,
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: screenWidth * 0.02,
                                            bottom: screenHeight * 0.02),
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            splashFactory:
                                                NoSplash.splashFactory,
                                            highlightColor: Colors.transparent,
                                            onTap: () => navigatorKey
                                                .currentState
                                                ?.pop(context),
                                            child: SizedBox(
                                              width: screenWidth * 0.05,
                                              child: Container(
                                                decoration: const BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Color.fromRGBO(
                                                            0, 0, 0, 0.25),
                                                        spreadRadius: 1,
                                                        blurRadius: 5,
                                                        offset: Offset(0,
                                                            1), // changes position of shadow
                                                      ),
                                                    ],
                                                    shape: BoxShape.circle,
                                                    color:
                                                        Palette.mainWhiteColor),
                                                child: Padding(
                                                    padding:
                                                        EdgeInsets.all(3.0.sp),
                                                    child: const Icon(
                                                        Icons.arrow_back)),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Expanded(child: SizedBox()),
                                      // Padding(
                                      //   padding: EdgeInsets.only(
                                      //       right: screenWidth * 0.07),
                                      //   child: Text(
                                      //     'Στοιχεία Εξοπλισμού',
                                      //     style: TextStyle(
                                      //         color: Palette.mainBlackColor,
                                      //         fontSize: 7.sp,
                                      //         fontWeight: FontWeight.w600),
                                      //   ),
                                      // ),
                                      const Expanded(child: SizedBox()),
                                    ],
                                  ),
                                  // SizedBox(
                                  //   height: screenHeight * 0.005,
                                  // ),
                                  Center(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: screenWidth * 0.02,
                                          right: screenWidth * 0.02),
                                      child: SizedBox(
                                        width: screenWidth,
                                        child: Divider(
                                          thickness: 0.2.sp,
                                          color: Palette.mainBlackColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  getSensorCard(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      isLoading
                          ? Container(
                              height: screenHeight,
                              width: screenWidth,
                              color: Colors.black.withOpacity(0.55),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: Palette.mainBlackColor,
                                ),
                              ),
                            )
                          : const SizedBox(),
                      assignmentIsActive
                          ? getNewAssignmentWindow()
                          : const SizedBox(),
                    ],
                  ),
                )),
          );
        }),
      ),
    );
  }

  getSensorCard() {
    return Expanded(
        child: SizedBox(
      child: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
                top: screenHeight * 0.02,
                bottom: screenHeight * 0.0,
                left: screenWidth * 0.02,
                right: screenWidth * 0.02),
            child: SizedBox(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          getSensorInfo(),
                        ],
                      ),
                      SizedBox(
                        height: screenHeight * 0.03,
                      ),
                      assignButton()
                    ],
                  ),
                  SizedBox(
                    width: screenWidth * 0.02,
                  ),
                  getProbesInfo(),
                  //  getAssignedHistory(),
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }

  getNewAssignmentWindow() {
    List<Employee> availableEmployees = [];
    User user = Provider.of<UserProvider>(context, listen: true).user;
    for (Employee employee in user.employees) {
      if (employee.professionID == widget.sensor.professionID) {
        var index = user.assignedSensors.indexWhere((element) {
          return element.returnedDate.isEmpty &&
              element.sensorID == widget.sensor.id;
        });
        if (index == -1) {
          availableEmployees.add(employee);
        }
      }
    }
    return Stack(
      children: [
        Center(
          child: Container(
            width: screenWidth * 0.4,
            height: screenHeight * 0.7,
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                availableEmployees.isNotEmpty
                    ? const SizedBox()
                    : const Expanded(child: SizedBox()),
                availableEmployees.isNotEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: screenHeight * 0.04,
                          ),
                          SizedBox(
                            width: screenWidth * 0.38,
                            child: Center(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  'Αναθέστε εξοπλισμό στον εργαζόμενο.',
                                  style: TextStyle(
                                      color: Palette.mainBlackColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 5.sp),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: screenWidth * 0.35,
                            child: const Center(
                              child: Divider(
                                color: Palette.mainBlackColor,
                                thickness: 1,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.04,
                          ),
                          SizedBox(
                            height: screenHeight * 0.45,
                            child: ScrollConfiguration(
                              behavior: const ScrollBehavior()
                                  .copyWith(overscroll: false),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: availableEmployees
                                      .map<Widget>((employee) =>
                                          getAvailableEmployees(employee))
                                      .toList(),
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    : SizedBox(
                        width: screenWidth * 0.38,
                        child: Center(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'Δεν υπάρχει διαθέσιμός εξοπλισμός για τον εργαζόμενο',
                              style: TextStyle(
                                  color: Palette.mainBlackColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 3.5.sp),
                            ),
                          ),
                        ),
                      ),
                const Expanded(child: SizedBox()),
                InkWell(
                  onTap: () {
                    assignmentIsActive = false;
                    isLoading = false;
                    setState(() {});
                    // assignmentIsActive=false;
                    // isLoading=false;
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Palette.mainRedColor,
                        borderRadius: BorderRadius.circular(6.sp),
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
                          vertical: screenHeight * 0.01,
                          horizontal: screenWidth * 0.02),
                      child: Text(
                        'ΕΠΙΣΤΡΟΦΗ',
                        style: TextStyle(
                            color: Palette.mainWhiteColor,
                            fontSize: 6.sp,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
              ],
            ),
          ),
        ),
        isBeingAssigned
            ? Center(
                child: Container(
                  width: screenWidth * 0.4,
                  height: screenHeight * 0.7,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.55),
                    borderRadius: BorderRadius.circular(4.sp),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Palette.mainBlackColor,
                    ),
                  ),
                ),
              )
            : const SizedBox()
      ],
    );
  }

  assignButton() {
    var status = false;
    List<AssignedSensor> assignedSensors =
        Provider.of<UserProvider>(context, listen: false).user.assignedSensors;
    var assignedIndex = assignedSensors.indexWhere((element) {
      return element.sensorID == widget.sensor.id &&
          element.returnedDate.isEmpty;
    });
    if (assignedIndex != -1) {
      status = true;
    }
    var index = -1;
    if (status) {
      index = Provider.of<UserProvider>(context, listen: false)
          .user
          .employees
          .indexWhere((element) =>
              element.id == assignedSensors[assignedIndex].employeeID);
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        status
            ? SizedBox(
                width: screenWidth * 0.32,
                child: Center(
                  child: InkWell(
                    splashFactory: NoSplash.splashFactory,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      index != -1
                          ? removeSensor(assignedSensors[assignedIndex])
                          : null;
                    },
                    child: Container(
                      width: screenWidth * 0.2,
                      decoration: BoxDecoration(
                          color: index != -1
                              ? Palette.mainRedColor
                              : Palette.mainRedColor.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(6.sp),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.25),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset:
                                  Offset(0, 1), // changes position of shadow
                            ),
                          ]),
                      child: FittedBox(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.01,
                              horizontal: screenWidth * 0.02),
                          child: Center(
                            child: Text(
                              'Επιστροφή Εξοπλισμού',
                              style: TextStyle(
                                  color: Palette.mainWhiteColor,
                                  fontSize: 5.sp,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : SizedBox(
                width: screenWidth * 0.32,
                child: Center(
                  child: InkWell(
                    onTap: () {
                      assignmentIsActive = true;
                      isLoading = true;
                      setState(() {});
                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: screenWidth * 0.00),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Palette.mainGreenColor,
                            borderRadius: BorderRadius.circular(6.sp),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.45),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset:
                                    Offset(0, 1), // changes position of shadow
                              ),
                            ]),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.01,
                              horizontal: screenWidth * 0.02),
                          child: Text(
                            'Ανάθεση Εξοπλισμού',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Palette.mainWhiteColor,
                                fontSize: 5.sp,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
        SizedBox(
          height: screenHeight * 0.03,
        ),
        SizedBox(
          child: Center(
            child: InkWell(
              splashFactory: NoSplash.splashFactory,
              highlightColor: Colors.transparent,
              onTap: () =>
                  widget.sensor.lat.isNotEmpty && widget.sensor.lng.isNotEmpty
                      ? openMap()
                      : null,
              child: Container(
                decoration: BoxDecoration(
                    color: widget.sensor.lat.isNotEmpty &&
                            widget.sensor.lng.isNotEmpty
                        ? Colors.blueAccent
                        : Colors.blueAccent.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(6.sp),
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
                      horizontal: screenWidth * 0.02,
                      vertical: screenHeight * 0.01),
                  child: Center(
                      child: Text(
                    'Εντοπισμός Εξοπλισμού',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: widget.sensor.lat.isNotEmpty &&
                                widget.sensor.lng.isNotEmpty
                            ? Palette.mainWhiteColor
                            : Palette.mainWhiteColor.withOpacity(0.75),
                        fontSize: 5.sp,
                        fontWeight: FontWeight.bold),
                  )),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: screenHeight * 0.05,
        ),
      ],
    );
  }

  getAssignedHistory() {
    var status = false;
    List<AssignedSensor> assignedSensors =
        Provider.of<UserProvider>(context, listen: false).user.assignedSensors;
    var assignedIndex = assignedSensors.indexWhere((element) {
      return element.sensorID == widget.sensor.id &&
          element.returnedDate.isNotEmpty;
    });
    if (assignedIndex != -1) {
      status = true;
    }
    return Expanded(
      child: Column(
        children: [
          status
              ? Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Palette.mainWhiteColor,
                        borderRadius: BorderRadius.circular(6.sp),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.25),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 1), // changes position of shadow
                          ),
                        ]),
                    child: Column(
                      children: [
                        SizedBox(
                          height: screenHeight * 0.02,
                        ),
                        SizedBox(
                          child: Text(
                            'Ιστορικό Αναθέσεων Εξοπλισμού',
                            style: TextStyle(
                                color: Palette.mainBlackColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 5.sp),
                          ),
                        ),
                        SizedBox(
                          height: screenHeight * 0.02,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.02),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: screenWidth * 0.12,
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
                                  width: screenWidth * 0.12,
                                  child: Text(
                                    'Εργαζόμενος',
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
                                  width: screenWidth * 0.12,
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
                                  width: screenWidth * 0.12,
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
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.02),
                          child: const Divider(
                            color: Palette.mainBlackColor,
                            thickness: 1,
                          ),
                        ),
                        Expanded(
                          child: ScrollConfiguration(
                            behavior: const ScrollBehavior()
                                .copyWith(overscroll: false),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: screenHeight * 0.02,
                                  ),
                                  SizedBox(
                                    height: screenHeight,
                                    child: ListView.builder(
                                      itemCount: assignedSensors.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return getPastAssignedSensor(
                                            assignedSensors[index]);
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.1,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Column(
                  children: [
                    SizedBox(
                      height: screenHeight * 0.25,
                    ),
                    Center(
                      child: Text(
                        'Δεν υπάρχουν παλαιότερες αναθέσεις εξοπλισμού.',
                        style: TextStyle(
                            color: Palette.mainBlackColor.withOpacity(0.75),
                            fontWeight: FontWeight.bold,
                            fontSize: 4.sp),
                      ),
                    ),
                  ],
                ),
          SizedBox(
            height: screenHeight * 0.02,
          ),
        ],
      ),
    );
  }

  getSensorInfo() {
    return Container(
      width: screenWidth * 0.35,
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
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.02, vertical: screenHeight * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.sensor.name.isNotEmpty
                ? Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            child: Text(
                              'Όνομα: ',
                              style: TextStyle(
                                  color: Palette.mainBlackColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 5.sp),
                            ),
                          ),
                          SizedBox(
                            width: screenWidth * 0.22,
                            child: Text(
                              widget.sensor.name,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Palette.mainBlackColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 5.sp),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: screenHeight * 0.02,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                child: Text(
                                  'ID Εξοπλισμού: ',
                                  style: TextStyle(
                                      color: Palette.mainBlackColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 5.sp),
                                ),
                              ),
                              SizedBox(
                                child: Text(
                                  widget.sensor.imei,
                                  style: TextStyle(
                                      color: Palette.mainBlackColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 5.sp),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.02,
                      ),
                    ],
                  )
                : const SizedBox(),
            // SizedBox(
            //   height: screenHeight * 0.02,
            // ),
            getAssignmentStatus(),
          ],
        ),
      ),
    );
  }

  getAssignmentStatus() {
    var status = false;
    List<AssignedSensor> assignedSensors =
        Provider.of<UserProvider>(context, listen: false).user.assignedSensors;
    var assignedIndex = assignedSensors.indexWhere((element) {
      return element.sensorID == widget.sensor.id &&
          element.returnedDate.isEmpty;
    });
    if (assignedIndex != -1) {
      status = true;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          child: Text(
            'Είναι Διαθέσιμος:',
            style: TextStyle(
                color: Palette.mainBlackColor,
                fontSize: 5.sp,
                fontWeight: FontWeight.w600),
          ),
        ),
        SizedBox(
          child: Text(
            status ? "Όχι" : 'Ναι',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 5.sp,
              color: status ? Palette.mainRedColor : Palette.mainGreenColor,
            ),
          ),
        ),
        widget.sensor.hasAssigned
            ? Builder(builder: (context) {
                return Column(
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
                                  fontSize: 5.sp,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      child: Text(
                        widget.sensor.isActive ? "Ναι" : 'Όχι',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 5.sp,
                          color: !widget.sensor.isActive
                              ? Palette.mainRedColor
                              : Palette.mainGreenColor,
                        ),
                      ),
                    ),
                  ],
                );
              })
            : const SizedBox(),
        SizedBox(
          height: screenHeight * 0.02,
        ),
        status
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    child: Row(
                      children: [
                        SizedBox(
                          child: Text('Εργαζόμενος: ',
                              style: TextStyle(
                                  color: Palette.mainBlackColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 5.sp)),
                        ),
                        SizedBox(
                          width: screenWidth * 0.18,
                          child: Text(
                              assignedSensors[assignedIndex].employeeName,
                              style: TextStyle(
                                  color: Palette.mainBlackColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 5.sp)),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.02,
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      children: [
                        SizedBox(
                          child: Text('Ημ/νια. Ανάθεσης: ',
                              style: TextStyle(
                                  color: Palette.mainBlackColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 5.sp)),
                        ),
                        SizedBox(
                          width: screenWidth * 0.18,
                          child: Text(
                              assignedSensors[assignedIndex].assignedDate,
                              style: TextStyle(
                                  color: Palette.mainBlackColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 5.sp)),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : const SizedBox(),
      ],
    );
  }

  Future<void> removeSensor(AssignedSensor assignedSensor) async {
    isLoading = true;
    User user = Provider.of<UserProvider>(context, listen: false).user;
    setState(() {});
    var response = await completeAssignedSensor(assignedSensor.id, user.id);
    if (response) {
      var creds = await SharedPrefsService().getCachedCredentials();
      var data = await logInUser(creds[0], creds[1]);
      await Provider.of<UserProvider>(context, listen: false).setUser(data);
      //Navigator.pop(context);
    }
    isLoading = false;
    setState(() {});
  }

  getPastAssignedSensor(AssignedSensor sensor) {
    return sensor.sensorID == widget.sensor.id && sensor.returnedDate.isNotEmpty
        ? Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
            child: Column(
              children: [
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: screenWidth * 0.12,
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
                        width: screenWidth * 0.12,
                        child: Text(
                          sensor.employeeName,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Palette.mainBlackColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 5.sp),
                        ),
                      ),
                      // SizedBox(
                      //   width: screenWidth * 0.02,
                      // ),
                      // SizedBox(
                      //   width: screenWidth * 0.12,
                      //   child: Text(
                      //     sensor.sensorName,
                      //     textAlign: TextAlign.center,
                      //     style: TextStyle(
                      //         color: Palette.mainBlackColor,
                      //         fontWeight: FontWeight.bold,
                      //         fontSize: 4.sp),
                      //   ),
                      // ),
                      SizedBox(
                        width: screenWidth * 0.02,
                      ),
                      SizedBox(
                        width: screenWidth * 0.12,
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
                        width: screenWidth * 0.12,
                        child: Text(
                          sensor.returnedDate,
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
          )
        : const SizedBox();
  }

  getAvailableEmployees(Employee employee) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: screenWidth * 0.2,
                child: Text(
                  "${employee.firstName} ${employee.lastName}",
                  style: TextStyle(
                      color: Palette.mainBlackColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 5.sp),
                ),
              ),
              const Expanded(child: SizedBox()),
              InkWell(
                onTap: () async {
                  isBeingAssigned = true;
                  setState(() {});
                  var response = await addAssignment(
                      Provider.of<UserProvider>(context, listen: false).user.id,
                      widget.sensor.id,
                      employee.id);
                  if (response) {
                    var creds =
                        await SharedPrefsService().getCachedCredentials();
                    var data = await logInUser(creds[0], creds[1]);
                    isLoading = false;
                    await Provider.of<UserProvider>(context, listen: false)
                        .setUser(data);
                    // Navigator.pop(context);
                    isBeingAssigned = false;
                    isLoading = false;
                    assignmentIsActive = false;
                  } else {
                    isBeingAssigned = false;
                    isLoading = false;
                    assignmentIsActive = false;
                  }
                  setState(() {});
                },
                child: Container(
                  width: screenWidth * 0.1,
                  decoration: BoxDecoration(
                      color: Palette.mainGreenColor,
                      borderRadius: BorderRadius.circular(6.sp),
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
                        vertical: screenHeight * 0.01,
                        horizontal: screenWidth * 0.02),
                    child: Center(
                        child: Text(
                      'Ανάθεση',
                      style: TextStyle(
                          color: Palette.mainWhiteColor,
                          fontSize: 5.sp,
                          fontWeight: FontWeight.w500),
                    )),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: screenHeight * 0.02,
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
          SizedBox(
            height: screenHeight * 0.02,
          ),
        ],
      ),
    );
  }

  openMap() async {
    MapsLauncher.launchCoordinates(
        double.parse(widget.sensor.lat), double.parse(widget.sensor.lng));
  }

  Future<void> refreshUser(data) async {}

  getProbesInfo() {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: screenHeight * 0.7,
          width: screenWidth * 0.5,
          decoration: BoxDecoration(
              color: Palette.mainWhiteColor,
              borderRadius: BorderRadius.circular(6.sp),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.25),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 1), // changes position of shadow
                ),
              ]),
          child: ScrollConfiguration(
            behavior: const ScrollBehavior().copyWith(overscroll: false),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.02,
                    vertical: screenHeight * 0.01),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: screenHeight * 0.02,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: screenWidth * 0.02),
                      child: Text(
                        'Περιλαμβάνει:',
                        style: TextStyle(
                            fontSize: 5.sp,
                            fontWeight: FontWeight.w600,
                            color: Palette.mainBlackColor),
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.05,
                    ),
                    widget.sensor.probe1.isNotEmpty
                        ? widget.sensor.probe1[0]['maptype1_name'].isNotEmpty
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '1.  ',
                                        style: TextStyle(
                                            color: Palette.mainBlackColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 5.sp),
                                      ),
                                      SizedBox(
                                        width: screenWidth * 0.4,
                                        child: Text(
                                          widget.sensor.probe1[0]
                                              ['maptype1_name'],
                                          style: TextStyle(
                                              color: Palette.mainBlackColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 5.sp),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.03,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: screenWidth * 0.02),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Είδος ΜΑΠ: ',
                                          style: TextStyle(
                                              color: Palette.mainBlackColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 5.sp),
                                        ),
                                        SizedBox(
                                          width: screenWidth * 0.3,
                                          child: Text(
                                            widget.sensor.probe1[0]
                                                    ['map1_name'] ??
                                                '',
                                            style: TextStyle(
                                                color: Palette.mainBlackColor,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 5.sp),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.03,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: screenWidth * 0.02),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Συνθήκη Χρήσης: ',
                                          style: TextStyle(
                                              color: Palette.mainBlackColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 5.sp),
                                        ),
                                        SizedBox(
                                          width: screenWidth * 0.3,
                                          child: Text(
                                            widget.sensor.probe1[0][
                                                            'condition1_name'] ==
                                                        null ||
                                                    widget.sensor.probe1[0][
                                                            'condition1_name'] ==
                                                        ''
                                                ? widget.sensor.probe1[0]
                                                            ['mandatory'] ==
                                                        "True"
                                                    ? 'Υποχρεωτική Χρήση'
                                                    : 'Προαιρετική Χρήση'
                                                : widget.sensor.probe1[0]
                                                    ['condition1_name'],
                                            style: TextStyle(
                                                color: Palette.mainBlackColor,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 5.sp),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  widget.sensor.probe1[0]['storage1'] != null
                                      ? Column(
                                          children: [
                                            SizedBox(
                                              height: screenHeight * 0.03,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: screenWidth * 0.02),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    'Αποθήκευση: ',
                                                    style: TextStyle(
                                                        color: Palette
                                                            .mainBlackColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 5.sp),
                                                  ),
                                                  SizedBox(
                                                    width: screenWidth * 0.3,
                                                    child: Text(
                                                      widget.sensor.probe1[0]
                                                              ['storage1'] ??
                                                          '',
                                                      style: TextStyle(
                                                          color: Palette
                                                              .mainBlackColor,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 5.sp),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      : const SizedBox(),
                                  widget.sensor.probe1[0]['maintenance1'] !=
                                          null
                                      ? Column(
                                          children: [
                                            SizedBox(
                                              height: screenHeight * 0.03,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: screenWidth * 0.02),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    'Συντήρηση: ',
                                                    style: TextStyle(
                                                        color: Palette
                                                            .mainBlackColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 5.sp),
                                                  ),
                                                  SizedBox(
                                                    width: screenWidth * 0.3,
                                                    child: Text(
                                                      widget.sensor.probe1[0][
                                                              'maintenance1'] ??
                                                          '',
                                                      style: TextStyle(
                                                          color: Palette
                                                              .mainBlackColor,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 5.sp),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      : const SizedBox(),
                                  SizedBox(
                                    height: screenHeight * 0.04,
                                  ),
                                  Center(
                                    child: SizedBox(
                                      width: screenWidth * 0.3,
                                      child: const Divider(
                                        thickness: 1,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.04,
                                  ),
                                ],
                              )
                            : const SizedBox()
                        : const SizedBox(),
                    widget.sensor.probe2.isNotEmpty
                        ? widget.sensor.probe2[0]['maptype2_name'].isNotEmpty
                            ? Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '2.  ',
                                        style: TextStyle(
                                            color: Palette.mainBlackColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 5.sp),
                                      ),
                                      SizedBox(
                                        width: screenWidth * 0.4,
                                        child: Text(
                                          widget.sensor.probe2[0]
                                              ['maptype2_name'],
                                          style: TextStyle(
                                              color: Palette.mainBlackColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 5.sp),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.03,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: screenWidth * 0.02),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Είδος ΜΑΠ: ',
                                          style: TextStyle(
                                              color: Palette.mainBlackColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 5.sp),
                                        ),
                                        SizedBox(
                                          width: screenWidth * 0.3,
                                          child: Text(
                                            widget.sensor.probe2[0]
                                                    ['map2_name'] ??
                                                '',
                                            style: TextStyle(
                                                color: Palette.mainBlackColor,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 5.sp),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.03,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: screenWidth * 0.02),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Συνθήκη Χρήσης: ',
                                          style: TextStyle(
                                              color: Palette.mainBlackColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 5.sp),
                                        ),
                                        SizedBox(
                                          width: screenWidth * 0.3,
                                          child: Text(
                                            widget.sensor.probe2[0][
                                                            'condition2_name'] ==
                                                        null ||
                                                    widget.sensor.probe2[0][
                                                            'condition2_name'] ==
                                                        ''
                                                ? widget.sensor.probe2[0]
                                                            ['mandatory'] ==
                                                        "True"
                                                    ? 'Υποχρεωτική Χρήση'
                                                    : 'Προαιρετική Χρήση'
                                                : widget.sensor.probe2[0]
                                                    ['condition2_name'],
                                            style: TextStyle(
                                                color: Palette.mainBlackColor,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 5.sp),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  widget.sensor.probe2[0]['storage2'] != null
                                      ? Column(
                                          children: [
                                            SizedBox(
                                              height: screenHeight * 0.03,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: screenWidth * 0.02),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Αποθήκευση: ',
                                                    style: TextStyle(
                                                        color: Palette
                                                            .mainBlackColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 5.sp),
                                                  ),
                                                  SizedBox(
                                                    width: screenWidth * 0.3,
                                                    child: Text(
                                                      widget.sensor.probe2[0]
                                                              ['storage2'] ??
                                                          '',
                                                      style: TextStyle(
                                                          color: Palette
                                                              .mainBlackColor,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 5.sp),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      : const SizedBox(),
                                  widget.sensor.probe2[0]['maintenance2'] !=
                                          null
                                      ? Column(
                                          children: [
                                            SizedBox(
                                              height: screenHeight * 0.03,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: screenWidth * 0.02),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Συντήρηση: ',
                                                    style: TextStyle(
                                                        color: Palette
                                                            .mainBlackColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 5.sp),
                                                  ),
                                                  SizedBox(
                                                    width: screenWidth * 0.3,
                                                    child: Text(
                                                      widget.sensor.probe2[0][
                                                              'maintenance2'] ??
                                                          '',
                                                      style: TextStyle(
                                                          color: Palette
                                                              .mainBlackColor,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 5.sp),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      : const SizedBox(),
                                  SizedBox(
                                    height: screenHeight * 0.04,
                                  ),
                                  Center(
                                    child: SizedBox(
                                      width: screenWidth * 0.3,
                                      child: const Divider(
                                        thickness: 1,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.04,
                                  ),
                                ],
                              )
                            : const SizedBox()
                        : const SizedBox(),
                    widget.sensor.probe3.isNotEmpty
                        ? widget.sensor.probe3[0]['maptype3_name'].isNotEmpty
                            ? Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '3.  ',
                                        style: TextStyle(
                                            color: Palette.mainBlackColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 5.sp),
                                      ),
                                      SizedBox(
                                        width: screenWidth * 0.4,
                                        child: Text(
                                          widget.sensor.probe3[0]
                                              ['maptype3_name'],
                                          style: TextStyle(
                                              color: Palette.mainBlackColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 5.sp),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.03,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: screenWidth * 0.02),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Είδος ΜΑΠ: ',
                                          style: TextStyle(
                                              color: Palette.mainBlackColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 5.sp),
                                        ),
                                        SizedBox(
                                          width: screenWidth * 0.3,
                                          child: Text(
                                            widget.sensor.probe3[0]
                                                    ['map3_name'] ??
                                                '',
                                            style: TextStyle(
                                                color: Palette.mainBlackColor,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 5.sp),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.03,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: screenWidth * 0.02),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Συνθήκη Χρήσης: ',
                                          style: TextStyle(
                                              color: Palette.mainBlackColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 5.sp),
                                        ),
                                        SizedBox(
                                          width: screenWidth * 0.3,
                                          child: Text(
                                            widget.sensor.probe3[0][
                                                            'condition3_name'] ==
                                                        null ||
                                                    widget.sensor.probe3[0][
                                                            'condition3_name'] ==
                                                        ''
                                                ? widget.sensor.probe3[0]
                                                            ['mandatory'] ==
                                                        "True"
                                                    ? 'Υποχρεωτική Χρήση'
                                                    : 'Προαιρετική Χρήση'
                                                : widget.sensor.probe3[0]
                                                    ['condition3_name'],
                                            style: TextStyle(
                                                color: Palette.mainBlackColor,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 5.sp),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  widget.sensor.probe3[0]['storage3'] != null
                                      ? Column(
                                          children: [
                                            SizedBox(
                                              height: screenHeight * 0.03,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: screenWidth * 0.02),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Αποθήκευση: ',
                                                    style: TextStyle(
                                                        color: Palette
                                                            .mainBlackColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 5.sp),
                                                  ),
                                                  SizedBox(
                                                    width: screenWidth * 0.3,
                                                    child: Text(
                                                      widget.sensor.probe3[0]
                                                              ['storage3'] ??
                                                          '',
                                                      style: TextStyle(
                                                          color: Palette
                                                              .mainBlackColor,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 5.sp),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      : const SizedBox(),
                                  widget.sensor.probe3[0]['maintenance3'] !=
                                          null
                                      ? Column(
                                          children: [
                                            SizedBox(
                                              height: screenHeight * 0.03,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: screenWidth * 0.02),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Συντήρηση: ',
                                                    style: TextStyle(
                                                        color: Palette
                                                            .mainBlackColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 5.sp),
                                                  ),
                                                  SizedBox(
                                                    width: screenWidth * 0.3,
                                                    child: Text(
                                                      widget.sensor.probe3[0][
                                                              'maintenance3'] ??
                                                          '',
                                                      style: TextStyle(
                                                          color: Palette
                                                              .mainBlackColor,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 5.sp),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      : const SizedBox(),
                                  SizedBox(
                                    height: screenHeight * 0.04,
                                  ),
                                  Center(
                                    child: SizedBox(
                                      width: screenWidth * 0.3,
                                      child: const Divider(
                                        thickness: 1,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.04,
                                  ),
                                ],
                              )
                            : const SizedBox()
                        : const SizedBox(),
                    widget.sensor.probe4.isNotEmpty
                        ? widget.sensor.probe4[0]['maptype4_name'].isNotEmpty
                            ? Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '4.  ',
                                        style: TextStyle(
                                            color: Palette.mainBlackColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 5.sp),
                                      ),
                                      SizedBox(
                                        width: screenWidth * 0.4,
                                        child: Text(
                                          widget.sensor.probe4[0]
                                              ['maptype4_name'],
                                          style: TextStyle(
                                              color: Palette.mainBlackColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 5.sp),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.03,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: screenWidth * 0.02),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Είδος ΜΑΠ: ',
                                          style: TextStyle(
                                              color: Palette.mainBlackColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 5.sp),
                                        ),
                                        SizedBox(
                                          width: screenWidth * 0.3,
                                          child: Text(
                                            widget.sensor.probe4[0]
                                                    ['map4_name'] ??
                                                '',
                                            style: TextStyle(
                                                color: Palette.mainBlackColor,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 5.sp),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.03,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: screenWidth * 0.02),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Συνθήκη Χρήσης: ',
                                          style: TextStyle(
                                              color: Palette.mainBlackColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 5.sp),
                                        ),
                                        SizedBox(
                                          width: screenWidth * 0.3,
                                          child: Text(
                                            widget.sensor.probe4[0][
                                                            'condition4_name'] ==
                                                        null ||
                                                    widget.sensor.probe4[0][
                                                            'condition4_name'] ==
                                                        ''
                                                ? widget.sensor.probe4[0]
                                                            ['mandatory'] ==
                                                        "True"
                                                    ? 'Υποχρεωτική Χρήση'
                                                    : 'Προαιρετική Χρήση'
                                                : widget.sensor.probe4[0]
                                                    ['condition4_name'],
                                            style: TextStyle(
                                                color: Palette.mainBlackColor,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 5.sp),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  widget.sensor.probe4[0]['storage4'] != null
                                      ? Column(
                                          children: [
                                            SizedBox(
                                              height: screenHeight * 0.03,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: screenWidth * 0.02),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    'Αποθήκευση: ',
                                                    style: TextStyle(
                                                        color: Palette
                                                            .mainBlackColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 5.sp),
                                                  ),
                                                  SizedBox(
                                                    width: screenWidth * 0.3,
                                                    child: Text(
                                                      widget.sensor.probe4[0]
                                                              ['storage4'] ??
                                                          '',
                                                      style: TextStyle(
                                                          color: Palette
                                                              .mainBlackColor,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 5.sp),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      : const SizedBox(),
                                  widget.sensor.probe4[0]['maintenance4'] !=
                                          null
                                      ? Column(
                                          children: [
                                            SizedBox(
                                              height: screenHeight * 0.03,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: screenWidth * 0.02),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Συντήρηση: ',
                                                    style: TextStyle(
                                                        color: Palette
                                                            .mainBlackColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 5.sp),
                                                  ),
                                                  SizedBox(
                                                    width: screenWidth * 0.3,
                                                    child: Text(
                                                      widget.sensor.probe4[0][
                                                              'maintenance4'] ??
                                                          '',
                                                      style: TextStyle(
                                                          color: Palette
                                                              .mainBlackColor,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 5.sp),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      : const SizedBox(),
                                  SizedBox(
                                    height: screenHeight * 0.04,
                                  ),
                                  Center(
                                    child: SizedBox(
                                      width: screenWidth * 0.3,
                                      child: const Divider(
                                        thickness: 1,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.04,
                                  ),
                                ],
                              )
                            : const SizedBox()
                        : const SizedBox(),
                    widget.sensor.probe5.isNotEmpty
                        ? widget.sensor.probe5[0]['maptype5_name'].isNotEmpty
                            ? Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '5.  ',
                                        style: TextStyle(
                                            color: Palette.mainBlackColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 5.sp),
                                      ),
                                      SizedBox(
                                        width: screenWidth * 0.4,
                                        child: Text(
                                          widget.sensor.probe5[0]
                                              ['maptype5_name'],
                                          style: TextStyle(
                                              color: Palette.mainBlackColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 5.sp),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.03,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: screenWidth * 0.02),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Είδος ΜΑΠ: ',
                                          style: TextStyle(
                                              color: Palette.mainBlackColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 5.sp),
                                        ),
                                        SizedBox(
                                          width: screenWidth * 0.3,
                                          child: Text(
                                            widget.sensor.probe5[0]
                                                    ['map5_name'] ??
                                                '',
                                            style: TextStyle(
                                                color: Palette.mainBlackColor,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 5.sp),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.03,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: screenWidth * 0.02),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Συνθήκη Χρήσης: ',
                                          style: TextStyle(
                                              color: Palette.mainBlackColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 5.sp),
                                        ),
                                        SizedBox(
                                          width: screenWidth * 0.3,
                                          child: Text(
                                            widget.sensor.probe5[0][
                                                            'condition5_name'] ==
                                                        null ||
                                                    widget.sensor.probe5[0][
                                                            'condition5_name'] ==
                                                        ''
                                                ? widget.sensor.probe5[0]
                                                            ['mandatory'] ==
                                                        "True"
                                                    ? 'Υποχρεωτική Χρήση'
                                                    : 'Προαιρετική Χρήση'
                                                : widget.sensor.probe5[0]
                                                    ['condition5_name'],
                                            style: TextStyle(
                                                color: Palette.mainBlackColor,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 5.sp),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  widget.sensor.probe5[0]['storage5'] != null
                                      ? Column(
                                          children: [
                                            SizedBox(
                                              height: screenHeight * 0.03,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: screenWidth * 0.02),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Αποθήκευση: ',
                                                    style: TextStyle(
                                                        color: Palette
                                                            .mainBlackColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 5.sp),
                                                  ),
                                                  SizedBox(
                                                    width: screenWidth * 0.3,
                                                    child: Text(
                                                      widget.sensor.probe5[0]
                                                              ['storage5'] ??
                                                          '',
                                                      style: TextStyle(
                                                          color: Palette
                                                              .mainBlackColor,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 5.sp),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      : const SizedBox(),
                                  widget.sensor.probe5[0]['maintenance5'] !=
                                          null
                                      ? Column(
                                          children: [
                                            SizedBox(
                                              height: screenHeight * 0.03,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: screenWidth * 0.02),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Συντήρηση: ',
                                                    style: TextStyle(
                                                        color: Palette
                                                            .mainBlackColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 5.sp),
                                                  ),
                                                  SizedBox(
                                                    width: screenWidth * 0.3,
                                                    child: Text(
                                                      widget.sensor.probe5[0][
                                                              'maintenance5'] ??
                                                          '',
                                                      style: TextStyle(
                                                          color: Palette
                                                              .mainBlackColor,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 5.sp),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      : const SizedBox(),
                                  SizedBox(
                                    height: screenHeight * 0.04,
                                  ),
                                  Center(
                                    child: SizedBox(
                                      width: screenWidth * 0.3,
                                      child: const Divider(
                                        thickness: 1,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.04,
                                  ),
                                ],
                              )
                            : const SizedBox()
                        : const SizedBox(),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
