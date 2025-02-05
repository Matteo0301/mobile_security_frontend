import 'package:flutter/material.dart';
import 'package:mobile_security/description_page.dart';
import 'package:mobile_security/model.dart';
import 'package:mobile_security/requests.dart';
import 'package:mobile_security/tasks.dart';
import 'package:provider/provider.dart';

class TaskList extends StatelessWidget {
  const TaskList(this.request, {super.key});
  final ValueGetter<Future<List<Task>>> request;

  @override
  Widget build(BuildContext context) {
    return Consumer<Model<Task>>(
      builder: (context, tasks, child) {
        return FutureBuilder(
          future: request(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Errors while retrieving data:\n${snapshot.error}'),
              );
            } else if (snapshot.hasData) {
              List<Task> list = snapshot.data as List<Task>;
              tasks.removeAll();
              for (var coll in list) {
                tasks.add(coll);
              }
              if (list.isEmpty) {
                return const Center(child: Text('No data found'));
              }
              return ListView.builder(
                itemCount: tasks.items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      style: TextStyle(
                        fontSize: 20,
                        decoration:
                            (tasks
                                    .items[tasks.items.length - index - 1]
                                    .completed)
                                ? TextDecoration.lineThrough
                                : null,
                      ),
                      tasks.items[tasks.items.length - index - 1].title,
                    ),
                    leading: Checkbox(
                      value:
                          tasks.items[tasks.items.length - index - 1].completed,
                      onChanged: (value) async {
                        if (value != null) {
                          await updateTask(
                            tasks.items[tasks.items.length - index - 1].id,
                            value,
                          );
                          tasks.notifyListeners();
                        }
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => Description(
                                title:
                                    tasks
                                        .items[tasks.items.length - index - 1]
                                        .title,
                                description:
                                    tasks
                                        .items[tasks.items.length - index - 1]
                                        .description,
                              ),
                        ),
                      );
                    },
                    trailing: IconButton(
                      onPressed: () {
                        deleteTask(
                              tasks.items[tasks.items.length - index - 1].id,
                            )
                            .then((_) => tasks.notifyListeners())
                            .onError(
                              (error, stackTrace) =>
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(error.toString())),
                                  ),
                            );
                      },
                      icon: const Icon(Icons.delete),
                    ),
                  );
                },
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        );
      },
    );
  }
}
