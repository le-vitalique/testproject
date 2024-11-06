import 'package:flutter/material.dart';
import 'package:testproject/models/contact.dart';
import 'package:testproject/helpers/database_helper.dart';
import 'package:testproject/ui/dialogs.dart';

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
        padding: const EdgeInsets.only(bottom: 80),
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
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ConfirmDeleteDialog(
                        contact: list[index],
                        callback: () {
                          setState(() {});
                        },
                      );
                    },
                  );
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
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return ConfirmDeleteDialog(
                callback: () {
                  setState(() {});
                },
              );
            },
          );
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
        future: DatabaseHelper.instance.getAllContacts(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Stack(children: [
                buildContacts(snapshot.data),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: _deleteAll((snapshot.data as List<Contact>).length),
                  ),
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
