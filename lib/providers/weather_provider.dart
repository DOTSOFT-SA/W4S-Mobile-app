import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:wear4safe/models/weather_model.dart';
import 'package:wear4safe/providers/state_provider.dart';

import '../services/api_calls.dart';

class WeatherProvider extends ChangeNotifier {
  String description = '';
  String iconID = '';
  double temp = -1000.0;
  List<WeatherModel> weatherList = [];

  fetchWeather(context) async {
    Provider.of<AppStateProvider>(context, listen: false)
        .setFetchingDataState(true);
    var data = await getWeather();
    if (data.isNotEmpty) {
      description = data['weather'];
      iconID = data['iconID'];
      temp = data['temp'];
      weatherList = (data['totalWeather'] as List<dynamic>)
          .map((weather) => WeatherModel.fromJson(weather))
          .toList();
    }
    Provider.of<AppStateProvider>(context, listen: false)
        .setFetchingDataState(false);
    notifyListeners();
  }
}
