// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:string_extensions/string_extensions.dart';
import 'package:wear4safe/globals/app_bar.dart';
import 'package:wear4safe/globals/side_menu.dart';
import 'package:wear4safe/helpers/assets.dart';
import 'package:wear4safe/main.dart';
import 'package:wear4safe/models/employee_model.dart';
import 'package:wear4safe/models/sensor_model.dart';
import 'package:wear4safe/pages/worker_info_page.dart';
import 'package:wear4safe/pages/worker_info_worker_view_page.dart';
import 'package:wear4safe/providers/user_provider.dart';
import 'package:wear4safe/services/api_calls.dart';
import '../globals/text_fields.dart';
import '../helpers/colors.dart';
import '../helpers/sizer_utils.dart';

class WorkersPage extends StatefulWidget {
  const WorkersPage({super.key});

  @override
  State<WorkersPage> createState() => _WorkersPageState();
}

class _WorkersPageState extends State<WorkersPage> {
  bool searchIsLoading = false;

  TextFields pinTextField = TextFields(
    textColor: Palette.mainBlackColor,
    textFieldFillColor: Palette.mainGreyColor,
    labelStyleColor: Colors.white,
    labelTextColor: Colors.white,
    borderEnabledColor: Palette.mainBlackColor,
    borderFocusColor: Palette.mainBlackColor,
    borderErrorColor: Palette.mainBlackColor,
    errorTextColor: Palette.mainRedColor,
  );

