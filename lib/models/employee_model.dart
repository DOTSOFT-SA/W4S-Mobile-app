import 'package:wear4safe/models/profession_map_model.dart';
import 'package:wear4safe/models/sensor_model.dart';

import 'assigned_model.dart';

class Employee {
  late String id;
  late String firstName;
  late String lastName;
  late String phone;
  String professionName;
  List<ProfessionMap> professionMaps = [];
  String professionID;
  String email;
  List assignedSensors = [];
  List<AssignedSensor> assignedHistorySensors = [];
  String pin;

  Employee.fromJson(Map<String, dynamic> json)
      : id = json['employee_id'] ?? '',
        firstName = json['firstname'] ?? '',
        lastName = json['surname'] ?? '',
        phone = json['phone'] ?? '',
        professionName = json['profession_name'] ?? '',
        professionID = json['profession_id'] ?? '',
        email = json['email'] ?? '',
        pin = json['pin'] ?? '';
}
