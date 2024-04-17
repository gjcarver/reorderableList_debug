import 'package:flutter/material.dart';
import 'help_temp.dart';
import 'resources.dart';
import 'resources_institution.dart';
import 'design_experiment.dart';
import 'design_observation.dart';
import 'design_measurement.dart';
import 'design_reconstruction.dart';
import 'design_reenactment.dart';
import 'design_replication.dart';
////import \'flowchart\.dart\'\;
import 'package:flag/flag.dart';
//import 'camera.dart';

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

      home: MyHomePage(title: 'N4O Workflow Tool Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

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

      body: const SingleChildScrollView(

        child: Column(

          children: <Widget>[





//       padding: const EdgeInsets.only(top:10, left:10, right:10),

              //         Expanded(


              SizedBox(height: 10),

              Column(
                children: <Widget>[
                  RowInstitution(),
                  RowResources(),
                  Row1(),
                  Row2(),
                ],


                  ),
                ],
              ),

              //               ],
              //             ),
            ),


//    ),
//          ],
//        ),
//
//
//      ),


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

class RowInstitution extends StatelessWidget {
  const RowInstitution({super.key});

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Column(
        children: [

        const Text(
        'Enter or edit information about your Institution:',
        style: TextStyle(
            fontSize: 20),
      ),

      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          //               const SizedBox(width: 16),

          FloatingActionButton.extended(
            heroTag: "btnMi",
            backgroundColor: Colors.red,
            onPressed: () {

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const InstitutionForm()),
              );

            },
            label: const Text('Institution'),
            icon: const Icon(Icons.account_balance),
          ),
        ],
      ),
        ],
      ),//

    );

  }
}

class RowResources extends StatelessWidget {
  const RowResources({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [

          const Text(
            'Input or edit Resources:',
            style: TextStyle(
                fontSize: 20),
          ),

          Row(
        mainAxisAlignment: MainAxisAlignment.center,
        //             crossAxisAlignment: CrossAxisAlignment.space,
        children: <Widget>[
//                const SizedBox(width: 16),

          FloatingActionButton.extended(
            heroTag: "btnMResources",
            backgroundColor: Colors.cyan,
            onPressed: () {

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AvailableResources()),
              );

            },
            label: const Text('Resources'),
            icon: const Icon(Icons.shopping_cart),
          ),
        ],
      ),
      ],
    ),//

    );

  }
}

class Row1 extends StatelessWidget {
  const Row1({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [

          const Text(
        "WHAT do you want to do?", style: TextStyle(
          fontSize: 20
      ),),


      Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

      const SizedBox(height: 16),

      FloatingActionButton.extended(
        heroTag: "btnMEDesign",
        backgroundColor: Colors.deepOrange,
        onPressed: () {

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ExperimentForm()),
          );

        },
        label: const Text('EXPERIMENT'),
        icon: const Icon(Icons.science),
      ),

      FloatingActionButton.extended(
        heroTag: "btnMObservation",
        backgroundColor: Colors.orange,
        onPressed: () {

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ObservationForm()),
          );

        },
        label: const Text('OBSERVATION'),
        icon: const Icon(Icons.biotech),
      ),

      FloatingActionButton.extended(
        heroTag: "btnMMeasurement",
        backgroundColor: Colors.amber,
        onPressed: () {

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MeasurementForm()),
          );

        },
        label: const Text('MEASUREMENT'),
        icon: const Icon(Icons.bar_chart),
      ),
        ],
      ),
        ],
      ),//

    );

  }
}


class Row2 extends StatelessWidget {
  const Row2({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(width: 16),
          FloatingActionButton.extended(
            heroTag: "btnMReconstruction",
            backgroundColor: Colors.green,
            onPressed: () {

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ReconstructionForm()),
              );

            },
            label: const Text('RECONSTRUCTION'),
            icon: const Icon(Icons.foundation),
          ),

          FloatingActionButton.extended(
            heroTag: "btnMReplication",
            backgroundColor: Colors.lightGreen,
            onPressed: () {

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ReplicationForm()),
              );

            },
            label: const Text('REPLICATION'),
            icon: const Icon(Icons.copy),
          ),

          FloatingActionButton.extended(
            heroTag: "btnMReenactment",
            backgroundColor: Colors.lime,
            onPressed: () {

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ReenactmentForm()),
              );

            },
            label: const Text('RE-ENACTMENT'),
            icon: const Icon(Icons.theater_comedy_outlined),
          ),
        ],
      ),
//
//      Image.asset('images/2wunderkindera.png',
//          fit: BoxFit.fitWidth),
    );

  }
}