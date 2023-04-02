import 'package:flutter/material.dart';

class UnderConstructionView extends StatelessWidget {
  const UnderConstructionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.construction,
            size: 200,
          ),
          Text(
            "This page is under construction.",
            style: Theme.of(context).textTheme.headlineMedium,
          )
        ],
      ),
    );
  }
}
