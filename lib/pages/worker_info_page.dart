// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:provider/provider.dart';
import 'package:wear4safe/globals/app_bar.dart';
import 'package:wear4safe/globals/side_menu.dart';
import 'package:wear4safe/helpers/colors.dart';
import 'package:wear4safe/helpers/sizer_utils.dart';
import 'package:wear4safe/main.dart';
import 'package:wear4safe/models/assigned_model.dart';
import 'package:wear4safe/models/employee_model.dart';
import 'package:wear4safe/providers/user_provider.dart';
import 'package:wear4safe/services/api_calls.dart';
import 'package:wear4safe/services/shared_prefs_service.dart';

import '../models/sensor_model.dart';
import '../models/user_model.dart';

class WorkerInfo extends StatefulWidget {
  Employee employee;

  WorkerInfo({super.key, required this.employee});

  @override
  State<WorkerInfo> createState() => _WorkerInfoState();
}

class _WorkerInfoState extends State<WorkerInfo> {
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
                      customAppBar(context, 'Στοιχεία Εργαζομένου'),
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
                                      //     'Στοιχεία Εργαζομένου',
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
                                        child: const Divider(
                                          thickness: 1,
                                          color: Palette.mainBlackColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  getEmployeeCard(),
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

  getEmployeeCard() {
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
              height: screenHeight * 0.7,
              child: Row(
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            getEmployeeInfo(),
                          ],
                        ),
                        SizedBox(
                          height: screenHeight * 0.015,
                        ),
                        Row(
                          children: [
                            getEmployeeAssignedInfo(),
                          ],
                        ),
                        widget.employee.assignedSensors.isEmpty
                            ? Padding(
                                padding: EdgeInsets.only(
                                    left: screenWidth * 0.07,
                                    top: screenHeight * 0.1),
                                child: SizedBox(child: assignButton()),
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: screenWidth * 0.02,
                  ),
                  widget.employee.assignedSensors.isNotEmpty
                      ? getProbesInfo(widget.employee.assignedSensors[0][1])
                      : const SizedBox()
                  // getAssignedHistory(),
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }

