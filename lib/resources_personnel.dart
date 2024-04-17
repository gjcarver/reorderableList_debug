import 'package:flutter/material.dart';
import 'main.dart';
import 'sql_personnel.dart';
import 'help_personnel.dart';
import 'resources.dart';
//import 'camera.dart';
import 'package:flag/flag.dart';
//import 'package:validation_pro/validate.dart';
//import 'dart:developer';


void main() {
  runApp(const PersonForm());
}

class PersonForm extends StatelessWidget {
  const PersonForm({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Remove the debug banner
        debugShowCheckedModeBanner: false,
        title: 'Person',
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
        ),
        home: const PersonPage());
  }
}

class PersonPage extends StatefulWidget {
  const PersonPage({super.key});

  @override
  State<PersonPage> createState() => _PersonPageState();
}

class _PersonPageState extends State<PersonPage> {
  // All persons
  List<Map<String, dynamic>> _person = [];

  bool _isLoading = true;
  // This function is used to fetch all data from the database
  void _refreshPerson() async {
    final data = await SQLPerson.getItems();
    setState(() {
      _person = data;
      _isLoading = false;
    });
  }

  void _onChanged(dynamic val) => debugPrint(val.toString());

  @override
  void initState() {
    super.initState();
    _refreshPerson(); // Loading the diary when the app starts
  }

  final TextEditingController _personNameController = TextEditingController();
  final TextEditingController _personPositionController = TextEditingController();
  final TextEditingController _personExperienceController = TextEditingController();
  final TextEditingController _personEmailController = TextEditingController();

  final TextEditingController _personActivityAreaController = TextEditingController();
  final TextEditingController _personFunctionController = TextEditingController();
  final TextEditingController _personCommentController = TextEditingController();

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void _showForm(int? id) async {
    if (id != null) {
      // id == null -> create new item
      // id != null -> update an existing item
      final existingPerson =
      _person.firstWhere((element) => element['id'] == id);
      _personNameController.text = existingPerson['personName'];
      _personPositionController.text = existingPerson['personType'];
      _personExperienceController.text = existingPerson['personExperience'];
      _personEmailController.text = existingPerson['personModel'];

      _personActivityAreaController.text = existingPerson['personActivityArea'];
      _personFunctionController.text = existingPerson['personFunction'];
      _personCommentController.text = existingPerson['personComment'];
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
                  textCapitalization: TextCapitalization.words,
                  controller: _personNameController,
                  decoration: const InputDecoration(hintText: 'Person NAME'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _personPositionController,
                  decoration: const InputDecoration(hintText: 'Person POSITION'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _personFunctionController,
                  decoration: const InputDecoration(hintText: 'Person FUNCTION'),
                ),
              ),

//              Padding(
//                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
//                child: TextField(
//                  controller: _personExperienceController,
//                  decoration: const InputDecoration(hintText: 'Person EXPERIENCE'),
//                ),
//              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _personEmailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(hintText: 'Person E-MAIL'),
//                  onChanged: (value) {
//                    if (Validate.isEmail(value)) {
//                      log("Valid e-mail");
//                    } else {
//                      return("Email not valid");
//                    }
//                    },
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _personActivityAreaController,
                  decoration: const InputDecoration(hintText: 'Person ACTIVITY Area'),
                ),
              ),

//              Padding(
//                  padding: const EdgeInsets.only(top:10, left:10, right:10),
//
//                  child: Column(
//                    crossAxisAlignment: CrossAxisAlignment.center,
//                    children: [
//
////                    const Text("What is your level of experience?", style: TextStyle(
////                        fontSize: 24
////                    ),),
//
//                    FormBuilderFilterChip<String>(
//                        alignment: WrapAlignment.spaceEvenly,
//                        autovalidateMode: AutovalidateMode.onUserInteraction,
//                        decoration: const InputDecoration(
//                            labelText: 'What is your level of experience?'),
//                        name: 'person_experience',
//                        labelStyle: const TextStyle(fontSize: 24),
//                        selectedColor: Colors.red,
//                        elevation: 5,
//                        options: const [
//
//                          FormBuilderChipOption(
//                            value: 'None',
//                            avatar: CircleAvatar(child: Text('1')),
//                          ),
//                          FormBuilderChipOption(
//                            value: 'Beginner',
//                            avatar: CircleAvatar(child: Text('2')),
//                          ),
//                          FormBuilderChipOption(
//                            value: 'Experienced',
//                            avatar: CircleAvatar(child: Text('3')),
//                          ),
//                          FormBuilderChipOption(
//                            value: 'Expert',
//                            avatar: CircleAvatar(child: Text('4')),
////                            onChanged: _onChanged,
////                           validator: FormBuilderValidators.compose([
////                             FormBuilderValidators.minLength(1),
////                             FormBuilderValidators.maxLength(3),
////                           ]),
//                          ),
//                        ],
//                    ),
//                ],
//                  ),
//              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _personCommentController,
                  decoration: const InputDecoration(hintText: 'Person COMMENT'),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton.icon(
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('BACK'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange[200], //elevated button background color
                    ),
                    onPressed: () {

                      Navigator.of(context).pop();
                    },
                  ),

//          ElevatedButton.icon(
//            icon: const Icon(Icons.camera_alt),
//            label: const Text('PHOTO'),
//            onPressed: () {
//
//              Navigator.push(
//                context,
//                MaterialPageRoute(builder: (context) => PhotosVideo()),
//              );
//
//            },
//          ),

