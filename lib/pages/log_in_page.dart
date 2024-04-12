// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wear4safe/helpers/colors.dart';
import 'package:wear4safe/main.dart';
import 'package:wear4safe/pages/sensors_page.dart';
import 'package:wear4safe/providers/user_provider.dart';
import 'package:wear4safe/services/shared_prefs_service.dart';

import '../globals/text_fields.dart';
import '../helpers/assets.dart';
import '../helpers/sizer_utils.dart';
import '../providers/alerts_provider.dart';
import '../services/api_calls.dart';
import 'workers_page.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  TextFields emailTextField = TextFields(
    textColor: Palette.mainBlackColor,
    textFieldFillColor: Palette.mainGreyColor,
    labelStyleColor: Colors.white,
    labelTextColor: Colors.white,
    borderEnabledColor: Palette.mainBlackColor,
    borderFocusColor: Palette.mainBlackColor,
    borderErrorColor: Palette.mainBlackColor,
    errorTextColor: Palette.mainRedColor,
  );

  TextFields passwordTextField = TextFields(
    textColor: Palette.mainBlackColor,
    textFieldFillColor: Palette.mainGreyColor,
    labelStyleColor: Colors.white,
    labelTextColor: Colors.white,
    borderEnabledColor: Palette.mainBlackColor,
    borderFocusColor: Palette.mainBlackColor,
    borderErrorColor: Palette.mainBlackColor,
    errorTextColor: Palette.mainRedColor,
  );

  int userScope = 0;
  bool superVisorIsLoading = false;
  bool workerIsLoading = false;
  bool validData = true;
  bool failedToLogIn = false;
  bool wrongCredentials = false;
  String errorMessage = 'Παρακαλώ εισάγετε τον κωδικό πρόσβασης';

  @override
  void initState() {
    super.initState();
    configureTextFields();
  }

  @override
  void dispose() {
    emailTextField.dispose();
    passwordTextField.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: LayoutBuilder(builder: (BuildContext, BoxConstraints) {
          screenWidth = BoxConstraints.maxWidth;
          screenHeight = BoxConstraints.maxHeight;
          return Scaffold(
              backgroundColor: Palette.mainGreyColor,
              resizeToAvoidBottomInset: true,
              body: WillPopScope(
                onWillPop: () async {
                  return false;
                },
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: SingleChildScrollView(
                    child: SizedBox(
                      child: Stack(
                        children: [
                          Center(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: screenHeight * 0.05,
                                ),
                                SizedBox(
                                  width: screenWidth * 0.25,
                                  child: Image.asset(Assets.logo),
                                ),
                                SizedBox(
                                  height: screenHeight * 0.12,
                                ),
                                SizedBox(
                                  width: screenWidth * 0.25,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      getCredentialsFields(),
                                      SizedBox(
                                        height: screenHeight * 0.03,
                                      ),
                                      getSupervisorLogInButton(),
                                      SizedBox(
                                        height: screenHeight * 0.03,
                                      ),
                                      getWorkerLogInButton(),
                                      SizedBox(
                                        height: screenHeight * 0.03,
                                      ),
                                      failedToLogIn
                                          ? Center(
                                              child: Text(
                                                'Παρουσιάστηκε ένα πρόβλημα παρακαλώ δοκιμάστε ξανά αργότερα.',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Palette.mainRedColor,
                                                    fontSize: 4.sp,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            )
                                          : const SizedBox()
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ));
        }),
      ),
    );
  }

  void configureTextFields() {
    emailTextField.borderEnabledRadius = BorderRadius.circular(10.sp);
    emailTextField.borderFocusRadius = BorderRadius.circular(10.sp);
    emailTextField.borderErrorRadius = BorderRadius.circular(10.sp);
    emailTextField.formatSpaces = true;

    passwordTextField.obscureText = true;
    passwordTextField.borderEnabledRadius = BorderRadius.circular(10.sp);
    passwordTextField.borderEnabledRadius = BorderRadius.circular(10.sp);
    passwordTextField.borderFocusRadius = BorderRadius.circular(10.sp);
    passwordTextField.borderErrorRadius = BorderRadius.circular(10.sp);
    passwordTextField.formatSpaces = true;

    emailTextField.controller.addListener(() {
      setState(() {});
    });
    emailTextField.myFocusNode.addListener(() {
      if (emailTextField.myFocusNode.hasFocus) {
        emailTextField.valueIsInvalid = false;
      }
      setState(() {});
    });

    passwordTextField.controller.addListener(() {
      setState(() {});
    });
    passwordTextField.myFocusNode.addListener(() {
      if (passwordTextField.myFocusNode.hasFocus) {
        passwordTextField.valueIsInvalid = false;
      }
      setState(() {});
    });
  }

  getCredentialsFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: screenWidth * 0.01),
          child: Text(
            'Email',
            style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w600),
          ),
        ),
        SizedBox(
          height: screenHeight * 0.015,
        ),
        SizedBox(
          height: screenHeight * 0.09,
          child: emailTextField.customTextField(
              screenWidth * 0.8, '', 'Παρακαλώ εισάγετε το Email'),
        ),
        SizedBox(
          height: screenHeight * 0.025,
        ),
        Padding(
          padding: EdgeInsets.only(left: screenWidth * 0.01),
          child: Align(
            alignment: Alignment.centerLeft,
            child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'Κωδικός Πρόσβασης',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 4.sp),
                )),
          ),
        ),
        SizedBox(
          height: screenHeight * 0.015,
        ),
        SizedBox(
          height: screenHeight * 0.09,
          child: passwordTextField.customTextField(
              screenWidth * 0.8, '', errorMessage),
        ),
      ],
    );
  }

  getSupervisorLogInButton() {
    return Stack(
      children: [
        InkWell(
          splashFactory: NoSplash.splashFactory,
          highlightColor: Colors.transparent,
          onTap: () async {
            if (!superVisorIsLoading && !workerIsLoading) {
              setState(() {
                validData = true;
              });
              validateData();
              if (validData) {
                setState(() {
                  superVisorIsLoading = true;
                });
                var response = await logInUser(emailTextField.controller.text,
                    passwordTextField.controller.text);
                if (response['id'] != null) {
                  if (response['id'] == '0') {
                    errorMessage = 'Εισάγατε λάθος Email ή Κωδικό Πρόσβασης';
                    passwordTextField.valueIsInvalid = true;
                  } else if (response['id'] != '-1') {
                    await Provider.of<UserProvider>(context, listen: false)
                        .setUser(response);
                    Provider.of<UserProvider>(context, listen: false)
                        .setUserScope(0, context);
                    await SharedPrefsService().cacheCredentials(
                        emailTextField.controller.text,
                        passwordTextField.controller.text);
                    await SharedPrefsService().cacheScope(0);
                    Provider.of<AlertsProvider>(context, listen: false)
                        .setAlerts();
                    navigatorKey.currentState?.push(MaterialPageRoute(
                        builder: (context) => const SensorsPage()));
                  } else {
                    failedToLogIn = true;
                  }
                } else {
                  failedToLogIn = true;
                }

                setState(() {
                  superVisorIsLoading = false;
                });
              }
            }
          },
          child: Center(
            child: Container(
              // width: screenWidth * 0.15,
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
                child: superVisorIsLoading
                    ? FittedBox(
                        fit: BoxFit.scaleDown,
                        child: CircularProgressIndicator(
                          color: Palette.mainBlackColor.withOpacity(0.35),
                        ),
                      )
                    : FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Είσοδος Επόπτη',
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

  void validateData() {
    FocusScope.of(context).unfocus();
    failedToLogIn = false;
    errorMessage = 'Παρακαλώ εισάγετε τον κωδικό πρόσβασης';
    if (emailTextField.controller.text.isEmpty) {
      emailTextField.valueIsInvalid = true;
      validData = false;
    }

    if (passwordTextField.controller.text.isEmpty) {
      passwordTextField.valueIsInvalid = true;
      validData = false;
    }
    setState(() {});
  }

  getWorkerLogInButton() {
    return Stack(
      children: [
        InkWell(
          splashFactory: NoSplash.splashFactory,
          highlightColor: Colors.transparent,
          onTap: () async {
            if (!superVisorIsLoading && !workerIsLoading) {
              setState(() {
                validData = true;
              });
              validateData();
              if (validData) {
                setState(() {
                  workerIsLoading = true;
                });
                var response = await logInUser(emailTextField.controller.text,
                    passwordTextField.controller.text);
                if (response['id'] != null) {
                  if (response['id'] == '0') {
                    errorMessage = 'Εισάγατε λάθος Email ή Κωδικό Πρόσβασης';
                    passwordTextField.valueIsInvalid = true;
                  } else {
                    await Provider.of<UserProvider>(context, listen: false)
                        .setUser(response);
                    Provider.of<UserProvider>(context, listen: false)
                        .setUserScope(1, context);
                    await SharedPrefsService().cacheCredentials(
                        emailTextField.controller.text,
                        passwordTextField.controller.text);
                    await SharedPrefsService().cacheScope(1);

                    navigatorKey.currentState?.push(
                      MaterialPageRoute(
                          builder: (context) => const WorkersPage()),
                    );
                  }
                } else {
                  failedToLogIn = true;
                }

                setState(() {
                  workerIsLoading = false;
                });
              }
            }
          },
          child: Center(
            child: Container(
              // width: screenWidth * 0.15,
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
                child: workerIsLoading
                    ? FittedBox(
                        fit: BoxFit.scaleDown,
                        child: CircularProgressIndicator(
                          color: Palette.mainBlackColor.withOpacity(0.35),
                        ),
                      )
                    : FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Είσοδος Εργαζομένου',
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
