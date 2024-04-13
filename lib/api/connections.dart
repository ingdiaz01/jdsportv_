import 'dart:convert';

import 'package:http/http.dart' as http;

class ServerApi {
  static int port = 3002;

  // static String myIpServer = 'http://172.21.0.11:$port/';
  // static String myIpServer = 'http://qjm-id4.com:$port/';
  static String myIpServer = 'https://k9lv2jwk-3002.use2.devtunnels.ms/';


  static Future httpGet(String ruta) async {
    var url;

    url = Uri.parse('$myIpServer$ruta');

    try {
      var response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        //'Authorization': 'Bearer $token',
      });

      /// 200 ok
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);

        if (jsonResponse != null) return jsonResponse;
      }

      /// 403 no tiene acceso
      if (response.statusCode == 403) {
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse != null) return jsonResponse;
      }

      /// 401 no autorizado se vencio la session del token
      if (response.statusCode == 401) {
        return response.reasonPhrase.toString();
      }
    } catch (ex) {
      throw ex.toString();
    }
  }

}