import 'package:flutter/material.dart';
import 'package:testproject/qr_code_scanner.dart';
import 'package:testproject/theme.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: appTheme,
      home: const MyHomePage(title: 'Стажировка'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FormState> _loginFormStateKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _submitForm() {
    if (_loginFormStateKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const QrCodeScanner(title: 'test title'),
        ),
      );
      _loginFormStateKey.currentState!.reset();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Form(
        key: _loginFormStateKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              key: const Key('username'),
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Имя пользователя'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Введите имя пользователя';
                } else if (value != 'admin') {
                  return 'Неверные данные';
                } else {
                  return null;
                }
              },
            ),
            TextFormField(
              key: const Key('password'),
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Пароль'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Введите пароль';
                } else if (value != '12345') {
                  return 'Неверные данные';
                } else {
                  return null;
                }
              },
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              key: const Key('submit'),
              onPressed: _submitForm,
              child: const Text('Войти'),
            ),
          ],
        ),
      ),
    );
  }
}




