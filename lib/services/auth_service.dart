import 'package:firebase_auth/firebase_auth.dart';
import 'package:octoloupe/components/snackbar.dart';
import 'package:octoloupe/constants/error.dart';
import 'package:octoloupe/model/user_model.dart';
import 'package:octoloupe/CRUD/user_crud.dart';
import 'package:flutter/material.dart';
import 'package:octoloupe/screens/admin_central_page.dart';
import 'package:octoloupe/screens/auth_page.dart';
import 'package:octoloupe/screens/home_page.dart';
import '../components/loader_spinning.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Documentation : https://firebase.google.com/docs/auth/flutter/password-auth?hl=fr
  
  // Create account and save user data in Firestore
  Future<UserCredential?> signUpUser(String email, String password, String firstName, String name, {required BuildContext context, required Function(bool) setLoading}) async {
    try {
      setLoading(true);

      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      //Save information in Firestore
      if (user != null) {
        String role = 'user';
        UserModel newUser = UserModel(
          uid: user.uid,
          email: user.email ?? '',
          firstName: firstName,
          name: name,
          role: role,
        ); 

        // Save user in Firestore
        await UserCRUD(user.uid).createUser(newUser);

        setLoading(false);

        if (context.mounted) {
          CustomSnackBar(
            message: 'Compte utilisateur créé avec succès',
            backgroundColor: Colors.green,
          ).showSnackBar(context);
        }

        if (!user.emailVerified) {
          await user.sendEmailVerification();
        }
      }
      return userCredential;
    } on FirebaseAuthException catch (e) {

      setLoading(false);

      if (context.mounted) {
        CustomSnackBar(
          message: 'Echec de la création de compte utilisateur',
          backgroundColor: Colors.red,
        ).showSnackBar(context);
      }

      if (e.code == 'weak-password') {
        throw Exception(ErrorMessages.weakPassword);
      } else if (e.code == 'email-already-in-use') {
        throw Exception(ErrorMessages.emailAlreadyInUse);
      } else {
        throw Exception('Erreur: ${e.message}');
      }
    }
  }

  Future<UserCredential?> signUpAdmin(String email, String password, String firstName, String name, {required BuildContext context, required Function(bool) setLoading} ) async {
    try {
      setLoading(true);

      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        String role = "admin";
        UserModel newUser = UserModel(
          uid: user.uid,
          email: user.email ?? '',
          firstName: firstName,
          name: name,
          role: role,
        );
        // Ajout de l'utilisateur à la base de données
        await UserCRUD(user.uid).createUser(newUser);

        setLoading(false);

        if (context.mounted) {
          CustomSnackBar(
            message: 'Compte administrateur créé avec succès',
            backgroundColor: Colors.green,
          ).showSnackBar(context);
        }

        if (!user.emailVerified) {
          await user.sendEmailVerification();
        }
      }
      return userCredential;
    } on FirebaseAuthException catch (e) {

      setLoading(false);

      if (context.mounted) {
        CustomSnackBar(
          message: 'Echec de la création de compte administrateur',
          backgroundColor: Colors.red,
        ).showSnackBar(context);
      }

      if (e.code == 'weak-password') {
        throw Exception(ErrorMessages.weakPassword);
      } else if (e.code == 'email-already-in-use') {
        throw Exception(ErrorMessages.emailAlreadyInUse);
      } else {
        throw Exception('Erreur: ${e.message}');
      }
    }
  }

