import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:wear4safe/helpers/consts.dart';
import 'package:wear4safe/main.dart';
import 'package:wear4safe/providers/user_provider.dart';

Future<http.Response> logInUserService(email, password) {
  String customUrl = EndPointUrls.logInUrl.replaceAll('EMAIL', email);
  customUrl = customUrl.replaceAll('PASS', password);
  return http.get(
    Uri.parse(customUrl),
    headers: <String, String>{
      "Content-Type": "application/json",
    },
  );
}

Future<http.Response> professionMapService(id) {
  return http.get(
    Uri.parse('${EndPointUrls.professionMapUrl}$id'),
    headers: <String, String>{
      "Content-Type": "application/json",
    },
  );
}

Future<http.Response> assignedSensorsService(id) {
  return http.get(
    Uri.parse('${EndPointUrls.assignmentsUrl}$id'),
    headers: <String, String>{
      "Content-Type": "application/json",
    },
  );
}

Future<http.Response> assignedHistorySensorsService(id) {
  return http.get(
    Uri.parse('${EndPointUrls.assignmentsHistoryUrl}$id'),
    headers: <String, String>{
      "Content-Type": "application/json",
    },
  );
}

Future<http.Response> completeAssignedSensorService(assignmentID, userID) {
  var customUrl = EndPointUrls.completeAssignmentUrl
      .replaceAll('assignmentID', assignmentID);
  return http.get(
    Uri.parse('$customUrl$userID'),
    headers: <String, String>{
      "Content-Type": "application/json",
    },
  );
}

Future<http.Response> addAssignedSensorService(userID, sensorID, employeeID) {
  var customUrl = EndPointUrls.addAssignmentUrl.replaceAll('userID', userID);
  customUrl = customUrl.replaceAll('sensorID', sensorID);
  return http.get(
    Uri.parse('$customUrl$employeeID'),
    headers: <String, String>{
      "Content-Type": "application/json",
    },
  );
}

Future<http.Response> weatherService() {
  return http.get(
    Uri.parse(EndPointUrls.weatherUrl),
    headers: <String, String>{
      "Content-Type": "application/json",
    },
  );
}

Future<http.Response> alertsService(id) {
  var customUrl = EndPointUrls.alertsUrl.replaceAll(
      'ORGID',
      Provider.of<UserProvider>(navigatorKey!.currentContext!, listen: false)
          .user
          .organizationID);
  return http.get(
    Uri.parse(
        "$customUrl${Provider.of<UserProvider>(navigatorKey!.currentContext!, listen: false).user.sector}"),
    headers: <String, String>{
      "Content-Type": "application/json",
    },
  );
}

Future<http.Response> pinService(pin) {
  return http.get(
    Uri.parse('${EndPointUrls.pinUrl}$pin'),
    headers: <String, String>{
      "Content-Type": "application/json",
    },
  );
}

Future<http.Response> problemService(typeID, sensorID, employeeID, mapID) {
  var customUrl = EndPointUrls.issueUrl.replaceAll('TYPEID', typeID);
  customUrl = customUrl.replaceAll('MAPID', mapID);
  customUrl = customUrl.replaceAll('SENSORID', sensorID);
  customUrl = customUrl.replaceAll('EMPLID', employeeID);
  return http.get(
    Uri.parse(customUrl),
    headers: <String, String>{
      "Content-Type": "application/json",
    },
  );
}
