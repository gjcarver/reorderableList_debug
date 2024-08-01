import 'package:flutter/material.dart';
//import 'main.dart';
import 'sql_recipe.dart';
import 'help_recipe.dart';
//import 'resources.dart';
import 'package:flag/flag.dart';
//import 'camera.dart';
import 'tasks_reorder.dart';
//import 'interact2.dart';

void main() {
  runApp(const RecipeForm());
}

class RecipeForm extends StatelessWidget {
  const RecipeForm({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Remove the debug banner
        debugShowCheckedModeBanner: false,
        title: 'Recipe',
        theme: ThemeData(
          primarySwatch: Colors.lightGreen,
        ),
        home: const RecipePage());
  }
}

class RecipePage extends StatefulWidget {
  const RecipePage({super.key});

  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  // All recipes
  List<Map<String, dynamic>> _recipe = [];

  bool _isLoading = true;
  // This function is used to fetch all data from the database
  void _refreshRecipe() async {
    final data = await SQLHelperRecipe.getItems();
    setState(() {
      _recipe = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshRecipe(); // Loading the diary when the app starts
  }

  final TextEditingController _recipeNameController = TextEditingController();
  final TextEditingController _recipeTypeController = TextEditingController();
  final TextEditingController _recipeReferenceController = TextEditingController();
  final TextEditingController _recipeAimController = TextEditingController();
  final TextEditingController _recipeSerialNumberController = TextEditingController();
  final TextEditingController _recipeActivityAreaController = TextEditingController();
  final TextEditingController _recipePurposeController = TextEditingController();
  final TextEditingController _recipeWebPageController = TextEditingController();
  final TextEditingController _recipeCommentController = TextEditingController();

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void _showForm(int? id) async {
    if (id != null) {
      // id == null -> create new item
      // id != null -> update an existing item
      final existingRecipe =
      _recipe.firstWhere((element) => element['id'] == id);
      _recipeNameController.text = existingRecipe['recipeName'];
      _recipeTypeController.text = existingRecipe['recipeType'];
      _recipeReferenceController.text = existingRecipe['recipeReference'];
      _recipeAimController.text = existingRecipe['recipeAim'];
      _recipeSerialNumberController.text = existingRecipe['recipeSerialNumber'];
      _recipeActivityAreaController.text = existingRecipe['recipeActivityArea'];
      _recipePurposeController.text = existingRecipe['recipePurpose'];
      _recipeWebPageController.text = existingRecipe['recipeWebPage'];
      _recipeCommentController.text = existingRecipe['recipeComment'];
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
                'Plan a RECIPE:',
                style: TextStyle(
                    fontSize: 24),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _recipeNameController,
                  decoration: const InputDecoration(hintText: 'Recipe NAME'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _recipeTypeController,
                  decoration: const InputDecoration(hintText: 'Recipe TYPE'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _recipeReferenceController,
                  decoration: const InputDecoration(hintText: 'WHAT do you want to cook?'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _recipeAimController,
                  decoration: const InputDecoration(hintText: 'WHY do you want to cook this?'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _recipeSerialNumberController,
                  decoration: const InputDecoration(hintText: 'Recipe SERIAL NUMBER (other identifier)'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _recipeActivityAreaController,
                  decoration: const InputDecoration(hintText: 'Recipe ACTIVITY Area'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _recipePurposeController,
                  decoration: const InputDecoration(hintText: 'Recipe PURPOSE'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _recipeWebPageController,
                  decoration: const InputDecoration(hintText: 'Experiment WEB PAGE'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _recipeCommentController,
                  decoration: const InputDecoration(hintText: 'Recipe COMMENT'),
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

                    onPressed: () async {
                      // Save new recipe
                      if (id == null) {
                        await _addItem();
                      }

                      if (id != null) {
                        await _updateItem(id);
                      }

                      String designName = _recipeNameController.text.isNotEmpty
                          ? _recipeNameController.text
                          : 'RECIPE';

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TasksForm(designName: designName, tasks: const [],)),
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
                      // Save new recipe
                      if (id == null) {
                        await _addItem();
                      }

                      if (id != null) {
                        await _updateItem(id);
                      }

                      // Clear the text fields
                      _recipeNameController.text = '';
                      _recipeTypeController.text = '';
                      _recipeReferenceController.text = '';
                      _recipeAimController.text = '';
                      _recipeSerialNumberController.text = '';
                      _recipeActivityAreaController.text = '';
                      _recipePurposeController.text = '';
                      _recipeWebPageController.text = '';
                      _recipeCommentController.text = '';

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

// Insert a new recipe to the database
  Future<void> _addItem() async {
    await SQLHelperRecipe.createItem(
        _recipeNameController.text, _recipeTypeController.text, _recipeReferenceController.text,  _recipeAimController.text, _recipeSerialNumberController.text, _recipeActivityAreaController.text, _recipePurposeController.text,  _recipeWebPageController.text, _recipeCommentController.text);
    _refreshRecipe();
  }

  // Update an existing recipe
  Future<void> _updateItem(id) async {
    await SQLHelperRecipe.updateItem(
        id, _recipeNameController.text, _recipeTypeController.text, _recipeReferenceController.text,  _recipeAimController.text, _recipeSerialNumberController.text, _recipeActivityAreaController.text, _recipePurposeController.text, _recipeWebPageController.text, _recipeCommentController.text);
    _refreshRecipe();
  }

  // Delete an item
  void _deleteItem(id) async {
    await SQLHelperRecipe.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Recipe deleted!'),
    ));
    _refreshRecipe();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('N4O Workflow Tool: Recipe Design'),
        leading: const Icon(Icons.restaurant_menu_outlined),
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
                MaterialPageRoute(builder: (context) => const HelpRecipe()),
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
                MaterialPageRoute(builder: (context) => const HelpRecipe()),
              );

            },
          ),

          IconButton(
            icon: const Icon(Icons.help),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpRecipe()),
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
        itemCount: _recipe.length,
        itemBuilder: (context, index) => Card(
          color: Colors.lightGreen[200],
          margin: const EdgeInsets.all(15),
          child: ListTile(
              title: Text(_recipe[index]['recipeName']),
              subtitle: Text(_recipe[index]['recipeType']),
              trailing: SizedBox(
                width: 120,
                child: Row(
                  children: [
                    Expanded(
                      child: IconButton(
//                        iconSize: 40,
                        icon: const Icon(Icons.check_box_outlined),
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>
                                TasksForm(designName: _recipe[index]['recipeName'], tasks: const [],)),
                          );
                          },
                      ),
                    ),
         //           const SizedBox(
         //             width: 30.0,
         //           ),
                    Expanded(
                      child: IconButton(
//                        iconSize: 40,
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showForm(_recipe[index]['id']),
                      ),
                    ),
             //      const SizedBox(
             //        width: 30.0,
             //      ),
                    Expanded(
                      child: IconButton(
//                        iconSize: 40,
                        icon: const Icon(Icons.delete),
                        onPressed: () =>
                            _deleteItem(_recipe[index]['id']),
                      ),
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

//      bottomNavigationBar: BottomNavigationBar(
//
//        onTap: (compoundIndex) {
//          StepState.disabled.index;
//          switch (compoundIndex) {
//            case 0:
//              {
//                Navigator.push(
//                  context,
//                  MaterialPageRoute(
//                      builder: (context) => const AvailableResources()),
//                );
//                setState(() {
//                  compoundIndex = 0;
//                });
//              }
//
//              break;
//
//            case 1:
//              {
//                setState(() {
//                  compoundIndex = 1;
//                });
//                Navigator.push(
//                  context,
//                  MaterialPageRoute(
//                      builder: (context) => const NFDIexperimentApp()),
//                );
//              }
//
//              break;
//
////            case 2:
////              {
////                setState(() {
////                  compoundIndex = 2;
////                });
////                Navigator.push(
////                  context,
////                  MaterialPageRoute(
////                      builder: (_) => const FlowChart()),
////                );
////              }
////
////              break;
//
//          }
//        },
//
//        backgroundColor: Colors.lightGreen,
//        items: const <BottomNavigationBarItem>[
//          BottomNavigationBarItem(
//            icon: Icon(Icons.arrow_back),
//            label: 'Resources',
//          ),
//          BottomNavigationBarItem(
//            icon: Icon(Icons.home),
//            label: 'Home',
//          ),
////          BottomNavigationBarItem(
////            icon: Icon(Icons.schema_outlined,
////                color: Colors.white),
////            label: 'FLOW CHART',
////          ),
//        ],
//      ),

    );
  }
}