/* https://github.com/Nayangadhiya/Firebase-AuthServices-Flutter/blob/main/lib/screens/login_screen.dart */
  //SignIn with email and password
  Future<UserCredential?> signIn(String email, String password, {required BuildContext context, required Function(bool) setLoading}) async {
    try {
      setLoading(true);

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password
      );

      User? user = userCredential.user;
      //Collect user data from firestore
      if (user != null) {
        UserCRUD userCRUD = UserCRUD(user.uid);
        UserModel? userDoc = await userCRUD.getUser();

        setLoading(false);

        if (context.mounted) {
          CustomSnackBar(
            message: 'Connexion réussie',
            backgroundColor: Colors.green,
          ).showSnackBar(context);
        }

        if (userDoc?.role == 'admin') {
          if (context.mounted) {
            Navigator.pushReplacement(
              context, 
              MaterialPageRoute(builder: (context) => AdminCentralPage()),
            );
          }
        } else {
          if (context.mounted) {
            Navigator.pushReplacement(
              context, 
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          }
        }
      }
      return userCredential; 
    } on FirebaseAuthException catch (e) {

      setLoading(false);

      if (context.mounted) {
        CustomSnackBar(
          message: 'Paire identifiant/mot de passe incorrecte',
          backgroundColor: Colors.red,
        ).showSnackBar(context);
      }

      if (e.code == 'user-not-found') {
        throw Exception(ErrorMessages.userNotFound);
      } else if (e.code == 'wrong-password') {
        throw Exception(ErrorMessages.wrongPassword);
      } else {
        throw Exception('Erreur: ${e.message}');
      }
    }
  }

    //Send email to reset password
  Future<void> sendPasswordResetEmail(String email, {required BuildContext context, required Function(bool) setLoading}) async {
    try {
      setLoading(true);

      UserCRUD userCRUD = UserCRUD();

      bool userExists = await userCRUD.checkIfUserExists(email);

      if (userExists) {
        await FirebaseAuth.instance.sendPasswordResetEmail(
          email: email,
        );

        setLoading(false);

        if (context.mounted) {
          CustomSnackBar(
            message: 'Email de réinitialisation envoyé',
            backgroundColor: Colors.green,
          ).showSnackBar(context);
        }

        if (context.mounted) {
          Navigator.pushReplacement(
            context, 
            MaterialPageRoute(builder: (context) => AuthPage()),
          );
        }
      } else {
        setLoading(false);

        if (context.mounted) {
          CustomSnackBar(
            message: 'Aucun utilisateur trouvé pour cet email',
            backgroundColor: Colors.red,
          ).showSnackBar(context);
        }
      }
    } on FirebaseAuthException catch (e) {

      setLoading(false);

      if (e.code == 'invalid-email') {
        throw Exception(ErrorMessages.invalidEmail);
      } else if (e.code == 'user-not-found') {
        throw Exception(ErrorMessages.noUserFound);
      } else {
        throw Exception('Erreur: ${e.message}');
      }
    }
  }

  //SignOut
  Future<void> signOut({required BuildContext context, required Function(bool) setLoading}) async {
    try {
      setLoading(true);

      User? user = _auth.currentUser;

      if (user != null) {
        setLoading(false);

        await _auth.signOut();

        if (context.mounted) {
          CustomSnackBar(
            message: 'Déconnexion réussie',
            backgroundColor: Colors.green,
          ).showSnackBar(context);
        }

        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AuthPage()),
          );
        }
      } 
    } catch (e) {
      if (context.mounted) {
        CustomSnackBar(
          message: 'Vous n\'êtes pas connecté',
          backgroundColor: Colors.red,
        ).showSnackBar(context);
      }
      debugPrint('Error during disconnection: $e');
    } 
  }

  //Delete User
  Future<void> deleteUser({required BuildContext context, required Function(bool) setLoading}) async {
    try {
      setLoading(true);

      User? user = _auth.currentUser;

      if (user != null) {
        setLoading(false);

        await UserCRUD(user.uid).deleteUser();
        await user.delete();

        if (context.mounted) {
          CustomSnackBar(
            message: 'Utilisateur supprimé',
            backgroundColor: Colors.green,
          ).showSnackBar(context);
        }

        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AuthPage()),
          );
        }
      }
    } catch (e) {
      setLoading(false);

      if (context.mounted) {
        CustomSnackBar(
          message: 'Erreur lors de la suppression du compte utilisateur',
          backgroundColor: Colors.red,
        ).showSnackBar(context);
      }
      throw Exception('Erreur: $e');
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



  //Update user password
  Future<void> updatePassword(String newPassword, {required BuildContext context, required Function(bool) setLoading}) async {
    try {
      setLoading(true);

      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.updatePassword(newPassword);

        setLoading(false);

        if (context.mounted) {
          CustomSnackBar(
            message: 'Le mot de passe a été mis à jour',
            backgroundColor: Colors.green,
          ).showSnackBar(context);
        }
      } 
    } catch (e) {

      setLoading(false);

      if (context.mounted) {
        CustomSnackBar(
          message: 'Erreur lors de la mise à jour du mot de passe',
          backgroundColor: Colors.red,
        ).showSnackBar(context);
      }

      throw Exception('Erreur: $e');
    }
  }
}