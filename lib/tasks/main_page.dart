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
          /*           actions: [
            Consumer<Model<Task>>(
              builder: (context, collections, child) {
                if (collections.selected.isEmpty) {
                  return const SizedBox.shrink();
                } else {
                  return IconButton(
                    onPressed: () async {
                      bool? confirm = await showDialog(
                        context: context,
                        builder: (_) {
                          return ConfirmDialog(context: context);
                        },
                      );
                      if (confirm == null || !confirm) {
                        return;
                      }
                      List<Task> coll = [];
                      for (var index in collections.selected) {
                        coll.add(collections.items[index]);
                      }
                      removeCollections(coll)
                          .then(
                            (value) => {
                              collections.clearSelected(),
                              collections.notifyListeners(),
                            },
                          )
                          .catchError((error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(error.toString())),
                            );

                            collections.notifyListeners();
                            return <dynamic>{};
                          });
                    },
                    icon: const Icon(Icons.delete),
                  );
                }
              },
            ),
            Consumer<Model<Task>>(
              builder: (context, collections, child) {
                return UpdateButton(model: collections);
              },
            ),
          ], */
        ),
        body: content,
        floatingActionButton: AddButton(),
      ),
    );
  }
}
