import 'dart:convert';

import 'package:http/http.dart';
import 'package:wear4safe/models/alerts_model.dart';
import 'package:wear4safe/models/assigned_model.dart';
import 'package:wear4safe/models/profession_map_model.dart';

import 'api_services.dart';

Future logInUser(email, password) async {
  List data = [
    {"id": "-1"}
  ];
  try {
    Response response = await logInUserService(email, password);
    if (response.statusCode != 200) {
      return data[0];
    } else {
      if (data.isNotEmpty) {
        data[0] = jsonDecode(response.body);
        if (data[0] is List) {
          data[0] = data[0][0];
        }
      }
    }
  } catch (e) {
    print('Log in user failed with error $e');
    return data[0];
  }

  return data[0];
}

Future<List<ProfessionMap>> getProfessionsMap(id) async {
  List<ProfessionMap> data = [];
  try {
    Response response = await professionMapService(id);
    if (response.statusCode != 200) {
    } else {
      return jsonDecode(response.body)
          .map((e) => ProfessionMap.fromJson(e))
          .toList();
    }
  } catch (e) {
    print('Get maps  failed with error $e');
  }
  return data;
}

Future<List<AssignedSensor>> getAssignedSensors(id) async {
  List<AssignedSensor> data = [];
  try {
    Response response = await assignedSensorsService(id);
    if (response.statusCode != 200) {
    } else {
      var dummy = jsonDecode(response.body);
      // .map((e) => AssignedSensor.fromJson(e))
      // .toList();
      if (dummy.isNotEmpty) {
        for (var element in dummy) {
          data.add(AssignedSensor.fromJson(element));
        }
      }
      return data;
    }
  } catch (e) {
    print('Get assigned sensors failed with error $e');
  }
  return data;
}

Future<List<AssignedSensor>> getAssignedHistorySensors(id) async {
  List<AssignedSensor> data = [];
  try {
    Response response = await assignedHistorySensorsService(id);
    if (response.statusCode != 200) {
    } else {
      var dummy = jsonDecode(response.body);

      if (dummy.isNotEmpty) {
        for (var element in dummy) {
          data.add(AssignedSensor.fromJson(element));
        }
      }
      return data;
    }
  } catch (e) {
    print('Get assigned history failed with error $e');
  }
  return data;
}

Future<bool> completeAssignedSensor(assignmentID, userID) async {
  try {
    Response response =
        await completeAssignedSensorService(assignmentID, userID);
    if (response.statusCode != 200) {
      return false;
    } else {
      return true;
    }
  } catch (e) {
    print('complete assignment failed with error $e');
  }
  return false;
}

Future<bool> addAssignment(userID, sensorID, employeeID) async {
  try {
    Response response =
        await addAssignedSensorService(userID, sensorID, employeeID);
    if (response.statusCode != 200) {
      return false;
    } else {
      return true;
    }
  } catch (e) {
    print('Add assignment failed with error $e');
  }
  return false;
}

Future<Map> getWeather() async {
  var data = {"weather": '', "iconID": "", "temp": -1000.0, 'totalWeather': []};
  List hourlyWeather = [];
  try {
    Response response = await weatherService();
    if (response.statusCode != 200) {
      return data;
    } else {
      var decodedData = jsonDecode(response.body);
      data['weather'] = decodedData['current']['weather'][0]['main'] ?? '';
      data['iconID'] = decodedData['current']['weather'][0]['icon'] ?? '';
      data['temp'] = decodedData['current']['temp'] ?? '';
      for (var i = 0; i < 34; i = i + 3) {
        // print(DateTime.fromMillisecondsSinceEpoch(
        //     decodedData['hourly'][i]['dt'] * 1000));
        hourlyWeather.add({
          "timestamp": decodedData['hourly'][i]['dt'] * 1000 ?? 0,
          "temp": decodedData['hourly'][i]['temp'] ?? -1000.0,
          "humidity": decodedData['hourly'][i]['humidity'] ?? 0,
          "weatherStatus": decodedData['hourly'][i]['weather'][0]['main'] ?? '',
          "weatherIcon": decodedData['hourly'][i]['weather'][0]['icon'] ?? '',
        });
      }
      data['totalWeather'] = hourlyWeather;
      //print(data);

      return data;
    }
  } catch (e) {
    print('Get weather failed with error $e');
  }
  return data;
}

Future<List<AlertsModel>> getAlerts(id) async {
  List<AlertsModel> data = [];
  try {
    Response response = await alertsService(id);
    if (response.statusCode != 200) {
    } else {
      var dummy = jsonDecode(response.body);
      if (dummy.isNotEmpty) {
        for (var element in dummy) {
          data.add(AlertsModel.fromJson(element));
        }
      }
      return data;
    }
  } catch (e) {
    print('Get alerts failed with error $e');
  }
  return data;
}

Future sendPin(pin) async {
  List data = [
    {"id": "0"}
  ];
  try {
    Response response = await pinService(pin);
    if (response.statusCode != 200) {
      return data[0];
    } else {
      if (data.isNotEmpty) {
        data[0] = jsonDecode(response.body);
        if (data[0] is List) {
          data[0] = data[0][0];
        }
        print(data[0]);
      }
    }
  } catch (e) {
    print('Pin failed with error $e');
    return data[0];
  }

  return data[0];
}

Future<bool> sendIssue(typeID, sensorID, employeeID, mapID) async {
  try {
    Response response =
        await problemService(typeID, sensorID, employeeID, mapID);
    if (response.statusCode != 200) {
      return false;
    } else {
      print(response.body);
      return true;
    }
  } catch (e) {
    print('Send issue failed with error $e');
  }
  return false;
}
