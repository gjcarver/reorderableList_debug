import 'package:flutter/material.dart';
import 'main.dart';
import 'sql_tasks.dart';
import 'help_tasks.dart';
import 'resources.dart';
import '/flowchart_editor/widget/editor.dart';
import 'package:flag/flag.dart';

void main() {
  runApp(const TasksForm());
}

class TasksForm extends StatelessWidget {
  const TasksForm({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Remove the debug banner
        debugShowCheckedModeBanner: false,
        title: 'Tasks',
        theme: ThemeData(
          primarySwatch: Colors.lightBlue,
        ),
        home: const TasksPage(title: 'Task Manager'),
    );
  }
}

class TasksPage extends StatefulWidget {
  const TasksPage({super.key, required this.title});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final List<Task> _tasks = <Task>[];
  final TextEditingController _textFieldController = TextEditingController();

  void _addTaskItem(String name) {
    setState(() {
      _tasks.add(Task(name: name, completed: false));
    });
    _textFieldController.clear();
  }

  // this method sorts the item.
  void sorting() {
    setState(() {
      _tasks.sort();
    });
  }

// This method set the new index to the element.
  void reorderData(int oldindex, int newindex) {
    setState(() {
      if (newindex > oldindex) {
        newindex -= 1;
      }
      final items = _tasks.removeAt(oldindex);
      _tasks.insert(newindex, items);
    });
  }

  void _handleTaskChange(Task task) {
    setState(() {
      task.completed = !task.completed;
    });
  }

  void _deleteTask(Task task) {
    setState(() {
      _tasks.removeWhere((element) => element.name == task.name);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('N4O Workflow Task: Tasks'),
        leading: const Icon(Icons.check_box_outlined),
        backgroundColor: Colors.lightBlue,

        actions: <Widget>[

          IconButton(
            icon:
            Flag.fromCode(
              FlagsCode.DE,
              height: 100,
            ),

            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpTasks()),
              );

            },
          ),

          IconButton(
            icon:
            Flags.fromCode(
              const [
                FlagsCode.GB,
                FlagsCode.US,
              ],
              height: 25,
              width: 25 * 4 / 3,
            ),

            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpTasks()),
              );

            },
          ),

          IconButton(
            icon: const Icon(Icons.help),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpTasks()),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : ReorderableListView(
        onReorder: reorderData,
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        children: _tasks.map((Task task) {
          return TaskItem(
              task: task,
              onTaskChanged: _handleTaskChange,
              removeTask: _deleteTask);
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlueAccent,
        child: const Icon(Icons.add),
        onPressed: () => _showForm(null),
      ),
      
      bottomNavigationBar: BottomNavigationBar(
        unselectedLabelStyle: const TextStyle(color: Colors.white),
        onTap: (compoundIndex) {
          StepState.disabled.index;
          switch (compoundIndex) {
            case 0:
            {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AvailableResources()),
              );
              setState(() {
                compoundIndex = 0;
              });
            }
            
            break;
            
            case 1:
            {
              setState(() {
                compoundIndex = 2;
              });
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const FlowchartEditor()),
              );
            }
            
            break;
            
            case 2:
            {
              setState(() {
                compoundIndex = 1;
              });
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const NFDIexperimentApp()),
              );
            }
            
            break;

          }
          },
        
        backgroundColor: Colors.lightBlueAccent,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_back,
                color: Colors.white),
            label: 'Resources',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schema_outlined,
                color: Colors.white),
            label: 'FLOW CHART',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home,
                color: Colors.white),
            label: 'Home',
          ),
        ],
      ),

    );
  
  Future<void> _displayDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add a task'),
          content: TextField(
            controller: _textFieldController,
            decoration: const InputDecoration(hintText: 'Enter task'),
            autofocus: true,
          ),
          actions: <Widget>[
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _addTaskItem(_textFieldController.text);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}

class Task {
  Task({required this.name, required this.completed});
  String name;
  bool completed;
}

class TaskItem extends StatelessWidget {
  TaskItem(
      {required this.task,
        required this.onTaskChanged,
        required this.removeTask})
      : super(key: ObjectKey(task));

  final Task task;
  final void Function(Task task) onTaskChanged;
  final void Function(Task task) removeTask;

  TextStyle? _getTextStyle(bool checked) {
    if (!checked) return null;

    return const TextStyle(
      color: Colors.black54,
      decoration: TextDecoration.lineThrough,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: ListTile(
        onTap: () {
          onTaskChanged(task);
        },
        leading: Checkbox(
          checkColor: Colors.greenAccent,
          activeColor: Colors.red,
          value: task.completed,
          onChanged: (value) {
            onTaskChanged(task);
          },
        ),
        title: Row(children: <Widget>[
          Expanded(
            child: Text(task.name, style: _getTextStyle(task.completed)),
          ),
          IconButton(
            iconSize: 30,
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
            alignment: Alignment.centerRight,
            onPressed: () {
              removeTask(task);
            },
          ),
        ]),
      ),
    );
  }
}