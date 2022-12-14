// ignore_for_file: type=lint
// THIS FILE WAS AUTOMATICALLY GENERATED BY flutter_rive_generator. MODIFICATIONS WILL BE LOST WHEN THE GENERATOR RUNS AGAIN.
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:rive/rive.dart' as rive;
import 'package:rive/src/rive_core/state_machine_controller.dart' as core;

const assetsBaseFolder = "assets";

String _assetPath() {
  return (kIsWeb ? '' : assetsBaseFolder + '/') + 'valybol.riv';
}

class Valybol {
  final rive.RiveFile file;
  static String get assetPath => _assetPath();

  Valybol._(this.file);

  static Future<Valybol> load() async {
    final riveFile =
        rive.RiveFile.import(await rootBundle.load(Valybol.assetPath));
    return Valybol._(riveFile);
  }

  Beach? _beach;
  Beach get beach => _beach ??= Beach(file.artboards
      .where((artboard) => artboard.name == r'Beach')
      .elementAt(0));

  Ball? _ball;
  Ball get ball => _ball ??= Ball(file.artboards
      .where((artboard) => artboard.name == r'ball')
      .elementAt(0));

  Humanoid? _humanoid;
  Humanoid get humanoid => _humanoid ??= Humanoid(file.artboards
      .where((artboard) => artboard.name == r'humanoid')
      .elementAt(0));

  Whale? _whale;
  Whale get whale => _whale ??= Whale(file.artboards
      .where((artboard) => artboard.name == r'whale')
      .elementAt(0));
}

class Beach {
  final rive.Artboard artboard;
  Beach(this.artboard);

  BeachStateMachine1StateMachine getBeachStateMachine1StateMachine(
      [core.OnStateChange? onStateChange]) {
    return BeachStateMachine1StateMachine(this
        .artboard
        .stateMachineByName("State Machine 1", onChange: onStateChange)!);
  }
}

abstract class BeachController {
  abstract final rive.RiveAnimationController controller;
}

class BeachSimpleAnimation extends BeachController {
  final rive.RiveAnimationController controller;

  BeachSimpleAnimation(this.controller);
}

class BeachOneShotAnimation extends BeachController {
  final rive.RiveAnimationController controller;

  BeachOneShotAnimation(this.controller);
}

enum BeachAnimations {
  idle(r"idle"),
  receive(r"receive"),
  drop(r"drop"),
  returnball(r"return ball"),
  shoot(r"shoot"),
  set(r"set");

  final String name;
  const BeachAnimations(this.name);
  BeachOneShotAnimation makeOneShotAnimation({
    bool autoplay = true,
    double mix = 1,
    void Function()? onStart,
    void Function()? onStop,
  }) {
    return BeachOneShotAnimation(rive.OneShotAnimation(this.name,
        autoplay: autoplay, mix: mix, onStart: onStart, onStop: onStop));
  }

  BeachSimpleAnimation makeSimpleAnimation({
    bool autoplay = true,
    double mix = 1,
  }) {
    return BeachSimpleAnimation(
        rive.SimpleAnimation(this.name, autoplay: autoplay, mix: mix));
  }

  String toString() {
    return this.name;
  }
}

class BeachStateMachine1StateMachine {
  final rive.StateMachineController controller;
  final rive.SMITrigger set;
  final rive.SMINumber dx;
  final rive.SMINumber f;
  BeachStateMachine1StateMachine(this.controller)
      : set = controller.findInput<bool>(r'set') as rive.SMITrigger,
        dx = controller.findInput<double>(r'dx') as rive.SMINumber,
        f = controller.findInput<double>(r'f') as rive.SMINumber;
}

class BeachRive extends StatelessWidget {
  final List<BeachAnimations> animations;
  final Alignment? alignment;
  final bool antialiasing;
  final List<BeachController> controllers;
  final BoxFit? fit;
  final Function(Beach artboard)? onInit;
  final Widget? placeHolder;

  const BeachRive({
    super.key,
    this.animations = const [],
    this.alignment,
    this.antialiasing = true,
    this.controllers = const [],
    this.fit,
    this.onInit,
    this.placeHolder,
  });

