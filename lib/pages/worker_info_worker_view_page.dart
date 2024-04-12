import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

class WorkerInfoWorkerView extends StatefulWidget {
  Employee employee;
  Sensor sensor;

  WorkerInfoWorkerView(
      {super.key, required this.employee, required this.sensor});

  @override
  State<WorkerInfoWorkerView> createState() => _WorkerInfoWorkerViewState();
}

class _WorkerInfoWorkerViewState extends State<WorkerInfoWorkerView> {
  bool isLoading = false;
  bool assignmentIsActive = false;
  bool isSendingData = false;
  bool issueIsActive = false;
  bool check1 = false;
  bool check2 = false;
  bool check3 = false;
  bool check4 = false;
  bool check5 = false;
  var mapID = '1';

  @override
  void initState() {
    super.initState();
    callPinRecursive();
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
                      issueIsActive ? getIssueWindow() : const SizedBox(),
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
                  Column(
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
                        height: screenHeight * 0.03,
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
                  SizedBox(
                    width: screenWidth * 0.02,
                  ),
                  widget.employee.assignedSensors.isEmpty
                      ? const SizedBox()
                      : getProbesInfo()
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
                    height: screenHeight * 0.3,
                    child: ScrollConfiguration(
                      behavior:
                          const ScrollBehavior().copyWith(overscroll: false),
                      child: SingleChildScrollView(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: widget.employee.assignedSensors
                                .map<Widget>((sensor) => getAssignedSensorsInfo(
                                    sensor, sensor[0], sensor[1]))
                                .toList()),
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
    return Padding(
      padding: EdgeInsets.only(right: screenWidth * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: screenHeight * 0.02,
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
            height: screenHeight * 0.02,
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
            height: screenHeight * 0.04,
          ),
          Provider.of<UserProvider>(context, listen: false).scope == 0
              ? SizedBox(
                  width: screenWidth * 0.32,
                  child: Center(
                    child: InkWell(
                      splashFactory: NoSplash.splashFactory,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        removeSensor(assignedSensor, sensor, currentSensor);
                      },
                      child: Container(
                        width: screenWidth * 0.2,
                        decoration: BoxDecoration(
                            color: Palette.mainRedColor,
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
                )
              : const SizedBox(),
          widget.employee.assignedSensors.isNotEmpty
              ? SizedBox(
                  width: screenWidth * 0.32,
                  child: Center(
                    child: InkWell(
                      splashFactory: NoSplash.splashFactory,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        setState(() {
                          issueIsActive = true;
                          isLoading = true;
                        });
                      },
                      child: Container(
                        width: screenWidth * 0.2,
                        decoration: BoxDecoration(
                            color: Palette.mainRedColor,
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
                            child: Text(
                              'Αναφορά Προβλήματος',
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
                )
              : const SizedBox()
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

  getIssueWindow() {
    return Stack(
      children: [
        Center(
          child: Container(
            width: screenWidth * 0.4,
            height: screenHeight * 0.8,
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
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                SizedBox(
                    child: Text(
                  'Αναφορά Προβλήματος',
                  style: TextStyle(
                      color: Palette.mainBlackColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 5.sp),
                )),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                SizedBox(
                  height: screenHeight * 0.34,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                      child: Column(
                        children: [
                          SizedBox(
                            height: screenHeight * 0.03,
                          ),
                          widget.sensor.probe1[0]['maptype1_name'].isNotEmpty
                              ? Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          check1 = true;
                                          check2 = false;
                                          check3 = false;
                                          check4 = false;
                                          check5 = false;
                                          mapID = widget.sensor.probe1[0]
                                              ['maptype1_id'];
                                        });
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            child: SizedBox(
                                              child: Icon(
                                                check1
                                                    ? Icons
                                                        .radio_button_checked_outlined
                                                    : Icons
                                                        .radio_button_off_outlined,
                                                size: 7.sp,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: screenWidth * 0.02,
                                          ),
                                          SizedBox(
                                              width: screenWidth * 0.3,
                                              child: Text(
                                                  widget.sensor.probe1[0]
                                                      ['maptype1_name'],
                                                  style: TextStyle(
                                                      color: Palette
                                                          .mainBlackColor,
                                                      fontSize: 5.sp,
                                                      fontWeight:
                                                          FontWeight.w600))),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: screenHeight * 0.02,
                                    )
                                  ],
                                )
                              : const SizedBox(),
                          widget.sensor.probe2[0]['maptype2_name'].isNotEmpty
                              ? Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          check2 = true;
                                          check1 = false;
                                          check3 = false;
                                          check4 = false;
                                          check5 = false;
                                          mapID = widget.sensor.probe2[0]
                                              ['maptype2_id'];
                                        });
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            child: Icon(
                                              check2
                                                  ? Icons
                                                      .radio_button_checked_outlined
                                                  : Icons
                                                      .radio_button_off_outlined,
                                              size: 7.sp,
                                            ),
                                          ),
                                          SizedBox(
                                            width: screenWidth * 0.02,
                                          ),
                                          SizedBox(
                                              width: screenWidth * 0.3,
                                              child: Text(
                                                  widget.sensor.probe2[0]
                                                      ['maptype2_name'],
                                                  style: TextStyle(
                                                      color: Palette
                                                          .mainBlackColor,
                                                      fontSize: 5.sp,
                                                      fontWeight:
                                                          FontWeight.w600))),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: screenHeight * 0.02,
                                    )
                                  ],
                                )
                              : const SizedBox(),
                          widget.sensor.probe3[0]['maptype3_name'].isNotEmpty
                              ? Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          check3 = true;
                                          check2 = false;
                                          check1 = false;
                                          check4 = false;
                                          check5 = false;
                                          mapID = widget.sensor.probe3[0]
                                              ['maptype3_id'];
                                        });
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            child: Icon(
                                              check3
                                                  ? Icons
                                                      .radio_button_checked_outlined
                                                  : Icons
                                                      .radio_button_off_outlined,
                                              size: 7.sp,
                                            ),
                                          ),
                                          SizedBox(
                                            width: screenWidth * 0.02,
                                          ),
                                          SizedBox(
                                              width: screenWidth * 0.3,
                                              child: Text(
                                                  widget.sensor.probe3[0]
                                                      ['maptype3_name'],
                                                  style: TextStyle(
                                                      color: Palette
                                                          .mainBlackColor,
                                                      fontSize: 5.sp,
                                                      fontWeight:
                                                          FontWeight.w600))),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: screenHeight * 0.02,
                                    )
                                  ],
                                )
                              : const SizedBox(),
                          widget.sensor.probe4[0]['maptype4_name'].isNotEmpty
                              ? Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          check4 = true;
                                          check2 = false;
                                          check3 = false;
                                          check1 = false;
                                          check5 = false;
                                          mapID = widget.sensor.probe4[0]
                                              ['maptype4_id'];
                                        });
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            child: Icon(
                                              check4
                                                  ? Icons
                                                      .radio_button_checked_outlined
                                                  : Icons
                                                      .radio_button_off_outlined,
                                              size: 7.sp,
                                            ),
                                          ),
                                          SizedBox(
                                            width: screenWidth * 0.02,
                                          ),
                                          SizedBox(
                                              width: screenWidth * 0.3,
                                              child: Text(
                                                  widget.sensor.probe4[0]
                                                      ['maptype4_name'],
                                                  style: TextStyle(
                                                      color: Palette
                                                          .mainBlackColor,
                                                      fontSize: 5.sp,
                                                      fontWeight:
                                                          FontWeight.w600))),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: screenHeight * 0.02,
                                    )
                                  ],
                                )
                              : const SizedBox(),
                          widget.sensor.probe5[0]['maptype5_name'].isNotEmpty
                              ? Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          check5 = true;
                                          check2 = false;
                                          check3 = false;
                                          check4 = false;
                                          check1 = false;
                                          mapID = widget.sensor.probe5[0]
                                              ['maptype5_id'];
                                        });
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            child: Icon(
                                              check5
                                                  ? Icons
                                                      .radio_button_checked_outlined
                                                  : Icons
                                                      .radio_button_off_outlined,
                                              size: 7.sp,
                                            ),
                                          ),
                                          SizedBox(
                                            width: screenWidth * 0.02,
                                          ),
                                          SizedBox(
                                              width: screenWidth * 0.3,
                                              child: Text(
                                                  widget.sensor.probe5[0]
                                                      ['maptype5_name'],
                                                  style: TextStyle(
                                                      color: Palette
                                                          .mainBlackColor,
                                                      fontSize: 5.sp,
                                                      fontWeight:
                                                          FontWeight.w600))),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: screenHeight * 0.02,
                                    )
                                  ],
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                  ),
                ),
                getIssuedOptions(),
                const Expanded(child: SizedBox()),
                InkWell(
                  onTap: () {
                    isLoading = false;
                    issueIsActive = false;
                    check1 = false;
                    check2 = false;
                    check3 = false;
                    check4 = false;
                    check5 = false;
                    setState(() {});
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
        isSendingData
            ? Center(
                child: Container(
                  width: screenWidth * 0.4,
                  height: screenHeight * 0.8,
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
                  isSendingData = true;
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
                    isSendingData = true;
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

  getProbesInfo() {
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
                      Padding(
                        padding: EdgeInsets.only(left: screenWidth * 0.02),
                        child: Text(
                          'Σήμερα πρέπει να φορέσω:',
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
                          ? widget.sensor.probe1[0]['display1'] == 'True'
                              ? widget.sensor.probe1[0]['maptype1_name']
                                      .isNotEmpty
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(width: screenWidth * 0.02),
                                            Text(
                                              '',
                                              style: TextStyle(
                                                  color: Palette.mainBlackColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 5.sp),
                                            ),
                                            SizedBox(
                                              width: screenWidth * 0.3,
                                              child: Text(
                                                widget.sensor.probe1[0]
                                                    ['maptype1_name'],
                                                style: TextStyle(
                                                    color:
                                                        Palette.mainBlackColor,
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
                                                    color:
                                                        Palette.mainBlackColor,
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
                                                    color:
                                                        Palette.mainBlackColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 5.sp),
                                              ),
                                              SizedBox(
                                                width: screenWidth * 0.3,
                                                child: Text(
                                                  widget.sensor.probe1[0][
                                                          'current_condition1'] ??
                                                      'Υποχρεωτική χρήση',
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
                                        widget.sensor.probe1[0]['storage1'] !=
                                                null
                                            ? Column(
                                                children: [
                                                  SizedBox(
                                                    height: screenHeight * 0.03,
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left:
                                                            screenWidth * 0.02),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Αποθήκευση: ',
                                                          style: TextStyle(
                                                              color: Palette
                                                                  .mainBlackColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 5.sp),
                                                        ),
                                                        SizedBox(
                                                          width:
                                                              screenWidth * 0.3,
                                                          child: Text(
                                                            widget.sensor.probe1[
                                                                        0][
                                                                    'storage1'] ??
                                                                '',
                                                            style: TextStyle(
                                                                color: Palette
                                                                    .mainBlackColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 5.sp),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : const SizedBox(),
                                        widget.sensor.probe1[0]
                                                    ['maintenance1'] !=
                                                null
                                            ? Column(
                                                children: [
                                                  SizedBox(
                                                    height: screenHeight * 0.03,
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left:
                                                            screenWidth * 0.02),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Συντήρηση: ',
                                                          style: TextStyle(
                                                              color: Palette
                                                                  .mainBlackColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 5.sp),
                                                        ),
                                                        SizedBox(
                                                          width:
                                                              screenWidth * 0.3,
                                                          child: Text(
                                                            widget.sensor.probe1[
                                                                        0][
                                                                    'maintenance1'] ??
                                                                '',
                                                            style: TextStyle(
                                                                color: Palette
                                                                    .mainBlackColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
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
                              : const SizedBox()
                          : const SizedBox(),
                      widget.sensor.probe2.isNotEmpty
                          ? widget.sensor.probe2[0]['display2'] == 'True'
                              ? widget.sensor.probe2[0]['maptype2_name']
                                      .isNotEmpty
                                  ? Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(width: screenWidth * 0.02),
                                            Text(
                                              '',
                                              style: TextStyle(
                                                  color: Palette.mainBlackColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 5.sp),
                                            ),
                                            SizedBox(
                                              width: screenWidth * 0.3,
                                              child: Text(
                                                widget.sensor.probe2[0]
                                                    ['maptype2_name'],
                                                style: TextStyle(
                                                    color:
                                                        Palette.mainBlackColor,
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
                                                    color:
                                                        Palette.mainBlackColor,
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
                                                    color:
                                                        Palette.mainBlackColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 5.sp),
                                              ),
                                              SizedBox(
                                                width: screenWidth * 0.3,
                                                child: Text(
                                                  widget.sensor.probe2[0][
                                                          'current_condition2'] ??
                                                      'Υποχρεωτική χρήση',
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
                                        widget.sensor.probe2[0]['storage2'] !=
                                                null
                                            ? Column(
                                                children: [
                                                  SizedBox(
                                                    height: screenHeight * 0.03,
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left:
                                                            screenWidth * 0.02),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Αποθήκευση: ',
                                                          style: TextStyle(
                                                              color: Palette
                                                                  .mainBlackColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 5.sp),
                                                        ),
                                                        SizedBox(
                                                          width:
                                                              screenWidth * 0.3,
                                                          child: Text(
                                                            widget.sensor.probe2[
                                                                        0][
                                                                    'storage2'] ??
                                                                '',
                                                            style: TextStyle(
                                                                color: Palette
                                                                    .mainBlackColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 5.sp),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : const SizedBox(),
                                        widget.sensor.probe2[0]
                                                    ['maintenance2'] !=
                                                null
                                            ? Column(
                                                children: [
                                                  SizedBox(
                                                    height: screenHeight * 0.03,
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left:
                                                            screenWidth * 0.02),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Συντήρηση: ',
                                                          style: TextStyle(
                                                              color: Palette
                                                                  .mainBlackColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 5.sp),
                                                        ),
                                                        SizedBox(
                                                          width:
                                                              screenWidth * 0.3,
                                                          child: Text(
                                                            widget.sensor.probe2[
                                                                        0][
                                                                    'maintenance2'] ??
                                                                '',
                                                            style: TextStyle(
                                                                color: Palette
                                                                    .mainBlackColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
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
                              : const SizedBox()
                          : const SizedBox(),
                      widget.sensor.probe3.isNotEmpty
                          ? widget.sensor.probe3[0]['display3'] == 'True'
                              ? widget.sensor.probe3[0]['maptype3_name']
                                      .isNotEmpty
                                  ? Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(width: screenWidth * 0.02),
                                            Text(
                                              '',
                                              style: TextStyle(
                                                  color: Palette.mainBlackColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 5.sp),
                                            ),
                                            SizedBox(
                                              width: screenWidth * 0.3,
                                              child: Text(
                                                widget.sensor.probe3[0]
                                                    ['maptype3_name'],
                                                style: TextStyle(
                                                    color:
                                                        Palette.mainBlackColor,
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
                                                    color:
                                                        Palette.mainBlackColor,
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
                                                    color:
                                                        Palette.mainBlackColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 5.sp),
                                              ),
                                              SizedBox(
                                                width: screenWidth * 0.3,
                                                child: Text(
                                                  widget.sensor.probe3[0][
                                                          'current_condition3'] ??
                                                      'Υποχρεωτική χρήση',
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
                                        widget.sensor.probe3[0]['storage3'] !=
                                                null
                                            ? Column(
                                                children: [
                                                  SizedBox(
                                                    height: screenHeight * 0.03,
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left:
                                                            screenWidth * 0.02),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Αποθήκευση: ',
                                                          style: TextStyle(
                                                              color: Palette
                                                                  .mainBlackColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 5.sp),
                                                        ),
                                                        SizedBox(
                                                          width:
                                                              screenWidth * 0.3,
                                                          child: Text(
                                                            widget.sensor.probe3[
                                                                        0][
                                                                    'storage3'] ??
                                                                '',
                                                            style: TextStyle(
                                                                color: Palette
                                                                    .mainBlackColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 5.sp),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : const SizedBox(),
                                        widget.sensor.probe3[0]
                                                    ['maintenance3'] !=
                                                null
                                            ? Column(
                                                children: [
                                                  SizedBox(
                                                    height: screenHeight * 0.03,
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left:
                                                            screenWidth * 0.02),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Συντήρηση: ',
                                                          style: TextStyle(
                                                              color: Palette
                                                                  .mainBlackColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 5.sp),
                                                        ),
                                                        SizedBox(
                                                          width:
                                                              screenWidth * 0.3,
                                                          child: Text(
                                                            widget.sensor.probe3[
                                                                        0][
                                                                    'maintenance3'] ??
                                                                '',
                                                            style: TextStyle(
                                                                color: Palette
                                                                    .mainBlackColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
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
                              : const SizedBox()
                          : const SizedBox(),
                      widget.sensor.probe4.isNotEmpty
                          ? widget.sensor.probe4[0]['display4'] == 'True'
                              ? widget.sensor.probe4[0]['maptype4_name']
                                      .isNotEmpty
                                  ? Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(width: screenWidth * 0.02),
                                            Text(
                                              '',
                                              style: TextStyle(
                                                  color: Palette.mainBlackColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 5.sp),
                                            ),
                                            SizedBox(
                                              width: screenWidth * 0.3,
                                              child: Text(
                                                widget.sensor.probe4[0]
                                                    ['maptype4_name'],
                                                style: TextStyle(
                                                    color:
                                                        Palette.mainBlackColor,
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
                                                    color:
                                                        Palette.mainBlackColor,
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
                                                    color:
                                                        Palette.mainBlackColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 5.sp),
                                              ),
                                              SizedBox(
                                                width: screenWidth * 0.3,
                                                child: Text(
                                                  widget.sensor.probe4[0][
                                                          'current_condition4'] ??
                                                      'Υποχρεωτική χρήση',
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
                                        widget.sensor.probe4[0]['storage4'] !=
                                                null
                                            ? Column(
                                                children: [
                                                  SizedBox(
                                                    height: screenHeight * 0.03,
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left:
                                                            screenWidth * 0.02),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Αποθήκευση: ',
                                                          style: TextStyle(
                                                              color: Palette
                                                                  .mainBlackColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 5.sp),
                                                        ),
                                                        SizedBox(
                                                          width:
                                                              screenWidth * 0.3,
                                                          child: Text(
                                                            widget.sensor.probe4[
                                                                        0][
                                                                    'storage4'] ??
                                                                '',
                                                            style: TextStyle(
                                                                color: Palette
                                                                    .mainBlackColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 5.sp),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : const SizedBox(),
                                        widget.sensor.probe4[0]
                                                    ['maintenance4'] !=
                                                null
                                            ? Column(
                                                children: [
                                                  SizedBox(
                                                    height: screenHeight * 0.03,
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left:
                                                            screenWidth * 0.02),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Συντήρηση: ',
                                                          style: TextStyle(
                                                              color: Palette
                                                                  .mainBlackColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 5.sp),
                                                        ),
                                                        SizedBox(
                                                          width:
                                                              screenWidth * 0.3,
                                                          child: Text(
                                                            widget.sensor.probe4[
                                                                        0][
                                                                    'maintenance4'] ??
                                                                '',
                                                            style: TextStyle(
                                                                color: Palette
                                                                    .mainBlackColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
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
                              : const SizedBox()
                          : const SizedBox(),
                      widget.sensor.probe5.isNotEmpty
                          ? widget.sensor.probe5[0]['display5'] == 'True'
                              ? widget.sensor.probe5[0]['maptype5_name']
                                      .isNotEmpty
                                  ? Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(width: screenWidth * 0.02),
                                            Text(
                                              '',
                                              style: TextStyle(
                                                  color: Palette.mainBlackColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 5.sp),
                                            ),
                                            SizedBox(
                                              width: screenWidth * 0.3,
                                              child: Text(
                                                widget.sensor.probe5[0]
                                                    ['maptype5_name'],
                                                style: TextStyle(
                                                    color:
                                                        Palette.mainBlackColor,
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
                                                    color:
                                                        Palette.mainBlackColor,
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
                                                    color:
                                                        Palette.mainBlackColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 5.sp),
                                              ),
                                              SizedBox(
                                                width: screenWidth * 0.3,
                                                child: Text(
                                                  widget.sensor.probe5[0][
                                                          'current_condition5'] ??
                                                      'Υποχρεωτική χρήση',
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
                                        widget.sensor.probe5[0]['storage5'] !=
                                                null
                                            ? Column(
                                                children: [
                                                  SizedBox(
                                                    height: screenHeight * 0.03,
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left:
                                                            screenWidth * 0.02),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Αποθήκευση: ',
                                                          style: TextStyle(
                                                              color: Palette
                                                                  .mainBlackColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 5.sp),
                                                        ),
                                                        SizedBox(
                                                          width:
                                                              screenWidth * 0.3,
                                                          child: Text(
                                                            widget.sensor.probe5[
                                                                        0][
                                                                    'storage5'] ??
                                                                '',
                                                            style: TextStyle(
                                                                color: Palette
                                                                    .mainBlackColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 5.sp),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : const SizedBox(),
                                        widget.sensor.probe5[0]
                                                    ['maintenance5'] !=
                                                null
                                            ? Column(
                                                children: [
                                                  SizedBox(
                                                    height: screenHeight * 0.03,
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left:
                                                            screenWidth * 0.02),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Συντήρηση: ',
                                                          style: TextStyle(
                                                              color: Palette
                                                                  .mainBlackColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 5.sp),
                                                        ),
                                                        SizedBox(
                                                          width:
                                                              screenWidth * 0.3,
                                                          child: Text(
                                                            widget.sensor.probe5[
                                                                        0][
                                                                    'maintenance5'] ??
                                                                '',
                                                            style: TextStyle(
                                                                color: Palette
                                                                    .mainBlackColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
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

  getIssuedOptions() {
    bool showOptions = false;
    if (check1 || check2 || check3 || check4 || check5) {
      showOptions = true;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: screenHeight * 0.02,
        ),
        SizedBox(
          child: Center(
            child: InkWell(
              splashFactory: NoSplash.splashFactory,
              highlightColor: Colors.transparent,
              onTap: () async {
                if (showOptions) {
                  isSendingData = true;
                  setState(() {});
                  var response = await sendIssue(
                      '1', widget.sensor.id, widget.employee.id, mapID);
                  isSendingData = false;
                  isLoading = false;
                  issueIsActive = false;
                  check1 = false;
                  check2 = false;
                  check3 = false;
                  check4 = false;
                  check5 = false;
                  setState(() {});
                }
              },
              child: Container(
                width: screenWidth * 0.2,
                decoration: BoxDecoration(
                    color: showOptions
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
                      child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Δεν είναι διαθέσιμο',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Palette.mainWhiteColor,
                          fontSize: 5.sp,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: screenHeight * 0.02,
        ),
        SizedBox(
          child: Center(
            child: InkWell(
              splashFactory: NoSplash.splashFactory,
              highlightColor: Colors.transparent,
              onTap: () async {
                if (showOptions) {
                  isSendingData = true;
                  setState(() {});
                  var response = await sendIssue(
                      '2', widget.sensor.id, widget.employee.id, mapID);
                  isSendingData = false;
                  isLoading = false;
                  issueIsActive = false;
                  check1 = false;
                  check2 = false;
                  check3 = false;
                  check4 = false;
                  check5 = false;
                  setState(() {});
                }
              },
              child: Container(
                width: screenWidth * 0.2,
                decoration: BoxDecoration(
                    color: showOptions
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
                      child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Έχει φθορά',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Palette.mainWhiteColor,
                          fontSize: 5.sp,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: screenHeight * 0.02,
        ),
        SizedBox(
          child: Center(
            child: InkWell(
              splashFactory: NoSplash.splashFactory,
              highlightColor: Colors.transparent,
              onTap: () async {
                if (showOptions) {
                  isSendingData = true;
                  setState(() {});
                  var response = await sendIssue(
                      '3', widget.sensor.id, widget.employee.id, mapID);
                  isSendingData = false;
                  isLoading = false;
                  issueIsActive = false;
                  check1 = false;
                  check2 = false;
                  check3 = false;
                  check4 = false;
                  check5 = false;
                  setState(() {});
                }
              },
              child: Container(
                width: screenWidth * 0.2,
                decoration: BoxDecoration(
                    color: showOptions
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
                      child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Άλλο',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Palette.mainWhiteColor,
                          fontSize: 5.sp,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> callPinRecursive() async {
    Future.delayed(const Duration(seconds: 5)).then((value) async {
      print('im calling recursive pin');
      var response = await sendPin(widget.employee.id);
      if (response['id'] != null) {
        if (response['id'] == "0") {
          navigatorKey?.currentState?.pop();
        } else {
          Sensor sensor = Sensor.fromJson(response);

          var index = Provider.of<UserProvider>(context, listen: false)
              .user
              .employees
              .indexWhere((element) => element.id == widget.employee.id);
          if (index != -1) {
            widget.employee = Provider.of<UserProvider>(context, listen: false)
                .user
                .employees[index];
            widget.sensor = sensor;
          } else {
            navigatorKey?.currentState?.pop();
          }
        }
      } else {
        Sensor sensor = Sensor.fromJson(response);

        var index = Provider.of<UserProvider>(context, listen: false)
            .user
            .employees
            .indexWhere((element) => element.id == widget.employee.id);
        if (index != -1) {
          widget.employee = Provider.of<UserProvider>(context, listen: false)
              .user
              .employees[index];
          widget.sensor = sensor;
        } else {
          navigatorKey?.currentState?.pop();
          navigatorKey?.currentState?.pop();
        }
      }
      setState(() {});
      callPinRecursive();
    });
  }
}
