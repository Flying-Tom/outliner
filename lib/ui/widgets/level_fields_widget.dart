import 'package:flutter/material.dart';

class LevelFieldsWidget extends StatelessWidget {
  final List<TextEditingController> controllers;

  const LevelFieldsWidget({
    super.key,
    required this.controllers,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(controllers.length, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextField(
            controller: controllers[index],
            decoration: InputDecoration(
              labelText: 'Level ${index + 1} pattern',
              border: const OutlineInputBorder(),
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
            ),
            maxLines: 1,
          ),
        );
      }),
    );
  }
}
