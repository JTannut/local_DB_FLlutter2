import 'dart:io';
import 'package:checkpoint3/models/Transactions.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class TransactionDB {
  //บริการเกียวกับฐานข้อมูล

  String dbName; //เก็บชื่อฐานข้อมูล

  // ถ้ายังไม่ถูกสร้าง => สร้าง
  // ถูกสร้างไว้แล้ว => เปิด
  TransactionDB({this.dbName});

  Future<Database> openDatabase() async {
    //หาตำแหน่งที่จะเก็บข้อมูล
    Directory appDirectory = await getApplicationDocumentsDirectory();
    String dbLocation = join(appDirectory.path, dbName);
    // สร้าง database
    DatabaseFactory dbFactory = await databaseFactoryIo;
    Database db = await dbFactory.openDatabase(dbLocation);
    return db;
  }

  //บันทึกข้อมูล
  Future<int> InsertData(Transactions statement) async {
    //ฐานข้อมูล => Store
    // transaction.db => expense
    var db = await this.openDatabase();
    var store = intMapStoreFactory.store("expense");

    // json
    var keyID = store.add(db, {
      "title": statement.title,
      "lastnaem": statement.lastname,
      "address": statement.address,
      "amount": statement.amount,
      "Email": statement.email,
      "Password": statement.password,
      "date": statement.date.toIso8601String()
    });
    db.close();
    return keyID;
  }

  Future<List<Transactions>> loadAllData() async {
    var db = await this.openDatabase();
    var store = intMapStoreFactory.store("expense");
    var snapshot = await store.find(db,
        finder: Finder(sortOrders: [SortOrder(Field.key, false)]));
    List transactionList = List<Transactions>();
    //ดึงมาทีละแถว
    for (var record in snapshot) {
      transactionList.add(Transactions(
          title: record["title"],
          lastname: record["lastname"],
          address: record["address"],
          amount: record["amount"],
          email: record["email"],
          password: record["password"],
          date: DateTime.parse(record["date"])));
    }
    return transactionList;
  }
}