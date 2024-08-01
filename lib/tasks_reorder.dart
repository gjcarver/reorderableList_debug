//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'main.dart';
//import 'resources.dart';
import 'reorder_sql.dart';
import 'help_tasks.dart';
//import '/diagram_editor/widget/editor.dart';
import 'package:flag/flag.dart';

void main() {
  runApp(const TasksForm(tasks: [], designName: 'designName'));
}

class TasksForm extends StatelessWidget {
  final List<Task> tasks;
  final String designName;

  const TasksForm({super.key, required this.tasks, required this.designName});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'N4O Workflow Tool: Tasks List Builder',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: TaskList(tasks: const [], designName: designName,),
    );
  }
}

class TaskList extends StatefulWidget {
  final String designName;
  const TaskList({super.key, required List tasks, required this.designName});

  @override
  State<TaskList> createState() => _TaskListState(designName: designName);
}

class _TaskListState extends State<TaskList> {
  final String designName;
  _TaskListState({required this.designName});

  List<Task> _tasks = [];

  void sorting() {
    setState(() {
      _tasks.sort((a, b) {
        int sequence = a.newIndex?.compareTo(b.newIndex?? 0)?? 0;
        if (sequence == 0) {
          sequence = a.oldIndex?.compareTo(b.oldIndex?? 0)?? 0;
        }
        return sequence;
      });
    });
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

  // This function is used to fetch all data from the database
  void _refreshTasks() async {
    final data = await SQLHelperTasks.getItems();
    setState(() {
      _tasks =
          data.map((e) => Task(oldIndex: e['oldIndex'] ?? 'id', newIndex: e['newIndex'], designName: e['designName'], taskName: e['taskName'], completed: false, taskType: e['taskType'], taskActivityArea: '', taskFunction: '', taskComment: '', id: e['id'] ?? 0)).toList();
      _isLoading = false;
    });
  }

  bool _isLoading = true;

  get index => null;

  @override
  void initState() {
    super.initState();
    _refreshTasks();
  }

  final TextEditingController _oldIndexController = TextEditingController();
  final TextEditingController _newIndexController = TextEditingController();
  final TextEditingController _designNameController = TextEditingController();
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _taskTypeController = TextEditingController();
  final TextEditingController _taskActivityAreaController = TextEditingController();
  final TextEditingController _taskFunctionController = TextEditingController();
  final TextEditingController _taskCommentController = TextEditingController();

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  Future<void> _showForm(Task? task) async {
    if (task != null) {
      final existingTask =
      _tasks.firstWhere((element) => element.taskName == task.taskName);
      _oldIndexController.text = existingTask.oldIndex.toString();
      _newIndexController.text = existingTask.newIndex.toString();
      _designNameController.text = existingTask.designName;
      _taskNameController.text = existingTask.taskName;
      _taskTypeController.text = existingTask.taskType;
      _taskActivityAreaController.text = existingTask.taskActivityArea;
      _taskFunctionController.text = existingTask.taskFunction;
      _taskCommentController.text = existingTask.taskComment;
    }

    Future<void> _addItem(int? oldIndex, int? newIndex, String designName, String taskName, String taskType, String taskActivityArea, String taskFunction, String taskComment) async {
      await SQLHelperTasks.createItem(
          oldIndex,
          newIndex,
          designName,
          _taskNameController.text,
          _taskTypeController.text,
          _taskActivityAreaController.text,
          _taskFunctionController.text,
          _taskCommentController.text);
      _refreshTasks();
    }

    Future<void> updateItem(id, int? oldIndex, int? newIndex, String designName, String taskName, String taskType, String taskActivityArea, String taskFunction, String taskComment) async {
      await SQLHelperTasks.updateItem(
          id, oldIndex,
          newIndex,
          _designNameController.text,
          _taskNameController.text,
          _taskTypeController.text,
          _taskActivityAreaController.text,
          _taskFunctionController.text,
          _taskCommentController.text);
      _refreshTasks();
    }

    showModalBottomSheet(
      context: context,
      elevation: 5,
      isScrollControlled: true,
      builder: (context) =>
          SingleChildScrollView(
            padding: EdgeInsets.only(
              top: 15,
              left: 15,
              right: 15,
              bottom: MediaQuery
                  .of(context)
                  .viewInsets
                  .bottom + 120,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[

                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 5),
                  child: TextField(
                    controller: _taskNameController,
                    decoration: const InputDecoration(
                        hintText: 'Task NAME'),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 5),
                  child: TextField(
                    controller: _taskTypeController,
                    decoration: const InputDecoration(
                        hintText: 'Task TYPE'),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 5),
                  child: TextField(
                    controller: _taskActivityAreaController,
                    decoration: const InputDecoration(
                        hintText: 'Task ACTIVITY Area'),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 5),
                  child: TextField(
                    controller: _taskFunctionController,
                    decoration: const InputDecoration(
                        hintText: 'Task FUNCTION (related verb)'),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 5),
                  child: TextField(
                    controller: _taskCommentController,
                    decoration: const InputDecoration(
                        hintText: 'Task COMMENT'),
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ElevatedButton.icon(
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('BACK'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors
                            .lightBlue[200],
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),

                    ElevatedButton.icon(
                      icon: const Icon(Icons.save),
                      label: Text(task == null ? 'SAVE' : 'UPDATE'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors
                            .lightBlue[200],
                      ),
                      onPressed: () async {
                        if (task == null) {

                          var result = await SQLHelperTasks.rawQuery();
//                          int? maxId = result.isNotEmpty ? result.first['id'] as int : null;
                          print(result);
                          var oldIndex = int.parse(result?[0]['id'] ?? '0');

                          var newIndex = 0;
                          print('Old: $oldIndex');
                          print('New: $newIndex');

                          await _addItem(
                              oldIndex as int?,
                              newIndex,
                              designName,
                              _taskNameController.text,
                              _taskTypeController.text,
                              _taskActivityAreaController.text,
                              _taskFunctionController.text,
                              _taskCommentController.text);
                        }

                        if (task != null) {
                          print('Tasky: $task');
//                          var oldIndex = await SQLHelperTasks.getItem("SELECT MAX(id)+1 as id FROM items" as int);
                          var resultSet = await SQLHelperTasks.rawQuery();
                          var oldIndex = resultSet.first['id'] as int;

                          var newIndex = task.newIndex;
                          await updateItem(task.id, oldIndex as int?,
                              newIndex,
                              _designNameController.text,
                              _taskNameController.text,
                              _taskTypeController.text,
                              _taskActivityAreaController.text,
                              _taskFunctionController.text,
                              _taskCommentController.text);
                        }

                        _oldIndexController.text = '';
                        _newIndexController.text = '';
                        _designNameController.text = designName;
                        _taskNameController.text = '';
                        _taskTypeController.text = '';
                        _taskActivityAreaController.text = '';
                        _taskFunctionController.text = '';
                        _taskCommentController.text = '';
                        if (!mounted) return;
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String? designName = widget.designName;
    return Scaffold(
      appBar: AppBar(
        title: Text('N4O Workflow Tool: $designName Tasks'),
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
        itemCount: _tasks.length,
        itemBuilder: (context, newIndex) {
          return Card(
            key: Key('$newIndex'),
            color: Colors.lightBlue[100],
            margin: const EdgeInsets.all(15),
            child: Visibility(
              visible: _tasks[newIndex].designName == designName,
              child: ListTile(
                title: Text(_tasks[newIndex].taskName),
                subtitle: Text(_tasks[newIndex].taskType),
                trailing: SizedBox(
                  width: 100,
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showForm(_tasks[newIndex]),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteItem(_tasks[newIndex].id),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
          },

        onReorder: (int oldIndex, int newIndex) =>
            setState(() {
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }
              final Task item = _tasks.removeAt(oldIndex);
              _tasks.insert(newIndex, item);
              SQLHelperTasks.reorderItems(oldIndex, newIndex);
              print('Old: $oldIndex');
              print('New: $newIndex');

              SQLHelperTasks.updateItem(item.id, oldIndex,
                  newIndex,
                  item.designName,
                  item.taskName,
                  _taskTypeController.text,
                  _taskActivityAreaController.text,
                  _taskFunctionController.text,
                  _taskCommentController.text);
            }),

      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlueAccent,
        onPressed: () => _showForm(null),
        tooltip: 'Add a Task',
        child: const Icon(Icons.add),
      ),

//      bottomNavigationBar: BottomNavigationBar(
//        unselectedLabelStyle: const TextStyle(color: Colors.white),
//        onTap: (compoundIndex) {
//          StepState.disabled.index;
//          switch (compoundIndex) {
//            case 0:
//              {
//                setState(() {
//                  compoundIndex = 0;
//                });
//                Navigator.push(
//                  context,
//                  MaterialPageRoute(
//                      builder: (context) => const AvailableResources()),
//                );
//              }
//
//              break;
//
////            case 1:
////              {
////                setState(() {
////                  compoundIndex = 1;
////                });
////                Navigator.push(
////                  context,
////                  MaterialPageRoute(
////                      builder: (context) => const FlowChartEditor()),
////                );
////              }
//
////              Map<String, dynamic> toJson() => {
////                'id': id,
////                'position': [position.dx, position.dy],
////                'size': [size.width, size.height],
////                'min_size': [minSize.width, minSize.height],
////                'type': type,
////                'z_order': zOrder,
////                'parent_id': parentId,
////                'children_ids': childrenIds,
////                'connections': connections,
////                'dynamic_data': data?.toJson(),
////              };
//
////              break;
//
//            case 2:
//              {
//                setState(() {
//                  compoundIndex = 2;
//                });
//                Navigator.push(
//                  context,
//                  MaterialPageRoute(
//                      builder: (context) => const NFDIexperimentApp()),
//                );
//              }
//
//              break;
//          }
//        },
//
//        backgroundColor: Colors.lightBlueAccent,
//        items: const <BottomNavigationBarItem>[
//          BottomNavigationBarItem(
//            icon: Icon(Icons.arrow_back,
//                color: Colors.white),
//            label: 'Resources',
//          ),
//          BottomNavigationBarItem(
//            icon: Icon(Icons.schema_outlined,
//                color: Colors.white),
//            label: 'FLOW CHART',
//          ),
//          BottomNavigationBarItem(
//            icon: Icon(Icons.home,
//                color: Colors.white),
//            label: 'Home',
//          ),
//        ],
//      ),

    );
  }

  void updateItem(id, int? oldIndex, int? newIndex, String designName, String taskName, String taskType, String taskActivityArea, String taskFunction, String taskComment) {
    _refreshTasks();
  }

//  updateItem(id, int? oldIndex, int? newIndex, String designName, String taskName, String taskType, String taskActivityArea, String taskFunction, String taskComment) async {
//    await SQLHelperTasks.updateItem(
//        id, oldIndex,
//        newIndex,
//        _designNameController.text,
//        _taskNameController.text,
//        _taskTypeController.text,
//        _taskActivityAreaController.text,
//        _taskFunctionController.text,
//        _taskCommentController.text);
//    _refreshTasks();
//  }

}

class Task {
  Task ({required this.oldIndex, required this.newIndex, required this.designName, required this.taskName, required this.taskType, required this.taskActivityArea, required this.taskFunction, required this.taskComment, required this.id, required this.completed});
  int? oldIndex;
  int? newIndex;
  String designName;
  String taskName;
  String taskType;
  String taskActivityArea;
  String taskFunction;
  String taskComment;
  int id;
  bool completed;
}