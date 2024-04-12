import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:provider/provider.dart';
import 'package:string_extensions/string_extensions.dart';
import 'package:wear4safe/models/alerts_model.dart';
import 'package:wear4safe/providers/alerts_provider.dart';

import '../globals/app_bar.dart';
import '../globals/side_menu.dart';
import '../globals/text_fields.dart';
import '../helpers/colors.dart';
import '../helpers/sizer_utils.dart';

class AlertsPage extends StatefulWidget {
  const AlertsPage({super.key});

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  String date = '';
  DateTime? datePicked;

  TextFields nameTextField = TextFields(
    textColor: Palette.mainBlackColor,
    textFieldFillColor: Palette.mainGreyColor,
    labelStyleColor: Colors.white,
    labelTextColor: Colors.white,
    borderEnabledColor: Palette.mainBlackColor,
    borderFocusColor: Palette.mainBlackColor,
    borderErrorColor: Palette.mainBlackColor,
    errorTextColor: Palette.mainRedColor,
  );

  TextFields dateTextField = TextFields(
    textColor: Palette.mainBlackColor,
    textFieldFillColor: Palette.mainGreyColor,
    labelStyleColor: Colors.white,
    labelTextColor: Colors.white,
    borderEnabledColor: Palette.mainBlackColor,
    borderFocusColor: Palette.mainBlackColor,
    borderErrorColor: Palette.mainBlackColor,
    errorTextColor: Palette.mainRedColor,
  );

