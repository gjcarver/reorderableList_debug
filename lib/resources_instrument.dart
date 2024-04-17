import 'package:flutter/material.dart';
import 'main.dart';
import 'sql_instrument.dart';
import 'help_instrument.dart';
import 'resources.dart';
import 'camera.dart';
import 'import_instrument.dart';
import 'package:flag/flag.dart';

void main() {
  runApp(const InstrumentForm());
}

class InstrumentForm extends StatelessWidget {
  const InstrumentForm({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Remove the debug banner
        debugShowCheckedModeBanner: false,
        title: 'Instrument',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const InstrumentPage());
  }
}

class InstrumentPage extends StatefulWidget {
  const InstrumentPage({super.key});

  @override
  State<InstrumentPage> createState() => _InstrumentPageState();
}

class _InstrumentPageState extends State<InstrumentPage> {
  // All instruments
  List<Map<String, dynamic>> _instrument = [];

  bool _isLoading = true;
  // This function is used to fetch all data from the database
  void _refreshInstrument() async {
    final data = await SQLInstrument.getItems();
    setState(() {
      _instrument = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshInstrument(); // Loading the diary when the app starts
  }

  final TextEditingController _instrumentNameController = TextEditingController();
  final TextEditingController _instrumentTypeController = TextEditingController();
  final TextEditingController _instrumentManufacturerController = TextEditingController();
  final TextEditingController _instrumentModelController = TextEditingController();
  final TextEditingController _instrumentSerialNumberController = TextEditingController();
  final TextEditingController _instrumentActivityAreaController = TextEditingController();
  final TextEditingController _instrumentFunctionController = TextEditingController();
  final TextEditingController _instrumentCommentController = TextEditingController();

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void _showForm(int? id) async {
    if (id != null) {
      // id == null -> create new item
      // id != null -> update an existing item
      final existingInstrument =
      _instrument.firstWhere((element) => element['id'] == id);
      _instrumentNameController.text = existingInstrument['instrumentName'];
      _instrumentTypeController.text = existingInstrument['instrumentType'];
      _instrumentManufacturerController.text = existingInstrument['instrumentManufacturer'];
      _instrumentModelController.text = existingInstrument['instrumentModel'];
      _instrumentSerialNumberController.text = existingInstrument['instrumentSerialNumber'];
      _instrumentActivityAreaController.text = existingInstrument['instrumentActivityArea'];
      _instrumentFunctionController.text = existingInstrument['instrumentFunction'];
      _instrumentCommentController.text = existingInstrument['instrumentComment'];
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
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextField(
                controller: _instrumentNameController,
                decoration: const InputDecoration(hintText: 'Instrument NAME'),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextField(
                controller: _instrumentTypeController,
                decoration: const InputDecoration(hintText: 'Instrument TYPE'),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextField(
                controller: _instrumentManufacturerController,
                decoration: const InputDecoration(hintText: 'Instrument MANUFACTURER'),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextField(
                controller: _instrumentModelController,
                decoration: const InputDecoration(hintText: 'Instrument MODEL'),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextField(
                controller: _instrumentSerialNumberController,
                decoration: const InputDecoration(hintText: 'Instrument SERIAL NUMBER'),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextField(
                controller: _instrumentActivityAreaController,
                decoration: const InputDecoration(hintText: 'Instrument ACTIVITY Area'),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextField(
                controller: _instrumentFunctionController,
                decoration: const InputDecoration(hintText: 'Instrument FUNCTION'),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextField(
                controller: _instrumentCommentController,
                decoration: const InputDecoration(hintText: 'Instrument COMMENT'),
              ),
            ),

      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          ElevatedButton.icon(
            icon: const Icon(Icons.arrow_back),
            label: const Text('BACK'),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[200], //elevated button background color
            ),
            onPressed: () {

              Navigator.of(context).pop();
            },
          ),

          ElevatedButton.icon(
            icon: const Icon(Icons.camera_alt),
            label: const Text('PHOTO'),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[200], //elevated button background color
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
                backgroundColor: Colors.blue[200], //elevated button background color
            ),
            onPressed: () async {
                // Save new instrument
                if (id == null) {
                  await _addItem();
                }

                if (id != null) {
                  await _updateItem(id);
                }

                // Clear the text fields
                _instrumentNameController.text = '';
                _instrumentTypeController.text = '';
                _instrumentManufacturerController.text = '';
                _instrumentModelController.text = '';
                _instrumentSerialNumberController.text = '';
                _instrumentActivityAreaController.text = '';
                _instrumentFunctionController.text = '';
                _instrumentCommentController.text = '';

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

// Insert a new instrument to the database
  Future<void> _addItem() async {
    await SQLInstrument.createItem(
        _instrumentNameController.text, _instrumentTypeController.text, _instrumentManufacturerController.text, _instrumentModelController.text, _instrumentSerialNumberController.text, _instrumentActivityAreaController.text, _instrumentFunctionController.text, _instrumentCommentController.text);
    _refreshInstrument();
  }

  // Update an existing instrument
  Future<void> _updateItem(int id) async {
    await SQLInstrument.updateItem(
        id, _instrumentNameController.text, _instrumentTypeController.text, _instrumentManufacturerController.text, _instrumentModelController.text, _instrumentSerialNumberController.text, _instrumentActivityAreaController.text, _instrumentFunctionController.text, _instrumentCommentController.text);
    _refreshInstrument();
  }

  // Delete an item
  void _deleteItem(int id) async {
    await SQLInstrument.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Instrument deleted!'),
    ));
    _refreshInstrument();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('N4O Workflow Tool: Instrument'),
        leading: const Icon(Icons.build),
        backgroundColor: Colors.blue,

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
                MaterialPageRoute(builder: (context) => const HelpInstrument()),
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
                MaterialPageRoute(builder: (context) => const HelpInstrument()),
              );

            },
          ),

          IconButton(
            icon: const Icon(Icons.help),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpInstrument()),
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
        itemCount: _instrument.length,
        itemBuilder: (context, index) => Card(
          color: Colors.blue[200],
          margin: const EdgeInsets.all(15),
          child: ListTile(
              title: Text(_instrument[index]['instrumentName']),
              subtitle: Text(_instrument[index]['instrumentType']),
              trailing: SizedBox(
                width: 100,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showForm(_instrument[index]['id']),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () =>
                          _deleteItem(_instrument[index]['id']),
                    ),
                  ],
                ),
              )),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
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
                  compoundIndex = 1;
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ImportInstrument(storage: InstrumentImport()),
                  ));
              }

              break;

            case 2:
              {
                setState(() {
                  compoundIndex = 2;
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

        backgroundColor: Colors.blueAccent,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_back,
                color: Colors.white),
            label: 'Resources',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.import_contacts,
                color: Colors.white),
            label: 'Import',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home,
                color: Colors.white),
            label: 'Home',
          ),

        ],
      ),

    );
  }
}