import 'package:flutter/material.dart';
import 'main.dart';
import 'sql_observation.dart';
import 'help_observation.dart';
import 'resources.dart';
import 'package:flag/flag.dart';
import 'camera.dart';
import 'tasks.dart';

void main() {
  runApp(const ObservationForm());
}

class ObservationForm extends StatelessWidget {
  const ObservationForm({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Remove the debug banner
        debugShowCheckedModeBanner: false,
        title: 'Observation',
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        home: const ObservationPage());
  }
}

class ObservationPage extends StatefulWidget {
  const ObservationPage({super.key});

  @override
  State<ObservationPage> createState() => _ObservationPageState();
}

class _ObservationPageState extends State<ObservationPage> {
  // All observations
  List<Map<String, dynamic>> _observation = [];

  bool _isLoading = true;
  // This function is used to fetch all data from the database
  void _refreshObservation() async {
    final data = await SQLHelperObservations.getItems();
    setState(() {
      _observation = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshObservation(); // Loading the diary when the app starts
  }

  final TextEditingController _observationNameController = TextEditingController();
  final TextEditingController _observationTypeController = TextEditingController();
  final TextEditingController _observationObservedController = TextEditingController();
  final TextEditingController _observationAimController = TextEditingController();
  final TextEditingController _observationSerialNumberController = TextEditingController();
  final TextEditingController _observationActivityAreaController = TextEditingController();
  final TextEditingController _observationPurposeController = TextEditingController();
  final TextEditingController _observationWebPageController = TextEditingController();
  final TextEditingController _observationCommentController = TextEditingController();

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void _showForm(int? id) async {
    if (id != null) {
      // id == null -> create new item
      // id != null -> update an existing item
      final existingObservation =
      _observation.firstWhere((element) => element['id'] == id);
      _observationNameController.text = existingObservation['observationName'];
      _observationTypeController.text = existingObservation['observationType'];
      _observationObservedController.text = existingObservation['observationObserved'];
      _observationAimController.text = existingObservation['observationAim'];
      _observationSerialNumberController.text = existingObservation['observationSerialNumber'];
      _observationActivityAreaController.text = existingObservation['observationActivityArea'];
      _observationPurposeController.text = existingObservation['observationPurpose'];
      _observationWebPageController.text = existingObservation['_observationWebPage'];
      _observationCommentController.text = existingObservation['observationComment'];
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
              'Plan an OBSERVATION:',
              style: TextStyle(
                  fontSize: 24),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextField(
                controller: _observationNameController,
                decoration: const InputDecoration(hintText: 'Observation NAME'),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextField(
                controller: _observationSerialNumberController,
                decoration: const InputDecoration(hintText: 'Observation SERIAL NUMBER (other identifier)'),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextField(
                controller: _observationTypeController,
                decoration: const InputDecoration(hintText: 'Observation TYPE'),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextField(
                controller: _observationObservedController,
                decoration: const InputDecoration(hintText: 'WHAT are you looking at?'),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextField(
                controller: _observationAimController,
                decoration: const InputDecoration(hintText: 'WHAT are you looking for?'),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextField(
                controller: _observationActivityAreaController,
                decoration: const InputDecoration(hintText: 'Observation ACTIVITY Area'),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextField(
                controller: _observationPurposeController,
                decoration: const InputDecoration(hintText: 'Observation FUNCTION'),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextField(
                controller: _observationWebPageController,
                decoration: const InputDecoration(hintText: 'Experiment WEB PAGE'),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextField(
                controller: _observationCommentController,
                decoration: const InputDecoration(hintText: 'Observation COMMENT'),
              ),
            ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ElevatedButton.icon(
              icon: const Icon(Icons.arrow_back),
              label: const Text('BACK'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[200] //elevated button background color
              ),
              onPressed: () {

                Navigator.of(context).pop();
              },
            ),

            ElevatedButton.icon(
              icon: const Icon(Icons.check_box_outlined),
              label: const Text('TASKS'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[200] //elevated button background color
              ),
              onPressed: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TasksForm()),
                );

              },
            ),

//            ElevatedButton.icon(
//              icon: const Icon(Icons.task_outlined),
//              label: const Text('TASKS'),
//              style: ElevatedButton.styleFrom(
//                  backgroundColor: Colors.orange[200] //elevated button background color
//              ),
//              onPressed: () {
//
//                Navigator.push(
//                  context,
//                  MaterialPageRoute(builder: (context) => const FlowchartEditor()),
//                );
//
//              },
//            ),

            ElevatedButton.icon(
              icon: const Icon(Icons.camera_alt),
              label: const Text('PHOTO'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[200] //elevated button background color
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
                  backgroundColor: Colors.orange[200] //elevated button background color
              ),
              onPressed: () async {
                // Save new observation
                if (id == null) {
                  await _addItem();
                }

                if (id != null) {
                  await _updateItem(id);
                }

                // Clear the text fields
                _observationNameController.text = '';
                _observationTypeController.text = '';
                _observationObservedController.text = '';
                _observationAimController.text = '';
                _observationSerialNumberController.text = '';
                _observationActivityAreaController.text = '';
                _observationPurposeController.text = '';
                _observationWebPageController.text = '';
                _observationCommentController.text = '';

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

// Insert a new observation to the database
  Future<void> _addItem() async {
    await SQLHelperObservations.createItem(
        _observationNameController.text, _observationTypeController.text, _observationObservedController.text, _observationAimController.text, _observationSerialNumberController.text, _observationActivityAreaController.text, _observationPurposeController.text, _observationWebPageController.text, _observationCommentController.text);
    _refreshObservation();
  }

  // Update an existing observation
  Future<void> _updateItem(int id) async {
    await SQLHelperObservations.updateItem(
        id, _observationNameController.text, _observationTypeController.text, _observationObservedController.text, _observationAimController.text, _observationSerialNumberController.text, _observationActivityAreaController.text, _observationPurposeController.text, _observationWebPageController.text, _observationCommentController.text);
    _refreshObservation();
  }

  // Delete an item
  void _deleteItem(int id) async {
    await SQLHelperObservations.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Observation deleted!'),
    ));
    _refreshObservation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('N4O Workflow Tool: Observation Plan'),
        leading: const Icon(Icons.biotech),
        backgroundColor: Colors.orange,

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
                MaterialPageRoute(builder: (context) => const HelpObservation()),
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
                MaterialPageRoute(builder: (context) => const HelpObservation()),
              );

            },
          ),

          IconButton(
            icon: const Icon(Icons.help),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpObservation()),
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
        itemCount: _observation.length,
        itemBuilder: (context, index) => Card(
          color: Colors.orange[100],
          margin: const EdgeInsets.all(15),
          child: ListTile(
              title: Text(_observation[index]['observationName']),
              subtitle: Text(_observation[index]['observationType']),
              trailing: SizedBox(
                width: 100,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showForm(_observation[index]['id']),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () =>
                          _deleteItem(_observation[index]['id']),
                    ),
                  ],
                ),
              )),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(null),
        backgroundColor: Colors.orangeAccent,
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

        backgroundColor: Colors.orangeAccent,
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