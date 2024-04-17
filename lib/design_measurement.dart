import 'package:flutter/material.dart';
import 'main.dart';
import 'sql_measurement.dart';
import 'help_measurement.dart';
import 'resources.dart';
import 'package:flag/flag.dart';
import 'camera.dart';
import 'tasks.dart';

void main() {
  runApp(const MeasurementForm());
}

class MeasurementForm extends StatelessWidget {
  const MeasurementForm({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Remove the debug banner
        debugShowCheckedModeBanner: false,
        title: 'Measurement',
        theme: ThemeData(
          primarySwatch: Colors.amber,
        ),
        home: const MeasurementPage());
  }
}

class MeasurementPage extends StatefulWidget {
  const MeasurementPage({super.key});

  @override
  State<MeasurementPage> createState() => _MeasurementPageState();
}

class _MeasurementPageState extends State<MeasurementPage> {
  // All measurements
  List<Map<String, dynamic>> _measurement = [];

  bool _isLoading = true;
  // This function is used to fetch all data from the database
  void _refreshMeasurement() async {
    final data = await SQLHelperMeasurements.getItems();
    setState(() {
      _measurement = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshMeasurement(); // Loading the diary when the app starts
  }

  final TextEditingController _measurementNameController = TextEditingController();
  final TextEditingController _measurementTypeController = TextEditingController();
  final TextEditingController _measurementObservedController = TextEditingController();
  final TextEditingController _measurementAimController = TextEditingController();
  final TextEditingController _measurementSerialNumberController = TextEditingController();
  final TextEditingController _measurementActivityAreaController = TextEditingController();
  final TextEditingController _measurementPurposeController = TextEditingController();
  final TextEditingController _measurementWebPageController = TextEditingController();
  final TextEditingController _measurementCommentController = TextEditingController();

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void _showForm(int? id) async {
    if (id != null) {
      // id == null -> create new item
      // id != null -> update an existing item
      final existingMeasurement =
      _measurement.firstWhere((element) => element['id'] == id);
      _measurementNameController.text = existingMeasurement['measurementName'];
      _measurementTypeController.text = existingMeasurement['measurementType'];
      _measurementObservedController.text = existingMeasurement['measurementObserved'];
      _measurementAimController.text = existingMeasurement['measurementAim'];
      _measurementSerialNumberController.text = existingMeasurement['measurementSerialNumber'];
      _measurementActivityAreaController.text = existingMeasurement['measurementActivityArea'];
      _measurementPurposeController.text = existingMeasurement['measurementPurpose'];
      _measurementWebPageController.text = existingMeasurement['_measurementWebPage'];
      _measurementCommentController.text = existingMeasurement['measurementComment'];
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
              'Plan a MEASUREMENT:',
              style: TextStyle(
                  fontSize: 24),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextField(
                controller: _measurementNameController,
                decoration: const InputDecoration(hintText: 'Measurement NAME'),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextField(
                controller: _measurementSerialNumberController,
                decoration: const InputDecoration(hintText: 'Measurement SERIAL NUMBER (other identifier)'),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextField(
                controller: _measurementTypeController,
                decoration: const InputDecoration(hintText: 'Measurement TYPE'),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextField(
                controller: _measurementObservedController,
                decoration: const InputDecoration(hintText: 'WHAT are you looking at?'),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextField(
                controller: _measurementAimController,
                decoration: const InputDecoration(hintText: 'WHAT are you looking for?'),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextField(
                controller: _measurementActivityAreaController,
                decoration: const InputDecoration(hintText: 'Measurement ACTIVITY Area'),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextField(
                controller: _measurementPurposeController,
                decoration: const InputDecoration(hintText: 'Measurement FUNCTION'),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextField(
                controller: _measurementWebPageController,
                decoration: const InputDecoration(hintText: 'Experiment WEB PAGE'),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextField(
                controller: _measurementCommentController,
                decoration: const InputDecoration(hintText: 'Measurement COMMENT'),
              ),
            ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ElevatedButton.icon(
              icon: const Icon(Icons.arrow_back),
              label: const Text('BACK'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber[200] //elevated button background color
              ),
              onPressed: () {

                Navigator.of(context).pop();
              },
            ),

            ElevatedButton.icon(
              icon: const Icon(Icons.check_box_outlined),
              label: const Text('TASKS'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber[200] //elevated button background color
              ),
              onPressed: () async {
                // Save new measurement
                if (id == null) {
                  await _addItem();
                }

                if (id != null) {
                  await _updateItem(id);
                }

                // Clear the text fields
                _measurementNameController.text = '';
                _measurementTypeController.text = '';
                _measurementObservedController.text = '';
                _measurementAimController.text = '';
                _measurementSerialNumberController.text = '';
                _measurementActivityAreaController.text = '';
                _measurementPurposeController.text = '';
                _measurementWebPageController.text = '';
                _measurementCommentController.text = '';

                // Close the bottom sheet
                if (!mounted) return;

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
                  backgroundColor: Colors.amber[200] //elevated button background color
              ),
              onPressed: () async {
                // Save new measurement
                if (id == null) {
                  await _addItem();
                }

                if (id != null) {
                  await _updateItem(id);
                }

                // Clear the text fields
                _measurementNameController.text = '';
                _measurementTypeController.text = '';
                _measurementObservedController.text = '';
                _measurementAimController.text = '';
                _measurementSerialNumberController.text = '';
                _measurementActivityAreaController.text = '';
                _measurementPurposeController.text = '';
                _measurementWebPageController.text = '';
                _measurementCommentController.text = '';

                // Close the bottom sheet
                if (!mounted) return;

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
                  backgroundColor: Colors.amber[200] //elevated button background color
              ),
              onPressed: () async {
                // Save new measurement
                if (id == null) {
                  await _addItem();
                }

                if (id != null) {
                  await _updateItem(id);
                }

                // Clear the text fields
                _measurementNameController.text = '';
                _measurementTypeController.text = '';
                _measurementObservedController.text = '';
                _measurementAimController.text = '';
                _measurementSerialNumberController.text = '';
                _measurementActivityAreaController.text = '';
                _measurementPurposeController.text = '';
                _measurementWebPageController.text = '';
                _measurementCommentController.text = '';

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

// Insert a new measurement to the database
  Future<void> _addItem() async {
    await SQLHelperMeasurements.createItem(
        _measurementNameController.text,
        _measurementTypeController.text,
        _measurementObservedController.text,
        _measurementAimController.text,
        _measurementSerialNumberController.text,
        _measurementActivityAreaController.text,
        _measurementPurposeController.text,
        _measurementWebPageController.text,
        _measurementCommentController.text);
    _refreshMeasurement();
  }

  // Update an existing measurement
  Future<void> _updateItem(int id) async {
    await SQLHelperMeasurements.updateItem(
        id, _measurementNameController.text,
        _measurementTypeController.text,
        _measurementObservedController.text,
        _measurementAimController.text,
        _measurementSerialNumberController.text,
        _measurementActivityAreaController.text,
        _measurementPurposeController.text,
        _measurementWebPageController.text,
        _measurementCommentController.text);
    _refreshMeasurement();
  }

  // Delete an item
  void _deleteItem(int id) async {
    await SQLHelperMeasurements.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Measurement deleted!'),
    ));
    _refreshMeasurement();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('N4O Workflow Tool: Measurement Plan'),
        leading: const Icon(Icons.bar_chart),
        backgroundColor: Colors.amber,

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
                MaterialPageRoute(builder: (context) => const HelpMeasurement()),
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
                MaterialPageRoute(builder: (context) => const HelpMeasurement()),
              );

            },
          ),

          IconButton(
            icon: const Icon(Icons.help),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpMeasurement()),
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
        padding: const EdgeInsets.symmetric(horizontal: 40),
        itemCount: _measurement.length,
        itemBuilder: (context, index) => Card(
          color: Colors.amber[100],
          margin: const EdgeInsets.all(15),
          child: ListTile(
              title: Text(_measurement[index]['measurementName']),
              subtitle: Text(_measurement[index]['measurementType']),
              trailing: SizedBox(
                width: 100,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showForm(_measurement[index]['id']),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () =>
                          _deleteItem(_measurement[index]['id']),
                    ),
                  ],
                ),
              )),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(null),
        backgroundColor: Colors.amberAccent,
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

        backgroundColor: Colors.amberAccent,
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
