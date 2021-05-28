import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:maxfit/components/common/save_button.dart';
import 'package:maxfit/components/common/toast.dart';
import 'package:maxfit/core/constants.dart';
import 'package:maxfit/domain/workout.dart';
import 'package:maxfit/screens/add_workout_week.dart';

class AddWorkout extends StatefulWidget {
  final WorkoutSchedule workoutSchedule;

  AddWorkout({Key key, this.workoutSchedule}) : super(key: key);

  @override
  _AddWorkoutState createState() => _AddWorkoutState();
}

class _AddWorkoutState extends State<AddWorkout> {
  final _fbKey = GlobalKey<FormBuilderState>();

  WorkoutSchedule workout = WorkoutSchedule(weeks: []);

  @override
  void initState() {
    if (widget.workoutSchedule != null) workout = widget.workoutSchedule.copy();

    super.initState();
  }

  void _saveWorkout() {
    // Если пошло что-то не так с сохранением и валидацией, то выводим тосты
    if (_fbKey.currentState.saveAndValidate()) {
      if(workout.weeks == null || workout.weeks.length == 0)
      {
        buildToast('Please add at least one training week');
        return;
      }

      Navigator.of(context).pop(workout);
    } else {
      buildToast('Ooops! Something is not right');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Create Workout'),
          actions: <Widget>[
            SaveButton(onPressed: _saveWorkout)
          ],
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(color: bgColorWhite),
          child: Column(
            children: <Widget>[
              FormBuilder(
                // context,
                key: _fbKey,
                initialValue: {},               
                child: Column(
                  children: <Widget>[
                    FormBuilderTextField(
                      name: "title",
                      decoration: InputDecoration(
                        labelText: "Title*",
                      ),
                      onChanged: (dynamic val) {},
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context),
                        FormBuilderValidators.maxLength(context, 100),
                      ]),
                    ),
                    FormBuilderDropdown(
                      name: "level",
                      decoration: InputDecoration(
                        labelText: "Level*",
                      ),
                      initialValue: 'Beginner',
                      allowClear: false,
                      hint: Text('Select Level'),
                      validator: FormBuilderValidators.required(context),
                      items: <String>['Beginner', 'Intermediate', 'Advanced']
                          .map((level) => DropdownMenuItem(
                                value: level,
                                child: Text('$level'),
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Weeks',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    child: Icon(Icons.add),
                    onPressed: () async {
                      var week = await Navigator.push<WorkoutWeek>(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => AddWorkoutWeek()));
                      if (week != null)
                        setState(() {
                          workout.weeks.add(week);
                        });
                    },
                  )
                ],
              ),
              workout.weeks.length <= 0
                  ? Text(
                      'Please add at least one training week',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    )
                  : _buildWeeks()
            ],
          ),
        ));
  }

  Widget _buildWeeks() {
    return Expanded(
        //padding: EdgeInsets.all(5),
        child: Column(
            children: workout.weeks
                .map((week) => Card(
                      elevation: 2.0,
                      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: InkWell(
                        onTap: () async {
                          var ind = workout.weeks.indexOf(week);

                          var modifiedWeek = await Navigator.push<WorkoutWeek>(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) =>
                                      AddWorkoutWeek(week: week)));
                          if (modifiedWeek != null) {                            
                            setState(() {
                              workout.weeks[ind] = modifiedWeek;  
                            });                            
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(50, 65, 85, 0.9)),
                          child: ListTile(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
                            leading: Container(
                              padding: EdgeInsets.only(right: 12),
                              child: Icon(
                                Icons.check,
                                color: Colors.green,
                              ),
                              decoration: BoxDecoration(
                                  border: Border(
                                      right: BorderSide(
                                          width: 1, color: Colors.white24))),
                            ),
                            title: Text(
                                'Week ${workout.weeks.indexOf(week) + 1} - ${week.daysWithDrills} Training Days',
                                style: TextStyle(
                                    color:
                                        Theme.of(context).textTheme.headline6.color,
                                    fontWeight: FontWeight.bold)),
                            trailing: Icon(Icons.keyboard_arrow_right,
                                color: Theme.of(context).textTheme.headline6.color),
                          ),
                        ),
                      ),
                    ))
                .toList()));
  }
}