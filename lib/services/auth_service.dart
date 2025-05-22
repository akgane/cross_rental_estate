import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:rental_estate_app/providers/theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<AppUser?> get user {
    return _auth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;
      return await _getUserData(user.uid);
    });
  }

  Future<AppUser?> _getUserData(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();

    return (
        doc.exists
            ? AppUser.fromFirestore(doc.data()!, uid)
            : null
    );
  }

  Future<AppUser?> registerWithEmail(String email,
      String password,
      String username) async {
    print("$email | $password | $username");
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );

      final user = AppUser(
          uid: credential.user!.uid,
          email: email,
          username: username
      );

      await _firestore
          .collection('users')
          .doc(credential.user!.uid)
          .set(user.toFirestore());

      return user;
    }on FirebaseException catch (e){
      debugPrint('Firebase registration exception: $e');
      return null;
    }catch (e){
      debugPrint('Unknown registration exception: $e');
      return null;
    }
  }

  Future<AppUser?> loginWithEmail(
      String email,
      String password) async{
    print("$email | $password");
    try{
      final credential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );

      final user = await _getUserData(credential.user!.uid);
      if (user == null) {
        throw Exception('User data not found');
      }
      return user;
    }on FirebaseAuthException catch (e){
      debugPrint('Firebase login exception: $e');
      throw e;
    }catch (e){
      debugPrint('Unknown login exception: $e');
      throw e;
    }
  }

  Future<AppUser> loginAsGuest() async{
    try{
      final credential = await _auth.signInAnonymously();
      return guestCreator(credential.user!.uid);
    }on FirebaseAuthException catch(e){
      debugPrint('Firebase signInAnonymously exception: $e');
      return guestCreator(null);
    }catch(e){
      debugPrint('Unknown login exception: $e');
      return guestCreator(null);
    }
  }

  Future<void> signOut() async{
    await _auth.signOut();
  }

  Future<void> updateUser(AppUser user) async {
    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .update(user.toFirestore());
    } on FirebaseException catch (e) {
      debugPrint('Firebase update user exception: $e');
      throw e;
    } catch (e) {
      debugPrint('Unknown update user exception: $e');
      throw e;
    }
  }

  Future<void> updateUsername(String uid, String newUsername) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .update({'username': newUsername});
    } on FirebaseException catch (e) {
      debugPrint('Firebase update username exception: $e');
      throw e;
    } catch (e) {
      debugPrint('Unknown update username exception: $e');
      throw e;
    }
  }

  Future<void> updateEmail(String uid, String newEmail) async {
    try {
      // Обновляем email в Firebase Auth
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        await currentUser.updateEmail(newEmail);
        
        // Обновляем email в Firestore
        await _firestore
            .collection('users')
            .doc(uid)
            .update({'email': newEmail});
      } else {
        throw Exception('No authenticated user found');
      }
    } on FirebaseException catch (e) {
      debugPrint('Firebase update email exception: $e');
      throw e;
    } catch (e) {
      debugPrint('Unknown update email exception: $e');
      throw e;
    }
  }

  AppUser guestCreator(String? uid){
    return AppUser(
      uid: uid ?? 'uid',
      email: 'no email',
      username: 'Guest', //TODO loc
    );
  }

  Future<AppUser?> getUserById(String userId) async {
    try {
      final userData = await _getUserData(userId);
      if (userData == null) {
        throw Exception('User not found');
      }
      return userData;
    } catch (e) {
      debugPrint('Error getting user by ID: $e');
      throw e;
    }
  }
}