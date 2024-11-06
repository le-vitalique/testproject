import 'package:flutter/material.dart';
import 'package:testproject/models/contact.dart';
import 'package:testproject/helpers/database_helper.dart';

class ConfirmDeleteDialog extends StatelessWidget {
  const ConfirmDeleteDialog({
    super.key,
    this.contact,
    required this.callback,
  });

  final Contact? contact;
  final Function callback;

  @override
  Widget build(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("Нет"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget confirmButton = TextButton(
      child: const Text("Да"),
      onPressed: () async {
        if (contact == null) {
          await DatabaseHelper.instance.deleteAllContacts();
        } else {
          await DatabaseHelper.instance.deleteContact(contact!);
        }
        if (context.mounted) {
          Navigator.pop(context);
        }
        callback();
      },
    );

    return AlertDialog(
      icon: const CircleAvatar(
        child: Icon(Icons.question_mark),
      ),
      title:
          Text((contact == null) ? 'Удалить все контакты' : 'Удалить контакт?'),
      content: Text((contact == null)
          ? 'Вы действительно хотите удалить все контакты?'
          : 'Вы действительно хотите удалить контакт?'),
      actions: [
        cancelButton,
        confirmButton,
      ],
    );
  }
}