                  ElevatedButton.icon(
                    icon: const Icon(Icons.save),
                    label: Text(id == null ? 'SAVE' : 'UPDATE'),

                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange[200], //elevated button background color
                    ),
                    onPressed: () async {
                      // Save new person
                      if (id == null) {
                        await _addItem();
                      }

                      if (id != null) {
                        await _updateItem(id);
                      }

                      // Clear the text fields
                      _personNameController.text = '';
                      _personPositionController.text = '';
                      _personExperienceController.text = '';
                      _personEmailController.text = '';

                      _personActivityAreaController.text = '';
                      _personFunctionController.text = '';
                      _personCommentController.text = '';

                      // Close the bottom sheet
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

// Insert a new person to the database
  Future<void> _addItem() async {
    await SQLPerson.createItem(
        _personNameController.text, _personPositionController.text, _personExperienceController.text, _personEmailController.text, _personActivityAreaController.text, _personFunctionController.text, _personCommentController.text);
    _refreshPerson();
  }

  // Update an existing person
  Future<void> _updateItem(int id) async {
    await SQLPerson.updateItem(
        id, _personNameController.text, _personPositionController.text, _personExperienceController.text, _personEmailController.text, _personActivityAreaController.text, _personFunctionController.text, _personCommentController.text);
    _refreshPerson();
  }

  // Delete an item
  void _deleteItem(int id) async {
    await SQLPerson.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Person deleted!'),
    ));
    _refreshPerson();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('N4O Workflow Tool: Person'),
        leading: const Icon(Icons.person),
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
                MaterialPageRoute(builder: (context) => const HelpPersonnel()),
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
                MaterialPageRoute(builder: (context) => const HelpPersonnel()),
              );

            },
          ),

          IconButton(
            icon: const Icon(Icons.help),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpPersonnel()),
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
        itemCount: _person.length,
        itemBuilder: (context, index) => Card(
          color: Colors.deepOrange[200],
          margin: const EdgeInsets.all(15),
          child: ListTile(
              title: Text(_person[index]['personName']),
              subtitle: Text(_person[index]['personType']),
              trailing: SizedBox(
                width: 100,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showForm(_person[index]['id']),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () =>
                          _deleteItem(_person[index]['id']),
                    ),
                  ],
                ),
              )),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrangeAccent,
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
//                      builder: (_) => const PhotosVideo()),
//                );
//              }
//
//              break;

          }
        },

        backgroundColor: Colors.deepOrangeAccent,
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