import 'package:flutter/material.dart';
import 'package:maxfit/domain/domains.dart';
import 'package:maxfit/screens/screens.dart';
import 'package:provider/provider.dart';

// Тут мы даём понимание нашему приложению, залогирован ли пользователь или нет
class LandingPage extends StatelessWidget {
  const LandingPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FireUser user = Provider.of<FireUser>(context);
    // Залогирован ли пользователь или нет
    final bool isLoggedIn = user != null;

    return isLoggedIn ? HomePage() : AuthorizationPage();
  }
}