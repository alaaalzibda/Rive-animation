import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class RocketShip extends StatefulWidget {
  const RocketShip({super.key});

  @override
  State<RocketShip> createState() => _RocketShipState();
}

class _RocketShipState extends State<RocketShip> {
  Artboard? artboard;
  SMITrigger? triggerInput;

  initializeArtboard() async {
    final data = await rootBundle.load("assets/rive/rocket_ship.riv");

    final file = RiveFile.import(data);
    artboard = file.mainArtboard;
    final controller =
        StateMachineController.fromArtboard(artboard!, "State Machine 1");
    if (controller != null) {
      artboard!.addController(controller);
      triggerInput = controller.findInput<bool>("Trigger 1") as SMITrigger;
      triggerInput!.fire();
    } else {
      print('controller not found');
    }
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    await initializeArtboard();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: artboard == null
            ? const SizedBox()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 450,
                    child: Rive(
                      artboard: artboard!,
                    ),
                  ),
                  ElevatedButton(
                    child: const Text('Toggle rocket'),
                    onPressed: () {
                      triggerInput!.fire();
                    },
                  ),
                ],
              ),
      ),
    );
  }
}
