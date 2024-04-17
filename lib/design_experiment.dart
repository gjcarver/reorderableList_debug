import 'package:flutter/material.dart';
import 'main.dart';
import 'sql_experiment.dart';
import 'help_experiment.dart';
import 'resources.dart';
import 'package:flag/flag.dart';
import 'camera.dart';
import 'tasks.dart';

void main() {
  runApp(const ExperimentForm());
}

class ExperimentForm extends StatelessWidget {
  const ExperimentForm({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Remove the debug banner
        debugShowCheckedModeBanner: false,
        title: 'Experiment',
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
        ),
        home: const ExperimentPage());
  }
}

class ExperimentPage extends StatefulWidget {
  const ExperimentPage({super.key});

  @override
  State<ExperimentPage> createState() => _ExperimentPageState();
}

class _ExperimentPageState extends State<ExperimentPage> {
  // All experiments
  List<Map<String, dynamic>> _experiment = [];

  bool _isLoading = true;
  // This function is used to fetch all data from the database
  void _refreshExperiment() async {
    final data = await SQLHelperExperiments.getItems();
    setState(() {
      _experiment = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshExperiment(); // Loading the diary when the app starts
  }

  final TextEditingController _experimentNameController = TextEditingController();
  final TextEditingController _experimentTypeController = TextEditingController();
//  final TextEditingController _experimentManufacturerController = TextEditingController();
//  final TextEditingController _experimentModelController = TextEditingController();
  final TextEditingController _experimentSerialNumberController = TextEditingController();
  final TextEditingController _experimentActivityAreaController = TextEditingController();
  final TextEditingController _experimentPurposeController = TextEditingController();
  final TextEditingController _experimentWebPageController = TextEditingController();
  final TextEditingController _experimentCommentController = TextEditingController();

  // This purpose will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void _showForm(int? id) async {
    if (id != null) {
      // id == null -> create new item
      // id != null -> update an existing item
      final existingExperiment =
      _experiment.firstWhere((element) => element['id'] == id);
      _experimentNameController.text = existingExperiment['experimentName'];
      _experimentTypeController.text = existingExperiment['experimentType'];
//      _experimentManufacturerController.text = existingExperiment['experimentManufacturer'];
//      _experimentModelController.text = existingExperiment['experimentModel'];
      _experimentSerialNumberController.text = existingExperiment['experimentSerialNumber'];
      _experimentActivityAreaController.text = existingExperiment['experimentActivityArea'];
      _experimentPurposeController.text = existingExperiment['experimentPurpose'];
      _experimentWebPageController.text = existingExperiment['_experimentWebPage'];
      _experimentCommentController.text = existingExperiment['experimentComment'];
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
              'Plan an EXPERIMENT:',
              style: TextStyle(
                  fontSize: 24),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextField(
                controller: _experimentNameController,
                decoration: const InputDecoration(hintText: 'Experiment NAME'),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextField(
                controller: _experimentSerialNumberController,
                decoration: const InputDecoration(hintText: 'Experiment SERIAL NUMBER (other identifier)'),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextField(
                controller: _experimentTypeController,
                decoration: const InputDecoration(hintText: 'Experiment TYPE'),
              ),
            ),

//            Padding(
//              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
//              child: TextField(
//                controller: _experimentManufacturerController,
//                decoration: const InputDecoration(hintText: 'Experiment MANUFACTURER'),
//              ),
//            ),
//
//            Padding(
//              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
//              child: TextField(
//                controller: _experimentModelController,
//                decoration: const InputDecoration(hintText: 'Experiment MODEL'),
//              ),
//            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextField(
                controller: _experimentActivityAreaController,
                decoration: const InputDecoration(hintText: 'Experiment ACTIVITY Area'),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextField(
                controller: _experimentPurposeController,
                decoration: const InputDecoration(hintText: 'Experiment PURPOSE'),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextField(
                controller: _experimentWebPageController,
                decoration: const InputDecoration(hintText: 'Experiment WEB PAGE'),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextField(
                controller: _experimentCommentController,
                decoration: const InputDecoration(hintText: 'Experiment COMMENT'),
              ),
            ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ElevatedButton.icon(
              icon: const Icon(Icons.arrow_back),
              label: const Text('BACK'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange[200] //elevated button background color
              ),
              onPressed: () {

                Navigator.of(context).pop();
              },
            ),

            ElevatedButton.icon(
              icon: const Icon(Icons.check_box_outlined),
              label: const Text('TASKS'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange[200] //elevated button background color
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
                  backgroundColor: Colors.deepOrange[200] //elevated button background color
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
                  backgroundColor: Colors.deepOrange[200] //elevated button background color
              ),
              onPressed: () async {
                // Save new experiment
                if (id == null) {
                  await _addItem();
                }

                if (id != null) {
                  await _updateItem(id);
                }

                // Clear the text fields
                _experimentNameController.text = '';
                _experimentTypeController.text = '';
//                _experimentManufacturerController.text = '';
//                _experimentModelController.text = '';
                _experimentSerialNumberController.text = '';
                _experimentActivityAreaController.text = '';
                _experimentPurposeController.text = '';
                _experimentWebPageController.text = '';
                _experimentCommentController.text = '';

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

// Insert a new experiment to the database
  Future<void> _addItem() async {
    await SQLHelperExperiments.createItem(
        _experimentNameController.text, _experimentTypeController.text, _experimentSerialNumberController.text, _experimentActivityAreaController.text, _experimentPurposeController.text, _experimentWebPageController.text, _experimentCommentController.text);
    _refreshExperiment();
  }

  // Update an existing experiment
  Future<void> _updateItem(int id) async {
    await SQLHelperExperiments.updateItem(
        id, _experimentNameController.text,
        _experimentTypeController.text,
        _experimentSerialNumberController.text,
        _experimentActivityAreaController.text,
        _experimentPurposeController.text,
        _experimentWebPageController.text,
        _experimentCommentController.text);
    _refreshExperiment();
  }

  // Delete an item
  void _deleteItem(int id) async {
    await SQLHelperExperiments.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Experiment deleted!'),
    ));
    _refreshExperiment();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('N4O Workflow Tool: Experiment Design'),
        leading: const Icon(Icons.science_outlined),
        backgroundColor: Colors.deepOrange,

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
                MaterialPageRoute(builder: (context) => const HelpExperiment()),
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
                MaterialPageRoute(builder: (context) => const HelpExperiment()),
              );

            },
          ),

          IconButton(
            icon: const Icon(Icons.help),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpExperiment()),
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
        itemCount: _experiment.length,
        itemBuilder: (context, index) => Card(
          color: Colors.deepOrange[100],
          margin: const EdgeInsets.all(15),
          child: ListTile(
              title: Text(_experiment[index]['experimentName']),
              subtitle: Text(_experiment[index]['experimentType']),
              trailing: SizedBox(
                width: 100,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showForm(_experiment[index]['id']),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () =>
                          _deleteItem(_experiment[index]['id']),
                    ),
                  ],
                ),
              )),
        ),
      ),

//                FloatingActionButton.extended(
//                  heroTag: "btnMFlowChart",
//                  backgroundColor: Colors.teal,
//                  onPressed: () {
//
//                    Navigator.push(
//                      context,
//                      MaterialPageRoute(builder: (context) => const FlowChart()),
//                    );
//
//                  },
//                  label: const Text('FLOW CHART'),
//                  icon: const Icon(Icons.schema_outlined),
//                ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(null),
        backgroundColor: Colors.deepOrangeAccent,
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

        backgroundColor: Colors.deepOrangeAccent,
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