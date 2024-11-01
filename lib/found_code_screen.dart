import 'package:flutter/material.dart';
import 'package:testproject/contact.dart';

class FoundCodeScreen extends StatefulWidget {
  final List<Contact> contactsList;
  final Function() screenClosed;

  const FoundCodeScreen({
    super.key,
    required this.contactsList,
    required this.screenClosed,
  });

  @override
  State<StatefulWidget> createState() => _FoundCodeScreenState();
}

class _FoundCodeScreenState extends State<FoundCodeScreen> {
  final List<GlobalKey<FormState>> _contactFormStateKeys = [];
  final List<TextEditingController> _nameControllers = [];
  final List<TextEditingController> _phoneControllers = [];

  void _submitForm(GlobalKey<FormState> key) {
    if (key.currentState!.validate()) {
      print('form validated');
    }
  }

  Widget buildUsers(List<Contact> contacts) => ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final Contact contact = contacts[index];

          _contactFormStateKeys.add(GlobalKey<FormState>());

          _nameControllers.add(TextEditingController(text: contact.name));
          _phoneControllers.add(TextEditingController(text: contact.phone));

          return Form(
            key: _contactFormStateKeys[index],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    key: const Key('name'),
                    controller: _nameControllers[index],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Введите имя';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    key: const Key('phone'),
                    controller: _phoneControllers[index],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Введите телефон';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                IconButton(
                  key: const Key('submit'),
                  onPressed: () {
                    _submitForm(_contactFormStateKeys[index]);
                  },
                  icon: const Icon(Icons.save),
                ),
              ],
            ),
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (didPop) {
          print('PopScope called');
          widget.screenClosed();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Found Code'),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Scanned Code:'),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: buildUsers(widget.contactsList),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
