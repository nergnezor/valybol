import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'rive/valybol.rive.dart';

void main() {
  runApp(const MaterialApp(home: Game()));
}

class Game extends StatelessWidget {
  const Game({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: RiveAnimation.asset(
        'assets/' + Valybol.assetPath,
        fit: BoxFit.cover,
        // animations: ['waves'],
        // stateMachines: ['State Machine 1'],
      ),
    ));
  }
}
