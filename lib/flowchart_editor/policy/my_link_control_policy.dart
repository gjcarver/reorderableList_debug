import 'package:diagram_editor/diagram_editor.dart';
import 'custom_policy.dart';
import 'package:flutter/material.dart';

mixin MyLinkControlPolicy implements LinkPolicy, CustomStatePolicy {
  @override
  onLinkTapUp(String linkId, TapUpDetails details) {
    hideLinkOption();
    canvasWriter.model.hideAllLinkJoints();
    canvasWriter.model.showLinkJoints(linkId);

    showLinkOption(linkId,
        canvasReader.state.fromCanvasCoordinates(details.localPosition));
  }

  var _segmentIndex;

  get segmentIndex => _segmentIndex;

  set segmentIndex(value) {
    _segmentIndex = value;
  }

  @override
  onLinkScaleStart(String linkId, ScaleStartDetails details) {
    hideLinkOption();
    canvasWriter.model.hideAllLinkJoints();
    canvasWriter.model.showLinkJoints(linkId);
    segmentIndex = canvasReader.model
        .determineLinkSegmentIndex(linkId, details.localFocalPoint);
    if (segmentIndex != null) {
      canvasWriter.model
          .insertLinkMiddlePoint(linkId, details.localFocalPoint, segmentIndex);
      canvasWriter.model.updateLink(linkId);
    }
  }

  @override
  onLinkScaleUpdate(String linkId, ScaleUpdateDetails details) {
    if (segmentIndex != null) {
      canvasWriter.model.setLinkMiddlePointPosition(
          linkId, details.localFocalPoint, segmentIndex);
      canvasWriter.model.updateLink(linkId);
    }
  }

  @override
  onLinkLongPressStart(String linkId, LongPressStartDetails details) {
    hideLinkOption();
    canvasWriter.model.hideAllLinkJoints();
    canvasWriter.model.showLinkJoints(linkId);
    segmentIndex = canvasReader.model
        .determineLinkSegmentIndex(linkId, details.localPosition);
    if (segmentIndex != null) {
      canvasWriter.model
          .insertLinkMiddlePoint(linkId, details.localPosition, segmentIndex);
      canvasWriter.model.updateLink(linkId);
    }
  }

  @override
  onLinkLongPressMoveUpdate(String linkId, LongPressMoveUpdateDetails details) {
    if (segmentIndex != null) {
      canvasWriter.model.setLinkMiddlePointPosition(
          linkId, details.localPosition, segmentIndex);
      canvasWriter.model.updateLink(linkId);
    }
  }
}
