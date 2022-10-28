import 'package:flutter/material.dart';
import 'package:m_expense/TripDetails/newTrip.dart';
import 'package:m_expense/TripDetails/routes.dart';

import 'TripDetails/tripdetails.dart';

void main() {
  runApp(TripDetails());
}

class TripDetails extends StatelessWidget {
  const TripDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        Routes.tripDetails: (context) => const tripDetails(),
        Routes.newTrip: (context) => newTrip()
      },
      initialRoute: Routes.tripDetails,
    );
  }
}
