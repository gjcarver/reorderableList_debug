import 'package:flutter/material.dart';
import 'package:diagram_editor/diagram_editor.dart';
//import '/flowchart_editor/policy/custom_policy.dart';
import '/flowchart_editor/rw/model_reader.dart';

class MyComponentData {
  Color color;
  Color borderColor;
  double borderWidth;

  String text;
  Alignment textAlignment;
  double textSize;

  bool isHighlightVisible = false;

  MyComponentData({
    this.color = Colors.white,
    this.borderColor = Colors.black,
    this.borderWidth = 0.0,
    this.text = '',
    this.textAlignment = Alignment.center,
    this.textSize = 20,
  });

  MyComponentData.copy(MyComponentData customData)
      : this(
          color: customData.color,
          borderColor: customData.borderColor,
          borderWidth: customData.borderWidth,
          text: customData.text,
          textAlignment: customData.textAlignment,
          textSize: customData.textSize,
        );

  switchHighlight() {
    isHighlightVisible = !isHighlightVisible;
  }

  showHighlight() {
    isHighlightVisible = true;
  }

  hideHighlight() {
    isHighlightVisible = false;
  }

  // Function used to serialization of the diagram. E.g. to save to a file.
  Map<String, dynamic> toJson() => {
    'highlight': isHighlightVisible,
    'color': color.toString().split('(0x')[1].split(')')[0],
  };

  // Function used to deserialize the diagram. Must be passed to `canvasWriter.model.deserializeDiagram` for proper deserialization.
  MyComponentData.fromJson(Map<String, dynamic> json)
      : isHighlightVisible = json['highlight'],
        color = Color(int.parse(json['color'], radix: 16));

  // Function used to serialization of the diagram. E.g. to save to a file.
  Map<String, dynamic> toJson() => {
    'highlight': isHighlightVisible,
    'color': color.toString().split('(0x')[1].split(')')[0],
  };
}

// A place where you can init the canvas or your diagram (eg. load an existing diagram).
mixin MyInitPolicy implements InitPolicy {
  @override
  initializeDiagramEditor() {
    canvasWriter.state.setCanvasColor(Colors.grey[300]!);
  }
}


//mixin MyCanvasPolicy implements CanvasPolicy, CustomPolicy {
//  @override
//  onCanvasTapUp(TapUpDetails details) {
//    canvasWriter.model.hideAllLinkJoints();
//    if (selectedComponentId != null) {
//      hideComponentHighlight(selectedComponentId);
//    } else {
//      canvasWriter.model.addComponent(
//        ComponentData(
//          size: const Size(96, 72),
//          position:
//          canvasReader.state.fromCanvasCoordinates(details.localPosition),
//          data: MyComponentData(),
//        ),
//      );
//    }
//  }
//}

// Save the diagram to String in json format.
serialize() {
  serializedDiagram = canvasReader.model.serializeDiagram();
}

// Load the diagram from json format. Do it cautiously, to prevent unstable state remove the previous diagram (id collision can happen).
deserialize() {
  canvasWriter.model.removeAllComponents();
  canvasWriter.model.deserializeDiagram(
    serializedDiagram,
    decodeCustomComponentData: (json) => MyComponentData.fromJson(json),
    decodeCustomLinkData: null,
  );
}
}
