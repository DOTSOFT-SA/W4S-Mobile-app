import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:wear4safe/helpers/colors.dart';

import '../globals/global_variables.dart';
import '../models/alerts_model.dart';
import '../services/api_calls.dart';

class AlertsProvider extends ChangeNotifier {
  List<AlertsModel> alerts = [];
  bool hasData = false;
  List<AlertsModel> nonEssentialsAlerts = [];
  List<AlertsModel> essentialsAlerts = [];
  DateTime lastNotificationDate = DateTime.now();

  setAlerts() async {
    Future.delayed(Duration(seconds: hasData ? 60 : 1)).then((value) async {
      //Provider.of<AppStateProvider>(context, listen: false)
      //   .setFetchingDataState(true);
      alerts = await getAlerts(organizationID);
      if (alerts.isNotEmpty) {
        nonEssentialsAlerts =
            alerts.where((element) => element.isSOS == '0').toList();
        essentialsAlerts =
            alerts.where((element) => element.isSOS == '1').toList();
      }
      checkNotifications();
      hasData = true;
      notifyListeners();
      // Provider.of<AppStateProvider>(context, listen: false)
      // .setFetchingDataState(false);
      setAlerts();
    });
  }

  checkNotifications() {
    if (essentialsAlerts.isNotEmpty) {
      DateTime dateTime = DateTime.parse(essentialsAlerts.first.date);
      if (dateTime.isAfter(lastNotificationDate)) {
        lastNotificationDate = dateTime;
        AwesomeNotifications().initialize(
            // set the icon to null if you want to use the default app icon
            null,
            [
              NotificationChannel(
                channelGroupKey: 'basic_channel_group',
                channelKey: 'basic_channel',
                channelName: 'Basic notifications',
                channelDescription: 'Notification channel for basic tests',
                //defaultColor: Color(0xFF9D50DD),
              )
            ],
            // Channel groups are only visual and are not required
            // channelGroups: [
            //   NotificationChannelGroup(
            //       channelGroupKey: 'basic_channel_group',
            //       channelGroupName: 'Basic group')
            // ],
            debug: true);
        AwesomeNotifications().createNotification(
            content: NotificationContent(
          id: 10,
          channelKey: 'basic_channel',
          title: 'Έκτακτη Ανάγκη',
          body: 'Ένας εγαζόμενος έστειλε σήμα έκτακτης ανάγκης',
        ));
      }
    }
  }
}
