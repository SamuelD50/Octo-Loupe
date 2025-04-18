import 'package:firebase_auth/firebase_auth.dart';
import 'package:octoloupe/components/snackbar.dart';
import 'package:octoloupe/model/user_model.dart';
import 'package:octoloupe/CRUD/user_crud.dart';
import 'package:flutter/material.dart';
import 'package:octoloupe/pages/admin_central_page.dart';
import 'package:octoloupe/pages/auth_page.dart';
import 'package:octoloupe/pages/user_central_page.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Documentation : https://firebase.google.com/docs/auth/flutter/password-auth?hl=fr
  
  // Create account and save user data in Firestore
  Future<UserCredential?> signUpUser(
    String email,
    String password,
    String firstName,
    String name, {
      required BuildContext context,
      required Function(bool) setLoading
    }
  ) async {
    try {
      setLoading(true);

      UserCRUD userCRUD = UserCRUD();
      bool emailExists = await userCRUD.checkIfUserExists(email);
      if (emailExists) {
        setLoading(false);
        if (context.mounted) {
          CustomSnackBar(
            message: 'Email déjà utilisé',
            backgroundColor: Colors.red,
          ).showSnackBar(context);
        }
        return null;
      }

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

        if (!user.emailVerified) {
          await user.sendEmailVerification();
        }

        await Future.delayed(Duration(milliseconds: 25));

        setLoading(false);

        if (context.mounted) {
          CustomSnackBar(
            message: 'Compte utilisateur créé avec succès',
            backgroundColor: Colors.green,
          ).showSnackBar(context);
        }
      }
      return userCredential;
    } on FirebaseAuthException catch (e) {

      setLoading(false);

      if (context.mounted) {
        CustomSnackBar(
          message: 'Echec de la création de compte',
          backgroundColor: Colors.red,
        ).showSnackBar(context);
      }

      if (e.code == 'weak-password') {
        throw Exception('The password provided is too weak');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('The account already exists for that email');
      } else {
        throw Exception('Error creating user: ${e.message}');
      }
    }
  }

  Future<UserCredential?> signUpAdmin(
    String email,
    String password,
    String firstName,
    String name, {
      required BuildContext context,
      required Function(bool) setLoading
    }
  ) async {
    try {
      setLoading(true);

      UserCRUD userCRUD = UserCRUD();
      bool emailExists = await userCRUD.checkIfUserExists(email);
      if (emailExists) {
        setLoading(false);
        if (context.mounted) {
          CustomSnackBar(
            message: 'Email déjà utilisé',
            backgroundColor: Colors.red,
          ).showSnackBar(context);
        }
        return null;
      }

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

        if (!user.emailVerified) {
          await user.sendEmailVerification();
        }

        await Future.delayed(Duration(milliseconds: 25));

        setLoading(false);

        if (context.mounted) {
          CustomSnackBar(
            message: 'Compte administrateur créé avec succès',
            backgroundColor: Colors.green,
          ).showSnackBar(context);
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
        throw Exception('The password provided is to weak');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('The accounts already exists for that email');
      } else {
        throw Exception('Error creating user: ${e.message}');
      }
    }
  }

  int failedAttempts = 0;
  bool isButtonDisabled = false;

