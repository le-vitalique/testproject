import 'package:flutter/material.dart';
import 'package:testproject/ui/screens/qr_code_scanner.dart';

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

  void _submitForm() async {
    if (_loginFormStateKey.currentState!.validate()) {
      _loginFormStateKey.currentState!.reset();
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const QrCodeScanner(),
        ),
      );
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _loginFormStateKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  key: const Key('username'),
                  controller: _usernameController,
                  decoration: const InputDecoration(
                      icon: Icon(Icons.person),
                      labelText: 'Имя пользователя',
                      hintText: 'Введите имя пользователя'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Заполните поле';
                    } else if (value != 'admin') {
                      return 'Неверное имя пользователя';
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  key: const Key('password'),
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                      icon: Icon(Icons.password),
                      labelText: 'Пароль',
                      hintText: 'Введите пароль'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Заполните поле';
                    } else if (value != '12345') {
                      return 'Неверный пароль';
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  key: const Key('submit'),
                  onPressed: () async {
                    _submitForm();
                  },
                  child: const Text('Войти'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
