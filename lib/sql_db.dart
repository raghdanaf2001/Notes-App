import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqlDB {
  static Database? _db; //under score mean private attribute

  Future<Database?> get db async {
    if (_db == null) {
      _db = await initialDB();
      return _db;
    } else {
      return _db;
    }
  }

  initialDB() async {
    String DBpath = await getDatabasesPath(); //path in my device
    String path = join(DBpath,
        'appnote.db'); //path in my device in addition to the name of my DB
    Database myDB = await openDatabase(path,
        onCreate: _OnCreate,
        version: 2,
        onUpgrade:
            _onUpgrade); //when version changed it calls onUpgrade function (we change the version num when we need to apply changes to my DB)
    return myDB;
  }

  _onUpgrade(Database db, int oldversion, int newversion) async {
    //await db.execute("ALTER TABLE notes ADD COLUMN select TEXT");
    print("===================OnUpgrade");
  }

  _OnCreate(Database db, int version) async {
    await db.execute('''
CREATE TABLE "notes" (
  "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  "note" TEXT,
  "title" TEXT,
  "important" TEXT,
  "date" TEXT
  )
''');
    print("Created DB and It's Table");
  }

  Select(String sql) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.rawQuery(sql); //return records
    return response;
  }

  Insert(String sql) async {
    Database? mydb = await db;
    int response = await mydb!
        .rawInsert(sql); //return 0 (faile) or the number of the added record
    return response;
  }

  Update(String sql) async {
    Database? mydb = await db;
    int response = await mydb!
        .rawUpdate(sql); //return 0 (faile) or the number of the updated record
    return response;
  }

  Delete(String sql) async {
    Database? mydb = await db;
    int response = await mydb!
        .rawDelete(sql); //return 0 (faile) or the number of the deleted record
    return response;
  }

  DeleteDataBase() async {
    String DBpath = await getDatabasesPath(); //path in my device
    String path = join(DBpath, 'raghdan.db');
    await deleteDatabase(path);
    print("Deleted");
  }
}