/* https://github.com/Nayangadhiya/Firebase-AuthServices-Flutter/blob/main/lib/screens/login_screen.dart */
  //SignIn with email and password
  Future<UserCredential> signIn(
    String email,
    String password, {
      required BuildContext context,
      required Function(bool) setLoading
    }
  ) async {
    if (failedAttempts >= 5) {
      if (context.mounted) {
        CustomSnackBar(
          message: 'Trop de tentatives échouées. Réessayez plus tard',
          backgroundColor: Colors.red,
        ).showSnackBar(context);
        return Future.error('Too many attempts');
      }
    }
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
        UserModel? userDoc = await userCRUD.getUser(user.uid);

        if (userDoc?.role != null) {
          if (context.mounted) {
            Navigator.pushReplacement(
              context, 
              MaterialPageRoute(
                builder: (context) => userDoc!.role == 'admin'
                  ? AdminCentralPage()
                  : UserCentralPage(),
              ),
            );
          }

          await Future.delayed(Duration(milliseconds: 25));

          setLoading(false);
          
          if (context.mounted) {
            CustomSnackBar(
              message: 'Connexion réussie',
              backgroundColor: Colors.green,
            ).showSnackBar(context);
          }
        }
      }
      failedAttempts = 0;
      return userCredential;
    } on FirebaseAuthException catch (e) {

      setLoading(false);
      failedAttempts++;

      if (context.mounted) {
        CustomSnackBar(
          message: 'Paire identifiant/mot de passe incorrecte',
          backgroundColor: Colors.red,
        ).showSnackBar(context);
      }

      if (e.code == 'user-not-found') {
        throw Exception('No user found for that email');
      } else if (e.code == 'wrong-password') {
        throw Exception('Wrong password provided for that user');
      } else {
        throw Exception('Error during connection: ${e.message}');
      }
    }
  }

    //Send email to reset password
  Future<void> sendPasswordResetEmail(
    String email, {
      required BuildContext context,
      required Function(bool) setLoading
    }
  ) async {
    try {
      setLoading(true);

      UserCRUD userCRUD = UserCRUD();

      bool userExists = await userCRUD.checkIfUserExists(email);

      if (userExists) {
        await FirebaseAuth.instance.sendPasswordResetEmail(
          email: email,
        );

        if (context.mounted) {
          Navigator.pushReplacement(
            context, 
            MaterialPageRoute(builder: (context) => AuthPage()),
          );
        }

        await Future.delayed(Duration(milliseconds: 25));

        setLoading(false);

        if (context.mounted) {
          CustomSnackBar(
            message: 'Email de réinitialisation envoyé',
            backgroundColor: Colors.green,
          ).showSnackBar(context);
        }
      }
    } on FirebaseAuthException catch (e) {

      setLoading(false);

      if (context.mounted) {
        CustomSnackBar(
          message: 'Aucun utilisateur trouvé pour cet email',
          backgroundColor: Colors.red,
        ).showSnackBar(context);
      }

      if (e.code == 'invalid-email') {
        throw Exception('The email address is invalid');
      } else if (e.code == 'user-not-found') {
        throw Exception('No user found for that email');
      } else {
        throw Exception('Error reseting password: ${e.message}');
      }
    }
  }

  //SignOut
  Future<void> signOut({
    required BuildContext context,
    required Function(bool) setLoading
  }) async {
    try {
      setLoading(true);

      User? user = _auth.currentUser;

      if (user != null) {
        await _auth.signOut();

        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AuthPage()),
          );
        }

        await Future.delayed(Duration(milliseconds: 25));

        setLoading(false);

        if (context.mounted) {
          CustomSnackBar(
            message: 'Déconnexion réussie',
            backgroundColor: Colors.green,
          ).showSnackBar(context);
        }
      } 
    } catch (e) {
      if (context.mounted) {
        CustomSnackBar(
          message: 'Vous n\'êtes pas connecté',
          backgroundColor: Colors.red,
        ).showSnackBar(context);
      }

      throw Exception('Error during disconnection: $e');
    } 
  }

  //Delete User
  Future<void> deleteUser({
    required BuildContext context,
    required Function(bool) setLoading
  }) async {
    try {
      setLoading(true);

      User? user = _auth.currentUser;

      if (user != null) {
        await UserCRUD(user.uid).deleteUser(user.uid);
        await user.delete();

        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AuthPage()),
          );
        }

        await Future.delayed(Duration(milliseconds: 25));

        setLoading(false);

        if (context.mounted) {
          CustomSnackBar(
            message: 'Utilisateur supprimé',
            backgroundColor: Colors.green,
          ).showSnackBar(context);
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
      throw Exception('Error deleting user: $e');
    }
  }

  // Checking if user is connected
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  //Update email
  Future<void> updateEmail(
    String newEmail,
    String password,
    {required BuildContext context,
    required Function(bool) setLoading})
  async {
    try {
      setLoading(true);

      User? user = FirebaseAuth.instance.currentUser;
      
      if (user != null) {

        final credentialForUpdatingEmail = EmailAuthProvider.credential(
          email: user.email ?? '',
          password: password,
        );
        
        await user.reauthenticateWithCredential(credentialForUpdatingEmail);
        await user.verifyBeforeUpdateEmail(newEmail);
        UserModel? currentUser = await UserCRUD(user.uid).getUser(user.uid);

        if (currentUser != null) {
          UserModel updateUser = UserModel(
            uid: user.uid,
            email: newEmail,
            firstName: currentUser.firstName,
            name: currentUser.name,
            role: currentUser.role,
          );

          await UserCRUD(user.uid).updateUser(user.uid, updateUser);
        }

        await Future.delayed(Duration(milliseconds: 25));

        setLoading(false);

        if (context.mounted) {
          CustomSnackBar(
            message: 'Email de vérification envoyé',
            backgroundColor: Colors.green,
          ).showSnackBar(context);
        }
      }
    } catch (e) {
      setLoading(false);

      if (context.mounted) {
        CustomSnackBar(
          message: 'Erreur lors de la mise à jour de l\'email',
          backgroundColor: Colors.red,
        ).showSnackBar(context);
      }

      throw Exception('Error updating email: $e');
    }
  }

  //Update user password
  Future<void> updatePassword(
    String email,
    String currentPassword,
    String newPassword, {
      required BuildContext context,
      required Function(bool) setLoading
    }
  ) async {
    try {
      setLoading(true);

      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final credentialForUpdatingPassword = EmailAuthProvider.credential(
          email: email,
          password: currentPassword,
        );

        await user.reauthenticateWithCredential(credentialForUpdatingPassword);
        await user.updatePassword(newPassword);
        
        await Future.delayed(Duration(milliseconds: 25));

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
      throw Exception('Error updating password: $e');
    }
  }
}