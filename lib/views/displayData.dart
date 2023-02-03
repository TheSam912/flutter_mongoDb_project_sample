import 'package:flutter/material.dart';
import 'package:flutter_mongo_db_sample/dbHelper/mongodb.dart';
import 'package:flutter_mongo_db_sample/model/mongoDbModel.dart';

class DisplayData extends StatefulWidget {
  const DisplayData({Key? key}) : super(key: key);

  @override
  State<DisplayData> createState() => _DisplayDataState();
}

class _DisplayDataState extends State<DisplayData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Display all data"),
        centerTitle: true,
      ),
      body: SafeArea(
          child: FutureBuilder(
        future: MongoDataBase.getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: displayCard(
                          MongoDbModel.fromJson(snapshot.data![index])),
                    );
                  });
            } else {
              return const Center(
                child: Text("No data available"),
              );
            }
          }
        },
      )),
    );
  }

  Widget displayCard(MongoDbModel data) {
    return Card(
      elevation: 20,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${data.id}"),
            const Divider(thickness: 1),
            Text("First name: ${data.firstName}"),
            const Divider(
              thickness: 1,
            ),
            Text("Last name: ${data.lastName}"),
            const Divider(
              thickness: 1,
            ),
            Text("Address: ${data.address}"),
          ],
        ),
      ),
    );
  }
}
