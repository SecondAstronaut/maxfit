import 'package:flutter/material.dart';
import 'package:maxfit/services/authorization.dart';
import 'package:maxfit/components/components.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Переменная для Bottom Navigation Bar, чтобы понимать какая кнопка нажата
  int sectionIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Объект BuildContext context позволяет общаться с родителем, узнавать место в иерархии, для
      // общения можно использовать of(context).
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text(sectionIndex == 0 ? 'Active Workouts' : 'Find Workouts'),
        leading: Icon(Icons.fitness_center),
        actions: [
          TextButton.icon(
            onPressed: () {
              AuthorizationService().logOut();
            }, 
            icon: Icon(
              Icons.supervised_user_circle, 
              color: Colors.white,
            ), 
            label: SizedBox.shrink(),
          ),
        ],
      ),
      body: sectionIndex == 0 ? ActiveWorkouts() : WorkoutsList(),
      // Аналог прердыдущего bottomNavigationBar, только с использованием package'a
      // CurvedNavigationBar
      bottomNavigationBar: bottomNavBar(),
      // Нижний навигационный бар
      // bottomNavigationBar: BottomNavigationBar(
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.fitness_center),
      //       label: 'My workouts',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.search),
      //       label: 'Find workouts',
      //     ),
      //   ],
      //   currentIndex: sectionIndex,
      //   backgroundColor: Colors.white30,
      //   selectedItemColor: Colors.white,
      //   onTap: (int index) {
      //     setState(() {
      //       // Изменяем состояние кнопки взависимости какая кнопку нажата
      //       sectionIndex = index;
      //     });
      //   },
      // ),
    );
  }
  
  Widget bottomNavBar() {
    return CurvedNavigationBar(
      items: const [
        Icon(Icons.fitness_center),
        Icon(Icons.search),
      ],
      index: sectionIndex,
      height: 50,
      color: Colors.white.withOpacity(0.5),
      buttonBackgroundColor: Colors.white,
      backgroundColor: Colors.white.withOpacity(0.5),
      animationCurve: Curves.easeInOut,
      animationDuration: Duration(milliseconds: 500),
      onTap: (int index) {
        setState(() {
          sectionIndex = index;
        });
      },
    );
  }
}