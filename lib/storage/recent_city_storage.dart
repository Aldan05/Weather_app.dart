import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/recent_city_model.dart';

class RecentCityStorage {
  final db = FirebaseDatabase.instance.ref();
  
  String get uid => FirebaseAuth.instance.currentUser?.uid ?? "";

  Future<void> saveCity(RecentCityModel city) async {
    if (uid.isEmpty) return;
    // Changed toMap() to toJson() to match the model
    await db.child("users/$uid/recent_cities").push().set(city.toJson());
  }

  Stream<List<RecentCityModel>> getRecentCities() {
    if (uid.isEmpty) return Stream.value([]);
    return db.child("users/$uid/recent_cities").onValue.map((event) {
      final data = event.snapshot.value as Map?;
      if (data == null) return [];

      return data.values
          .map((e) => RecentCityModel.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    });
  }
}
