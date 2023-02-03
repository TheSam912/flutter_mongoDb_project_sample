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

  @override
  Widget build(BuildContext context) {
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
                      insertData(fnameController.text, lnameController.text,
                          addressController.text);
                    },
                    child: const Text('Inser data'))
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

  void clearAll(){
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
