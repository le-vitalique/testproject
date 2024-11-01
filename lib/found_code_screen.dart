// Screen with scanned code value
import 'package:flutter/material.dart';
import 'package:testproject/contact.dart';

class FoundCodeScreen extends StatefulWidget {
  // final String value;
  final List<Contact> value;
  final Function() screenClosed;

  const FoundCodeScreen({
    super.key,
    required this.value,
    required this.screenClosed,
  });

  @override
  State<StatefulWidget> createState() => _FoundCodeScreenState();
}

class _FoundCodeScreenState extends State<FoundCodeScreen> {
  List<Contact> contacts = getContacts();

  static List<Contact> getContacts() {
    const data = [
      {"id": 0, "name": "Rosalind Charles", "phone": "+1 (854) 436-2113"},
      {"id": 1, "name": "Rosemarie Stark", "phone": "+1 (902) 559-3648"},
      {"id": 2, "name": "Massey Parker", "phone": "+1 (887) 412-2951"},
      {"id": 3, "name": "Koch Whitney", "phone": "+1 (918) 473-3084"},
      {"id": 4, "name": "Padilla Wolfe", "phone": "+1 (931) 480-3519"}
    ];

    return data.map<Contact>(Contact.fromJson).toList();
  }

  Widget buildUsers(List<Contact> contacts) => ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final contact = contacts[index];
          return Text(contact.name);
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
        body:
            //buildUsers(contacts),
            Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Scanned Code:'),
                // Text(widget.value),
                Expanded(
                  // child: buildUsers(contacts),
                  child: buildUsers(widget.value),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
