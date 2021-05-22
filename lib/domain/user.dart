import 'package:firebase_auth/firebase_auth.dart';

class FireUser {
  String id;

  // Возвращаем из Firebase только id пользоателя
  FireUser.fromFirebase(User user) {
    id = user.uid;
  }
}