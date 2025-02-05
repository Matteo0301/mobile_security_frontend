import 'package:flutter/material.dart';
import 'package:mobile_security/model.dart';
import 'package:mobile_security/requests.dart';
import 'package:mobile_security/settings_page.dart';
import 'package:mobile_security/tasks.dart';
import 'package:mobile_security/tasks/add_button.dart';
import 'package:mobile_security/tasks/task_list.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.onThemeChanged});
  final VoidCallback onThemeChanged;

  @override
  Widget build(BuildContext context) {
    final content = TaskList(getTasks);
    return ChangeNotifierProvider(
      create: (context) => Model<Task>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('These are your tasks'),
          centerTitle: true,
          automaticallyImplyLeading: false,
          actions: [
            Consumer<Model<Task>>(
              builder: (context, collections, child) {
                return UpdateButton(model: collections);
              },
            ),
            IconButton(
              onPressed: () {
                logout();
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              icon: const Icon(Icons.logout_rounded),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => Settings(onThemeChanged: onThemeChanged),
                  ),
                );
              },
              icon: const Icon(Icons.settings),
            ),
          ],
        ),
        body: content,
        floatingActionButton: AddButton(),
      ),
    );
  }
}

class UpdateButton<T> extends StatelessWidget {
  final Model<T> model;

  const UpdateButton({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        model.notifyListeners();
      },
      icon: const Icon(Icons.update),
    );
  }
}
