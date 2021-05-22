import 'package:flutter/material.dart';
import 'package:maxfit/domain/domains.dart';

class WorkoutsList extends StatefulWidget {
  @override
  _WorkoutsListState createState() => _WorkoutsListState();
}

class _WorkoutsListState extends State<WorkoutsList> {

  @override
  void initState() {
    clearFilter();
    super.initState();
  }

  final workouts = <Workout>[
    Workout(title: 'Test1', author: 'Egor', description: 'Test workout Egor', level: 'Beginner'),
    Workout(title: 'Test2', author: 'Adel', description: 'Test workout Adel', level: 'Intermediate'),
    Workout(title: 'Test3', author: 'Max', description: 'Test workout Max', level: 'Advanced'),
    Workout(title: 'Test4', author: 'Nikita', description: 'Test workout Nikita', level: 'Beginner'),
    Workout(title: 'Test5', author: 'Bob', description: 'Test workout Bob', level: 'Intermediate'),
  ];

  // Показывать только мои воркауты или все остальные
  var filterOnlyMyWorkouts = false;
  // Возможность поиска по загаловку
  var filterTitle = '';
  // Контроллер текстовый
  var filterTitleController = TextEditingController();
  // Возможность поиска по уровню сложности занятия
  var filterLevel = 'Any Level';
  // Короткое описание что у нас сейчас в фильтре
  var filterText = '';
  var filterHeight = 0.0;

  List<Workout> filter() {
    setState(() {
      filterText = filterOnlyMyWorkouts ? 'My Workouts' : 'All workouts';
      filterText += '/' + filterLevel;
      if (filterTitle.isNotEmpty) filterText += '/' + filterTitle;
      filterHeight = 0;
    });

    var list = workouts;
    return list;
  }

  List<Workout> clearFilter() {
    setState(() {
      filterText = 'All workouts/Any Level';
      filterOnlyMyWorkouts = false;
      filterTitle = '';
      filterLevel = 'Any Level';
      filterTitleController.clear();
      filterHeight = 0;
    });

    var list = workouts;
    return list;
  }

  @override
  Widget build(BuildContext context) {
    var workoutsList = Expanded(
      child: ListView.builder(
        itemCount: workouts.length, // количество выводимых значений
        itemBuilder: (context, i) {
          // Card - виджет карточки
          return Card(
            elevation: 2, // поднятие карточки над поверхностью
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(50, 65, 85, 0.85)
              ),
              // ListTile нужен для более универсального вывода значений в List'е,
              // есть много полезных параметров
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                // leading - это то, что будет показываться перед title, т.е то, что будет показываться
                // в самом начале
                leading: Container(
                  padding: EdgeInsets.only(right: 12),
                  child: Icon(
                    Icons.fitness_center,
                    color: Theme.of(context).textTheme.headline6.color,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      // BorderSide служит для изменения границы конкретной стороны
                      right: BorderSide(
                        width: 1,
                        color: Colors.white24,
                      ),
                    ),
                  ),
                ),
                // title - это название нашего ListTile
                title: Text(
                  workouts[i].title, 
                  style: TextStyle(
                    color: Theme.of(context).textTheme.headline6.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // trailing - то что будет показываться в самом конце, в данном случае после title
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  color: Theme.of(context).textTheme.headline6.color,
                ),
                // subtitle - вторая строка, т.е подстрока
                subtitle: subtitle(context, workouts[i]),
              ),
            ),
          );
        }
      ),
    );
    
    var filterInfo = Container(
      margin: EdgeInsets.only(top: 3, left: 7, right: 7, bottom: 5),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.5)),
      height: 40,
      child: ElevatedButton(
        child: Row(
          children: [
            Icon(Icons.filter_list),
            Text(
              filterText,
              style: TextStyle(),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        onPressed: () {
          setState(() {
            filterHeight = (filterHeight == 0.0 ? 280.0 : 0.0);
          });
        }, 
      ),
    );

    var levelMenuItems = <String>[
      'Any Level',
      'Beginner',
      'Intermediate',
      'Advanced'
    ].map((String value) {
      return new DropdownMenuItem<String>(
        value: value,
        child: new Text(value),
      );
    }).toList();

    var filterForm = AnimatedContainer(
      margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 7),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SwitchListTile(
                title: const Text('Only My Workouts'),
                value: filterOnlyMyWorkouts, 
                onChanged: (bool val) =>
                  setState(() => filterOnlyMyWorkouts = val)),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Level'),
                items: levelMenuItems,
                value: filterLevel,
                onChanged: (String val) => setState(() => filterLevel = val),
              ),
              TextFormField(
                controller: filterTitleController,
                decoration: const InputDecoration(labelText: 'Title'),
                onChanged: (String val) => setState(() => filterLevel = val),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () {
                        filter();
                      }, 
                      child: Text('Apply', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () {
                        clearFilter();
                      },
                      child: Text('Clear', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      duration: const Duration(milliseconds: 400),
      curve: Curves.fastOutSlowIn,
      height: filterHeight,
    );

    return Column(
      children: [
        filterInfo,
        filterForm,
        workoutsList,
      ],
    );
  }
}

// Этот виджет выводит параметр цвета для Beginner - зеленый, Intermediate - оранжевый,
// Advance - красный
Widget subtitle(BuildContext context, Workout workout) {
  var color = Colors.grey;
  double indicatorLevel = 0;

  switch (workout.level) {
    case 'Beginner':
      color = Colors.green;
      indicatorLevel = 0.33;
      break; 
    case 'Intermediate':
      color = Colors.yellow;
      indicatorLevel = 0.66;
      break;
    case 'Advanced':
      color = Colors.red;
      indicatorLevel = 1;
      break;
  }

  return Row(
    children: [
      Expanded(
        flex: 1,
        child: LinearProgressIndicator(
          backgroundColor: Theme.of(context).textTheme.headline6.color,
          value: indicatorLevel,
          // AlwaysStoppedAnimation - анимация всегда остановлена
          valueColor: AlwaysStoppedAnimation(color),
        ),
      ),
      SizedBox(width: 10),
      Expanded(
        // flex - разделение по частям, т.е в данном случае данный Expanded будет больше
        // в 3 раза, чем первый Expanded
        flex: 3,
        child: Text(
          workout.level,
          style: TextStyle(
            color: Theme.of(context).textTheme.headline6.color,
          ),
        ),
      ),
    ],
  );
}