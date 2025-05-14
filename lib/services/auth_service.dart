import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:go_router/go_router.dart';
import 'package:octoloupe/components/snackbar.dart';
import 'package:octoloupe/model/user_model.dart';
import 'package:octoloupe/CRUD/user_crud.dart';
import 'package:flutter/material.dart';

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
    } on FirebaseAuthException catch (e, stackTrace) {

      setLoading(false);

      if (context.mounted) {
        CustomSnackBar(
          message: 'Echec de la création de compte',
          backgroundColor: Colors.red,
        ).showSnackBar(context);
      }

      FirebaseCrashlytics.instance.recordError(
        e,
        stackTrace,
        reason: 'Error signing up user -> Service',
        information: ['errorCode: ${e.code}']  
      );

/*       if (e.code == 'weak-password') {
        throw Exception('The password provided is too weak');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('The account already exists for that email');
      } else {
        throw Exception('Error creating user');
      } */
      
    }
    return null;
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
    } on FirebaseAuthException catch (e, stackTrace) {

      setLoading(false);

      if (context.mounted) {
        CustomSnackBar(
          message: 'Echec de la création de compte administrateur',
          backgroundColor: Colors.red,
        ).showSnackBar(context);
      }

      FirebaseCrashlytics.instance.recordError(
        e,
        stackTrace,
        reason: 'Error signing up admin -> Service',
        information: ['errorCode: ${e.code}']  
      );
    }
    return null;
  }

  int failedAttempts = 0;
  bool isButtonDisabled = false;

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
      }
      return Future.error('Too many attempts');
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
            context.go(
              userDoc!.role == 'admin' ?
                '/auth/admin' :
                '/auth/user'
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
    } on FirebaseAuthException catch (e, stackTrace) {

      setLoading(false);
      failedAttempts++;

      if (context.mounted) {
        CustomSnackBar(
          message: 'Paire identifiant/mot de passe incorrecte',
          backgroundColor: Colors.red,
        ).showSnackBar(context);
      }

      FirebaseCrashlytics.instance.recordError(
        e,
        stackTrace,
        reason: 'Error signing in -> Service',
        information: ['errorCode: ${e.code}']  
      );

      return Future.error('Error during sign-in');
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

        await Future.delayed(Duration(milliseconds: 25));

        if (context.mounted) {
          context.pop('/auth');
        }

        setLoading(false);

        if (context.mounted) {
          CustomSnackBar(
            message: 'Email de réinitialisation envoyé',
            backgroundColor: Colors.green,
          ).showSnackBar(context);
        }
      }
    } on FirebaseAuthException catch (e, stackTrace) {

      setLoading(false);

      if (context.mounted) {
        CustomSnackBar(
          message: 'Aucun utilisateur trouvé pour cet email',
          backgroundColor: Colors.red,
        ).showSnackBar(context);
      }

      FirebaseCrashlytics.instance.recordError(
        e,
        stackTrace,
        reason: 'Error sending reset password email -> Service',
        information: ['errorCode: ${e.code}']  
      );
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

        await Future.delayed(Duration(milliseconds: 25));

        if (context.mounted) {
          context.pop('/auth');
        }

        setLoading(false);

        if (context.mounted) {
          CustomSnackBar(
            message: 'Déconnexion réussie',
            backgroundColor: Colors.green,
          ).showSnackBar(context);
        }
      } 
    } on FirebaseAuthException catch (e, stackTrace) {
      if (context.mounted) {
        CustomSnackBar(
          message: 'Vous n\'êtes pas connecté',
          backgroundColor: Colors.red,
        ).showSnackBar(context);
      }

      FirebaseCrashlytics.instance.recordError(
        e,
        stackTrace,
        reason: 'Error signing out -> Service',
        information: ['errorCode: ${e.code}']  
      );
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

        await Future.delayed(Duration(milliseconds: 25));

        if (context.mounted) {
          context.pop('/auth');
        }

        setLoading(false);

        if (context.mounted) {
          CustomSnackBar(
            message: 'Utilisateur supprimé',
            backgroundColor: Colors.green,
          ).showSnackBar(context);
        }
      }
    } on FirebaseAuthException catch (e, stackTrace) {
      setLoading(false);

      if (context.mounted) {
        CustomSnackBar(
          message: 'Erreur lors de la suppression du compte utilisateur',
          backgroundColor: Colors.red,
        ).showSnackBar(context);
      }

      FirebaseCrashlytics.instance.recordError(
        e,
        stackTrace,
        reason: 'Error deleting user -> Service',
        information: ['errorCode: ${e.code}']
      );
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
    } on FirebaseAuthException catch (e, stackTrace) {
      setLoading(false);

      if (context.mounted) {
        CustomSnackBar(
          message: 'Erreur lors de la mise à jour de l\'email',
          backgroundColor: Colors.red,
        ).showSnackBar(context);
      }

      FirebaseCrashlytics.instance.recordError(
        e,
        stackTrace,
        reason: 'Error updating email -> Service',
        information: ['errorCode: ${e.code}'],
      );
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
    } on FirebaseAuthException catch (e, stackTrace) {
      setLoading(false);

      if (context.mounted) {
        CustomSnackBar(
          message: 'Erreur lors de la mise à jour du mot de passe',
          backgroundColor: Colors.red,
        ).showSnackBar(context);
      }

      FirebaseCrashlytics.instance.recordError(
        e,
        stackTrace,
        reason: 'Error updating password -> Service',
        information: ['errorCode: ${e.code}']
      );
    }
  }
}