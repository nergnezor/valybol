import 'rive/valybol.rive.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Valybol',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Valybol'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Valybol? valybol;
  BeachStateMachine1StateMachine? valybolController;

  @override
  void initState() {
    super.initState();
    Valybol.load().then((r) async {
      setState(() {
        valybol = r;
        valybolController = r.beach.getBeachStateMachine1StateMachine();
        r.beach.artboard.addController(valybolController!.controller);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final valybol = this.valybol;
    return Scaffold(
      body: Center(
        child: RiveAnimation.asset(
          fit: BoxFit.cover,
          Valybol.assetPath,
          animations: [const BeachAnimations().waves],
        ),
      ),
      // if (valybol != null) ...[
      //   SizedBox.square(
      //     dimension: 200,
      //     child: Rive(
      //       artboard: valybol.whale.artboard,
      //     ),
      //   ),
      //   Row(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       MaterialButton(
      //         onPressed: () {
      //           valybolController?.charge.value = true;
      //         },
      //         child: const Text('hover!'),
      //       ),
      //       MaterialButton(
      //         onPressed: () {
      //           valybolController?.shoot.value = true;
      //         },
      //         child: const Text('press!'),
      //       ),
      //     ],
      //   )
      // ]
      // ],
    );
  }
}
