import 'package:flutter/material.dart';
import 'package:mobile_security/model.dart';
import 'package:mobile_security/tasks.dart';
import 'package:mobile_security/tasks/add_button.dart';
import 'package:mobile_security/tasks/task_list.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late DateTime date;

  @override
  void initState() {
    super.initState();
    date = DateTime.now().copyWith(
      month: DateTime.now().month + 1,
      day: 0,
      hour: 12,
    );
    final next = date.copyWith(day: date.day + 1);
    if (next.day == 1 && date.hour >= 12) {
      date = next;
    }
  }

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
