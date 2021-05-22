import 'package:flutter/material.dart';
import 'package:maxfit/domain/domains.dart';
import 'package:maxfit/services/authorization.dart';
import 'package:provider/provider.dart';
import 'screens/screens.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaxFitApp());
}

class MaxFitApp extends StatelessWidget {
  @override
  // context - это специальный объект, который содержит в себе параметры отвечающие за сам компонент.
  // Объект context будет определять место нашего виджета внутри иерархии других виджетов, с помощью
  // context'a мы будем привязываться к различным глобльным переменным, будем знать наше место внутри
  // иерархии виджетов.
  Widget build(BuildContext context) {
    // Запоминание входа + потока через Provider
    return StreamProvider<FireUser>.value(
      value: AuthorizationService().currentUser,
      initialData: null,
      child: MaterialApp(
        title: 'Max Fitness',
        theme: ThemeData(
          primaryColor: Color.fromRGBO(50, 65, 85, 1),
          textTheme: TextTheme(headline6: TextStyle(color: Colors.white))
        ),
        home: LandingPage(),
      ),
    );
  }
}