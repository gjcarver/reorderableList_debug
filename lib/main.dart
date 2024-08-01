import 'package:flutter/material.dart';
import 'help_temp.dart';

import 'design_recipe.dart';

import 'package:flag/flag.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
//import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(const NFDIexperimentApp());
}

//Future<void> main() async {
//  WidgetsFlutterBinding.ensureInitialized();
//  await PhotosVideo.init();
//  runApp(const NFDIexperimentApp());
//}

class NFDIexperimentApp extends StatelessWidget {
  const NFDIexperimentApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'N4O Workflow Tool',

      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en'), // English
        Locale('de'), // German
      ],

      home: MyHomePage(title: 'N4O Workflow Tool Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
//  int _counter = 0;
//
//  void _incrementCounter() {
//    setState(() {
//      // This call to setState tells the Flutter framework that something has
//      // changed in this State, which causes it to rerun the build method below
//      // so that the display can reflect the updated values. If we changed
//      // _counter without calling setState(), then the build method would not be
//      // called again, and so nothing would appear to happen.
//      _counter++;
//    });
//  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        title: const Text('N4O Workflow Tool'),
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
                MaterialPageRoute(builder: (context) => const HelpTemp()),
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
                MaterialPageRoute(builder: (context) => const HelpTemp()),
              );

            },
          ),

          IconButton(
            icon: const Icon(Icons.help),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpTemp()),
              );

            },
          ),
        ],

      ),

      body: Center(

        child: Column(

          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
//            const Text(
//              'Enter or edit information about your Institution:',
////            AppLocalizations.of(context)!.enterInstitution,
//
//              style: TextStyle(
//                  fontSize: 20),
//            ),

//            Row(
//              mainAxisAlignment: MainAxisAlignment.center,
//              children: <Widget>[
// //               const SizedBox(width: 16),
//
//                FloatingActionButton.extended(
//                  heroTag: "btnMi",
//                  backgroundColor: Colors.red,
//                  onPressed: () {
//
//                    Navigator.push(
//                      context,
//                      MaterialPageRoute(builder: (context) => const InstitutionForm()),
//                    );
//
//                  },
//                  label: const Text('Institution'),
//                  icon: const Icon(Icons.account_balance),
//                ),
//              ],
//            ),// This trailing comma makes auto-formatting nicer for build methods.

//            const Text(
//              'Enter or edit Resources:',
//              style: TextStyle(
//                  fontSize: 20),
//            ),

//            Row(
//              mainAxisAlignment: MainAxisAlignment.center,
// //             crossAxisAlignment: CrossAxisAlignment.space,
//              children: <Widget>[
////                const SizedBox(width: 16),
//
//                FloatingActionButton.extended(
//                  heroTag: "btnMResources",
//                  backgroundColor: Colors.cyan,
//                  onPressed: () {
//
//                    Navigator.push(
//                      context,
//                      MaterialPageRoute(builder: (context) => const AvailableResources()),
//                    );
//
//                  },
//                  label: const Text('Resources'),
//                  icon: const Icon(Icons.shopping_cart_outlined),
//                ),
//              ],
//            ),

//            Padding(
//              padding: const EdgeInsets.only(top:10, left:10, right:10),

            Padding(
          padding: const EdgeInsets.only(top:10, left:10, right:10),
 //         Expanded(

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [

//              Column(
// //                             mainAxisAlignment: MainAxisAlignment.center,
//                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                children: <Widget>[

                  const Text("WHAT do you want to do?", style: TextStyle(
                      fontSize: 20
                  ),),

                  const SizedBox(height: 10),

//              Row(
//                mainAxisSize: MainAxisSize.max,
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//
//                      const SizedBox(height: 16),
//
//                      FloatingActionButton.extended(
//                        heroTag: "btnMEDesign",
//                        backgroundColor: Colors.deepOrange,
//                        onPressed: () {
//
//                          Navigator.push(
//                            context,
//                            MaterialPageRoute(builder: (context) => const ExperimentForm()),
//                          );
//
//                        },
//                        label: const Text('EXPERIMENT'),
//                        icon: const Icon(Icons.science_outlined),
//                      ),
//
//                      FloatingActionButton.extended(
//                        heroTag: "btnMObservation",
//                        backgroundColor: Colors.orange,
//                        onPressed: () {
//
//                          Navigator.push(
//                            context,
//                            MaterialPageRoute(builder: (context) => const ObservationForm()),
//                          );
//
//                        },
//                        label: const Text('OBSERVATION'),
//                        icon: const Icon(Icons.biotech),
//                      ),
//
//                      FloatingActionButton.extended(
//                        heroTag: "btnMMeasurement",
//                        backgroundColor: Colors.amber,
//                        onPressed: () {
//
//                          Navigator.push(
//                            context,
//                            MaterialPageRoute(builder: (context) => const MeasurementForm()),
//                          );
//
//                        },
//                        label: const Text('MEASUREMENT'),
//                        icon: const Icon(Icons.bar_chart),
//                      ),
//                    ],
//                  ),
//
//              const SizedBox(height: 16),

// ],
//           ),
//           ),
 //                 const SizedBox(width: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(width: 16),
//                      FloatingActionButton.extended(
//                        heroTag: "btnMReconstruction",
//                        backgroundColor: Colors.green,
//                        onPressed: () {
//
//                          Navigator.push(
//                            context,
//                            MaterialPageRoute(builder: (context) => const ReconstructionForm()),
//                          );
//
//                        },
//                        label: const Text('RECONSTRUCTION'),
//                        icon: const Icon(Icons.foundation),
//                      ),

//                      FloatingActionButton.extended(
//                        heroTag: "btnMReplication",
//                        backgroundColor: Colors.lightGreen,
//                        onPressed: () {
//
//                          Navigator.push(
//                            context,
//                            MaterialPageRoute(builder: (context) => const ReplicationForm()),
//                          );
//
//                        },
//                        label: const Text('REPLICATION'),
//                        icon: const Icon(Icons.copy),
//                      ),

//                      FloatingActionButton.extended(
//                        heroTag: "btnMReenactment",
//                        backgroundColor: Colors.lime,
//                        onPressed: () {
//
//                          Navigator.push(
//                            context,
//                            MaterialPageRoute(builder: (context) => const ReenactmentForm()),
//                          );
//
//                        },
//                        label: const Text('RE-ENACTMENT'),
//                        icon: const Icon(Icons.theater_comedy_outlined),
//                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const SizedBox(width: 16),
                          FloatingActionButton.extended(
                            heroTag: "btnRecipe",
                            backgroundColor: Colors.green,
                            onPressed: () {

                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const RecipeForm()),
                              );

                            },
                            label: const Text('RECIPE'),
                            icon: const Icon(Icons.restaurant_menu_outlined),
                          ),


                        ],
                      ),

                    ],
                  ),
          ],
          ),

 //               ],
 //             ),
          ),
