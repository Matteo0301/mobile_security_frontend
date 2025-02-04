import 'dart:io';
import 'package:flutter/material.dart' hide TextField;
import 'package:mobile_security/model.dart';
import 'package:mobile_security/requests.dart';
import 'package:mobile_security/tasks.dart';
import 'package:provider/provider.dart';

class AddButton extends StatefulWidget {
  const AddButton({super.key});

  @override
  State<StatefulWidget> createState() => AddButtonState();
}

class AddButtonState extends State<AddButton> {
  @override
  void initState() {
    super.initState();
  }

  final formKey = GlobalKey<FormState>();

  Future<void> inputPopup(
    BuildContext context,
    Model<Task> tasks,
    Task? initial,
  ) async {
    var titleController = TextEditingController();
    var descriptionController = TextEditingController();
    if (context.mounted) {
      await showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text('Add task'),
            content: Container(
              padding: const EdgeInsets.all(10),
              height: 300,
              width: 300,
              child: ListView(
                children: [
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 16,
                          ),
                          child: TextFormField(
                            controller: titleController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Title',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Insert title';
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 16,
                          ),
                          child: TextFormField(
                            /* maxLines: null,
                            expands: true, */
                            controller: descriptionController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Description',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Insert description';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Insert all values')),
                    );
                  }
                },
                child: const Text('Add'),
              ),
            ],
          );
        },
      );
    }

    if (titleController.text == '' || descriptionController.text == '') {
      return;
    }
    await addTask(
      titleController.text,
      descriptionController.text,
    ).then((value) => {tasks.notifyListeners()}).catchError((error) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
      tasks.notifyListeners();
      return <dynamic>{};
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Model<Task>>(
      builder: (context, tasks, child) {
        return FloatingActionButton.extended(
          onPressed: () async => inputPopup(context, tasks, null),
          label: const Text('Add task'),
          icon: const Icon(Icons.add),
        );
      },
    );
  }
}
