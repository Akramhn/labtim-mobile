import 'dart:convert';

import 'package:http/http.dart' as http;

class Api {
  // ignore: non_constant_identifier_names
  static AddPatient(Map data) async {
    try {
      final response =
          await http.post(Url.addPatient, body: {"data": jsonEncode(data)});
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var result = data['data'];

        if (result[0]) {
          return result;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      // print('Error occurred: $e');
    }
  }

  static getPatient() async {
    final response = await http.get(Url.getPatient);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }

  static Future<bool> deletPatient(String id) async {
    final response =
        await http.post(Url.delPatient, body: {"idp": jsonEncode(id)});

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var result = data['data'];
      if (result[0]) {
        return true; // Return true if the deletion is successful
      } else {
        return false; // Return false if the deletion fails
      }
    } else {
      return false; // Return false if the request fails
    }
  }
}

class Url {
  static var addPatient =
      Uri.https('labtim.000webhostapp.com', 'labtim_mob/addPatient.php');
  static var getPatient =
      Uri.https('labtim.000webhostapp.com', 'labtim_mob/getPatient.php');
  static var delPatient =
      Uri.https('labtim.000webhostapp.com', 'labtim_mob/delet.php');
}
