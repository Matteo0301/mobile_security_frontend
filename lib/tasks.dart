import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_security/config.dart';
import 'package:mobile_security/requests.dart';

class Task {
  final String id;
  final String title;
  final String description;
  final bool completed;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.completed,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      completed: json['completed'],
    );
  }
}

Future<List<Task>> getTasks() async {
  try {
    final response = await http.get(
      Uri.parse('${Config.backendBaseUrl}/tasks'),
      headers: <String, String>{'authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      //return LoggedUser.fromJson(jsonDecode(response.body), username);
      try {
        debugPrint(response.body);
        final content = jsonDecode(response.body);
        debugPrint(content);
        List<Task> tasks = [];
        for (var t in content['tasks']) {
          tasks.add(Task.fromJson(t));
        }
        debugPrint(tasks.toString());
        return tasks;
      } catch (e) {
        debugPrint("Error decoding JSON");
        return Future.error('Received invalid response');
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
