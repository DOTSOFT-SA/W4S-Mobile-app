class AssignedSensor {
  String id;
  //String userId;
  String sensorID;
  String employeeID;
  String employeeName;
  String sensorName;
  String assignedDate;
  String returnedDate;
  String userName;

  AssignedSensor.fromJson(Map<String, dynamic> json)
      : id = json['assignment_id'] ?? '',
        sensorID = json['sensor_id'] ?? '',
        employeeID = json['employee_id'] ?? '',
        employeeName = json['employee_fullname'] ?? '',
        userName = json['user_fullname'] ?? '',
        sensorName = json['sensor_name'] ?? '',
        assignedDate = json['assignment_date'] ?? '',
        returnedDate = json['return_date'] ?? '';
}
