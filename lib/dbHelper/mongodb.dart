import 'dart:developer';

import 'package:flutter_mongo_db_sample/dbHelper/constant.dart';
import 'package:flutter_mongo_db_sample/model/mongoDbModel.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MongoDataBase {
  static var db, userCollection;

  static connect() async {
    db = await Db.create(MONGO_CONN_URL);
    await db.open();
    userCollection = db.collection(USER_COLLECTION);
  }

  static Future<List<Map<String,dynamic>>> getData() {
    final arrayData = userCollection.find().toList();
    return arrayData;
  }

  static Future<String> insert(MongoDbModel data) async {
    try {
      var result = await userCollection.insertOne(data.toJson());
      if(result.isSuccess){
        return "Data Inserted !";
      }else{
        return "Something wrong";
      }
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }
}
