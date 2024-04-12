import 'package:wear4safe/models/sensor_model.dart';

import 'assigned_model.dart';
import 'employee_model.dart';

class User {
  String id;
  String organizationID;
  List<Sensor> sensors = [];
  List<Employee> employees = [];
  List<AssignedSensor> assignedSensors = [];
  String sector;

  User({required this.id, required this.organizationID, required this.sector});

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? '',
        sector = json['sector_id'] ?? '',
        organizationID = json['organization_id'] ?? '',
        sensors = (json["sensors"] as List<dynamic>)
            .map((sensor) => Sensor.fromJson(sensor))
            .toList(),
        employees = (json["employees"] as List<dynamic>)
            .map((employee) => Employee.fromJson(employee))
            .toList();
}
