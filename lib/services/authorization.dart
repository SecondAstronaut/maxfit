import 'package:firebase_auth/firebase_auth.dart';
import 'package:maxfit/domain/domains.dart';

class AuthorizationService {
  // instance всего объекта аутентификации.
  // FirebaseAuth содержит в себе все методы, которые необходимы для работы
  // с аутентификацией Firebase.
  final FirebaseAuth _fAuth = FirebaseAuth.instance;

  // signInWithEmailAndPassword - позволяет логиниться в наше приложение
  // Future - обещание того, что мы получим в будующем
  Future<FireUser> signInWithEmailAndPassword(String email, String password) async {
    try {
      // Авторизация через email and password
      UserCredential result = await _fAuth.signInWithEmailAndPassword(email: email, password: password);
      // возвращаем юзера
      User user = result.user;
      // Возвращаем из Firebase только id пользоателя
      return FireUser.fromFirebase(user);
    } catch(e) {
      print(e);
      return null;
    }
  }

  // signUpWithEmailAndPassword - позволяет регистрироваться в нашем приложении
  // Future - обещание того, что мы получим в будующем
  Future<FireUser> signUpWithEmailAndPassword(String email, String password) async {
    try {
      // Регистрация через email and password
      UserCredential result = await _fAuth.createUserWithEmailAndPassword(email: email, password: password);
      // возвращаем юзера
      User user = result.user;
      // Возвращаем из Firebase только id пользоателя
      return FireUser.fromFirebase(user);
    } catch(e) {
      print(e);
      return null;
    }
  }

  // Выход из приложения
  Future logOut() async {
    await _fAuth.signOut();
  }

  // Stream - поток, через который (если мы на него подпишемся (т.е начнём смотреть на этот поток через какой-то фрагмнент кода),
  // то к нам может прийти через какое-то время через него информация о том, что что-то произошло) мы получаем некоторые данные.
  Stream<FireUser> get currentUser {
    return _fAuth.authStateChanges().map((User user) => user != null ? FireUser.fromFirebase(user) : null);
  }
}