import 'package:diagram_editor/diagram_editor.dart';
import '/flowchart_editor/policy/minimap_policy.dart';
import '/flowchart_editor/policy/my_policy_set.dart';
import '/flowchart_editor/widget/menusubstances.dart';
import '/flowchart_editor/widget/menutools.dart';
import '/flowchart_editor/widget/option_icon.dart';
import 'package:flutter/material.dart';
//import 'package:path_provider/path_provider.dart' as path;

class FlowchartEditor extends StatefulWidget {
  const FlowchartEditor({super.key});

  @override
  _FlowchartEditorState createState() => _FlowchartEditorState();
}

class _FlowchartEditorState extends State<FlowchartEditor> {
  late DiagramEditorContext diagramEditorContext;
  late DiagramEditorContext diagramEditorContextMiniMap;

  MyPolicySet myPolicySet = MyPolicySet();
  MiniMapPolicySet miniMapPolicySet = MiniMapPolicySet();

  bool isMiniMapVisible = true;
  bool isSMenuVisible = false;
  bool isTMenuVisible = false;
  bool isOptionsVisible = true;

  @override
  void initState() {
    diagramEditorContext = DiagramEditorContext(
      policySet: myPolicySet,
    );
    diagramEditorContextMiniMap = DiagramEditorContext.withSharedModel(
        diagramEditorContext,
        policySet: miniMapPolicySet);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // showPerformanceOverlay: !kIsWeb,
      showPerformanceOverlay: false,
      home: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Container(color: Colors.grey),
              Positioned(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: DiagramEditor(
                    diagramEditorContext: diagramEditorContext,
                  ),
                ),
              ),

