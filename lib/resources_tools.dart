import 'package:flutter/material.dart';
import 'main.dart';
import 'sql_tools.dart';
import 'help_tools.dart';
import 'resources.dart';
import 'camera.dart';
import 'package:flag/flag.dart';

void main() {
  runApp(const ToolsForm());
}

class ToolsForm extends StatelessWidget {
  const ToolsForm({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Remove the debug banner
        debugShowCheckedModeBanner: false,
        title: 'Tools',
        theme: ThemeData(
          primarySwatch: Colors.lightBlue,
        ),
        home: const ToolsPage());
  }
}

class ToolsPage extends StatefulWidget {
  const ToolsPage({super.key});

  @override
  State<ToolsPage> createState() => _ToolsPageState();
}

class _ToolsPageState extends State<ToolsPage> {
  // All tools
  List<Map<String, dynamic>> _tools = [];

  bool _isLoading = true;
  // This function is used to fetch all data from the database
  void _refreshTools() async {
    final data = await SQLHelperTools.getItems();
    setState(() {
      _tools = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshTools(); // Loading the diary when the app starts
  }

  final TextEditingController _toolNameController = TextEditingController();
  final TextEditingController _toolTypeController = TextEditingController();
  final TextEditingController _toolActivityAreaController = TextEditingController();
  final TextEditingController _toolFunctionController = TextEditingController();
  final TextEditingController _toolCommentController = TextEditingController();

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void _showForm(int? id) async {
    if (id != null) {
      // id == null -> create new item
      // id != null -> update an existing item
      final existingTool =
      _tools.firstWhere((element) => element['id'] == id);
      _toolNameController.text = existingTool['toolName'];
      _toolTypeController.text = existingTool['toolType'];
      _toolActivityAreaController.text = existingTool['toolActivityArea'];
      _toolFunctionController.text = existingTool['toolFunction'];
      _toolCommentController.text = existingTool['toolComment'];
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
//            crossAxisAlignment: CrossAxisAlignment.end,
            children: [

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _toolNameController,
                  decoration: const InputDecoration(hintText: 'Tool NAME'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _toolTypeController,
                  decoration: const InputDecoration(hintText: 'Tool TYPE'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _toolActivityAreaController,
                  decoration: const InputDecoration(hintText: 'Tool ACTIVITY Area'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _toolFunctionController,
                  decoration: const InputDecoration(hintText: 'Tool FUNCTION (related verb)'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _toolCommentController,
                  decoration: const InputDecoration(hintText: 'Tool COMMENT'),
                ),
              ),

      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          ElevatedButton.icon(
            icon: const Icon(Icons.arrow_back),
            label: const Text('BACK'),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue[200], //elevated button background color
            ),
            onPressed: () {

              Navigator.of(context).pop();
            },
          ),

          ElevatedButton.icon(
            icon: const Icon(Icons.camera_alt),
            label: const Text('PHOTO'),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue[200], //elevated button background color
            ),
            onPressed: () async {
              // Save new tool
              if (id == null) {
                await _addItem();
              }

              if (id != null) {
                await _updateItem(id);
              }

              // Clear the text fields
              _toolNameController.text = '';
              _toolTypeController.text = '';
              _toolActivityAreaController.text = '';
              _toolFunctionController.text = '';
              _toolCommentController.text = '';
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
                backgroundColor: Colors.lightBlue[200], //elevated button background color
            ),
            onPressed: () async {
                  // Save new tool
                  if (id == null) {
                    await _addItem();
                  }

                  if (id != null) {
                    await _updateItem(id);
                  }

                  // Clear the text fields
                  _toolNameController.text = '';
                  _toolTypeController.text = '';
                  _toolActivityAreaController.text = '';
                  _toolFunctionController.text = '';
                  _toolCommentController.text = '';
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

// Insert a new tool to the database
  Future<void> _addItem() async {
    await SQLHelperTools.createItem(
        _toolNameController.text,
        _toolTypeController.text,
        _toolActivityAreaController.text,
        _toolFunctionController.text,
        _toolCommentController.text);
    _refreshTools();
  }

  // Update an existing tool
  Future<void> _updateItem(int id) async {
    await SQLHelperTools.updateItem(
        id, _toolNameController.text,
        _toolTypeController.text,
        _toolActivityAreaController.text,
        _toolFunctionController.text,
        _toolCommentController.text);
    _refreshTools();
  }

  // Delete an item
  void _deleteItem(int id) async {
    await SQLHelperTools.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Tool deleted!'),
    ));
    _refreshTools();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('N4O Workflow Tool: Tools'),
        leading: const Icon(Icons.build_outlined),
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
                MaterialPageRoute(builder: (context) => const HelpTools()),
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
                MaterialPageRoute(builder: (context) => const HelpTools()),
              );

            },
          ),

          IconButton(
            icon: const Icon(Icons.help),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpTools()),
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
        itemCount: _tools.length,
        itemBuilder: (context, index) => Card(
          color: Colors.lightBlue[200],
          margin: const EdgeInsets.all(15),
          child: ListTile(
              title: Text(_tools[index]['toolName']),
              subtitle: Text(_tools[index]['toolType']),
              trailing: SizedBox(
                width: 100,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showForm(_tools[index]['id']),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () =>
                          _deleteItem(_tools[index]['id']),
                    ),
                  ],
                ),
              )),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlueAccent,
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

        backgroundColor: Colors.lightBlueAccent,
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