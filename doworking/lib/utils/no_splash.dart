import 'package:flutter/material.dart';

class NoSplashFactory extends InteractiveInkFeatureFactory {
    const NoSplashFactory();

    InteractiveInkFeature create({
        @required MaterialInkController controller,
        @required RenderBox referenceBox,
        @required Offset position,
        @required Color color,
        TextDirection textDirection,
        bool containedInkWell: false,
        RectCallback rectCallback,
        BorderRadius borderRadius,
        ShapeBorder customBorder,
        double radius,
        VoidCallback onRemoved,
    }) {
        return new NoSplash(
            controller: controller,
            referenceBox: referenceBox,
            color: color,
            onRemoved: onRemoved,
        );
    }
}

class NoSplash extends InteractiveInkFeature {
    NoSplash({
        @required MaterialInkController controller,
        @required RenderBox referenceBox,
        Color color,
        VoidCallback onRemoved,
    }) : assert(controller != null),
                assert(referenceBox != null),
                super(controller: controller, referenceBox: referenceBox, onRemoved: onRemoved) {
        controller.addInkFeature(this);
    }
    @override
    void paintFeature(Canvas canvas, Matrix4 transform) { }
}