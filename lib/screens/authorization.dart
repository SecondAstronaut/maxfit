import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:maxfit/domain/domains.dart';
import 'package:maxfit/services/authorization.dart';

class AuthorizationPage extends StatefulWidget {
  AuthorizationPage({Key key}) : super(key: key);

  @override
  _AuthorizationPageState createState() => _AuthorizationPageState();
}

class _AuthorizationPageState extends State<AuthorizationPage> {
  // Контроллеры для _form()
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  // Переменные для функции, _email и _password служат для запоминания пароля и email 
  String _email;
  String _password;
  bool showLogin = true;

  AuthorizationService _authService = AuthorizationService();

  @override
  Widget build(BuildContext context) {
    Widget _logo() {
      return Padding(
        padding: EdgeInsets.only(top: 100),
        child: Container(
          // Центрирование по центру Align()
          child: Align(
            child: Text(
              'Max Fitness', 
              style: TextStyle(
                fontSize: 45,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
    }

    // TextEditingController - используется для работы текстовых полей
    // bool obscure - используется для скрытия пароля
    Widget _input(Icon icon, String hint, TextEditingController controller, bool obscure) {
      return Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: TextField(
          // Все операции с полями деляются через кон
          controller: controller,
          // obscureText - используется для скрытия пароля
          obscureText: obscure,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
          // InputDecoration - декорация input'a
          decoration: InputDecoration(
            // hintStyle - настройка стилей хинта
            hintStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white30,
            ),
            // hintText - выводт текста хинта
            hintText: hint,
            // Показывать border вокруг TextField, когда у нас в фокусе наш инпут focusedBorder
            // OutlineInputBorder - контур границы input'a
            focusedBorder: OutlineInputBorder(
              // настройка border'a (контура, рамочки) - BorderSide
              borderSide: BorderSide(
                color: Colors.white,
                width: 3,
              ),
            ),
            // Когда наш инпут не в фокусе enabledBorder
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white54,
                width: 1,
              ),
            ),
            prefixIcon: Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: IconTheme(
                data: IconThemeData(
                  color: Colors.white
                ), 
                child: icon,
              ),
            ),
          ),
        ),
      );
    }

    Widget _button(String text, void func()) {
      return ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed))
                return Theme.of(context).primaryColor;
              return Colors.white;
            }
          ),
        ),
        // style: ElevatedButton.styleFrom(
        //   primary: Colors.white,
        //   onPrimary: Theme.of(context).primaryColor,
        //   back
        // ),
        // ButtonStyle(
          // Теперь чтобы изменить цвет нажатия и т.д придёться использовать эту залупу
          // overlayColor: MaterialStateProperty.resolveWith<Color>(
          //   (Set<MaterialState> states) 
          //     {
          //     // Цвет при фокусе
          //     if (states.contains(MaterialState.focused))
          //       return Colors.white;
          //     // Цвет при наведении
          //     if (states.contains(MaterialState.hovered))
          //       return Colors.white;
          //     // Цвет при нажатии
          //     if (states.contains(MaterialState.pressed))
          //       return Theme.of(context).primaryColor;
          //     return null; // Defer to the widget's default.
          //   }
          // ),
          // backgroundColor: MaterialStateProperty.resolveWith<Color>(
          //   (Set<MaterialState> states) {
          //     MaterialStateProperty.all<Color>(Colors.white);
          //     // if (states.contains(MaterialState.disabled))
          //     //   return Colors.white;
          //     // if (states.contains(MaterialState.hovered))
          //     //   return Colors.white;
          //     // if (states.contains(MaterialState.pressed))
          //     //   return Theme.of(context).primaryColor;
          //     return null;
          //   }
          // ),
        // ),
        onPressed: () {
          func();
        },
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
            fontSize: 20,
          ),
        ),
      );
    }

    Widget _form(String label, void func()) {
      return Container(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 20, top: 10),
              child: _input(Icon(Icons.email), 'Email', _emailController, false),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: _input(Icon(Icons.lock), 'Password', _passwordController, true),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Container(
                height: 50,
                // MediaQuery.of(context).size.width - динамически настраивается ширина кнопки благодаря
                // высчитыванию размеров экрана
                width: MediaQuery.of(context).size.width,
                child: _button(label, func),
              ),
            ), 
          ],
        ),
      );
    }

    // Кнопка логина
    void _signInButtonAction() async {
      // Передача в переменные значения полей email и password с помощью .text
      _email = _emailController.text;
      _password = _passwordController.text;

      if(_email.isEmpty || _password.isEmpty) return;

      FireUser user = await _authService.signInWithEmailAndPassword(_email.trim(), _password.trim());

      // Если пользователь вернулся пустым, то мы показываем уведомление
      if (user == null) {
        // Ввывод сообщения об ошибке
        Fluttertoast.showToast(
          msg: "Can't Sign In you! Please cheak your email/password",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
        );
      } else {
        // Очистка полей .clear()
        _emailController.clear();
        _passwordController.clear();
      }
    }

    // Кнопка регистрации
    void _signUpButtonAction() async {
      // Передача в переменные значения полей email и password с помощью .text
      _email = _emailController.text;
      _password = _passwordController.text;

      if(_email.isEmpty || _password.isEmpty) return;

      FireUser user = await _authService.signUpWithEmailAndPassword(_email.trim(), _password.trim());

      // Если пользователь вернулся пустым, то мы показываем уведомление
      if (user == null) {
        // Ввывод сообщения об ошибке
        Fluttertoast.showToast(
          msg: "Can't Sign Up you! Please cheak your email/password",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
        );
      } else {
        // Очистка полей .clear()
        _emailController.clear();
        _passwordController.clear();
      }
    }

    // Декоративный элемент вконце нашей авторизации
    Widget _bottomWave() {
      return Expanded(
        child: Align(
          child: ClipPath(
            child: Container(
              color: Colors.white,
              height: 300,
            ),
            clipper: BottomWaveClipper(),
          ),
          alignment: Alignment.bottomCenter,
        ),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        children: [
          _logo(),
          SizedBox(height: 20),
          (
            // Если showLogin == false, то отображаем регистрацию, если true, то отображаем login 
            showLogin ? Column(
              children: [
                _form('Login', _signInButtonAction),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        showLogin = false;
                      });
                    },
                    child: Text(
                      'Not registered yet? Registered!', 
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            )
            : Column(
              children: [
                _form('Registered', _signUpButtonAction),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        showLogin = true;
                      });
                    },
                    child: Text(
                      'Already registered? Login!', 
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ),
          // Декоративный элемент внизу нашего приложения
          _bottomWave(),
        ],
      ),
    );
  }
}

class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(size.width, 0.0);
    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.lineTo(0.0, size.height + 5);
    var secondControlPoint = Offset(size.width - (size.width / 6), size.height);
    var secondEndPoint = Offset(size.width, 0.0);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}