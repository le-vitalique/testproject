import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:testproject/contact.dart';

class FoundCodeScreen extends StatefulWidget {
  final List<Contact> contactsList;

  const FoundCodeScreen({
    super.key,
    required this.contactsList,
  });

  @override
  State<StatefulWidget> createState() => _FoundCodeScreenState();
}

class _FoundCodeScreenState extends State<FoundCodeScreen> {
  final List<GlobalKey<FormState>> _contactFormStateKeys = [];
  final List<TextEditingController> _nameControllers = [];
  final List<TextEditingController> _phoneControllers = [];

  void _submitForm(GlobalKey<FormState> key, int index) {
    if (key.currentState!.validate()) {
      widget.contactsList[index].name = _nameControllers[index].text;
      widget.contactsList[index].phone = _phoneControllers[index].text;
      String encoded = jsonEncode(widget.contactsList);
      print(encoded);
    }
  }

  Widget buildContacts(List<Contact> contacts) => ListView.builder(
        shrinkWrap: true,
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
                    _submitForm(_contactFormStateKeys[index], index);
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Контакты'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          buildContacts(widget.contactsList),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              _save();
            },
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }

  void _save() {
    String encoded = jsonEncode(widget.contactsList);
    print(encoded);
  }
}
