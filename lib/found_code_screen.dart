import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
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
  final List<bool> _disabled = [];

  void _submitForm(GlobalKey<FormState> key, int index) {
    if (key.currentState!.validate()) {
      widget.contactsList[index].name = _nameControllers[index].text;
      widget.contactsList[index].phone = _phoneControllers[index].text;
      setState(() {
        _disabled[index] = true;
      });
    }
  }

  Widget buildContacts() => ListView.builder(
        shrinkWrap: true,
        itemCount: widget.contactsList.length,
        itemBuilder: (context, index) {
          final Contact contact = widget.contactsList[index];

          _contactFormStateKeys.add(GlobalKey<FormState>());

          _nameControllers.add(TextEditingController(text: contact.name));
          _phoneControllers.add(TextEditingController(text: contact.phone));
          _disabled.add(true);

          return Form(
            key: _contactFormStateKeys[index],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    key: const Key('name'),
                    decoration:
                        const InputDecoration(border: UnderlineInputBorder()),
                    controller: _nameControllers[index],
                    onChanged: (value) {
                      if (_disabled[index] == true) {
                        setState(() {
                          _disabled[index] = false;
                        });
                      }
                    },
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
                    decoration:
                        const InputDecoration(border: UnderlineInputBorder()),
                    controller: _phoneControllers[index],
                    keyboardType: TextInputType.phone,
                    inputFormatters: [MaskedInputFormatter('+# (###) ###-####', allowedCharMatcher: RegExp(r'[0-9]'))],
                    onChanged: (value) {
                      if (_disabled[index] == true) {
                        setState(() {
                          _disabled[index] = false;
                        });
                      }
                    },
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
                  onPressed: _disabled[index]
                      ? null
                      : () {
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
      ),
      body: Column(
        children: [
          buildContacts(),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
