import 'package:flutter/material.dart';
import 'package:testproject/contact.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

Future<List<Contact>> _getContacts() async {
  var databasesPath = await getDatabasesPath();
  var path = p.join(databasesPath, "contacts.db");
  Database db = await openDatabase(path);
  var mapContactList = await db.query('contacts');
  List<Contact> list = List<Contact>.from(
      mapContactList.map((model) => Contact.fromJson(model)));
  return list;
}

class ContactList extends StatelessWidget {
  const ContactList({super.key});

  Widget buildContacts(List<Contact> list) => ListView.builder(
      shrinkWrap: true,
      itemCount: list.length,
      itemBuilder: (context, index) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(list[index].name),
            Text(list[index].phone),
          ],
        );
      },
    );
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Контакты'),
      ),
      body: 
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: FutureBuilder(
          future: _getContacts(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return buildContacts(snapshot.data);
              case ConnectionState.none:
                return const Text('none');
              case ConnectionState.waiting:
                return const Center(child: CircularProgressIndicator());
              case ConnectionState.active:
                return const Text('active');
            }
          },
        ),
      ),
    );
  }
}

