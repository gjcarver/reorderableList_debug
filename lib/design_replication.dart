import 'package:flutter/material.dart';
import 'main.dart';
import 'sql_replication.dart';
import 'help_replication.dart';
import 'resources.dart';
import 'package:flag/flag.dart';
import 'camera.dart';
import 'tasks.dart';

void main() {
  runApp(const ReplicationForm());
}

class ReplicationForm extends StatelessWidget {
  const ReplicationForm({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Remove the debug banner
        debugShowCheckedModeBanner: false,
        title: 'Replication',
        theme: ThemeData(
          primarySwatch: Colors.lightGreen,
        ),
        home: const ReplicationPage());
  }
}

class ReplicationPage extends StatefulWidget {
  const ReplicationPage({super.key});

  @override
  State<ReplicationPage> createState() => _ReplicationPageState();
}

class _ReplicationPageState extends State<ReplicationPage> {
  // All replications
  List<Map<String, dynamic>> _replication = [];

  bool _isLoading = true;
  // This function is used to fetch all data from the database
  void _refreshReplication() async {
    final data = await SQLHelperReplication.getItems();
    setState(() {
      _replication = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshReplication(); // Loading the diary when the app starts
  }

  final TextEditingController _replicationNameController = TextEditingController();
  final TextEditingController _replicationTypeController = TextEditingController();
  final TextEditingController _replicationReferenceController = TextEditingController();
  final TextEditingController _replicationAimController = TextEditingController();
  final TextEditingController _replicationSerialNumberController = TextEditingController();
  final TextEditingController _replicationActivityAreaController = TextEditingController();
  final TextEditingController _replicationPurposeController = TextEditingController();
  final TextEditingController _replicationWebPageController = TextEditingController();
  final TextEditingController _replicationCommentController = TextEditingController();

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void _showForm(int? id) async {
    if (id != null) {
      // id == null -> create new item
      // id != null -> update an existing item
      final existingReplication =
      _replication.firstWhere((element) => element['id'] == id);
      _replicationNameController.text = existingReplication['replicationName'];
      _replicationTypeController.text = existingReplication['replicationType'];
      _replicationReferenceController.text = existingReplication['replicationReference'];
      _replicationAimController.text = existingReplication['replicationAim'];
      _replicationSerialNumberController.text = existingReplication['replicationSerialNumber'];
      _replicationActivityAreaController.text = existingReplication['replicationActivityArea'];
      _replicationPurposeController.text = existingReplication['replicationPurpose'];
      _replicationWebPageController.text = existingReplication['replicationWebPage'];
      _replicationCommentController.text = existingReplication['replicationComment'];
    }

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
//          crossAxisAlignment: CrossAxisAlignment.end,
            children: [

              const Text(
                'Plan a REPLICATION:',
                style: TextStyle(
                    fontSize: 24),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _replicationNameController,
                  decoration: const InputDecoration(hintText: 'Replication NAME'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _replicationSerialNumberController,
                  decoration: const InputDecoration(hintText: 'Replication SERIAL NUMBER (other identifier)'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _replicationTypeController,
                  decoration: const InputDecoration(hintText: 'Replication TYPE'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _replicationReferenceController,
                  decoration: const InputDecoration(hintText: 'WHAT do you want to replicate?'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _replicationAimController,
                  decoration: const InputDecoration(hintText: 'WHY do you want to replicate this?'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _replicationActivityAreaController,
                  decoration: const InputDecoration(hintText: 'Replication ACTIVITY Area'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _replicationPurposeController,
                  decoration: const InputDecoration(hintText: 'Replication FUNCTION'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _replicationWebPageController,
                  decoration: const InputDecoration(hintText: 'Experiment WEB PAGE'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _replicationCommentController,
                  decoration: const InputDecoration(hintText: 'Replication COMMENT'),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton.icon(
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('BACK'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightGreen[200] //elevated button background color
                    ),
                    onPressed: () {

                      Navigator.of(context).pop();
                    },
                  ),

                  ElevatedButton.icon(
                    icon: const Icon(Icons.check_box_outlined),
                    label: const Text('TASKS'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightGreen[200] //elevated button background color
                    ),
                    onPressed: () {

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const TasksForm()),
                      );

                    },
                  ),

                  ElevatedButton.icon(
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('PHOTO'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightGreen[200] //elevated button background color
                    ),
                    onPressed: () {

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PhotosVideo()),
                      );

                    },
                  ),

              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: Text(id == null ? 'SAVE' : 'UPDATE'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreen[200] //elevated button background color
                ),
                onPressed: () async {
                  // Save new replication
                  if (id == null) {
                    await _addItem();
                  }

                  if (id != null) {
                    await _updateItem(id);
                  }

                  // Clear the text fields
                  _replicationNameController.text = '';
                  _replicationTypeController.text = '';
                  _replicationReferenceController.text = '';
                  _replicationAimController.text = '';
                  _replicationSerialNumberController.text = '';
                  _replicationActivityAreaController.text = '';
                  _replicationPurposeController.text = '';
                  _replicationWebPageController.text = '';
                  _replicationCommentController.text = '';

                  // Close the bottom sheet
                  if (!mounted) return;
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
  //        ),
            ],
          ),
      ));
  }

// Insert a new replication to the database
  Future<void> _addItem() async {
    await SQLHelperReplication.createItem(
        _replicationNameController.text, _replicationTypeController.text, _replicationReferenceController.text,  _replicationAimController.text, _replicationSerialNumberController.text, _replicationActivityAreaController.text, _replicationPurposeController.text,  _replicationWebPageController.text, _replicationCommentController.text);
    _refreshReplication();
  }

  // Update an existing replication
  Future<void> _updateItem(int id) async {
    await SQLHelperReplication.updateItem(
        id, _replicationNameController.text, _replicationTypeController.text, _replicationReferenceController.text,  _replicationAimController.text, _replicationSerialNumberController.text, _replicationActivityAreaController.text, _replicationPurposeController.text, _replicationWebPageController.text, _replicationCommentController.text);
    _refreshReplication();
  }

  // Delete an item
  void _deleteItem(int id) async {
    await SQLHelperReplication.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Replication deleted!'),
    ));
    _refreshReplication();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('N4O Workflow Tool: Replication Design'),
        leading: const Icon(Icons.copy),
        backgroundColor: Colors.lightGreen,

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
                MaterialPageRoute(builder: (context) => const HelpReplication()),
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
                MaterialPageRoute(builder: (context) => const HelpReplication()),
              );

            },
          ),

          IconButton(
            icon: const Icon(Icons.help),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpReplication()),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
        itemCount: _replication.length,
        itemBuilder: (context, index) => Card(
          color: Colors.lightGreen[200],
          margin: const EdgeInsets.all(15),
          child: ListTile(
              title: Text(_replication[index]['replicationName']),
              subtitle: Text(_replication[index]['replicationType']),
              trailing: SizedBox(
                width: 100,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showForm(_replication[index]['id']),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () =>
                          _deleteItem(_replication[index]['id']),
                    ),
                  ],
                ),
              )),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(null),
        backgroundColor: Colors.lightGreen,
        child: const Icon(Icons.add),
      ),

      bottomNavigationBar: BottomNavigationBar(

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
                  compoundIndex = 1;
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NFDIexperimentApp()),
                );
              }

              break;

//            case 2:
//              {
//                setState(() {
//                  compoundIndex = 2;
//                });
//                Navigator.push(
//                  context,
//                  MaterialPageRoute(
//                      builder: (_) => const FlowChart()),
//                );
//              }
//
//              break;

          }
        },

        backgroundColor: Colors.lightGreen,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_back),
            label: 'Resources',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
//          BottomNavigationBarItem(
//            icon: Icon(Icons.schema_outlined,
//                color: Colors.white),
//            label: 'FLOW CHART',
//          ),
        ],
      ),

    );
  }
}