import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:testproject/models/contact.dart';

class DatabaseHelper {
  static const int _version = 1;
  static const String _databaseName = 'contacts.db';
  static const String _tableName = 'contacts';

  DatabaseHelper._();

  static final DatabaseHelper instance = DatabaseHelper._();

  static Database? _database;

  Future<Database> get database async {
    return _database ??= await _getDatabase();
  }

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

  Future<int> deleteAllContacts() async {
    final Database db = await database;
    return await db.delete(_tableName);
  }

  Future<int> addContact(Contact contact) async {
    final Database db = await database;
    return await db.insert(_tableName, contact.toJson());
  }

  Future<List<Contact>> getAllContacts() async {
    final Database db = await database;
    var mapContactList = await db.query('contacts');
    List<Contact> list = List<Contact>.from(
        mapContactList.map((model) => Contact.fromJson(model)));
    return list;
  }

  Future<int> deleteContact(Contact contact) async {
    final Database db = await database;
    return await db.delete(_tableName,
        where: 'name = ? and phone = ?',
        whereArgs: [contact.name, contact.phone]);
  }
}
