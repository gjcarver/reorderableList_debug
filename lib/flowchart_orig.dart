import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_flow_chart/flutter_flow_chart.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:star_menu/star_menu.dart';

import 'flowchart_element_settings_menu.dart';
import 'flowchart_text_menu.dart';
import 'main.dart';
import 'help_flowchart.dart';
import 'package:flag/flag.dart';
import 'resources.dart';

void main() {
  runApp(const WorkFlow());
}

class WorkFlow extends StatelessWidget {
  const WorkFlow({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Flow Chart Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FlowChartPage(title: 'N4O Workflow Tool Home Page'),
    );
  }
}

class FlowChartPage extends StatefulWidget {
  const FlowChartPage({super.key, required this.title});

  final String title;

  @override
  State<FlowChartPage> createState() => _FlowChartPageState();
}

class _FlowChartPageState extends State<FlowChartPage> {
  Dashboard dashboard = Dashboard();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text('N4O Workflow Tool: Process Builder'),
        leading: const Icon(Icons.schema_outlined),

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
                MaterialPageRoute(builder: (context) => const FlowChartHelp()),
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
                MaterialPageRoute(builder: (context) => const FlowChartHelp()),
              );

            },
          ),

          IconButton(
            icon: const Icon(Icons.help),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FlowChartHelp()),
              );
            },
          ),
        ],
      ),

      backgroundColor: Colors.black12,
      body: Padding(
        padding: const EdgeInsets.all(1.0),

        // child: Container(color: Colors.amber),

        child: Container(
          constraints: const BoxConstraints.expand(),
          child: FlowChart(
            dashboard: dashboard,
            onDashboardTapped: ((context, position) {
              debugPrint('Dashboard tapped $position');
              _displayDashboardMenu(context, position);
            }),
            onDashboardLongtTapped: ((context, position) {
              debugPrint('Dashboard long tapped $position');
            }),
            onElementLongPressed: (context, position, element) {
              debugPrint('Element with "${element.text}" text '
                  'long pressed');
            },
            onElementPressed: (context, position, element) {
              debugPrint('Element with "${element.text}" text pressed');
              _displayElementMenu(context, position, element);
            },
            onHandlerPressed: (context, position, handler, element) {
              debugPrint('handler pressed: position $position '
                  'handler $handler" of element $element');
              _displayHandlerMenu(position, handler, element);
            },
            onHandlerLongPressed: (context, position, handler, element) {
              debugPrint('handler long pressed: position $position '
                  'handler $handler" of element $element');
            },
          ),
        ),
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

        backgroundColor: Colors.blueAccent,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_back),
            label: 'Back',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
