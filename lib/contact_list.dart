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
  late List<Contact> contactList;
  bool isInit = false;

  @override
  initState() {
    super.initState();
    _dbInit();
    print('initState');
  }

  void _dbInit() async {
    var databasesPath = await getDatabasesPath();
    var path = p.join(databasesPath, "contacts.db");

    // await deleteDatabase(path);
    // var exists = await databaseExists(path);
    // print(exists);

    // Open the database, specifying a version and an onCreate callback
    _db = await openDatabase(path, version: 1, onCreate: _onCreate);

    // exists = await databaseExists(path);
    print('dbinit');
    print(_db.isOpen);

    var mapContactList = await _db.query('contacts');
    setState(() {
      contactList = List<Contact>.from(
          mapContactList.map((model) => Contact.fromJson(model)));
      print(contactList.length);
    });

    isInit = true;
  }

  _onCreate(Database db, int version) async {
    // Database is created, create the table
    await db.execute(
        "CREATE TABLE Contacts (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, phone TEXT)");
    // populate data
    // await db.insert(...);
  }

  Widget buildContacts() => ListView.builder(
        shrinkWrap: true,
        itemCount: contactList.length,
        itemBuilder: (context, index) {
          print('buildContacts');
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(contactList[index].name),
              Text(contactList[index].phone),
            ],
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    print('build');
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Контакты'),
      ),
     body: (isInit) ? Padding(padding: const EdgeInsets.all(10.0), child: buildContacts(),) : Container(),
    );
  }
}
