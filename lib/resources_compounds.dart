import 'package:flutter/material.dart';
import 'main.dart';
import 'sql_compounds.dart';
import 'help_compounds.dart';
import 'resources.dart';
import 'camera.dart';
import 'package:flag/flag.dart';

void main() {
  runApp(const CompoundsForm());
}

class CompoundsForm extends StatelessWidget {
  const CompoundsForm({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Remove the debug banner
        debugShowCheckedModeBanner: false,
        title: 'Compounds',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        home: const CompoundsPage());
  }
}

class CompoundsPage extends StatefulWidget {
  const CompoundsPage({super.key});

  @override
  State<CompoundsPage> createState() => _CompoundsPageState();
}

class _CompoundsPageState extends State<CompoundsPage> {
  // All compounds
  List<Map<String, dynamic>> _compounds = [];

  bool _isLoading = true;
  // This function is used to fetch all data from the database
  void _refreshCompounds() async {
    final data = await SQLHelperCompounds.getItems();
    setState(() {
      _compounds = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshCompounds(); // Loading the diary when the app starts
  }

  final TextEditingController _compoundNameController = TextEditingController();
  final TextEditingController _compoundTypeController = TextEditingController();
  final TextEditingController _compoundManufacturerController = TextEditingController();
  final TextEditingController _compoundCommentController = TextEditingController();

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void _showForm(int? id) async {
    if (id != null) {
      // id == null -> create new item
      // id != null -> update an existing item
      final existingCompound =
      _compounds.firstWhere((element) => element['id'] == id);
      _compoundNameController.text = existingCompound['compoundName'];
      _compoundTypeController.text = existingCompound['compoundType'];
      _compoundManufacturerController.text = existingCompound['compoundManufacturer'];
      _compoundCommentController.text = existingCompound['compoundComment'];
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
                  controller: _compoundNameController,
                  decoration: const InputDecoration(hintText: 'Compound NAME'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _compoundTypeController,
                  decoration: const InputDecoration(hintText: 'Compound TYPE'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _compoundManufacturerController,
                  decoration: const InputDecoration(hintText: 'Compound MANUFACTURER'),
                ),
              ),

//              Padding(
//                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
//                child: TextField(
//                  controller: _compoundActivityAreaController,
//                  decoration: const InputDecoration(hintText: 'Compound ACTIVITY Area'),
//                ),
//              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _compoundCommentController,
                  decoration: const InputDecoration(hintText: 'Compound COMMENT'),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton.icon(
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('BACK'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent[100], //elevated button background color
                    ),
                    onPressed: () {

                      Navigator.of(context).pop();
                      },
                  ),

                  ElevatedButton.icon(
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('PHOTO'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent[100], //elevated button background color
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
                        backgroundColor: Colors.deepPurpleAccent[100], //elevated button background color
                    ),
                    onPressed: () async {
                  // Save new compound
                  if (id == null) {
                    await _addItem();
                  }

                  if (id != null) {
                    await _updateItem(id);
                  }

                  // Clear the text fields
                  _compoundNameController.text = '';
                  _compoundTypeController.text = '';
                  _compoundManufacturerController.text = '';
                  _compoundCommentController.text = '';

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

// Insert a new compound to the database
  Future<void> _addItem() async {
    await SQLHelperCompounds.createItem(
        _compoundNameController.text, _compoundTypeController.text, _compoundManufacturerController.text, _compoundCommentController.text);
    _refreshCompounds();
  }

  // Update an existing compound
  Future<void> _updateItem(int id) async {
    await SQLHelperCompounds.updateItem(
        id, _compoundNameController.text, _compoundTypeController.text, _compoundManufacturerController.text, _compoundCommentController.text);
    _refreshCompounds();
  }

  // Delete an item
  void _deleteItem(int id) async {
    await SQLHelperCompounds.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Compound deleted!'),
    ));
    _refreshCompounds();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('N4O Workflow Tool: Compounds'),
        leading: const Icon(Icons.shopping_cart),
        backgroundColor: Colors.deepPurple,

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
                MaterialPageRoute(builder: (context) => const HelpCompounds()),
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
                MaterialPageRoute(builder: (context) => const HelpCompounds()),
              );

            },
          ),

          IconButton(
            icon: const Icon(Icons.help),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpCompounds()),
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
        itemCount: _compounds.length,
        itemBuilder: (context, index) => Card(
          color: Colors.deepPurpleAccent[100],
          margin: const EdgeInsets.all(15),
          child: ListTile(
              title: Text(_compounds[index]['compoundName']),
              subtitle: Text(_compounds[index]['compoundType']),
              trailing: SizedBox(
                width: 100,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showForm(_compounds[index]['id']),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () =>
                          _deleteItem(_compounds[index]['id']),
                    ),
                  ],
                ),
              )),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurpleAccent,
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
//                      builder: (context) => const PhotosVideo()),
//                );
//              }
//
//              break;
          }
        },

        backgroundColor: Colors.deepPurpleAccent,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_back,
                color: Colors.white),
            label: 'Resources',
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