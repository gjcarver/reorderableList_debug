import 'package:diagram_editor/diagram_editor.dart';
import 'canvas_policy.dart';
import 'canvas_widgets_policy.dart';
import 'component_design_policy.dart';
import 'component_policy.dart';
import 'component_widgets_policy.dart';
import 'custom_policy.dart';
import 'init_policy.dart';
import 'link_attachment_policy.dart';
import 'link_widgets_policy.dart';
import 'my_link_control_policy.dart';
import 'my_link_joint_control_policy.dart';

class MyPolicySet extends PolicySet
    with
        MyInitPolicy,
        MyCanvasPolicy,
        MyComponentPolicy,
        MyComponentDesignPolicy,
        MyLinkControlPolicy,
        MyLinkJointControlPolicy,
        MyLinkWidgetsPolicy,
        MyLinkAttachmentPolicy,
        MyCanvasWidgetsPolicy,
        MyComponentWidgetsPolicy,
        //
        CanvasControlPolicy,
        //
        CustomStatePolicy,
        CustomBehaviourPolicy {}
