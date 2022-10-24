import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

void main() {
  runApp(const MaterialApp(home: Valybol()));
}

class Valybol extends StatelessWidget {
  const Valybol({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
      child: RiveAnimation.asset(
        'assets/valybol.riv',
        fit: BoxFit.cover,
        animations: ['waves'],
        stateMachines: ['State Machine 1'],
      ),
    ));
  }
}
