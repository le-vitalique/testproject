import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:testproject/contact.dart';

class DatabaseHelper {
  static const int _version = 1;
  static const String _databaseName = 'contacts.db';
  static const String _tableName = 'contacts';

  static Future<Database> _getDatabase() async {
    var databasesPath = await getDatabasesPath();
    var path = p.join(databasesPath, _databaseName);
    // Open the database, specifying a version and an onCreate callback
    return await openDatabase(
      path,
      version: _version,
      onCreate: (db, version) async {
        await db.execute(
            "CREATE TABLE Contacts (name TEXT, phone TEXT, UNIQUE(name, phone))");
      },
    );
  }

  static Future<int> deleteAllContacts() async {
    final Database db = await _getDatabase();
    return await db.delete(_tableName);
  }

  static Future<int> addContact(Contact contact) async {
    final Database db = await _getDatabase();
    return await db.insert(_tableName, contact.toJson());
  }

  static Future<List<Contact>> getAllContacts() async {
    final Database db = await _getDatabase();
    var mapContactList = await db.query('contacts');
    List<Contact> list = List<Contact>.from(
        mapContactList.map((model) => Contact.fromJson(model)));
    return list;
  }

  static Future<int> deleteContact(Contact contact) async {
    final Database db = await _getDatabase();
    return await db.delete(_tableName,
        where: 'name = ? and phone = ?',
        whereArgs: [contact.name, contact.phone]);
  }
}
