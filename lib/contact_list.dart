import 'package:flutter/material.dart';
import 'package:testproject/contact.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class ContactList extends StatefulWidget {
  const ContactList({super.key});

  @override
  State<StatefulWidget> createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  late Database _db;
  List<Contact>? contactList;

  @override
  initState() {
    super.initState();
    _dbInit().then((value) {
      setState(() {
        contactList = value;
      });
      print('initState');
      print(contactList);
    });
  }

  Future<List<Contact>> _dbInit() async {
    var databasesPath = await getDatabasesPath();
    var path = p.join(databasesPath, "contacts.db");
    // Delete the database
    // await deleteDatabase(path);
    // Open the database, specifying a version and an onCreate callback
    _db = await openDatabase(path, version: 1, onCreate: _onCreate);
    var mapContactList = await _db.query('contacts');
    List<Contact> list = List<Contact>.from(
        mapContactList.map((model) => Contact.fromJson(model)));
    return list;
  }

  _onCreate(Database db, int version) async {
    // Database is created, create the table
    await db.execute(
        "CREATE TABLE Contacts (name TEXT, phone TEXT, UNIQUE(name, phone))");
  }

  Widget buildContacts() => ListView.builder(
        shrinkWrap: true,
        itemCount: contactList!.length,
        itemBuilder: (context, index) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(contactList![index].name),
              Text(contactList![index].phone),
            ],
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    print('contactList == null is ${contactList == null}');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Контакты'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: (contactList != null)
            ? buildContacts()
            : Center(
                child: Text('Нет данных'),
              ),
      ),
    );
  }
}
