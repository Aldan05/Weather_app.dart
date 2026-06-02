import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  final auth = FirebaseAuth.instance;
  final db = FirebaseDatabase.instance.ref();

  Future<User?> register(String email, String password, String name) async {
    UserCredential cred = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await db.child("users/${cred.user!.uid}").set({
      "name": name,
      "email": email,
    });

    return cred.user;
  }

  Future<User?> login(String email, String password) async {
    UserCredential cred = await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return cred.user;
  }

  Future<void> logout() async {
    await auth.signOut();
  }
}
