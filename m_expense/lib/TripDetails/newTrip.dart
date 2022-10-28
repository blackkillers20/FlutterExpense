import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:m_expense/TripDetails/databasehelper.dart';
import 'package:m_expense/TripDetails/routes.dart';
import 'package:m_expense/TripDetails/tripdetails.dart';

class newTrip extends StatefulWidget {
  int? id;
  newTrip({super.key, this.id});

  @override
  State<newTrip> createState() => _newTripState();
}

class _newTripState extends State<newTrip> {
  final TextEditingController txtName = TextEditingController();
  final TextEditingController txtDestination = TextEditingController();
  final TextEditingController txtStartDate = TextEditingController();
  final TextEditingController txtEndDate = TextEditingController();
  String title = "Create a new Trip";
  bool Risk = false;
  final TextEditingController txtDescription = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  // DatabaseHelper databaseHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    if (widget.id != null) {
      if (widget.id != 0) {
        title = "Editor";
        DatabaseHelper.getTrip(widget.id!).then((trip) => {
              setState(() => {
                    txtName.text = trip['tripName'],
                    txtDestination.text = trip['Destination'],
                    txtStartDate.text = trip['StartDate'],
                    txtEndDate.text = trip['EndDate'],
                    Risk = trip['RiskAssessment'] == 'true',
                    txtDescription.text = trip['Description'],
                  })
            });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text(title),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                  key: _formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          validator: requiredfield,
                          controller: txtName,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            hintText: "Trip Name",
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          validator: requiredfield,
                          controller: txtDestination,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            hintText: "Destination",
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          validator: requiredfield,
                          controller: txtStartDate,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            hintText: "Start Date",
                          ),
                          onTap: () => PickedStartDate(context),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                            validator: requiredfield,
                            controller: txtEndDate,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              hintText: "End Date",
                            ),
                            onTap: () => PickedEndDate(context)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(children: [
                          const Text("Risk Assessment"),
                          Switch(
                            value: Risk,
                            onChanged: (choice) => setState(() {
                              Risk = choice;
                            }),
                          ),
                        ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          controller: txtDescription,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            hintText: "Description",
                          ),
                        ),
                      ),
                      widget.id != null
                          ? widget.id != 0
                              ? ElevatedButton(
                                  onPressed: Edit,
                                  child: const Text(
                                    'Edit',
                                    style: TextStyle(fontSize: 20),
                                  ))
                              : ElevatedButton(
                                  onPressed: Save,
                                  child: const Text(
                                    'Save',
                                    style: TextStyle(fontSize: 20),
                                  ))
                          : ElevatedButton(
                              onPressed: Save,
                              child: const Text(
                                'Save',
                                style: TextStyle(fontSize: 20),
                              ))
                    ],
                  )),
            ),
          )),
    );
  }

  Future<void> PickedStartDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(1900),
        lastDate: DateTime(2050));

    if (newDate == null) {
      return;
    }

    setState(() {
      String format = DateFormat('dd/MM/yyyy').format(newDate);
      txtStartDate.text = format;
    });
  }

  Future<void> PickedEndDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(1900),
        lastDate: DateTime(2050));

    if (newDate == null) {
      return;
    }

    setState(() {
      String format = DateFormat('dd/MM/yyyy').format(newDate);

      txtEndDate.text = format;
    });
  }

  void Save() {
    if (_formkey.currentState!.validate()) {
      setState(() {
        DatabaseHelper.createTrip(
                txtName.text,
                txtDestination.text,
                txtStartDate.text,
                txtEndDate.text,
                Risk.toString(),
                txtDescription.text)
            .then((value) => {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const tripDetails()),
                      ((route) => false))
                });
      });
    }
  }

  void Edit() {
    if (_formkey.currentState!.validate()) {
      DatabaseHelper.updateTrip(
              widget.id!,
              txtName.text,
              txtDestination.text,
              txtStartDate.text,
              txtEndDate.text,
              Risk.toString(),
              txtDescription.text)
          .then((value) => {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const tripDetails()),
                    ((route) => false))
              });
    }
  }

  String? requiredfield(String? value) {
    if (value == null || value.isEmpty) {
      return 'Required Field!';
    }
    return null;
  }
}
