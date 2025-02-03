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

class LoggedUser {
  final String username;
  final bool admin;

  const LoggedUser({required this.username, required this.admin});

  factory LoggedUser.fromJson(Map<String, dynamic> json, String username) {
    token = json['token'];
    return LoggedUser(username: username, admin: json['admin']);
  }
}

void logout() {
  token = '';
}

Future<LoggedUser> loginRequest(username, password) async {
  try {
    final response = await http.get(
      Uri.https(Config.backendBaseUrl, '/users/auth/$username/$password'),
    );
    if (response.statusCode == 200) {
      return LoggedUser.fromJson(jsonDecode(response.body), username);
    } else {
      return Future.error('Credenziali errate');
    }
  } catch (e) {
    return Future.error('Impossibile connettersi al server');
  }
}