              Positioned(
                right: 16,
                top: 16,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    RotatedBox(
                      quarterTurns: 3,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isMiniMapVisible = !isMiniMapVisible;
                          });
                        },
                        child: Container(
                          color: Colors.yellow[300],
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Text(isMiniMapVisible
                                ? 'hide minimap'
                                : 'show minimap'),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: isMiniMapVisible,
                      child: SizedBox(
                        width: 320,
                        height: 240,
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                            color: Colors.black,
                            width: 2,
                          )),
                          child: DiagramEditor(
                            diagramEditorContext: diagramEditorContextMiniMap,
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),

              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      OptionIcon(
                        color: Colors.deepOrange.withOpacity(0.5),
                        iconData:
                            isOptionsVisible ? Icons.menu_open : Icons.menu,
                        shape: BoxShape.rectangle,
                        onPressed: () {
                          setState(() {
                            isOptionsVisible = !isOptionsVisible;
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      Visibility(
                        visible: isOptionsVisible,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            OptionIcon(
                              tooltip: 'reset view',
                              color: Colors.orange.withOpacity(0.7),
                              iconData: Icons.replay,
                              onPressed: () => myPolicySet.resetView(),
                            ),
                            const SizedBox(width: 8),
                            OptionIcon(
                              tooltip: 'delete all',
                              color: Colors.orangeAccent.withOpacity(0.7),
                              iconData: Icons.delete_forever,
                              onPressed: () => myPolicySet.removeAll(),
                            ),
                            const SizedBox(width: 8),
                            OptionIcon(
                              tooltip: 'save flowchart',
                              color: Colors.orangeAccent.withOpacity(0.7),
                              iconData: Icons.save,
                              onPressed: () => myPolicySet.saveChart(),
                            ),
                            const SizedBox(width: 8),
                            OptionIcon(
                              tooltip: myPolicySet.isGridVisible
                                  ? 'hide grid'
                                  : 'show grid',
                              color: Colors.yellow.withOpacity(0.7),
                              iconData: myPolicySet.isGridVisible
                                  ? Icons.grid_off
                                  : Icons.grid_on,
                              onPressed: () {
                                setState(() {
                                  myPolicySet.isGridVisible =
                                      !myPolicySet.isGridVisible;
                                });
                              },
                            ),
                            const SizedBox(width: 8),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Visibility(
                                  visible: myPolicySet.isMultipleSelectionOn,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      OptionIcon(
                                        tooltip: 'select all',
                                        color: Colors.yellowAccent.withOpacity(0.7),
                                        iconData: Icons.all_inclusive,
                                        onPressed: () =>
                                            myPolicySet.selectAll(),
                                      ),
                                      const SizedBox(height: 8),
                                      OptionIcon(
                                        tooltip: 'duplicate selected',
                                        color: Colors.grey.withOpacity(0.7),
                                        iconData: Icons.copy,
                                        onPressed: () =>
                                            myPolicySet.duplicateSelected(),
                                      ),
                                      const SizedBox(height: 8),
                                      OptionIcon(
                                        tooltip: 'remove selected',
                                        color: Colors.grey.withOpacity(0.7),
                                        iconData: Icons.delete,
                                        onPressed: () =>
                                            myPolicySet.removeSelected(),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                OptionIcon(
                                  tooltip: myPolicySet.isMultipleSelectionOn
                                      ? 'cancel multiselection'
                                      : 'enable multiselection',
                                  color: Colors.red.withOpacity(0.7),
                                  iconData: myPolicySet.isMultipleSelectionOn
                                      ? Icons.group_work
                                      : Icons.group_work_outlined,
                                  onPressed: () {
                                    setState(() {
                                      if (myPolicySet.isMultipleSelectionOn) {
                                        myPolicySet.turnOffMultipleSelection();
                                      } else {
                                        myPolicySet.turnOnMultipleSelection();
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Positioned(
                top: 0,
                left: 0,
                bottom: 0,
                child: Row(
                  children: [
                    Visibility(
                      visible: isSMenuVisible,
                      child: Container(
                        color: Colors.purpleAccent.withOpacity(0.4),
                        width: 120,
                        height: 320,
                        child: SubstancesMenu(myPolicySet: myPolicySet),
                      ),
                    ),
                    RotatedBox(
                      quarterTurns: 1,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isSMenuVisible = !isSMenuVisible;
                          });
                        },
                        child: Container(
                          color: Colors.purple[200],
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child:
                                Text(isSMenuVisible ? 'hide menu' : 'substances menu'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Positioned(
                top: 0,
                right: 0,
                bottom: 0,
                child: Row(
                  children: <Widget>[
                    RotatedBox(
                      quarterTurns: 3,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isTMenuVisible = !isTMenuVisible;
                          });
                        },
                        child: Container(
                          color: Colors.blueAccent[200],
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child:
                            Text(isTMenuVisible ? 'hide menu' : 'tools menu'),
                          ),
                        ),
                      ),
                    ),

                    Visibility(
                      visible: isTMenuVisible,
                      child: Container(
                        color: Colors.lightBlueAccent.withOpacity(0.4),
                        width: 120,
                        height: 300,
                        child: ToolsMenu(myPolicySet: myPolicySet),
                      ),
                    ),

                  ],
                ),
              ),



//              Positioned(
//                bottom: 0,
//                right: 0,
//                left: 0,
//                child: Row(
//                  children: <Widget>[
//                    RotatedBox(
//                      quarterTurns: 3,
//                      child: GestureDetector(
//                        onTap: () {
//                          setState(() {
//                            isTMenuVisible = !isTMenuVisible;
//                          });
//                        },
//                        child: Container(
//                          color: Colors.lightBlueAccent[200],
//                          child: Padding(
//                            padding: const EdgeInsets.all(4),
//                            child:
//                            Text(isTMenuVisible ? 'hide menu' : 'tools menu'),
//                          ),
//                        ),
//                      ),
//                    ),
//
//                    Visibility(
//                      visible: isTMenuVisible,
//                      child: Container(
//                        color: Colors.lightBlueAccent.withOpacity(0.4),
//                        width: 120,
//                        height: 300,
//                        child: ToolsMenu(myPolicySet: myPolicySet),
//                      ),
//                    ),
//
//                  ],
//                ),
//              ),


//              Positioned(
//                top: 8,
//                left: 8,
//                child: ElevatedButton(
//                  style: ButtonStyle(
//                    backgroundColor: MaterialStateProperty.all(Colors.blue),
//                  ),
//                  child: const Row(
//                    children: [
//                      Icon(Icons.arrow_back),
//                      SizedBox(width: 8),
//                      Text('BACK'),
//                    ],
//                  ),
//                  onPressed: () => Navigator.pop(context),
//                ),
//              ),
            ],
            
          ),
        ),

        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.blue,
          onPressed: () {
            // Add your onPressed code here!
          },
          label: const Text('BACK'),
          icon: const Icon(Icons.arrow_back),
        ),


//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.deepPurpleAccent,
//         child: const Row(
//           children: [
//             Icon(Icons.arrow_back),
///              SizedBox(width: 8),
//             Text('BACK'),
//           ],
//         ),
//         onPressed: () => Navigator.pop(context),
//       ),

      ),
    );
  }
}
