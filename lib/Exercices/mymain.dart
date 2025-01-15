import 'package:flutter/material.dart';
import 'package:hepl_progra_mobile/Controller/TaskController.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ToDoList(),
    );
  }
}

class ToDoList extends StatefulWidget {
  const ToDoList({super.key});

  @override
  State<ToDoList> createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  final taskController = TextEditingController();

  bool checked = false;
  bool mabool = false;
  final List<Map<String, dynamic>> checkIt = [];
  @override

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        children: [
          const SizedBox(height: 100),
          Checkbox(value: mabool, onChanged: (value){
            setState(() {
              mabool=value!;
            });}),
          SizedBox(
          width: 300,
          child: TextFormField(
            controller: taskController,
            decoration: const InputDecoration(
                label: Text("Your Task"),
                filled: true,
                hintText: "Your task here",
                border: OutlineInputBorder(borderRadius: BorderRadius. all(Radius. circular(10.0)))),
          ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

          ElevatedButton(
              onPressed: () {
                setState(() {
                  if (taskController.text.isNotEmpty) {
                    checkIt.add({
                      'text': taskController.text,
                      'checked': false,
                    });
                    TaskController.insertTask(taskController.text, false);

                    taskController.clear();
                  }
                });
              },
              child: const Text("Add Task")),
          ElevatedButton(
              onPressed: (){setState(() {
                checkIt.clear();
              });},
              child: const Text("Clear Data")),
          ]),
          Expanded(
              child: ListView.builder(
                  itemCount: checkIt.length,
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                    FutureBuilder<bool?>(
                    future: TaskController.getTaskState(checkIt[index]['text']), // Obtenez l'état
                    builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                    // Affichez un indicateur de chargement en attendant les données
                    return const CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                    // Gérez les erreurs ici
                    return Text("Error: ${snapshot.error}");
                    }
                    // Utilisez la valeur une fois qu'elle est chargée
                    bool? state = snapshot.data;
                    return Checkbox(
                    value: state,
                    onChanged: (value) {
                    setState(() {
                    checkIt[index]['checked'] = value;
                    TaskController.setTaskState(checkIt[index]['text'], value!);
                    });
                    print(TaskController.getTaskState(checkIt[index]['text']));
                    },
                    );
                    },
                    ),

                    Expanded(
                          child: Text(checkIt[index]['text']),
                        ),
                      ],
                    );
                  })),
        ],
      )

          // Column(
          //   children: [
          //     Checkbox(value: checked, onChanged: (_) => setState(() {
          //       checked = !checked;
          //     }),  )
          //   ],
          // ),

          ),
    );
  }
}
