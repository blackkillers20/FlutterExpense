import 'package:flutter/material.dart';
import 'package:m_expense/TripDetails/databasehelper.dart';
import 'package:m_expense/TripDetails/routes.dart';
import 'package:sqflite/sqflite.dart';
import 'package:m_expense/TripDetails/newTrip.dart';

class tripDetails extends StatefulWidget {
  const tripDetails({super.key});

  @override
  State<tripDetails> createState() => TripDetailsState();
}

class TripDetailsState extends State<tripDetails> {
  List<Map<String, dynamic>> _Trips = [];
  bool _isloading = true;
  late int id;
  // DatabaseHelper databaseHelper = new DatabaseHelper();

  // void showTrips() {
  //   Future.delayed(Duration(milliseconds: 500), () async {
  //     final data = await DatabaseHelper.getAllTrip();
  //     setState(() {
  //       _Trips = data;
  //       _isloading = false;
  //     });
  //   });
  // }

  void showTrips() async {
    final data = await DatabaseHelper.getAllTrip();
    setState(() {
      _Trips = data;
      _isloading = false;
    });
  }

  void Remove(int id) async {
    await DatabaseHelper.DeleteTrips(id);
    showTrips();
  }

  void initState() {
    super.initState();
    showTrips();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, Routes.newTrip);
            },
            child: const Icon(Icons.add),
          ),
          appBar: AppBar(
            title: const Text('M_Expense'),
          ),
          body: _isloading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemCount: _Trips.length,
                  itemBuilder: (context, index) => Card(
                        color: Color.fromARGB(255, 111, 185, 245),
                        margin: const EdgeInsets.all(15),
                        child: ListTile(
                          title: Text(_Trips[index]['tripName']),
                          subtitle: Text(_Trips[index]['Destination']),
                          trailing: SizedBox(
                            width: 100,
                            child: Row(children: [
                              IconButton(
                                  onPressed: (() =>
                                      Remove(_Trips[index]["id"])),
                                  icon: const Icon(Icons.delete)),
                              IconButton(
                                  onPressed: (() => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: ((context) => newTrip(
                                              id: _Trips[index]["id"]))))),
                                  icon: const Icon(Icons.edit))
                            ]),
                          ),
                        ),
                      ))),
    );
  }
}