  void configureTextFields() {
    nameTextField.borderEnabledRadius = BorderRadius.circular(10.sp);
    nameTextField.borderFocusRadius = BorderRadius.circular(10.sp);
    nameTextField.borderErrorRadius = BorderRadius.circular(10.sp);

    nameTextField.controller.addListener(() {
      setState(() {});
    });
    nameTextField.myFocusNode.addListener(() {
      if (nameTextField.myFocusNode.hasFocus) {
        nameTextField.valueIsInvalid = false;
      }
      setState(() {});
    });

    dateTextField.borderEnabledRadius = BorderRadius.circular(10.sp);
    dateTextField.borderFocusRadius = BorderRadius.circular(10.sp);
    dateTextField.borderErrorRadius = BorderRadius.circular(10.sp);

    dateTextField.controller.addListener(() {
      setState(() {});
    });
    dateTextField.myFocusNode.addListener(() {
      if (dateTextField.myFocusNode.hasFocus) {
        dateTextField.valueIsInvalid = false;
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    configureTextFields();
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
                      customAppBar(
                          context, 'Ειδοποιήσεις Μη Ορθής Χρήσης Εξοπλισμού'),
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
                                  getAlerts()
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

  getAlerts() {
    return Expanded(
      child: Row(
        children: [
          Column(
            children: [
              getFilters(),
            ],
          ),
          const Expanded(child: SizedBox()),
          SizedBox(
            width: screenWidth * 0.7,
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
                          width: screenWidth * 0.05,
                        ),
                        SizedBox(
                          width: screenWidth * 0.18,
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
                          width: screenWidth * 0.2,
                          child: Text(
                            'ΜΑΠ',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Palette.mainBlackColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 5.sp),
                          ),
                        ),
                        SizedBox(
                          width: screenWidth * 0.16,
                          child: Text('Ημ/νια. Ειδοποίησης',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Palette.mainBlackColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 5.sp)),
                        ),
                        SizedBox(
                          width: screenWidth * 0.07,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05,
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
                      child: Builder(builder: (context) {
                        List<AlertsModel> alerts = [];
                        alerts.addAll(context
                            .watch<AlertsProvider>()
                            .nonEssentialsAlerts);
                        alerts.retainWhere(
                            (element) => element.employeeName.isNotEmpty);
                        if (nameTextField.controller.text.isNotEmpty) {
                          String? filter = nameTextField.controller.text;
                          filter = filter.trim();
                          filter = filter.toGreekUpperCase();
                          alerts.retainWhere((element) =>
                              element.employeeName
                                  .toGreekUpperCase()
                                  ?.contains(filter ?? '') ??
                              false);
                        }
                        if (dateTextField.controller.text.isNotEmpty) {
                          alerts.retainWhere((element) {
                            var pickedData = DateTime(datePicked!.year,
                                datePicked!.month, datePicked!.day);
                            var alertDate = DateTime.parse(element.date);
                            DateTime customDate = DateTime(
                                alertDate.year, alertDate.month, alertDate.day);
                            return pickedData.isAtSameMomentAs(customDate);
                          });
                        }
                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(
                                height: screenHeight * 0.02,
                              ),
                              context.watch<AlertsProvider>().hasData
                                  ? alerts.isNotEmpty
                                      ? SizedBox(
                                          height: screenHeight,
                                          child: ListView.builder(
                                            itemCount: alerts.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return getPastAlerts(
                                                  alerts[index]);
                                            },
                                          ),
                                        )
                                      : SizedBox(
                                          width: screenWidth,
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: screenHeight * 0.3,
                                              ),
                                              SizedBox(
                                                child: Text(
                                                  context
                                                          .watch<
                                                              AlertsProvider>()
                                                          .nonEssentialsAlerts
                                                          .isEmpty
                                                      ? 'Το ιστορικό ειδοποιήσεων είναι κενό'
                                                      : 'Δεν υπάρχει εγγραφή που να πληρεί τις προϋποθέσεις',
                                                  style: TextStyle(
                                                      color: Palette
                                                          .mainBlackColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 5.sp),
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
                              SizedBox(
                                height: screenHeight * 0.04,
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  getPastAlerts(AlertsModel alert) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
      child: Column(
        children: [
          SizedBox(
            height: screenHeight * 0.02,
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // SizedBox(
                //   width: screenWidth * 0.05,
                // ),
                SizedBox(
                  width: screenWidth * 0.22,
                  child: Text(
                    alert.employeeName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Palette.mainBlackColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 5.sp),
                  ),
                ),
                // SizedBox(
                //   width: screenWidth * 0.1,
                // ),
                SizedBox(
                  width: screenWidth * 0.15,
                  child: Text(
                    alert.mapName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Palette.mainBlackColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 5.sp),
                  ),
                ),
                SizedBox(
                  width: screenWidth * 0.2,
                  child: Text(
                    alert.date,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Palette.mainBlackColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 5.sp),
                  ),
                ),
                SizedBox(
                  width: screenWidth * 0.01,
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

  void lookForAlerts() {
    Future.delayed(const Duration(milliseconds: 100)).then((value) {
      context.read<AlertsProvider>().setAlerts();
    });
  }

  openMap(passedAlert) async {
    AlertsModel alert = passedAlert;
    MapsLauncher.launchCoordinates(
        double.parse(alert.lat), double.parse(alert.long));
  }

  getFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: screenHeight * 0.05,
        ),
        Padding(
          padding: EdgeInsets.only(left: screenWidth * 0.02),
          child: Text(
            'Φίλτρα Αναζήτησης',
            style: TextStyle(
                color: Palette.mainBlackColor,
                fontWeight: FontWeight.bold,
                fontSize: 5.sp),
          ),
        ),
        SizedBox(
          height: screenHeight * 0.08,
        ),
        Padding(
          padding: EdgeInsets.only(left: screenWidth * 0.02),
          child: Text(
            'Εργαζόμενος',
            style: TextStyle(
                color: Palette.mainBlackColor,
                fontWeight: FontWeight.w500,
                fontSize: 5.sp),
          ),
        ),
        SizedBox(
          height: screenHeight * 0.02,
        ),
        Padding(
          padding: EdgeInsets.only(left: screenWidth * 0.01),
          child: SizedBox(
            height: screenHeight * 0.09,
            child: nameTextField.customTextField(screenWidth * 0.2, '', ''),
          ),
        ),
        SizedBox(
          height: screenHeight * 0.02,
        ),
        Padding(
          padding: EdgeInsets.only(left: screenWidth * 0.02),
          child: Text(
            'Ημερομηνία',
            style: TextStyle(
                color: Palette.mainBlackColor,
                fontWeight: FontWeight.w500,
                fontSize: 5.sp),
          ),
        ),
        SizedBox(
          height: screenHeight * 0.02,
        ),
        Padding(
          padding: EdgeInsets.only(left: screenWidth * 0.01),
          child: SizedBox(
            height: screenHeight * 0.09,
            child: Stack(children: [
              dateTextField.customTextField(screenWidth * 0.2, '', ''),
              SizedBox(
                height: screenHeight * 0.1,
                width: screenWidth * 0.2,
                child: InkWell(
                  onTap: () async {
                    datePicked = await DatePicker.showSimpleDatePicker(
                      context,
                      pickerMode: DateTimePickerMode.datetime,
                      backgroundColor: Colors.white,
                      textColor: Palette.mainBlackColor,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2023, 1, 1),
                      lastDate: DateTime.now(),
                      dateFormat: "dd-MMMM-yyyy",
                      looping: false,
                    );
                    if (datePicked != null) {
                      date =
                          "${datePicked?.day}/${datePicked?.month}/${datePicked?.year}";
                      dateTextField.controller.text = date;
                      setState(() {});
                    }
                  },
                ),
              )
            ]),
          ),
        ),
        SizedBox(
          height: screenHeight * 0.05,
        ),
        Padding(
          padding: EdgeInsets.only(left: screenWidth * 0.02),
          child: nameTextField.controller.text.isNotEmpty ||
                  dateTextField.controller.text.isNotEmpty
              ? InkWell(
                  onTap: () {
                    nameTextField.controller.text = '';
                    dateTextField.controller.text = '';
                    setState(() {});
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(6.sp)),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenHeight * 0.02,
                          vertical: screenWidth * 0.01),
                      child: Text(
                        'Καθαρισμός Φίλτρων',
                        style: TextStyle(
                            color: Palette.mainBlackColor,
                            fontSize: 5.sp,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                )
              : SizedBox(),
        )
      ],
    );
  }
}