  getEmployeeInfo() {
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
            widget.employee.firstName.isNotEmpty &&
                    widget.employee.lastName.isNotEmpty
                ? Column(
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
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
                              child: Text(
                                '${widget.employee.firstName} ${widget.employee.lastName}',
                                style: TextStyle(
                                    color: Palette.mainBlackColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 5.sp),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.02,
                      ),
                    ],
                  )
                : const SizedBox(),
            widget.employee.professionName.isNotEmpty
                ? Column(
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              child: Text(
                                'Ειδικότητα: ',
                                style: TextStyle(
                                    color: Palette.mainBlackColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 5.sp),
                              ),
                            ),
                            Text(
                              widget.employee.professionName,
                              style: TextStyle(
                                  color: Palette.mainGreenColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 5.sp),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.02,
                      ),
                    ],
                  )
                : const SizedBox(),
            widget.employee.phone.isNotEmpty
                ? Column(
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              child: Text(
                                'Τηλέφωνο: ',
                                style: TextStyle(
                                    color: Palette.mainBlackColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 5.sp),
                              ),
                            ),
                            SizedBox(
                              child: Text(
                                widget.employee.phone,
                                style: TextStyle(
                                    color: Palette.mainBlackColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 5.sp),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.02,
                      ),
                    ],
                  )
                : const SizedBox(),
            widget.employee.email.isNotEmpty
                ? Column(
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              child: Text(
                                'E-mail: ',
                                style: TextStyle(
                                    color: Palette.mainBlackColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 5.sp),
                              ),
                            ),
                            SizedBox(
                              width: screenWidth * 0.22,
                              child: Text(
                                widget.employee.email,
                                style: TextStyle(
                                    color: Palette.mainBlackColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 5.sp),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }

  getEmployeeAssignedInfo() {
    return Builder(builder: (context) {
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(
                  left: screenWidth * 0.015,
                  top: screenWidth * 0.02,
                  right: screenWidth * 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    child: Text(
                      "Διαθέτει Εξοπλισμό:",
                      style: TextStyle(
                          color: Palette.mainBlackColor,
                          fontSize: 5.sp,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                    child: Text(
                      widget.employee.assignedSensors.isNotEmpty
                          ? "Ναι"
                          : 'Όχι',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 5.sp,
                          color: widget.employee.assignedSensors.isNotEmpty
                              ? Palette.mainGreenColor
                              : Palette.mainRedColor),
                    ),
                  ),
                  widget.employee.assignedSensors.isNotEmpty
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
                                            fontWeight: FontWeight.w600,
                                            fontSize: 5.sp),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                child: Text(
                                  widget.employee.assignedSensors[0][1].isActive
                                      ? "Ναι"
                                      : 'Όχι',
                                  style: TextStyle(
                                      color: !widget.employee
                                              .assignedSensors[0][1].isActive
                                          ? Palette.mainRedColor
                                          : Palette.mainGreenColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 5.sp),
                                ),
                              ),
                            ],
                          );
                        })
                      : const SizedBox(),
                  SizedBox(
                    height: screenHeight * 0.02,
                  ),
                ],
              ),
            ),
            widget.employee.assignedSensors.isNotEmpty
                ? Container(
                    margin: EdgeInsets.only(
                        left: screenWidth * 0.015, bottom: screenHeight * 0.02),
                    //height: screenHeight * 0.3,
                    child: ScrollConfiguration(
                      behavior:
                          const ScrollBehavior().copyWith(overscroll: false),
                      child: SingleChildScrollView(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              getAssignedSensorsInfo(
                                  widget.employee.assignedSensors[0],
                                  widget.employee.assignedSensors[0][0],
                                  widget.employee.assignedSensors[0][1])
                            ]),
                      ),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      );
    });
  }

  getAssignedSensorsInfo(
      currentSensor, AssignedSensor assignedSensor, Sensor sensor) {
    var index = -1;
    if (widget.employee.id == assignedSensor.employeeID) {
      index = 0;
    }
    return Padding(
      padding: EdgeInsets.only(right: screenWidth * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: screenHeight * 0.01,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                child: Text(
                  "Όνομα Εξοπλισμού: ",
                  style: TextStyle(
                      color: Palette.mainBlackColor,
                      fontSize: 4.5.sp,
                      fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                width: screenWidth * 0.18,
                child: Text(
                  sensor.name,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 4.5.sp,
                      color: Palette.mainBlackColor),
                ),
              ),
            ],
          ),
          SizedBox(
            height: screenHeight * 0.02,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                child: Text(
                  "ID Εξοπλισμού: ",
                  style: TextStyle(
                      color: Palette.mainBlackColor,
                      fontSize: 4.5.sp,
                      fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                width: screenWidth * 0.2,
                child: Text(
                  sensor.imei,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 4.5.sp,
                      color: Palette.mainBlackColor),
                ),
              ),
            ],
          ),
          SizedBox(
            height: screenHeight * 0.01,
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  child: Text(
                    "Ημερομηνία Ανάθεσης: ",
                    style: TextStyle(
                        color: Palette.mainBlackColor,
                        fontSize: 4.5.sp,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(
                  child: Text(
                    assignedSensor.assignedDate,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 4.5.sp,
                        color: Palette.mainBlackColor),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: screenHeight * 0.02,
          ),
          Provider.of<UserProvider>(context, listen: false).scope == 0
              ? SizedBox(
                  width: screenWidth * 0.32,
                  child: Center(
                    child: InkWell(
                      splashFactory: NoSplash.splashFactory,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        index != -1
                            ? removeSensor(
                                assignedSensor, sensor, currentSensor)
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
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.01,
                              horizontal: screenWidth * 0.02),
                          child: Center(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
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
              : const SizedBox(),
        ],
      ),
    );
  }

  getAssignedHistory() {
    return Expanded(
      child: Column(
        children: [
          Expanded(
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
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
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
                          // SizedBox(
                          //   width: screenWidth * 0.02,
                          // ),
                          // SizedBox(
                          //   width: screenWidth * 0.12,
                          //   child: Text('Εργαζόμενος',
                          //       textAlign: TextAlign.center,
                          //       style: TextStyle(
                          //           color: Palette.mainBlackColor,
                          //           fontWeight: FontWeight.bold,
                          //           fontSize: 4.sp)),
                          // ),
                          SizedBox(
                            width: screenWidth * 0.02,
                          ),
                          SizedBox(
                            width: screenWidth * 0.12,
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
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                    child: const Divider(
                      color: Palette.mainBlackColor,
                      thickness: 1,
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      child: ScrollConfiguration(
                        behavior:
                            const ScrollBehavior().copyWith(overscroll: false),
                        child: SingleChildScrollView(
                          child: widget
                                  .employee.assignedHistorySensors.isNotEmpty
                              ? Column(
                                  children: [
                                    SizedBox(
                                      height: screenHeight * 0.02,
                                    ),
                                    SizedBox(
                                      height: screenHeight,
                                      child: ListView.builder(
                                        itemCount: widget.employee
                                            .assignedHistorySensors.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return getPastAssignedSensor(widget
                                              .employee
                                              .assignedHistorySensors[index]);
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: screenHeight * 0.05,
                                    ),
                                  ],
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
                                            color: Palette.mainBlackColor
                                                .withOpacity(0.75),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 4.sp),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  getPastAssignedSensor(AssignedSensor sensor) {
    return Padding(
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
                // SizedBox(
                //   width: screenWidth * 0.02,
                // ),
                // SizedBox(
                //   width: screenWidth * 0.08,
                //   child: Text(
                //     sensor.employeeName,
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
    );
  }

  Future<void> removeSensor(
      AssignedSensor assignedSensor, Sensor sensor, currentSensor) async {
    isLoading = true;
    User user = Provider.of<UserProvider>(context, listen: false).user;
    setState(() {});
    var response = await completeAssignedSensor(assignedSensor.id, user.id);
    if (response) {
      widget.employee.assignedSensors.remove(currentSensor);
      var date = DateTime.now();
      assignedSensor.returnedDate =
          "${date.year.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}";
      widget.employee.assignedHistorySensors.insert(0, assignedSensor);
    }
    var creds = await SharedPrefsService().getCachedCredentials();
    var data = await logInUser(creds[0], creds[1]);
    await Provider.of<UserProvider>(context, listen: false).setUser(data);
    isLoading = false;
    setState(() {});
  }

  assignButton() {
    return Provider.of<UserProvider>(context, listen: false).scope == 0
        ? InkWell(
            onTap: () {
              assignmentIsActive = true;
              isLoading = true;
              setState(() {});
              // assignmentIsActive=false;
              // isLoading=false;
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Palette.mainGreenColor,
                  borderRadius: BorderRadius.circular(6.sp),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.45),
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
                  'Ανάθεση Εξοπλισμού',
                  style: TextStyle(
                      color: Palette.mainWhiteColor,
                      fontSize: 6.sp,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          )
        : const SizedBox();
  }

  getNewAssignmentWindow() {
    List<Sensor> availableSensors = [];
    User user = Provider.of<UserProvider>(context, listen: true).user;
    for (Sensor sensor in user.sensors) {
      if (sensor.professionID == widget.employee.professionID) {
        var index = user.assignedSensors.indexWhere((element) {
          return element.returnedDate.isEmpty && element.sensorID == sensor.id;
        });
        if (index == -1) {
          availableSensors.add(sensor);
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
                availableSensors.isNotEmpty
                    ? const SizedBox()
                    : const Expanded(child: SizedBox()),
                availableSensors.isNotEmpty
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
                                  children: availableSensors
                                      .map<Widget>((sensor) =>
                                          getAvailableSensor(sensor))
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

  getAvailableSensor(Sensor sensor) {
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
                  sensor.name,
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
                      sensor.id,
                      widget.employee.id);
                  if (response) {
                    var creds =
                        await SharedPrefsService().getCachedCredentials();
                    var data = await logInUser(creds[0], creds[1]);
                    isLoading = false;
                    await Provider.of<UserProvider>(context, listen: false)
                        .setUser(data);
                    Navigator.pop(context);
                  } else {
                    isBeingAssigned = true;
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

  Future<void> refreshUser(data) async {
    await Provider.of<UserProvider>(context, listen: false).setUser(data);
  }

  getProbesInfo(Sensor sensor) {
    return Column(
      children: [
        Expanded(
          child: Container(
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          widget.employee.assignedSensors.isNotEmpty
                              ? SizedBox(
                                  width: screenWidth * 0.25,
                                  child: Center(
                                    child: InkWell(
                                      splashFactory: NoSplash.splashFactory,
                                      highlightColor: Colors.transparent,
                                      onTap: () => sensor.lat.isNotEmpty &&
                                              sensor.lng.isNotEmpty
                                          ? openMap(sensor)
                                          : null,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: sensor.lat.isNotEmpty &&
                                                    sensor.lng.isNotEmpty
                                                ? Colors.blueAccent
                                                : Colors.blueAccent
                                                    .withOpacity(0.5),
                                            borderRadius:
                                                BorderRadius.circular(6.sp),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Color.fromRGBO(
                                                    0, 0, 0, 0.25),
                                                spreadRadius: 1,
                                                blurRadius: 5,
                                                offset: Offset(0,
                                                    1), // changes position of shadow
                                              ),
                                            ]),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: screenWidth * 0.02,
                                              vertical: screenHeight * 0.01),
                                          child: Center(
                                              child: Text(
                                            'Εντοπισμός Εργαζομένου',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: sensor.lat.isNotEmpty &&
                                                        sensor.lng.isNotEmpty
                                                    ? Palette.mainWhiteColor
                                                    : Palette.mainWhiteColor
                                                        .withOpacity(0.75),
                                                fontSize: 5.sp,
                                                fontWeight: FontWeight.bold),
                                          )),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      ),
                      SizedBox(
                        height: screenHeight * 0.05,
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
                      widget.employee.assignedSensors.isNotEmpty
                          ? SizedBox(
                              height: screenHeight * 0.05,
                            )
                          : const SizedBox(),
                      sensor.probe1.isNotEmpty
                          ? sensor.probe1[0]['maptype1_name'].isNotEmpty
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                                            sensor.probe1[0]['maptype1_name'],
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
                                              sensor.probe1[0]['map1_name'] ??
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
                                              sensor.probe1[0][
                                                              'condition1_name'] ==
                                                          null ||
                                                      sensor.probe1[0][
                                                              'condition1_name'] ==
                                                          ''
                                                  ? sensor.probe1[0]
                                                              ['mandatory'] ==
                                                          "True"
                                                      ? 'Υποχρεωτική Χρήση'
                                                      : 'Προαιρετική Χρήση'
                                                  : sensor.probe1[0]
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
                                    sensor.probe1[0]['storage1'] != null
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
                                                        sensor.probe1[0]
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
                                    sensor.probe1[0]['maintenance1'] != null
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
                                                        sensor.probe1[0][
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
                      sensor.probe2.isNotEmpty
                          ? sensor.probe2[0]['maptype2_name'].isNotEmpty
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
                                            sensor.probe2[0]['maptype2_name'],
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
                                              sensor.probe2[0]['map2_name'] ??
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
                                              sensor.probe2[0][
                                                              'condition2_name'] ==
                                                          null ||
                                                      sensor.probe2[0][
                                                              'condition2_name'] ==
                                                          ''
                                                  ? sensor.probe2[0]
                                                              ['mandatory'] ==
                                                          "True"
                                                      ? 'Υποχρεωτική Χρήση'
                                                      : 'Προαιρετική Χρήση'
                                                  : sensor.probe2[0]
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
                                    sensor.probe2[0]['storage2'] != null
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
                                                        sensor.probe2[0]
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
                                    sensor.probe2[0]['maintenance2'] != null
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
                                                        sensor.probe2[0][
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
                      sensor.probe3.isNotEmpty
                          ? sensor.probe3[0]['maptype3_name'].isNotEmpty
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
                                            sensor.probe3[0]['maptype3_name'],
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
                                              sensor.probe3[0]['map3_name'] ??
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
                                              sensor.probe3[0][
                                                              'condition3_name'] ==
                                                          null ||
                                                      sensor.probe3[0][
                                                              'condition3_name'] ==
                                                          ''
                                                  ? sensor.probe3[0]
                                                              ['mandatory'] ==
                                                          "True"
                                                      ? 'Υποχρεωτική Χρήση'
                                                      : 'Προαιρετική Χρήση'
                                                  : sensor.probe3[0]
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
                                    sensor.probe3[0]['storage3'] != null
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
                                                        sensor.probe3[0]
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
                                    sensor.probe3[0]['maintenance3'] != null
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
                                                        sensor.probe3[0][
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
                      sensor.probe4.isNotEmpty
                          ? sensor.probe4[0]['maptype4_name'].isNotEmpty
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
                                            sensor.probe4[0]['maptype4_name'],
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
                                              sensor.probe4[0]['map4_name'] ??
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
                                              sensor.probe4[0][
                                                              'condition4_name'] ==
                                                          null ||
                                                      sensor.probe4[0][
                                                              'condition4_name'] ==
                                                          ''
                                                  ? sensor.probe4[0]
                                                              ['mandatory'] ==
                                                          "True"
                                                      ? 'Υποχρεωτική Χρήση'
                                                      : 'Προαιρετική Χρήση'
                                                  : sensor.probe4[0]
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
                                    sensor.probe4[0]['storage4'] != null
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
                                                        sensor.probe4[0]
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
                                    sensor.probe4[0]['maintenance4'] != null
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
                                                        sensor.probe4[0][
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
                      sensor.probe5.isNotEmpty
                          ? sensor.probe5[0]['maptype5_name'].isNotEmpty
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
                                            sensor.probe5[0]['maptype5_name'],
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
                                              sensor.probe5[0]['map5_name'] ??
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
                                              sensor.probe5[0][
                                                              'condition5_name'] ==
                                                          null ||
                                                      sensor.probe5[0][
                                                              'condition5_name'] ==
                                                          ''
                                                  ? sensor.probe5[0]
                                                              ['mandatory'] ==
                                                          "True"
                                                      ? 'Υποχρεωτική Χρήση'
                                                      : 'Προαιρετική Χρήση'
                                                  : sensor.probe5[0]
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
                                    sensor.probe5[0]['storage5'] != null
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
                                                        sensor.probe5[0]
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
                                    sensor.probe5[0]['maintenance5'] != null
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
                                                        sensor.probe5[0][
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
          ),
        )
      ],
    );
  }

  openMap(sensor) async {
    MapsLauncher.launchCoordinates(
        double.parse(sensor.lat), double.parse(sensor.lng));
  }
}
