import 'package:flutter/material.dart';
import 'main.dart';
import 'sql_reenactment.dart';
import 'help_reenactment.dart';
import 'resources.dart';
import 'package:flag/flag.dart';
import 'camera.dart';
import 'tasks.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

void main() {
  runApp(const ReenactmentForm());
}

class ReenactmentForm extends StatelessWidget {
  const ReenactmentForm({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Remove the debug banner
        debugShowCheckedModeBanner: false,
        title: 'Reenactment',
        theme: ThemeData(
          primarySwatch: Colors.lime,
        ),
        home: const ReenactmentPage());
  }
}

class ReenactmentPage extends StatefulWidget {
  const ReenactmentPage({super.key});

  @override
  State<ReenactmentPage> createState() => _ReenactmentPageState();
}

class _ReenactmentPageState extends State<ReenactmentPage> {
  // All reenactments
  List<Map<String, dynamic>> _reenactment = [];

  bool _isLoading = true;
  // This function is used to fetch all data from the database
  void _refreshReenactment() async {
    final data = await SQLHelperReenactment.getItems();
    setState(() {
      _reenactment = data;
      _isLoading = false;
    });
  }

  void _onChanged(dynamic val) => debugPrint(val.toString());

  @override
  void initState() {
    super.initState();
    _refreshReenactment(); // Loading the diary when the app starts
  }

