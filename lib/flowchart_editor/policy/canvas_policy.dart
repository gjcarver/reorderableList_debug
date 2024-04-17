import 'package:diagram_editor/diagram_editor.dart';
import 'custom_policy.dart';

mixin MyCanvasPolicy implements CanvasPolicy, CustomStatePolicy {
  @override
  onCanvasTap() {
    multipleSelected = [];

    if (isReadyToConnect) {
      isReadyToConnect = false;
      if (selectedComponentId != null) {
        canvasWriter.model.updateComponent(selectedComponentId!);
      }
    } else {
      selectedComponentId = null;
      hideAllHighlights();
    }
  }
}
