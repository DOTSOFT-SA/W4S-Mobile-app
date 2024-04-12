import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wear4safe/models/employee_model.dart';
import 'package:wear4safe/services/api_calls.dart';

import '../models/user_model.dart';

class ProfessionProvider extends ChangeNotifier {
  List professionIDs = [];

  fetchProfessionMaps(professionID, employeeID, context) async {
    if (!professionIDs.contains(professionID)) {
      Provider.of<User>(context, listen: false)
          .employees
          .firstWhere((element) => element.id == employeeID)
          .professionMaps = await getProfessionsMap(professionID);
      professionIDs.add(professionID);
      notifyListeners();
    }
  }
}
