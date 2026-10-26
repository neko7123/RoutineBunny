import 'package:flutter/material.dart';

class BunnyMascot extends StatelessWidget {
  const BunnyMascot({super.key, this.size = 150, this.expression = 'happy'});

  final double size;
  final String expression;

  @override
  Widget build(BuildContext context) => Semantics(
        label: 'RoutineBunny mascot',
        image: true,
        child: Stack(clipBehavior: Clip.none, children: [
          SizedBox(
              width: size,
              height: size,
              child: Image.asset('assets/routine_bunny_mascot.png',
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                  semanticLabel: 'RoutineBunny bunny holding a heart')),
          if (size >= 60) ...[
            Positioned(
                top: size * .08,
                right: -size * .02,
                child: Text('♡',
                    style: TextStyle(
                        color: const Color(0xFFFF8FA3),
                        fontSize: size * .16,
                        fontWeight: FontWeight.w800))),
            Positioned(
                top: size * .28,
                left: -size * .04,
                child: Text('✦',
                    style: TextStyle(
                        color: const Color(0xFFFFB6C1), fontSize: size * .12))),
            Positioned(
                bottom: size * .12,
                right: size * .03,
                child: Text('♡',
                    style: TextStyle(
                        color: const Color(0xFFFFB6C1), fontSize: size * .11)))
          ]
        ]),
      );
}
