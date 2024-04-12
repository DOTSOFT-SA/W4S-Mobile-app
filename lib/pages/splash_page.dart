// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wear4safe/helpers/colors.dart';
import 'package:wear4safe/pages/sensors_page.dart';
import 'package:wear4safe/pages/workers_page.dart';
import 'package:wear4safe/providers/alerts_provider.dart';

import '../helpers/sizer_utils.dart';
import '../providers/user_provider.dart';
import '../services/api_calls.dart';
import '../services/shared_prefs_service.dart';
import 'log_in_page.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    chooseScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: LayoutBuilder(builder: (BuildContext, BoxConstraints) {
          screenWidth = BoxConstraints.maxWidth;
          screenHeight = BoxConstraints.maxHeight;
          return Scaffold(
              resizeToAvoidBottomInset: false,
              body: SizedBox(
                child: Stack(
                  children: [
                    Center(
                      child: Column(
                        children: [
                          SizedBox(
                            height: screenHeight * 0.05,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Palette.mainBlackColor,
                        ),
                      ),
                    )
                  ],
                ),
              ));
        }),
      ),
    );
  }

  Future<void> chooseScreen() async {
    bool isLoggedIn = await SharedPrefsService().isUserLoggedIn();
    if (isLoggedIn) {
      var credentials = await SharedPrefsService().getCachedCredentials();
      if (credentials.isEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LogIn()),
        );
      } else {
        var response = await logInUser(credentials[0], credentials[1]);
        if (response['id'] != null) {
          if (response['id'] == '0') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LogIn()),
            );
          } else {
            await Provider.of<UserProvider>(context, listen: false)
                .setUser(response);
            await Provider.of<UserProvider>(context, listen: false)
                .getCachedUserScope(context);
            if (Provider.of<UserProvider>(context, listen: false).scope == 0) {
              Provider.of<AlertsProvider>(context, listen: false).setAlerts();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SensorsPage()),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WorkersPage()),
              );
            }
          }
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LogIn()),
          );
        }
      }
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LogIn()),
      );
    }
  }
}