  @override
  void initState() {
    pinTextField.borderEnabledRadius = BorderRadius.circular(12.sp);
    pinTextField.borderFocusRadius = BorderRadius.circular(12.sp);
    pinTextField.borderErrorRadius = BorderRadius.circular(12.sp);
    pinTextField.onlyNumbers = true;

    pinTextField.controller.addListener(() {
      setState(() {});
    });
    pinTextField.myFocusNode.addListener(() {
      if (pinTextField.myFocusNode.hasFocus) {
        pinTextField.valueIsInvalid = false;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: LayoutBuilder(builder: (BuildContext, BoxConstraints) {
          screenWidth = BoxConstraints.maxWidth;
          screenHeight = BoxConstraints.maxHeight;
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Scaffold(
                backgroundColor: Palette.mainGreyColor,
                resizeToAvoidBottomInset: false,
                body: SizedBox(
                  child: Stack(
                    children: [
                      customAppBar(
                          context,
                          context.read<UserProvider>().scope == 1
                              ? ''
                              : 'Εργαζόμενοι'),
                      Padding(
                        padding: EdgeInsets.only(top: screenHeight * 0.12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            sideMenu(),
                            context.read<UserProvider>().scope == 0
                                ? Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // SizedBox(
                                        //   height: screenHeight * 0.05,
                                        // ),
                                        // Align(
                                        //   alignment: Alignment.center,
                                        //   child: SizedBox(
                                        //     child: Text(
                                        //       'Λίστα Εργαζομένων',
                                        //       style: TextStyle(
                                        //           color: Palette.mainBlackColor,
                                        //           fontSize: 7.sp,
                                        //           fontWeight: FontWeight.w600),
                                        //     ),
                                        //   ),
                                        // ),
                                        // SizedBox(
                                        //   width: screenWidth * 0.01,
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
                                                .employees
                                                .isEmpty
                                            ? Expanded(
                                                child: SizedBox(
                                                  child: Center(
                                                    child: Text(
                                                      'Δεν υπάρχουν διαθέσιμοι εργαζόμενοι',
                                                      style: TextStyle(
                                                          color: Palette
                                                              .mainBlackColor,
                                                          fontSize: 5.sp,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : getEmployeesList(),
                                      ],
                                    ),
                                  )
                                : SizedBox(
                                    child: getWorkerSearch(),
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

  getEmployeesList() {
    List<Employee> employees = context.read<UserProvider>().user.employees;
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
              children: employees
                  .map<Widget>((employee) => getEmployee(employee))
                  .toList(),
            ),
          ),
        ),
      ),
    ));
  }

  getEmployee(Employee employee) {
    return InkWell(
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => WorkerInfo(
                    employee: employee,
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
              right: screenWidth * 0.01,
              top: screenHeight * 0.03,
              bottom: screenHeight * 0.03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: screenWidth * 0.03,
                    child: Image.asset(Assets.worker),
                  ),
                  SizedBox(
                    width: screenWidth * 0.02,
                  ),
                  SizedBox(
                    width: screenWidth * 0.17,
                    child: Text(
                      '${employee.firstName} ${employee.lastName}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Palette.mainBlackColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 4.sp),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              Center(
                child: SizedBox(
                  width: screenWidth * 0.25,
                  child: Divider(
                    thickness: 0.2.sp,
                    color: Palette.mainBlackColor,
                  ),
                ),
              ),
              employee.professionName.isNotEmpty
                  ? Column(
                      children: [
                        SizedBox(
                          height: screenHeight * 0.02,
                        ),
                        SizedBox(
                          width: screenWidth * 0.8,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  child: Text(
                                    'Ειδικότητα:',
                                    style: TextStyle(
                                        color: Palette.mainBlackColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 4.sp),
                                  ),
                                ),
                                SizedBox(
                                  width: screenWidth * 0.005,
                                ),
                                Column(
                                  children: [
                                    SizedBox(
                                      width: screenWidth * 0.17,
                                      child: Text(
                                        employee.professionName,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Palette.mainGreenColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 4.sp),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox(),
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
                        'Διαθέτει Εξοπλισμό:',
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
                  employee.assignedSensors.isNotEmpty ? "Ναι" : 'Όχι',
                  style: TextStyle(
                      color: employee.assignedSensors.isNotEmpty
                          ? Palette.mainGreenColor
                          : Palette.mainRedColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 4.sp),
                ),
              ),
              employee.assignedSensors.isNotEmpty
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
                                        fontSize: 4.sp),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            child: Text(
                              employee.assignedSensors[0][1].isActive
                                  ? "Ναι"
                                  : 'Όχι',
                              style: TextStyle(
                                  color:
                                      !employee.assignedSensors[0][1].isActive
                                          ? Palette.mainRedColor
                                          : Palette.mainGreenColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 4.sp),
                            ),
                          ),
                        ],
                      );
                    })
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  void callWeather() {
    // Future.delayed(const Duration(milliseconds: 200)).then((value) =>
    //     Provider.of<WeatherProvider>(context, listen: false)
    //         .fetchWeather(context));
  }

  getWorkerSearch() {
    return SizedBox(
      width: screenWidth * 0.9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Εισάγετε το πρoσωπικό σας PIN',
            style: TextStyle(
                color: Palette.mainBlackColor,
                fontWeight: FontWeight.bold,
                fontSize: 6.sp),
          ),
          SizedBox(
            height: screenHeight * 0.05,
          ),
          Padding(
            padding: EdgeInsets.only(left: screenWidth * 0.01),
            child: SizedBox(
              height: screenHeight * 0.09,
              child: pinTextField.customTextField(screenWidth * 0.3, '',
                  'Το ΠΙΝ που εισάγατε δεν αντιστοιχεί σε εργαζόμενο'),
            ),
          ),
          SizedBox(
            height: screenHeight * 0.05,
          ),
          getSearchButton(),
          SizedBox(
            height: screenHeight * 0.2,
          ),
        ],
      ),
    );
  }

  getSearchButton() {
    return Stack(
      children: [
        InkWell(
          splashFactory: NoSplash.splashFactory,
          highlightColor: Colors.transparent,
          onTap: () async {
            if (!searchIsLoading) {
              setState(() {
                searchIsLoading = true;
              });
              var response = await sendPin(pinTextField.controller.text);
              if (response['id'] != null) {
                if (response['id'] == "0") {
                  pinTextField.valueIsInvalid = true;
                } else {
                  Sensor sensor = Sensor.fromJson(response);
                  var value = pinTextField.controller.text;
                  if (value.startsWith('0')) {
                    value = value.substring(1);
                  }
                  var index = Provider.of<UserProvider>(context, listen: false)
                      .user
                      .employees
                      .indexWhere((element) => element.id == value);
                  if (index != -1) {
                    navigatorKey.currentState?.push(
                      MaterialPageRoute(
                          builder: (context) => WorkerInfoWorkerView(
                              employee: Provider.of<UserProvider>(context,
                                      listen: false)
                                  .user
                                  .employees[index],
                              sensor: sensor)),
                    );
                  } else {
                    pinTextField.valueIsInvalid = true;
                  }
                  pinTextField.controller.text = '';
                }
              } else {
                Sensor sensor = Sensor.fromJson(response);
                var value = pinTextField.controller.text;
                if (value.startsWith('0')) {
                  value = value.substring(1);
                }
                var index = Provider.of<UserProvider>(context, listen: false)
                    .user
                    .employees
                    .indexWhere((element) => element.id == value);
                if (index != -1) {
                  navigatorKey.currentState?.push(
                    MaterialPageRoute(
                        builder: (context) => WorkerInfoWorkerView(
                            employee: Provider.of<UserProvider>(context,
                                    listen: false)
                                .user
                                .employees[index],
                            sensor: sensor)),
                  );
                } else {
                  pinTextField.valueIsInvalid = true;
                }
                pinTextField.controller.text = '';
              }
              setState(() {
                searchIsLoading = false;
              });
            }
          },
          child: Center(
            child: Container(
              width: screenWidth * 0.3,
              height: screenHeight * 0.07,
              decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.25),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 1), // changes position of shadow
                    ),
                  ],
                  border: Border.all(
                      color: Palette.mainBlackColor.withOpacity(0.25)),
                  borderRadius: BorderRadius.circular(12.sp),
                  color: Palette.mainGreenColor),
              child: Center(
                child: searchIsLoading
                    ? FittedBox(
                        fit: BoxFit.scaleDown,
                        child: CircularProgressIndicator(
                          color: Palette.mainBlackColor.withOpacity(0.35),
                        ),
                      )
                    : FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Αναζήτηση Εργαζομένου',
                          style: TextStyle(
                              color: Palette.mainWhiteColor,
                              fontSize: 6.sp,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
