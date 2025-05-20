import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // ******************** createUserWithEmailAndPassword ********************
  Future<User> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    UserCredential userCredential =
        await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user!;
  }

  // ******************** singInwithEmailAndPassword ********************
  Future<User> singInwithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    UserCredential userCredential =
        await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user!;
  }

  // ******************** createNewPassword ********************
  Future<void> sendPasswordResetEmail({
    required String userEmail,
  }) async {
    await firebaseAuth.sendPasswordResetEmail(email: userEmail);
  }

  // ******************** deleteUser ********************
  Future<void> deleteUser() async {
    await firebaseAuth.currentUser!.delete();
  }

  bool isUserLoggedIn() {
    return firebaseAuth.currentUser != null;
  }

// ******************** logOut ********************
  Future<void> logOut() async {
    await firebaseAuth.signOut();
  }

  Future<void> updateUserEmail({required String newEmail}) async {
    if (isUserLoggedIn()) {
      await firebaseAuth.currentUser!.verifyBeforeUpdateEmail(newEmail);
    }
  }

  Future<void> reauthenticateUser({required String currentPassword}) async {
    if (isUserLoggedIn()) {
      // Create a credential for reauthentication

      final credential = EmailAuthProvider.credential(
        email: FirebaseAuth.instance.currentUser!.email!,
        password: currentPassword,
      );

      // Reauthenticate the user
      await FirebaseAuth.instance.currentUser!
          .reauthenticateWithCredential(credential);
    }
  }

  Future<User> getCurrentUser() async {
    return firebaseAuth.currentUser!;
  }
}
