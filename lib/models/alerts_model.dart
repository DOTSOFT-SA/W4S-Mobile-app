class AlertsModel {
  String date = '-';
  String employeeName = '-';
  String mapName = '-';
  String lat = '';
  String long = '';
  String sensorName = '';
  String isSOS = "0";
  String employeeID = "-1";

  AlertsModel.fromJson(Map<String, dynamic> json)
      : date = json['dt_tracker'] ?? '-',
        lat = json['lat'] ?? '',
        long = json['lng'] ?? '',
        employeeName = json['employee_name'] ?? '-',
        mapName = json['map_name'] ?? '-',
        sensorName = json['sensor_name'] ?? '-',
        isSOS = json['sos'] ?? "0",
        employeeID = json['employee_id'] ?? '-1';
}
