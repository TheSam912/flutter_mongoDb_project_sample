import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mongo_db_sample/dbHelper/mongodb.dart';
import 'package:flutter_mongo_db_sample/model/mongoDbModel.dart';
import 'package:mongo_dart/mongo_dart.dart' as myMongo;

class InsertData extends StatefulWidget {
  const InsertData({Key? key}) : super(key: key);

  @override
  State<InsertData> createState() => _InsertDataState();
}

class _InsertDataState extends State<InsertData> {
  var fnameController = TextEditingController();
  var lnameController = TextEditingController();
  var addressController = TextEditingController();

  var _checkInsertUpdate = "Insert";

  @override
  Widget build(BuildContext context) {
    MongoDbModel data =
        ModalRoute.of(context)?.settings.arguments as MongoDbModel;

    if (data != null) {
      print("------------------------${data.id}");
      fnameController.text = data.firstName;
      lnameController.text = data.lastName;
      addressController.text = data.address;
      _checkInsertUpdate = "Update";
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Insert Data"),
        centerTitle: true,
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            TextField(
              controller: fnameController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal)),
                  label: Text('First name')),
            ),
            const SizedBox(
              height: 12,
            ),
            TextField(
              controller: lnameController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal)),
                  label: Text('Last name')),
            ),
            const SizedBox(
              height: 12,
            ),
            TextField(
              controller: addressController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal)),
                  label: Text('Address')),
              minLines: 3,
              maxLines: 5,
            ),
            const SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                    onPressed: () {
                      _fakeData();
                    },
                    child: const Text('Generate data')),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (_checkInsertUpdate == "Insert") {
                          insertData(fnameController.text, lnameController.text,
                              addressController.text);
                        } else if (_checkInsertUpdate == "Update") {
                          updateData(data.id, fnameController.text, lnameController.text,
                              addressController.text);
                        }
                      });
                    },
                    child: Text(_checkInsertUpdate))
              ],
            )
          ],
        ),
      )),
    );
  }

  Future<void> insertData(String fName, String lName, String address) async {
    var _id = myMongo.ObjectId();
    final data = MongoDbModel(
        id: _id, firstName: fName, lastName: lName, address: address);
    var result = await MongoDataBase.insert(data);
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Data inserted id: ${_id.$oid}")));
    clearAll();
  }

  Future<void> updateData(
      var id, String fName, String lName, String address) async {
    final updateData = MongoDbModel(
        id: id, firstName: fName, lastName: lName, address: address);
    await MongoDataBase.update(updateData).whenComplete(() {
      Navigator.pop(context);
    });
  }

  void clearAll() {
    fnameController.text = "";
    lnameController.text = "";
    addressController.text = "";
  }

  void _fakeData() {
    setState(() {
      fnameController.text = faker.person.firstName();
      lnameController.text = faker.person.lastName();
      addressController.text =
          "${faker.address.streetName()}/n${faker.address.streetAddress()}";
    });
  }
}
