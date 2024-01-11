import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final userCollection = FirebaseFirestore.instance.collection("users");
  final firebaseAuth = FirebaseAuth.instance;
  Future<void> registerUserWithAuth(
      {required String name,
      required String email,
      required String password}) async {
    try {
      final UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        String uid = userCredential.user!.uid;
        _registerUser(uid: uid, name: name, email: email, password: password);

        print("Kayıt oluşturuldu");
      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

  Future<void> signInWithAuth(
      {required String email, required String password}) async {
    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        String uid = userCredential.user!.uid;
        DocumentSnapshot userDoc = await userCollection.doc(uid).get();
        String userName = userDoc.exists ? userDoc['name'] : 'asd';
        print("Giriş başarılı. Kullanıcı adı: $userName");
      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

  Future<void> _registerUser(
      {required String uid,
      required String name,
      required String email,
      required String password}) async {
    await userCollection.doc(uid).set({
      "email": email,
      "name": name,
      "password": password,
    });
  }

  Future<String> getUserName({required String uid}) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();
      return userDoc['name'];
    } else {
      return 'Hata';
    }
  }
}