//            ),






//            const Text(
//              'WHAT do you want to do?',
//              style: TextStyle(
//                  fontSize: 20),
//            ),
//
//            Row(
//              mainAxisAlignment: MainAxisAlignment.center,
//              children: <Widget>[
//
//                const SizedBox(width: 16),
//
//                FloatingActionButton.extended(
//                  heroTag: "btnMEDesign",
//                  backgroundColor: Colors.deepOrange,
//                  onPressed: () {
//
//                    Navigator.push(
//                      context,
//                      MaterialPageRoute(builder: (context) => const ExperimentForm()),
//                    );
//
//                  },
//                  label: const Text('EXPERIMENT'),
//                  icon: const Icon(Icons.science),
//                ),
//
//                FloatingActionButton.extended(
//                  heroTag: "btnMObservation",
//                  backgroundColor: Colors.orange,
//                  onPressed: () {
//
//                    Navigator.push(
//                      context,
//                      MaterialPageRoute(builder: (context) => const ObservationForm()),
//                    );
//
//                  },
//                  label: const Text('OBSERVATION'),
//                  icon: const Icon(Icons.biotech),
//                ),
//
//                FloatingActionButton.extended(
//                  heroTag: "btnMMeasurement",
//                  backgroundColor: Colors.amber,
//                  onPressed: () {
//
//                    Navigator.push(
//                      context,
//                      MaterialPageRoute(builder: (context) => const MeasurementForm()),
//                    );
//
//                  },
//                  label: const Text('MEASUREMENT'),
//                  icon: const Icon(Icons.bar_chart),
//                ),
//              ],
//            ),
//
//// ],
////           ),
////           ),
//
//                Row(
//                  mainAxisAlignment: MainAxisAlignment.center,
//                  children: <Widget>[
//                    const SizedBox(width: 16),
//                FloatingActionButton.extended(
//                  heroTag: "btnMReconstruction",
//                  backgroundColor: Colors.green,
//                  onPressed: () {
//
//                    Navigator.push(
//                      context,
//                      MaterialPageRoute(builder: (context) => const ReconstructionForm()),
//                    );
//
//                  },
//                  label: const Text('RECONSTRUCTION'),
//                  icon: const Icon(Icons.foundation),
//                ),
//
//                    FloatingActionButton.extended(
//                      heroTag: "btnMReplication",
//                      backgroundColor: Colors.lightGreen,
//                      onPressed: () {
//
//                        Navigator.push(
//                          context,
//                          MaterialPageRoute(builder: (context) => const ReplicationForm()),
//                        );
//
//                      },
//                      label: const Text('REPLICATION'),
//                      icon: const Icon(Icons.copy),
//                    ),
//
//                FloatingActionButton.extended(
//                  heroTag: "btnMReenactment",
//                  backgroundColor: Colors.lime,
//                  onPressed: () {
//
//                    Navigator.push(
//                      context,
//                      MaterialPageRoute(builder: (context) => const ReenactmentForm()),
//                    );
//
//                  },
//                  label: const Text('RE-ENACTMENT'),
//                  icon: const Icon(Icons.theater_comedy_outlined),
//                ),
//                    ],
//                ),

//            Row(
//              mainAxisAlignment: MainAxisAlignment.center,
//              children: <Widget>[
//                const SizedBox(width: 16),
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
//              ],
//            ),


              ],
            ),


        ),


      bottomNavigationBar: BottomNavigationBar(

        onTap: (resourcesIndex) {
          StepState.disabled.index;
          switch (resourcesIndex) {
//            case 0:
//              {
//                Navigator.push(
//                  context,
//                  MaterialPageRoute(
//                      builder: (context) => const GeeksForGeeks()),
//                );
//                setState(() {
//                  resourcesIndex = 0;
//                });
//              }
//
//              break;

            case 1:
              {
                setState(() {
                  resourcesIndex = 1;
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
//                  resourcesIndex = 2;
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

        backgroundColor: Colors.blueAccent,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_back,
                color: Colors.white),
            label: 'Back',
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

