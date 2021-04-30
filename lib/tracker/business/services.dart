import 'package:bot_toast/bot_toast.dart';
import 'package:covid_19/tracker/business/latestmodel.dart';

import 'package:http/http.dart' as http;

import 'historyModel.dart';

class CovidDataServices {
  static Future<Latest> getLatestData() async {
    try {
      var response = await http
          .get(Uri.parse('https://api.rootnet.in/covid19-in/stats/latest'));
      print(response.body);
      final latest = latestFromJson(response.body);
      return latest;
    } catch (e) {
      print(e);
      BotToast.showText(text: "Error retriveing the data from the server");
      return null;
    }
  }

  static Future<History> getHistoryData() async {
    try {
      var response = await http
          .get(Uri.parse('https://api.rootnet.in/covid19-in/stats/history'));
      print(response.body);
      final history = historyFromJson(response.body);
      return history;
    } catch (e) {
      print(e);
      BotToast.showText(text: "Error retriveing the data from the server");
      return null;
    }
  }
}
