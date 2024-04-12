class WeatherModel {
  int timeStamp = 0;
  double temp = -1000.0;
  int humidity = -100;
  String weatherStatus = '';
  String weatherIcon = '';

  WeatherModel.fromJson(Map<String, dynamic> json)
      : timeStamp = json['timestamp'] ?? 0,
        temp = double.parse(json['temp'].toString()) ?? -1000.0,
        humidity = json['humidity'] ?? -100,
        weatherStatus = json['weatherStatus'] ?? '',
        weatherIcon = json['weatherIcon'] ?? '';
}
