import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_security/config.dart';

String token = '';

class DevHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = _certificateCheck;
  }
}

// We need to tell dart to accept our certificate since it's self signed
bool _certificateCheck(cert, host, port) {
  return true;
}

void logout() {
  token = '';
}

Future<void> loginRequest(username, password) async {
  try {
    final response = await http.get(
      Uri.parse('${Config.backendBaseUrl}/auth/$username/$password'),
    );
    if (response.statusCode == 200) {
      //return LoggedUser.fromJson(jsonDecode(response.body), username);
      try {
        final content = jsonDecode(response.body);
        token = content['token'];
        debugPrint(token);
      } catch (e) {
        print("Error decoding JSON");
      }
    } else {
      return Future.error('Credenziali errate');
    }
  } catch (e) {
    return Future.error('Impossibile connettersi al server');
  }
}
