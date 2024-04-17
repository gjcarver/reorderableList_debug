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
      title: 'Tasks',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TaskList(title: 'Tasks'),
    );
  }
}

class TaskList extends StatefulWidget {
  const TaskList({super.key, required this.title});

  final String title;

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  final List<Task> _tasks = <Task>[];

  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _taskTypeController = TextEditingController();
  final TextEditingController _taskActivityAreaController = TextEditingController();
  final TextEditingController _taskFunctionController = TextEditingController();
  final TextEditingController _taskCommentController = TextEditingController();

  void _addTaskItem(String name) {
//    setState(() {
//      _tasks.add(Task(name: name, completed: false));
//    });
//    _taskNameController.clear();
//  }

    showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        builder: (context) => SingleChildScrollView(
          padding: EdgeInsets.only(
            top: 15,
            left: 15,
            right: 15,
            // this will prevent the soft keyboard from covering the text fields
            bottom: MediaQuery.of(context).viewInsets.bottom + 120,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
//            crossAxisAlignment: CrossAxisAlignment.end,
            children: [

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _taskNameController,
                  decoration: const InputDecoration(hintText: 'Task NAME'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _taskTypeController,
                  decoration: const InputDecoration(hintText: 'Task TYPE'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _taskActivityAreaController,
                  decoration: const InputDecoration(hintText: 'Task ACTIVITY Area'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _taskFunctionController,
                  decoration: const InputDecoration(hintText: 'Task FUNCTION (related verb)'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _taskCommentController,
                  decoration: const InputDecoration(hintText: 'Task COMMENT'),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton.icon(
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('BACK'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue[200], //elevated button background color
                    ),
                    onPressed: () {

                      Navigator.of(context).pop();
                    },
                  ),

//                  ElevatedButton.icon(
//                    icon: const Icon(Icons.schema_outlined),
//                    label: const Text('FLOW CHART'),
//                    style: ElevatedButton.styleFrom(
//                        backgroundColor: Colors.deepOrange[200], //elevated button background color
//                    ),
//                    onPressed: () {
//
//                      Navigator.push(
//                        context,
//                        MaterialPageRoute(builder: (context) => const FlowchartEditor()),
//                      );
//
//                    },
//                  ),

                  ElevatedButton.icon(
                    icon: const Icon(Icons.save),
                    label: Text(id == null ? 'SAVE' : 'UPDATE'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue[200], //elevated button background color
                    ),
                    onPressed: () async {
                      // Save new task
                      if (id == null) {
                        await _addItem();
                      }

                      if (id != null) {
                        await _updateItem(id);
                      }

                      // Clear the text fields
                      _taskNameController.text = '';
                      _taskTypeController.text = '';
                      _taskActivityAreaController.text = '';
                      _taskFunctionController.text = '';
                      _taskCommentController.text = '';
                      // Close the bottom sheet
                      if (!mounted) return;
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ],
          ),
        ));
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

//  void _deleteTask(Task task) {
//    setState(() {
//      _tasks.removeWhere((element) => element.name == task.name);
//    });
//  }


  // Insert a new task to the database
  Future<void> _addItem() async {
    await SQLHelperTasks.createItem(
        _taskNameController.text,
        _taskTypeController.text,
        _taskActivityAreaController.text,
        _taskFunctionController.text,
        _taskCommentController.text);
    _refreshTasks();
  }

  // Update an existing task
  Future<void> _updateItem(int id) async {
    await SQLHelperTasks.updateItem(
        id, _taskNameController.text,
        _taskTypeController.text,
        _taskActivityAreaController.text,
        _taskFunctionController.text,
        _taskCommentController.text);
    _refreshTasks();
  }


  void _deleteTask(Task task) {
    setState(() {
      _tasks.removeWhere((element) => element.name == task.name);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Task deleted!'),
      ));
      _refreshTasks();
    };
  }

  // Delete an item
  void _deleteItem(int id) async {
    await SQLHelperTasks.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Task deleted!'),
    ));
    _refreshTasks();
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
      body: ReorderableListView(
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
        onPressed: () => _displayDialog(),
        tooltip: 'Add a Task',
        child: const Icon(Icons.add),
      ),


//      floatingActionButton: FloatingActionButton(
//        backgroundColor: Colors.lightBlueAccent,
//        child: const Icon(Icons.add),
//        onPressed: () => _showForm(null),
//      ),

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
//          BottomNavigationBarItem(
//            icon: Icon(Icons.camera_alt,
//                color: Colors.white),
//            label: 'Photo',
//          ),
        ],
      ),




    );
  }

  Future<void> _displayDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add a task'),
          content: TextField(
            controller: _taskNameController,
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
                _addTaskItem(_taskNameController.text);
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
          title: Text(task.name),
//          subtitle: Text(_tasks[index]['taskType']),
          trailing: SizedBox(
            width: 100,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => onTaskChanged(task),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    removeTask(task);
                  },
                ),
              ],
            ),
          )),
    );
  }
}