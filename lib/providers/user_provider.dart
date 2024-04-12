import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:wear4safe/globals/global_variables.dart';
import 'package:wear4safe/main.dart';
import 'package:wear4safe/models/assigned_model.dart';
import 'package:wear4safe/models/employee_model.dart';
import 'package:wear4safe/models/sensor_model.dart';
import 'package:wear4safe/providers/assigned_provider.dart';
import 'package:wear4safe/providers/state_provider.dart';
import 'package:wear4safe/services/shared_prefs_service.dart';

import '../models/user_model.dart';
import '../services/api_calls.dart';
import 'menu_provider.dart';

class UserProvider extends ChangeNotifier {
  late User user;
  bool userHasData = false;
  int scope = 0;

  getCachedUserScope(context) async {
    scope = await SharedPrefsService().getCachedScope();
    if (scope == 1) {
      Provider.of<MenuProvider>(context, listen: false).setCurrentMenuIndex(2);
    }
    notifyListeners();
  }

  setUserScope(scope, context) {
    this.scope = scope;
    if (scope == 1) {
      Provider.of<MenuProvider>(context, listen: false).setCurrentMenuIndex(2);
    }
    notifyListeners();
  }

  setUser(data) async {
    user = User.fromJson(data);
    organizationID = user.organizationID;
    user.employees.removeWhere((element) => element.professionID.isEmpty);
    user.sensors.removeWhere((element) => element.professionID.isEmpty);
    await Provider.of<AssignedSensorsProvider>(navigatorKey.currentContext!,
            listen: false)
        .fetchAssignedSensors(user.organizationID);
    List<AssignedSensor> assignedSensors = Provider.of<AssignedSensorsProvider>(
            navigatorKey.currentContext!,
            listen: false)
        .assignedSensors;
    setEmployeeAssignmentsStatus(assignedSensors);
    setSensorsAssignmentsStatus(assignedSensors);
    await SharedPrefsService().setLoggedIn();
    userHasData = true;
    notifyListeners();
    Future.delayed(const Duration(seconds: 20)).then((value) {
      callRecursiveUser();
    });
  }

  logOutUser() async {
    await SharedPrefsService().logOutUser();
    userHasData = false;
    notifyListeners();
  }

  void setEmployeeAssignmentsStatus(List<AssignedSensor> assignedSensors) {
    for (Employee employee in user.employees) {
      for (AssignedSensor assignedSensor in assignedSensors) {
        if (employee.id == assignedSensor.employeeID &&
            assignedSensor.returnedDate.isEmpty) {
          var sensorIndex = user.sensors
              .indexWhere((element) => element.id == assignedSensor.sensorID);
          if (sensorIndex != -1) {
            employee.assignedSensors
                .add([assignedSensor, user.sensors[sensorIndex]]);
          }
        } else {
          user.assignedSensors.add(assignedSensor);
          if (employee.id == assignedSensor.employeeID) {
            employee.assignedHistorySensors.add(assignedSensor);
          }
        }
      }
    }

    notifyListeners();
  }

  void setSensorsAssignmentsStatus(List<AssignedSensor> assignedSensors) {
    for (Sensor sensor in user.sensors) {
      var index = assignedSensors.indexWhere((element) {
        return sensor.id == element.sensorID && element.returnedDate.isEmpty;
      });
      if (index != -1) {
        sensor.hasAssigned = true;
      }
    }
    notifyListeners();
  }

  Future<void> callRecursiveUser() async {
    print(' im calling user');
    var credentials = await SharedPrefsService().getCachedCredentials();
    var response = await logInUser(credentials[0], credentials[1]);
    if (response['id'] != null) {
      if (response['id'] == '0') {
      } else {
        await Provider.of<UserProvider>(navigatorKey.currentContext!,
                listen: false)
            .setUser(response);
      }
    }
  }
}
