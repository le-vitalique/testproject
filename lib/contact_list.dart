import 'package:flutter/material.dart';
import 'package:testproject/contact.dart';
import 'package:testproject/database_helper.dart';

class ContactList extends StatefulWidget {
  const ContactList({super.key});

  @override
  State<ContactList> createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  String _getInitials(String name) => name.isNotEmpty
      ? name.trim().split(RegExp(' +')).map((s) => s[0]).take(2).join()
      : '';

  Widget buildContacts(List<Contact> list) => ListView.builder(
        shrinkWrap: true,
        itemCount: list.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                child: Text(_getInitials(list[index].name)),
              ),
              title: Text(list[index].name),
              subtitle: Text(list[index].phone),
              trailing: IconButton(
                icon: const Icon(Icons.delete_forever),
                onPressed: () async {
                  await DatabaseHelper.deleteContact(list[index]);
                  setState(() {});
                },
              ),
            ),
          );
        },
      );

  Widget _deleteAll(int length) {
    if (length != 0) {
      return ElevatedButton.icon(
        onPressed: () async {
          await DatabaseHelper.deleteAllContacts();
          setState(() {});
        },
        label: const Text('Удалить все'),
        icon: const Icon(Icons.delete_forever),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Список контактов'),
      ),
      body: FutureBuilder(
        future: DatabaseHelper.getAllContacts(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Stack(children: [
                buildContacts(snapshot.data),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: _deleteAll((snapshot.data as List<Contact>).length),
                ),
              ]);
            case ConnectionState.none:
              return const Text('none');
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.active:
              return const Text('active');
          }
        },
      ),
    );
  }
}