  @override
  Widget build(BuildContext context) {
    return rive.RiveAnimation.asset(
      _assetPath(),
      animations: animations.map((e) => e.name).toList(),
      alignment: alignment,
      antialiasing: antialiasing,
      artboard: r'Beach',
      controllers: this.controllers.map((e) => e.controller).toList(),
      fit: fit,
      onInit: (p0) {
        onInit?.call(Beach(p0));
      },
      placeHolder: placeHolder,
      stateMachines: [],
    );
  }
}

class Ball {
  final rive.Artboard artboard;
  Ball(this.artboard);

  BallStateMachine1StateMachine getBallStateMachine1StateMachine(
      [core.OnStateChange? onStateChange]) {
    return BallStateMachine1StateMachine(this
        .artboard
        .stateMachineByName("State Machine 1", onChange: onStateChange)!);
  }
}

abstract class BallController {
  abstract final rive.RiveAnimationController controller;
}

class BallSimpleAnimation extends BallController {
  final rive.RiveAnimationController controller;

  BallSimpleAnimation(this.controller);
}

class BallOneShotAnimation extends BallController {
  final rive.RiveAnimationController controller;

  BallOneShotAnimation(this.controller);
}

enum BallAnimations {
  timeline1(r"Timeline 1");

  final String name;
  const BallAnimations(this.name);
  BallOneShotAnimation makeOneShotAnimation({
    bool autoplay = true,
    double mix = 1,
    void Function()? onStart,
    void Function()? onStop,
  }) {
    return BallOneShotAnimation(rive.OneShotAnimation(this.name,
        autoplay: autoplay, mix: mix, onStart: onStart, onStop: onStop));
  }

  BallSimpleAnimation makeSimpleAnimation({
    bool autoplay = true,
    double mix = 1,
  }) {
    return BallSimpleAnimation(
        rive.SimpleAnimation(this.name, autoplay: autoplay, mix: mix));
  }

  String toString() {
    return this.name;
  }
}

class BallStateMachine1StateMachine {
  final rive.StateMachineController controller;

  BallStateMachine1StateMachine(this.controller);
}

class BallRive extends StatelessWidget {
  final List<BallAnimations> animations;
  final Alignment? alignment;
  final bool antialiasing;
  final List<BallController> controllers;
  final BoxFit? fit;
  final Function(Ball artboard)? onInit;
  final Widget? placeHolder;

  const BallRive({
    super.key,
    this.animations = const [],
    this.alignment,
    this.antialiasing = true,
    this.controllers = const [],
    this.fit,
    this.onInit,
    this.placeHolder,
  });

  @override
  Widget build(BuildContext context) {
    return rive.RiveAnimation.asset(
      _assetPath(),
      animations: animations.map((e) => e.name).toList(),
      alignment: alignment,
      antialiasing: antialiasing,
      artboard: r'ball',
      controllers: this.controllers.map((e) => e.controller).toList(),
      fit: fit,
      onInit: (p0) {
        onInit?.call(Ball(p0));
      },
      placeHolder: placeHolder,
      stateMachines: [],
    );
  }
}

class Humanoid {
  final rive.Artboard artboard;
  Humanoid(this.artboard);
}

abstract class HumanoidController {
  abstract final rive.RiveAnimationController controller;
}

class HumanoidSimpleAnimation extends HumanoidController {
  final rive.RiveAnimationController controller;

  HumanoidSimpleAnimation(this.controller);
}

class HumanoidOneShotAnimation extends HumanoidController {
  final rive.RiveAnimationController controller;

  HumanoidOneShotAnimation(this.controller);
}

enum HumanoidAnimations {
  set(r"set");

  final String name;
  const HumanoidAnimations(this.name);
  HumanoidOneShotAnimation makeOneShotAnimation({
    bool autoplay = true,
    double mix = 1,
    void Function()? onStart,
    void Function()? onStop,
  }) {
    return HumanoidOneShotAnimation(rive.OneShotAnimation(this.name,
        autoplay: autoplay, mix: mix, onStart: onStart, onStop: onStop));
  }

