import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_security/config.dart';
import 'package:mobile_security/sqlite.dart';

String token = '';

void logout() {
  token = '';
  closeDB();
}

Future<void> loginRequest(String username, String password) async {
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
      return Future.error('Wrong credentials');
    }
  } catch (e) {
    return Future.error('Server not available');
  }
}

Future<void> registerRequest(String username, String password) async {
  try {
    final response = await http.post(
      Uri.parse('${Config.backendBaseUrl}/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
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
    } else if (response.statusCode == 400) {
      return Future.error('User already exists');
    } else {
      return Future.error('Server not available');
    }
  } catch (e) {
    return Future.error('Server not available');
  }
}

Future<void> addTask(String title, String description) async {
  try {
    final response = await http.post(
      Uri.parse('${Config.backendBaseUrl}/tasks'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        'title': title,
        'description': description,
      }),
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      return Future.error('Server not available');
    }
  } catch (e) {
    return Future.error('Server not available');
  }
}

Future<void> deleteTask(String id) async {
  try {
    final response = await http.delete(
      Uri.parse('${Config.backendBaseUrl}/task/$id'),
      headers: <String, String>{'authorization': 'Bearer $token'},
    );
    if (response.statusCode == 404) {
      return Future.error('Task does not exist');
    }
    if (response.statusCode < 200 || response.statusCode >= 500) {
      return Future.error('Server not available');
    }
  } catch (e) {
    return Future.error('Server not available');
  }
}

Future<void> updateTask(String id, bool completed) async {
  try {
    final response = await http.patch(
      Uri.parse('${Config.backendBaseUrl}/task/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'authorization': 'Bearer $token',
      },
      body: jsonEncode({'completed': completed}),
    );
    if (response.statusCode == 404) {
      return Future.error('Task does not exist');
    }
    if (response.statusCode < 200 || response.statusCode >= 500) {
      return Future.error('Server not available');
    }
  } catch (e) {
    return Future.error('Server not available');
  }
}
