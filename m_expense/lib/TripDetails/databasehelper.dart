// ignore_for_file: use_function_type_syntax_for_parameters

import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart' as sql;

class DatabaseHelper {
  static Future<void> create(sql.Database database) async {
    await database
        .execute('''CREATE TABLE details(id INTEGER PRIMARY KEY AUTOINCREMENT,
    tripName TEXT, Destination TEXT, StartDate TEXT, EndDate TEXT, RiskAssessment TEXT, Description TEXT)''');

    await database.execute(
        '''CREATE TABLE TripName (id INTEGER PRIMARY KEY AUTOINCREMENT, Name TEXT)''');
  }

  static Future<sql.Database> dtb() async {
    return sql.openDatabase('MEXPENSE.db', version: 1,
        onCreate: (sql.Database database, int version) async {
      await create(database);
    });
  }

  static Future<int> createTrip(String tripName, String Destination,
      String StartDate, String EndDate, String Risk, String Description) async {
    final db = await DatabaseHelper.dtb();

    final data = {
      'tripName': tripName,
      'Destination': Destination,
      'StartDate': StartDate,
      'EndDate': EndDate,
      'RiskAssessment': Risk,
      'Description': Description
    };
    final id = await db.insert('details', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<Map<String, dynamic>> getTrip(int id) async {
    final db = await DatabaseHelper.dtb();
    var trip =
        await db.query('details', where: "id = ?", whereArgs: [id], limit: 1);
    return trip[0];
  }

  static Future<List<Map<String, dynamic>>> getAllTrip() async {
    final db = await DatabaseHelper.dtb();
    return db.query('details', orderBy: "id");
  }

  static Future<int> updateTrip(int id, String tripName, String Destination,
      String StartDate, String EndDate, String Risk, String Description) async {
    final db = await DatabaseHelper.dtb();

    final data = {
      'tripName': tripName,
      'Destination': Destination,
      'StartDate': StartDate,
      'EndDate': EndDate,
      'RiskAssessment': Risk,
      'Description': Description
    };

    final results =
        await db.update("details", data, where: " id = ? ", whereArgs: [id]);
    return results;
  }

  static Future<void> DeleteTrips(int id) async {
    final db = await DatabaseHelper.dtb();
    try {
      await db.delete("details", where: " id = ? ", whereArgs: [id]);
    } catch (exception) {
      debugPrint("Something went wrong when deleting an Trips: $exception");
    }
  }
}