  HumanoidSimpleAnimation makeSimpleAnimation({
    bool autoplay = true,
    double mix = 1,
  }) {
    return HumanoidSimpleAnimation(
        rive.SimpleAnimation(this.name, autoplay: autoplay, mix: mix));
  }

  String toString() {
    return this.name;
  }
}

class HumanoidRive extends StatelessWidget {
  final List<HumanoidAnimations> animations;
  final Alignment? alignment;
  final bool antialiasing;
  final List<HumanoidController> controllers;
  final BoxFit? fit;
  final Function(Humanoid artboard)? onInit;
  final Widget? placeHolder;

  const HumanoidRive({
    super.key,
    this.animations = const [],
    this.alignment,
    this.antialiasing = true,
    this.controllers = const [],
    this.fit,
    this.onInit,
    this.placeHolder,
  });

  @override
  Widget build(BuildContext context) {
    return rive.RiveAnimation.asset(
      _assetPath(),
      animations: animations.map((e) => e.name).toList(),
      alignment: alignment,
      antialiasing: antialiasing,
      artboard: r'humanoid',
      controllers: this.controllers.map((e) => e.controller).toList(),
      fit: fit,
      onInit: (p0) {
        onInit?.call(Humanoid(p0));
      },
      placeHolder: placeHolder,
      stateMachines: [],
    );
  }
}

class Whale {
  final rive.Artboard artboard;
  Whale(this.artboard);

  WhaleStateMachine1StateMachine getWhaleStateMachine1StateMachine(
      [core.OnStateChange? onStateChange]) {
    return WhaleStateMachine1StateMachine(this
        .artboard
        .stateMachineByName("State Machine 1", onChange: onStateChange)!);
  }
}

abstract class WhaleController {
  abstract final rive.RiveAnimationController controller;
}

class WhaleSimpleAnimation extends WhaleController {
  final rive.RiveAnimationController controller;

  WhaleSimpleAnimation(this.controller);
}

class WhaleOneShotAnimation extends WhaleController {
  final rive.RiveAnimationController controller;

  WhaleOneShotAnimation(this.controller);
}

enum WhaleAnimations {
  breathe(r"breathe"),
  charge(r"charge"),
  shoot(r"shoot"),
  breatheold(r"breathe old");

  final String name;
  const WhaleAnimations(this.name);
  WhaleOneShotAnimation makeOneShotAnimation({
    bool autoplay = true,
    double mix = 1,
    void Function()? onStart,
    void Function()? onStop,
  }) {
    return WhaleOneShotAnimation(rive.OneShotAnimation(this.name,
        autoplay: autoplay, mix: mix, onStart: onStart, onStop: onStop));
  }

  WhaleSimpleAnimation makeSimpleAnimation({
    bool autoplay = true,
    double mix = 1,
  }) {
    return WhaleSimpleAnimation(
        rive.SimpleAnimation(this.name, autoplay: autoplay, mix: mix));
  }

  String toString() {
    return this.name;
  }
}

class WhaleStateMachine1StateMachine {
  final rive.StateMachineController controller;

  WhaleStateMachine1StateMachine(this.controller);
}

class WhaleRive extends StatelessWidget {
  final List<WhaleAnimations> animations;
  final Alignment? alignment;
  final bool antialiasing;
  final List<WhaleController> controllers;
  final BoxFit? fit;
  final Function(Whale artboard)? onInit;
  final Widget? placeHolder;

  const WhaleRive({
    super.key,
    this.animations = const [],
    this.alignment,
    this.antialiasing = true,
    this.controllers = const [],
    this.fit,
    this.onInit,
    this.placeHolder,
  });

  @override
  Widget build(BuildContext context) {
    return rive.RiveAnimation.asset(
      _assetPath(),
      animations: animations.map((e) => e.name).toList(),
      alignment: alignment,
      antialiasing: antialiasing,
      artboard: r'whale',
      controllers: this.controllers.map((e) => e.controller).toList(),
      fit: fit,
      onInit: (p0) {
        onInit?.call(Whale(p0));
      },
      placeHolder: placeHolder,
      stateMachines: [],
    );
  }
}
