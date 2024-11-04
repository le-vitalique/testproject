import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:testproject/contact.dart';
import 'package:sqflite/sqflite.dart';
import 'package:testproject/contact_list.dart';
import 'package:testproject/database_helper.dart';

class AddContacts extends StatefulWidget {
  final List<Contact> contactList;

  const AddContacts({
    super.key,
    required this.contactList,
  });

  @override
  State<StatefulWidget> createState() => _AddContactsState();
}

class _AddContactsState extends State<AddContacts> {
  final List<GlobalKey<FormState>> _contactFormStateKeys = [];
  final List<TextEditingController> _nameControllers = [];
  final List<TextEditingController> _phoneControllers = [];
  final List<bool> _saved = [];

  void _addContact(GlobalKey<FormState> key, int index) async {
    if (key.currentState!.validate()) {
      widget.contactList[index].name = _nameControllers[index].text;
      widget.contactList[index].phone = _phoneControllers[index].text;

      try {
        await DatabaseHelper.addContact(widget.contactList[index]);
        setState(() {
          _saved[index] = true;
          widget.contactList.removeAt(index);
          _saved.removeAt(index);
          _nameControllers.removeAt(index);
          _phoneControllers.removeAt(index);
          _contactFormStateKeys.removeAt(index);
        });
      } on DatabaseException catch (e) {
        if (mounted) {
          String msg = (e.isUniqueConstraintError())
              ? 'Контакт с такими данными уже существует!'
              : e.toString();
          showDialog(
            context: context,
            builder: (BuildContext context) => (AlertDialog(
              title: const Text('Ошибка!'),
              content: Text(msg),
              actions: [
                TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            )),
          );
        }
      }
    }
  }

  Widget buildContacts() => ListView.builder(
        shrinkWrap: true,
        itemCount: widget.contactList.length,
        itemBuilder: (context, index) {
          // final Contact contact = widget.contactList[index];

          _contactFormStateKeys.add(GlobalKey<FormState>());
          _nameControllers
              .add(TextEditingController(text: widget.contactList[index].name));
          _phoneControllers.add(
              TextEditingController(text: widget.contactList[index].phone));
          _saved.add(false);

          return Form(
            key: _contactFormStateKeys[index],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    key: const Key('name'),
                    readOnly: _saved[index] ? true : false,
                    decoration:
                        const InputDecoration(border: UnderlineInputBorder()),
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
                    readOnly: _saved[index] ? true : false,
                    decoration:
                        const InputDecoration(border: UnderlineInputBorder()),
                    controller: _phoneControllers[index],
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      MaskedInputFormatter(
                        '+# (###) ###-####',
                        allowedCharMatcher: RegExp(r'[0-9]'),
                      ),
                    ],
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
                  key: const Key('add'),
                  onPressed: _saved[index]
                      ? null
                      : () {
                          _addContact(_contactFormStateKeys[index], index);
                        },
                  disabledColor: Theme.of(context).iconTheme.color,
                  icon: _saved[index]
                      ? const Icon(Icons.check)
                      : const Icon(Icons.add),
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
        title: const Text('Добавить контакты'),
      ),
      body: Stack(
        children: [
          buildContacts(),
          Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton.icon(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ContactList(),
                  ),
                );
              },
              label: const Text('Список контактов'),
              icon: const Icon(Icons.contacts),
            ),
          ),
        ],
      ),
    );
  }
}
