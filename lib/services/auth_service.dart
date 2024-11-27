import 'package:firebase_auth/firebase_auth.dart';
import 'package:octoloupe/model/user_model.dart';
import 'package:octoloupe/services/database.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Documentation : https://firebase.google.com/docs/auth/flutter/password-auth?hl=fr
  
  // Create account and save user data in Firestore
  Future<UserCredential?> createUserWithEmailAndPassword(
    String email,
    String password,
    String firstName,
    String name,
    String role,
  ) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      //Save information in Firestore
      if (user != null) {
        UserModel newUser = UserModel(
          uid: user.uid,
          email: user.email ?? '',
          password: password,
          firstName: firstName,
          name: name,
          role: role,
        ); 

        // Save user in Firestore
        await DatabaseService(user.uid).createUser(newUser);

        if (!user.emailVerified) {
          await user.sendEmailVerification();
          debugPrint('Email verification is sent to ${user.email}');
        }
      }
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        debugPrint('The password provided is too weak');
      } else if (e.code == 'email-already-in-use') {
        debugPrint('The account alreade exists for that email.');
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
    return null;
  }

  Future<UserCredential?> createAdminWithEmailAndPassword(
    String email,
    String password,
    String firstName,
    String name,
    String role,
  ) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        role = "admin";

        UserModel newUser = UserModel(
          uid: user.uid,
          email: user.email ?? '',
          password: password,
          firstName: firstName,
          name: name,
          role: role,
        );

        await DatabaseService(user.uid).createUser(newUser);

        if (!user.emailVerified) {
          await user.sendEmailVerification();
          debugPrint('Email verification is sent to ${user.email}');
        }
      }
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        debugPrint('The password provided is too weak');
      } else if (e.code == 'email-already-in-use') {
        debugPrint('The account already exists for that email.');
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
    return null;
  }


  //SignIn with email and password
  Future<UserCredential?> signInWithEmailAndPassword(
    String email,
    String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password
      );

      //Collect user data from firestore
      User? user = userCredential.user;
      if (user != null) {
        UserModel? userData = await DatabaseService(user.uid).getUser();

        if (userData != null) {
          debugPrint('User data: ${userData.firstName} ${userData.name}');
        } else {
          debugPrint('User data not found for user: ${user.uid}');
        }
      }
      return userCredential; 
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        debugPrint('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        debugPrint('Wrong password provided for that user');
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
    return null;
  }

  //SignOut
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      debugPrint('Disconnected');
    } catch (e) {
      debugPrint('Disconnection failed: $e');
    }
  }

  // Checking if user is connected
  User? getCurrentUser() {
    return _auth.currentUser;
  }

/*  //Update email
  Future<void> updateEmail(String newEmail) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.verifyBeforeUpdateEmail(newEmail);
        debugPrint('Email updated successfully');
      } else {
        debugPrint('No user is currently signed in');
      }
    } catch (e) {
      debugPrint('Error updating email: $e');
    }
  } */

  //Send email to reset password
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email,
      );
      debugPrint('Password reset email sent to $email');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        debugPrint('The email address is not valid.');
      } else if (e.code == 'user-not-found') {
        debugPrint('No user found for that email.');
      }
    } catch (e) {
      debugPrint('Error sending password reset email: $e');
    }
  }

  //Update user password
  Future<void> updatePassword(String newPassword) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.updatePassword(newPassword);
        debugPrint('Password updated successfully');
      } else {
        debugPrint('No user is currently signed in');
      }
    } catch (e) {
      debugPrint('Error updating password: $e');
    }
  }

  //Delete User
  Future<void> deleteUser() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await DatabaseService(user.uid).deleteUser();
        await user.delete();
        debugPrint('User deleted');
      } else {
        debugPrint('No user is currently signed in');
      }
    } catch (e) {
      debugPrint('Deletion failed: $e');
    }
  }

  /*
  // JWT
  // Get ID token
  Future<String?> getIdToken() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String? idToken = await user.getIdToken();
        debugPrint('ID token: $idToken');
        return idToken;
      } else {
        debugPrint('No user is currently signed in.');
        return null;
      }
    } catch (e) {
      debugPrint('Error getting Id token: $e');
      return null;
    }
  }

  Future<String?> getRefreshedToken() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String? refreshedToken = await user.getIdToken(true);
        debugPrint('Refreshed token : $refreshedToken');
        return refreshedToken;
      } else {
        debugPrint('No user is currently signed in.');
        return null;
      }
    } catch (e) {
      debugPrint('Error getting refreshed Id token : $e');
      return null;
    }
  }

  //Sending token to back-end
  Future<void> sentTokenToBackend(String token) async {
    final response = await http.post(
      Uri.parse(''),
      headers: {
        'Authorization': 'Bearer $token',
      },
      body: {
        
      },
    );

    if (response.statusCode == 200) {
      debugPrint("Request succcessful");
    } else {
      debugPrint("Failed to authenticate with back-end");
    }
  } */

}