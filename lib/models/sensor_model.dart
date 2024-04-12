class Sensor {
  String name = '';
  String id;
  bool hasAssigned = false;
  String professionID;
  String lat;
  String lng;
  List probe1;
  List probe2;
  List probe3;
  List probe4;
  List probe5;
  String imei;
  bool isActive = true;

  Sensor.fromJson(Map<String, dynamic> json)
      : id = json['sensor_id'] ?? '',
        name = json['sensor_name'] ?? '',
        probe1 = json['probe_1'] ?? [],
        probe2 = json['probe_2'] ?? [],
        probe3 = json['probe_3'] ?? [],
        probe4 = json['probe_4'] ?? [],
        probe5 = json['probe_5'] ?? [],
        lat = json['lat'] ?? '',
        lng = json['lng'] ?? '',
        professionID = json['profession_id'] ?? '',
        imei = json['imei'] ?? '',
        isActive = json['active'] == null
            ? false
            : json['active'] == 'True'
                ? true
                : false;
}
