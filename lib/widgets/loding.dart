import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 128, 169, 189),
      child: const Center(
        child: SpinKitChasingDots(
          color: Colors.greenAccent,
          size: 50,
        ),
      ),
    );
  }
}
