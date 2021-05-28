import 'package:flutter/material.dart';

class ActiveWorkouts extends StatelessWidget {
  const ActiveWorkouts({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          'Active workouts',
          style: TextStyle(
            color: Theme.of(context).textTheme.headline6.color,
            fontSize: 24,
          ),
        ),
      ),
    );
  }
}