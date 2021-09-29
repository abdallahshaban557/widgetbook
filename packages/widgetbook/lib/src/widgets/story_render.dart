import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:widgetbook/src/cubit/canvas/canvas_cubit.dart';
import 'package:widgetbook/src/models/organizers/organizers.dart';
import 'package:widgetbook/src/providers/zoom_provider.dart';
import 'package:widgetbook/src/widgets/device_render.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class StoryRender extends StatefulWidget {
  const StoryRender({Key? key}) : super(key: key);

  @override
  _StoryState createState() => _StoryState();
}

class _StoryState extends State<StoryRender> {
  TransformationController controller = TransformationController(
    Matrix4.identity(),
  );

  Widget _buildStory() {
    return BlocBuilder<CanvasCubit, CanvasState>(builder: (context, state) {
      if (state.selectedStory != null) {
        return _buildCanvas(state.selectedStory!);
      }

      return Center(
        child: Container(),
      );
    });
  }

  void _updateController() {
    var state = ZoomProvider.of(context)!.state;

    var oldMatrix = controller.value;

    var translation = oldMatrix.getTranslation();

    var rotation = oldMatrix.getRotation();
    oldMatrix.setFromTranslationRotationScale(
      translation,
      vector.Quaternion.fromRotation(rotation),
      vector.Vector3.all(state.zoomLevel),
    );
    controller = TransformationController(oldMatrix);
  }

  Widget _buildCanvas(Story story) {
    _updateController();

    return BlocBuilder<CanvasCubit, CanvasState>(
      builder: (context, state) {
        return InteractiveViewer(
          boundaryMargin: const EdgeInsets.all(double.infinity),
          minScale: 0.25,
          maxScale: 5,
          constrained: false,
          transformationController: controller,
          onInteractionUpdate: (ScaleUpdateDetails details) {
            ZoomProvider.of(context)!
                .setScale(controller.value.getMaxScaleOnAxis());
          },
          child: DeviceRender(
            story: story,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildStory();
  }
}
