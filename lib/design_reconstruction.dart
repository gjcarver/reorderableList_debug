import 'package:flutter/material.dart';
import 'main.dart';
import 'sql_reconstruction.dart';
import 'help_reconstruction.dart';
import 'resources.dart';
import 'package:flag/flag.dart';
import 'camera.dart';
import 'tasks.dart';

void main() {
  runApp(const ReconstructionForm());
}

class ReconstructionForm extends StatelessWidget {
  const ReconstructionForm({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Remove the debug banner
        debugShowCheckedModeBanner: false,
        title: 'Reconstruction',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: const ReconstructionPage());
  }
}

class ReconstructionPage extends StatefulWidget {
  const ReconstructionPage({super.key});

  @override
  State<ReconstructionPage> createState() => _ReconstructionPageState();
}

class _ReconstructionPageState extends State<ReconstructionPage> {
  // All reconstructions
  List<Map<String, dynamic>> _reconstruction = [];

  bool _isLoading = true;
  // This function is used to fetch all data from the database
  void _refreshReconstruction() async {
    final data = await SQLHelperReconstruction.getItems();
    setState(() {
      _reconstruction = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshReconstruction(); // Loading the diary when the app starts
  }

  final TextEditingController _reconstructionNameController = TextEditingController();
  final TextEditingController _reconstructionTypeController = TextEditingController();
  final TextEditingController _reconstructionReferenceController = TextEditingController();
  final TextEditingController _reconstructionAimController = TextEditingController();
  final TextEditingController _reconstructionSerialNumberController = TextEditingController();
  final TextEditingController _reconstructionActivityAreaController = TextEditingController();
  final TextEditingController _reconstructionPurposeController = TextEditingController();
  final TextEditingController _reconstructionWebPageController = TextEditingController();
  final TextEditingController _reconstructionCommentController = TextEditingController();

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void _showForm(int? id) async {
    if (id != null) {
      // id == null -> create new item
      // id != null -> update an existing item
      final existingReconstruction =
      _reconstruction.firstWhere((element) => element['id'] == id);
      _reconstructionNameController.text = existingReconstruction['reconstructionName'];
      _reconstructionTypeController.text = existingReconstruction['reconstructionType'];
      _reconstructionReferenceController.text = existingReconstruction['reconstructionReference'];
      _reconstructionAimController.text = existingReconstruction['reconstructionAim'];
      _reconstructionSerialNumberController.text = existingReconstruction['reconstructionSerialNumber'];
      _reconstructionActivityAreaController.text = existingReconstruction['reconstructionActivityArea'];
      _reconstructionPurposeController.text = existingReconstruction['reconstructionPurpose'];
      _reconstructionWebPageController.text = existingReconstruction['_reconstructionWebPage'];
      _reconstructionCommentController.text = existingReconstruction['reconstructionComment'];
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
              'Plan a RECONSTRUCTION:',
              style: TextStyle(
                  fontSize: 24),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextField(
                controller: _reconstructionNameController,
                decoration: const InputDecoration(hintText: 'Reconstruction NAME'),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextField(
                controller: _reconstructionSerialNumberController,
                decoration: const InputDecoration(hintText: 'Reconstruction SERIAL NUMBER (other identifier)'),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextField(
                controller: _reconstructionTypeController,
                decoration: const InputDecoration(hintText: 'Reconstruction TYPE'),
              ),
            ),

      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        child: TextField(
          controller: _reconstructionReferenceController,
          decoration: const InputDecoration(hintText: 'WHAT do you want to reconstruct?'),
        ),
      ),

      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        child: TextField(
          controller: _reconstructionAimController,
          decoration: const InputDecoration(hintText: 'WHY do you want to reconstruct this?'),
        ),
      ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextField(
                controller: _reconstructionActivityAreaController,
                decoration: const InputDecoration(hintText: 'Reconstruction ACTIVITY Area'),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextField(
                controller: _reconstructionPurposeController,
                decoration: const InputDecoration(hintText: 'Reconstruction FUNCTION'),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextField(
                controller: _reconstructionWebPageController,
                decoration: const InputDecoration(hintText: 'Experiment WEB PAGE'),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextField(
                controller: _reconstructionCommentController,
                decoration: const InputDecoration(hintText: 'Reconstruction COMMENT'),
              ),
            ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ElevatedButton.icon(
              icon: const Icon(Icons.arrow_back),
              label: const Text('BACK'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[200] //elevated button background color
              ),
              onPressed: () {

                Navigator.of(context).pop();
              },
            ),

            ElevatedButton.icon(
              icon: const Icon(Icons.check_box_outlined),
              label: const Text('TASKS'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[200] //elevated button background color
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
                  backgroundColor: Colors.green[200] //elevated button background color
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
                  backgroundColor: Colors.green[200] //elevated button background color
              ),
              onPressed: () async {
                // Save new reconstruction
                if (id == null) {
                  await _addItem();
                }

                if (id != null) {
                  await _updateItem(id);
                }

                // Clear the text fields
                _reconstructionNameController.text = '';
                _reconstructionTypeController.text = '';
                _reconstructionReferenceController.text = '';
                _reconstructionAimController.text = '';
                _reconstructionSerialNumberController.text = '';
                _reconstructionActivityAreaController.text = '';
                _reconstructionPurposeController.text = '';
                _reconstructionWebPageController.text = '';
                _reconstructionCommentController.text = '';

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

// Insert a new reconstruction to the database
  Future<void> _addItem() async {
    await SQLHelperReconstruction.createItem(
        _reconstructionNameController.text, _reconstructionTypeController.text, _reconstructionReferenceController.text,  _reconstructionAimController.text, _reconstructionSerialNumberController.text, _reconstructionActivityAreaController.text, _reconstructionPurposeController.text, _reconstructionWebPageController.text, _reconstructionCommentController.text);
    _refreshReconstruction();
  }

  // Update an existing reconstruction
  Future<void> _updateItem(int id) async {
    await SQLHelperReconstruction.updateItem(
        id, _reconstructionNameController.text, _reconstructionTypeController.text, _reconstructionReferenceController.text,  _reconstructionAimController.text, _reconstructionSerialNumberController.text, _reconstructionActivityAreaController.text, _reconstructionPurposeController.text, _reconstructionWebPageController.text,  _reconstructionCommentController.text);
    _refreshReconstruction();
  }

  // Delete an item
  void _deleteItem(int id) async {
    await SQLHelperReconstruction.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Reconstruction deleted!'),
    ));
    _refreshReconstruction();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('N4O Workflow Tool: Reconstruction Design'),
        leading: const Icon(Icons.foundation),
        backgroundColor: Colors.green,

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
                MaterialPageRoute(builder: (context) => const HelpReconstruction()),
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
                MaterialPageRoute(builder: (context) => const HelpReconstruction()),
              );

            },
          ),

          IconButton(
            icon: const Icon(Icons.help),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpReconstruction()),
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
        itemCount: _reconstruction.length,
        itemBuilder: (context, index) => Card(
          color: Colors.green[100],
          margin: const EdgeInsets.all(15),
          child: ListTile(
              title: Text(_reconstruction[index]['reconstructionName']),
              subtitle: Text(_reconstruction[index]['reconstructionType']),
              trailing: SizedBox(
                width: 100,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showForm(_reconstruction[index]['id']),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () =>
                          _deleteItem(_reconstruction[index]['id']),
                    ),
                  ],
                ),
              )),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(null),
        backgroundColor: Colors.green,
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

        backgroundColor: Colors.green,
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