  final TextEditingController _reenactmentNameController = TextEditingController();
  final TextEditingController _reenactmentTypeController = TextEditingController();
  final TextEditingController _reenactmentReferenceController = TextEditingController();
  final TextEditingController _reenactmentAimController = TextEditingController();
  final TextEditingController _reenactmentSerialNumberController = TextEditingController();
  final TextEditingController _reenactmentActivityAreaController = TextEditingController();
  final TextEditingController _reenactmentPurposeController = TextEditingController();
  final TextEditingController _reenactmentWebPageController = TextEditingController();
  final TextEditingController _reenactmentCommentController = TextEditingController();

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void _showForm(int? id) async {
    if (id != null) {
      // id == null -> create new item
      // id != null -> update an existing item
      final existingReenactment =
      _reenactment.firstWhere((element) => element['id'] == id);
      _reenactmentNameController.text = existingReenactment['reenactmentName'];
      _reenactmentTypeController.text = existingReenactment['reenactmentType'];
      _reenactmentReferenceController.text = existingReenactment['reenactmentReference'];
      _reenactmentAimController.text = existingReenactment['reenactmentAim'];
      _reenactmentSerialNumberController.text = existingReenactment['reenactmentSerialNumber'];
      _reenactmentActivityAreaController.text = existingReenactment['reenactmentActivityArea'];
      _reenactmentPurposeController.text = existingReenactment['reenactmentPurpose'];
      _reenactmentWebPageController.text = existingReenactment['_reenactmentWebPage'];
      _reenactmentCommentController.text = existingReenactment['reenactmentComment'];
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
              'Plan a RE-ENACTMENT:',
              style: TextStyle(
                  fontSize: 24),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextField(
                controller: _reenactmentNameController,
                decoration: const InputDecoration(hintText: 'Reenactment NAME'),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextField(
                controller: _reenactmentSerialNumberController,
                decoration: const InputDecoration(hintText: 'Reenactment SERIAL NUMBER (other identifier)'),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextField(
                controller: _reenactmentTypeController,
                decoration: const InputDecoration(hintText: 'Reenactment TYPE'),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextField(
                controller: _reenactmentReferenceController,
                decoration: const InputDecoration(hintText: 'WHAT do you want to reenact?'),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextField(
                controller: _reenactmentAimController,
                decoration: const InputDecoration(hintText: 'WHY do you want to reenact this?'),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextField(
                controller: _reenactmentActivityAreaController,
                decoration: const InputDecoration(hintText: 'Reenactment ACTIVITY Area'),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextField(
                controller: _reenactmentPurposeController,
                decoration: const InputDecoration(hintText: 'Reenactment PURPOSE'),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(top:10, left:10, right:10),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    const Text("Reenactment PURPOSE:", style: TextStyle(
                        fontSize: 24
                    ),),

                    FormBuilderFilterChip<String>(
                      alignment: WrapAlignment.spaceEvenly,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      name: 'institution_function',
                      labelStyle: const TextStyle(fontSize: 24),
                      backgroundColor: Colors.lime[200],
                      selectedColor: Colors.lime,
                      elevation: 5,
                      options: const [
                        FormBuilderChipOption(
                          value: 'iEducation',
                          avatar: CircleAvatar(child: Icon(Icons.school_outlined)),
                          child: Text('Education'),
                        ),
                        FormBuilderChipOption(
                          value: 'iEntertainment',
                          avatar: CircleAvatar(child: Icon(Icons.stadium_outlined)),
                          child: Text('Entertainment'),
                        ),
                        FormBuilderChipOption(
                          value: 'iLivingHistory',
                          avatar: CircleAvatar(child: Icon(Icons.history_edu_outlined)),
                          child: Text('Living history'),
                        ),
                        FormBuilderChipOption(
                          value: 'iFun',
                          avatar: CircleAvatar(child: Icon(Icons.celebration_outlined)),
                          child: Text('Fun'),
                        ),
//                        FormBuilderChipOption(
//                          value: 'iReconstruction',
//                          avatar: CircleAvatar(child: Icon(Icons.foundation)),
//                          child: Text('Reconstruction'),
//                        ),
//                        FormBuilderChipOption(
//                          value: 'iReenactment',
//                          avatar: CircleAvatar(child: Icon(Icons.theater_comedy_outlined)),
//                          child: Text('Reenactment'),
//                        ),
                      ],
                      onChanged: _onChanged,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.minLength(1),
                      ]),
                    ),

                  ],)
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextField(
                controller: _reenactmentWebPageController,
                decoration: const InputDecoration(hintText: 'Reenactment WEB PAGE'),
              ),
            ),

            FormBuilderDateTimePicker(
                  name: 'date',
                  initialEntryMode: DatePickerEntryMode.calendar,
                  initialValue: DateTime.now(),
                  inputType: InputType.date,
                  decoration: InputDecoration(
                    labelText: 'Planned reenactment DATE',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
//                        _formKey.currentState!.fields['date']?.didChange(null);
                      },
                    ),
                  ),
//                  initialTime: const TimeOfDay(hour: 8, minute: 0),
                  // locale: const Locale.fromSubtags(languageCode: 'fr'),
                ),

//                FormBuilderDateRangePicker(
//                  name: 'date_range',
//                  firstDate: DateTime(1970),
//                  lastDate: DateTime(2030),
//                  format: DateFormat('yyyy-MM-dd'),
//                  onChanged: _onChanged,
//                  decoration: InputDecoration(
//                    labelText: 'Date Range',
//                    helperText: 'Helper text',
//                    hintText: 'Hint text',
//                    suffixIcon: IconButton(
//                      icon: const Icon(Icons.close),
//                      onPressed: () {
//                        _formKey.currentState!.fields['date_range']
//                            ?.didChange(null);
//                      },
//                    ),
//                  ),
//                ),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextField(
                controller: _reenactmentCommentController,
                decoration: const InputDecoration(hintText: 'Reenactment COMMENT'),
              ),
            ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ElevatedButton.icon(
              icon: const Icon(Icons.arrow_back),
              label: const Text('BACK'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lime[200] //elevated button background color
              ),
              onPressed: () {

                Navigator.of(context).pop();
              },
            ),

            ElevatedButton.icon(
              icon: const Icon(Icons.check_box_outlined),
              label: const Text('TASKS'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lime //elevated button background color
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
                  backgroundColor: Colors.lime //elevated button background color
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
                  backgroundColor: Colors.lime //elevated button background color
              ),
              onPressed: () async {
                // Save new reenactment
                if (id == null) {
                  await _addItem();
                }

                if (id != null) {
                  await _updateItem(id);
                }

                // Clear the text fields
                _reenactmentNameController.text = '';
                _reenactmentTypeController.text = '';
                _reenactmentReferenceController.text = '';
                _reenactmentAimController.text = '';
                _reenactmentSerialNumberController.text = '';
                _reenactmentActivityAreaController.text = '';
                _reenactmentPurposeController.text = '';
                _reenactmentWebPageController.text = '';
                _reenactmentCommentController.text = '';

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

// Insert a new reenactment to the database
  Future<void> _addItem() async {
    await SQLHelperReenactment.createItem(
        _reenactmentNameController.text, _reenactmentTypeController.text, _reenactmentReferenceController.text, _reenactmentAimController.text, _reenactmentSerialNumberController.text, _reenactmentActivityAreaController.text, _reenactmentPurposeController.text, _reenactmentWebPageController.text, _reenactmentCommentController.text);
    _refreshReenactment();
  }

  // Update an existing reenactment
  Future<void> _updateItem(int id) async {
    await SQLHelperReenactment.updateItem(
        id, _reenactmentNameController.text, _reenactmentTypeController.text, _reenactmentReferenceController.text, _reenactmentAimController.text, _reenactmentSerialNumberController.text, _reenactmentActivityAreaController.text, _reenactmentPurposeController.text, _reenactmentWebPageController.text, _reenactmentCommentController.text);
    _refreshReenactment();
  }

  // Delete an item
  void _deleteItem(int id) async {
    await SQLHelperReenactment.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Reenactment deleted!'),
    ));
    _refreshReenactment();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('N4O Workflow Tool: Reenactment Plan'),
        leading: const Icon(Icons.theater_comedy_outlined),
        backgroundColor: Colors.lime,

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
                MaterialPageRoute(builder: (context) => const HelpReenactment()),
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
                MaterialPageRoute(builder: (context) => const HelpReenactment()),
              );

            },
          ),

          IconButton(
            icon: const Icon(Icons.help),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpReenactment()),
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
        itemCount: _reenactment.length,
        itemBuilder: (context, index) => Card(
          color: Colors.lime[100],
          margin: const EdgeInsets.all(15),
          child: ListTile(
              title: Text(_reenactment[index]['reenactmentName']),
              subtitle: Text(_reenactment[index]['reenactmentType']),
              trailing: SizedBox(
                width: 100,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showForm(_reenactment[index]['id']),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () =>
                          _deleteItem(_reenactment[index]['id']),
                    ),
                  ],
                ),
              )),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(null),
        backgroundColor: Colors.lime,
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

        backgroundColor: Colors.lime,
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