//          BottomNavigationBarItem(
//            icon: Icon(Icons.camera_alt),
//            label: 'Photo',
//          ),
        ],
      ),

    );
  }

  //*********************
  //* POPUP MENUS
  //*********************

  /// Display a drop down menu when tapping on a handler
  _displayHandlerMenu(
      Offset position,
      Handler handler,
      FlowElement element,
      ) {
    StarMenuOverlay.displayStarMenu(
      context,
      StarMenu(
        params: StarMenuParameters(
          shape: MenuShape.linear,
          openDurationMs: 60,
          linearShapeParams: const LinearShapeParams(
            angle: 270,
            space: 10,
          ),
          onHoverScale: 1.1,
          useTouchAsCenter: true,
          centerOffset: position -
              Offset(
                dashboard.dashboardSize.width / 2,
                dashboard.dashboardSize.height / 2,
              ),
        ),
        onItemTapped: (index, controller) => controller.closeMenu!(),
        items: [
          FloatingActionButton(
            child: const Icon(Icons.delete),
            onPressed: () =>
                dashboard.removeElementConnection(element, handler),
          )
        ],
        parentContext: context,
      ),
    );
  }

  /// Display a drop down menu when tapping on an element
  _displayElementMenu(
      BuildContext context,
      Offset position,
      FlowElement element,
      ) {
    StarMenuOverlay.displayStarMenu(
      context,
      StarMenu(
        params: StarMenuParameters(
          shape: MenuShape.linear,
          openDurationMs: 60,
          linearShapeParams: const LinearShapeParams(
            angle: 270,
            alignment: LinearAlignment.left,
            space: 10,
          ),
          onHoverScale: 1.1,
          centerOffset: position - const Offset(50, 0),
          backgroundParams: const BackgroundParams(
            backgroundColor: Colors.transparent,
          ),
          boundaryBackground: BoundaryBackground(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).cardColor,
              boxShadow: kElevationToShadow[6],
            ),
          ),
        ),
        onItemTapped: (index, controller) {
          if (!(index == 5 || index == 2)) {
            controller.closeMenu!();
          }
        },
        items: [
          Text(
            element.text,
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
          InkWell(
            onTap: () => dashboard.removeElement(element),
            child: const Text('Delete'),
          ),
          TextMenu(element: element),
          InkWell(
            onTap: () {
              dashboard.removeElementConnections(element);
            },
            child: const Text('Remove all connections'),
          ),
          InkWell(
            onTap: () {
              dashboard.setElementResizable(element, true);
            },
            child: const Text('Resize'),
          ),
          ElementSettingsMenu(
            element: element,
          ),
        ],
        parentContext: context,
      ),
    );
  }

  /// Display a linear menu for the dashboard
  /// with menu entries built with [menuEntries]
  _displayDashboardMenu(BuildContext context, Offset position) {
    StarMenuOverlay.displayStarMenu(
      context,
      StarMenu(
        params: StarMenuParameters(
          shape: MenuShape.linear,
          openDurationMs: 60,
          linearShapeParams: const LinearShapeParams(
            angle: 270,
            alignment: LinearAlignment.left,
            space: 10,
          ),
          // calculate the offset from the dashboard center
          centerOffset: position -
              Offset(
                dashboard.dashboardSize.width / 2,
                dashboard.dashboardSize.height / 2,
              ),
        ),
        onItemTapped: (index, controller) => controller.closeMenu!(),
        parentContext: context,
        items: [
          ActionChip(
              label: const Text('Add diamond'),
              onPressed: () {
                dashboard.addElement(FlowElement(
                    position: position - const Offset(40, 40),
                    size: const Size(80, 80),
                    text: '${dashboard.elements.length}',
                    kind: ElementKind.diamond,
                    handlers: [
                      Handler.bottomCenter,
                      Handler.topCenter,
                      Handler.leftCenter,
                      Handler.rightCenter,
                    ]));
              }),
          ActionChip(
              label: const Text('Add rect'),
              onPressed: () {
                dashboard.addElement(FlowElement(
                    position: position - const Offset(50, 25),
                    size: const Size(100, 50),
                    text: '${dashboard.elements.length}',
                    kind: ElementKind.rectangle,
                    handlers: [
                      Handler.bottomCenter,
                      Handler.topCenter,
                      Handler.leftCenter,
                      Handler.rightCenter,
                    ]));
              }),
          ActionChip(
              label: const Text('Add oval'),
              onPressed: () {
                dashboard.addElement(FlowElement(
                    position: position - const Offset(50, 25),
                    size: const Size(100, 50),
                    text: '${dashboard.elements.length}',
                    kind: ElementKind.oval,
                    handlers: [
                      Handler.bottomCenter,
                      Handler.topCenter,
                      Handler.leftCenter,
                      Handler.rightCenter,
                    ]));
              }),
          ActionChip(
              label: const Text('Add parallelogram'),
              onPressed: () {
                dashboard.addElement(FlowElement(
                    position: position - const Offset(50, 25),
                    size: const Size(100, 50),
                    text: '${dashboard.elements.length}',
                    kind: ElementKind.parallelogram,
                    handlers: [
                      Handler.bottomCenter,
                      Handler.topCenter,
                    ]));
              }),
          ActionChip(
              label: const Text('Add storage'),
              onPressed: () {
                dashboard.addElement(FlowElement(
                    position: position - const Offset(50, 25),
                    size: const Size(100, 150),
                    text: '${dashboard.elements.length}',
                    kind: ElementKind.storage,
                    handlers: [
                      Handler.bottomCenter,
                      Handler.leftCenter,
                      Handler.rightCenter,
                    ]));
              }),
          ActionChip(
              label: const Text('Remove all'),
              onPressed: () {
                dashboard.removeAllElements();
              }),
          ActionChip(
              label: const Text('SAVE dashboard'),
              onPressed: () async {
                Directory appDocDir =
                await path.getApplicationDocumentsDirectory();
                dashboard.saveDashboard('${appDocDir.path}/FLOWCHART.json');
              }),
          ActionChip(
              label: const Text('LOAD dashboard'),
              onPressed: () async {
                Directory appDocDir =
                await path.getApplicationDocumentsDirectory();
                dashboard.loadDashboard('${appDocDir.path}/FLOWCHART.json');
              }),
        ],
      ),
    );
  }
}
