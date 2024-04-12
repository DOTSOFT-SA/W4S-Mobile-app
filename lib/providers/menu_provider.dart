import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wear4safe/helpers/colors.dart';
import 'package:wear4safe/helpers/sizer_utils.dart';
import 'package:wear4safe/pages/log_in_page.dart';
import 'package:wear4safe/providers/user_provider.dart';

class MenuProvider extends ChangeNotifier {
  int index = 1;
  int previewsIndex = 1;
  int widgetsIndex = 1;

  setCurrentMenuIndex(index) {
    previewsIndex = this.index;
    this.index = index;
    if (index != 0) {
      widgetsIndex = index;
    }
    notifyListeners();
  }

  logOutCanceled() {
    index = previewsIndex;
    notifyListeners();
  }

  logOutScreen(context) {
    showDialog(
      context: context,
      builder: (_) => LogOutView(),
    );
  }
}

class LogOutView extends StatefulWidget {
  LogOutView({super.key});

  @override
  State<LogOutView> createState() => _LogOutViewState();
}

class _LogOutViewState extends State<LogOutView> {
  int choice = 0;
  bool withDelete = false;
  @override
  void initState() {
    DateTime date = DateTime(2023, 9, 22);
    if (DateTime.now().isBefore(date)) {
      withDelete = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Provider.of<MenuProvider>(context, listen: false).logOutCanceled();
        return true;
      },
      child: SizedBox(
        child: Material(
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Palette.mainWhiteColor,
                    borderRadius: BorderRadius.circular(8.sp)),
                width: screenWidth * 0.4,
                height: screenHeight * 0.4,
                child: withDelete
                    ? getLogOutWithDelete()
                    : getLogOutWithoutDelete(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getLogOutWithoutDelete() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: screenHeight * 0.1,
        ),
        Text(
          'Είστε σίγουροι πως θέλετε να αποσυνδεθείτε?',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w500, fontSize: 5.sp),
        ),
        SizedBox(
          height: screenHeight * 0.06,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              splashFactory: NoSplash.splashFactory,
              highlightColor: Colors.transparent,
              onTap: () {
                if (choice == 0) {
                  choice = 1;
                  setState(() {});
                  Future.delayed(const Duration(milliseconds: 400))
                      .then((value) {
                    Provider.of<MenuProvider>(context, listen: false)
                        .logOutCanceled();
                    Navigator.pop(context);
                    setState(() {
                      choice = 0;
                    });
                  });
                }
              },
              child: Container(
                decoration: BoxDecoration(
                    color: choice == 1
                        ? Palette.mainRedColor
                        : Palette.mainBlackColor,
                    borderRadius: BorderRadius.circular(8.sp)),
                child: Padding(
                  padding: EdgeInsets.only(
                      left: screenWidth * 0.027,
                      right: screenWidth * 0.027,
                      top: screenHeight * 0.01,
                      bottom: screenHeight * 0.01),
                  child: Text(
                    'ΟΧΙ',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 5.sp),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: screenWidth * 0.05,
            ),
            InkWell(
              splashFactory: NoSplash.splashFactory,
              highlightColor: Colors.transparent,
              onTap: () {
                if (choice == 0) {
                  choice = 2;
                  setState(() {});
                  Future.delayed(const Duration(milliseconds: 400))
                      .then((value) {
                    Provider.of<MenuProvider>(context, listen: false)
                        .setCurrentMenuIndex(1);
                    Provider.of<UserProvider>(context, listen: false)
                        .logOutUser();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const LogIn()),
                        (Route<dynamic> route) => route is LogIn);
                    setState(() {
                      choice = 0;
                    });
                  });
                }
              },
              child: Container(
                decoration: BoxDecoration(
                    color: choice == 2
                        ? Palette.mainGreenColor
                        : Palette.mainBlackColor,
                    borderRadius: BorderRadius.circular(8.sp)),
                child: Padding(
                  padding: EdgeInsets.only(
                      left: screenWidth * 0.027,
                      right: screenWidth * 0.027,
                      top: screenHeight * 0.01,
                      bottom: screenHeight * 0.01),
                  child: Text(
                    'NAI',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 5.sp),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: screenHeight * 0.02,
        ),
      ],
    );
  }

  getLogOutWithDelete() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Διαγράψτε τον λογαριασμό σας ή αποσυνδεθείτε απο την εφαρμογή',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w500, fontSize: 5.sp),
        ),
        SizedBox(
          height: screenHeight * 0.06,
        ),
        InkWell(
          splashFactory: NoSplash.splashFactory,
          highlightColor: Colors.transparent,
          onTap: () {
            if (choice == 0) {
              choice = 1;
              setState(() {});
              Future.delayed(const Duration(milliseconds: 400)).then((value) {
                Provider.of<MenuProvider>(context, listen: false)
                    .setCurrentMenuIndex(1);
                Provider.of<UserProvider>(context, listen: false).logOutUser();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LogIn()),
                    (Route<dynamic> route) => route is LogIn);
                setState(() {
                  choice = 0;
                });
              });
            }
          },
          child: Container(
            decoration: BoxDecoration(
                color:
                    choice == 1 ? Palette.mainRedColor : Palette.mainBlackColor,
                borderRadius: BorderRadius.circular(8.sp)),
            child: Padding(
              padding: EdgeInsets.only(
                  left: screenWidth * 0.027,
                  right: screenWidth * 0.027,
                  top: screenHeight * 0.01,
                  bottom: screenHeight * 0.01),
              child: Text(
                'Διαγραφή',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 5.sp),
              ),
            ),
          ),
        ),
        SizedBox(
          height: screenHeight * 0.03,
        ),
        InkWell(
          splashFactory: NoSplash.splashFactory,
          highlightColor: Colors.transparent,
          onTap: () {
            if (choice == 0) {
              choice = 2;
              setState(() {});
              Future.delayed(const Duration(milliseconds: 400)).then((value) {
                Provider.of<MenuProvider>(context, listen: false)
                    .setCurrentMenuIndex(1);
                Provider.of<UserProvider>(context, listen: false).logOutUser();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LogIn()),
                    (Route<dynamic> route) => route is LogIn);
                setState(() {
                  choice = 0;
                });
              });
            }
          },
          child: Container(
            decoration: BoxDecoration(
                color: choice == 2
                    ? Palette.mainGreenColor
                    : Palette.mainBlackColor,
                borderRadius: BorderRadius.circular(8.sp)),
            child: Padding(
              padding: EdgeInsets.only(
                  left: screenWidth * 0.027,
                  right: screenWidth * 0.027,
                  top: screenHeight * 0.01,
                  bottom: screenHeight * 0.01),
              child: Text(
                'Αποσύνδεση',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 5.sp),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
