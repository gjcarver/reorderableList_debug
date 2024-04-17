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
        home: const TasksPage());
  }
}

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  // All tasks
  List<Map<String, dynamic>> _tasks = [];

  bool _isLoading = true;
  // This function is used to fetch all data from the database
  void _refreshTasks() async {
    final data = await SQLHelperTasks.getItems();
    setState(() {
      _tasks = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshTasks(); // Loading the diary when the app starts
  }

  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _taskTypeController = TextEditingController();
  final TextEditingController _taskActivityAreaController = TextEditingController();
  final TextEditingController _taskFunctionController = TextEditingController();
  final TextEditingController _taskCommentController = TextEditingController();

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void _showForm(int? id) async {
    if (id != null) {
      // id == null -> create new item
      // id != null -> update an existing item
      final existingTask =
      _tasks.firstWhere((element) => element['id'] == id);
      _taskNameController.text = existingTask['taskName'];
      _taskTypeController.text = existingTask['taskType'];
      _taskActivityAreaController.text = existingTask['taskActivityArea'];
      _taskFunctionController.text = existingTask['taskFunction'];
      _taskCommentController.text = existingTask['taskComment'];
    }

//    void _onReorder(int oldIndex, int newIndex) {
//      setState(() {
//        if (newIndex > oldIndex) {
//          newIndex -= 1;
//        }
//        final TaskModel item = _tasks.removeAt(oldIndex);
//        _tasks.insert(newIndex, item);
//      });
//    }

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
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : ReorderableListView.builder(

        padding: const EdgeInsets.symmetric(horizontal: 40),
        onReorder: (oldIndex, newIndex) {
          setState(() {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            final task = _tasks.removeAt(oldIndex);
            _tasks.insert(newIndex, task);
          });
        },
        itemCount: _tasks.length,
        itemBuilder: (context, index) => Card(
          key: Key('$index'),
          color: Colors.lightBlue[200],
          margin: const EdgeInsets.all(15),
          child: ListTile(
              title: Text(_tasks[index]['taskName']),
              subtitle: Text(_tasks[index]['taskType']),
              trailing: SizedBox(
                width: 100,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showForm(_tasks[index]['id']),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () =>
                          _deleteItem(_tasks[index]['id']),
                    ),
                  ],
                ),
              )),
        ),
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
//          BottomNavigationBarItem(
//            icon: Icon(Icons.camera_alt,
//                color: Colors.white),
//            label: 'Photo',
//          ),
        ],
      ),

    );
  }
}