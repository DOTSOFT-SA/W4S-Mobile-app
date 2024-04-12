import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:wear4safe/providers/state_provider.dart';
import 'package:wear4safe/providers/user_provider.dart';
import 'package:wear4safe/services/api_calls.dart';

import '../models/assigned_model.dart';
import '../models/employee_model.dart';
import '../models/user_model.dart';

class AssignedSensorsProvider extends ChangeNotifier {
  List<AssignedSensor> assignedSensors = [];
  List<AssignedSensor> assignedSensorsHistory = [];
  bool assignedHistoryHasData = false;

  fetchAssignedSensors(id) async {
    assignedSensors = await getAssignedSensors(id);
  }

  fetchAssignedHistorySensors(context, id) async {
    Provider.of<AppStateProvider>(context, listen: false)
        .setFetchingDataState(true);
    assignedSensorsHistory = await getAssignedHistorySensors(id);
    assignedHistoryHasData = true;
    User user = Provider.of<UserProvider>(context, listen: false).user;
    for (Employee employee in user.employees) {
      for (AssignedSensor assignedSensor in assignedSensors) {
        if (employee.id == assignedSensor.employeeID &&
            assignedSensor.returnedDate.isEmpty) {
          employee.assignedHistorySensors.add(assignedSensor);
        }
      }
    }
    Provider.of<AppStateProvider>(context, listen: false)
        .setFetchingDataState(false);
    notifyListeners();
  }
}
