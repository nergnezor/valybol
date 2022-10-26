// ignore_for_file: type=lint
// THIS FILE WAS AUTOMATICALLY GENERATED BY RIVE_GENERATOR. MODIFICATIONS WILL BE LOST WHEN THE GENERATOR RUNS AGAIN.
import 'package:flutter/services.dart';
import 'package:rive/rive.dart' as rive;
import 'package:rive/src/rive_core/state_machine_controller.dart' as core;

class Valybol {
  final rive.RiveFile file;
  static final assetPath = 'valybol.riv';

  Valybol._(this.file);
  
  static Future<Valybol> load() async {
    final riveFile = rive.RiveFile.import(await rootBundle.load('valybol.riv')); 
    return Valybol._(riveFile);
  }

  Beach? _beach;
  Beach get beach => _beach ??= Beach(file.artboardByName('Beach')!);
    
  Whale? _whale;
  Whale get whale => _whale ??= Whale(file.artboardByName('whale')!);
    

}

class Beach {
  final rive.Artboard artboard;
  Beach(this.artboard);

  final animations = const BeachAnimations();

  BeachStateMachine1StateMachine getBeachStateMachine1StateMachine([core.OnStateChange? onStateChange]) {
    return BeachStateMachine1StateMachine(this.artboard.stateMachineByName("State Machine 1",onChange: onStateChange)!);
  }
}

class BeachAnimations {
  final String waves = "waves";
  final String idle = "idle";
  final String load = "load";
  final String shoot = "shoot";
  final String boll = "boll";
  final String boll2 = "boll2";
  const BeachAnimations();
}

class BeachStateMachine1StateMachine {
  final rive.StateMachineController controller;
  final rive.SMITrigger charge;
  final rive.SMITrigger shoot;
  BeachStateMachine1StateMachine(this.controller) :
    charge = controller.findInput<bool>('charge') as rive.SMITrigger,
    shoot = controller.findInput<bool>('shoot') as rive.SMITrigger;
}


class Whale {
  final rive.Artboard artboard;
  Whale(this.artboard);

  final animations = const WhaleAnimations();

  
}

class WhaleAnimations {
  final String breathe = "breathe";
  final String charge = "charge";
  final String shoot = "shoot";
  final String breatheold = "breathe old";
  const WhaleAnimations();
}



 