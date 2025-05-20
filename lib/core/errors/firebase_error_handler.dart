import 'package:chatter/core/errors/error_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseErrorHandler {
 
  ErrorModel handle(dynamic e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'weak-password':
          return ErrorModel(
            errorMessage: 'Password provided is too weak.',
          );
        case 'email-already-in-use':
          return ErrorModel(
            errorMessage: 'The account already exists for that email.',
          );
        case 'user-not-found':
          return ErrorModel(
            errorMessage: 'No user found for that email.',
          );
        case 'wrong-password':
          return ErrorModel(
            errorMessage: 'Wrong password provided for that user.',
          );
        case 'network-request-failed':
          return ErrorModel(
            errorMessage: 'Make sure you are connected to the Internet.',
          );
        case 'account-exists-with-different-credential':
          return ErrorModel(
            errorMessage:
                'An account already exists with a different credential.',
          );
        case 'invalid-credential':
          return ErrorModel(
            errorMessage: 'The password or mail is incorrect.',
          );
        case 'too-many-requests':
          return ErrorModel(
            errorMessage: 'Too many requests. Try again later.',
          );
        case 'operation-not-allowed':
          return ErrorModel(
            errorMessage: 'Signing in with Email and Password is disabled.',
          );
        case 'user-disabled':
          return ErrorModel(
            errorMessage: 'User disabled.',
          );
        default:
          return ErrorModel(
            errorMessage: 'Something went wrong. Try again later.',
          );
      }
    } else if (e is FirebaseException) {
      switch (e.code) {
        case 'not-found':
          return ErrorModel(
            errorMessage: 'document not found',
          );
        case 'permission-denied':
          return ErrorModel(
            errorMessage: 'permission denied',
          );
        case 'unavailable':
          return ErrorModel(
            errorMessage: 'service unavailable',
          );
        case 'cancelled':
          return ErrorModel(
            errorMessage: 'request cancelled',
          );
        case 'deadline-exceeded':
          return ErrorModel(
            errorMessage: 'deadline exceeded',
          );
        case 'object-not-found':
          return ErrorModel(errorMessage: 'object not found');

        case 'unauthorized':
          return ErrorModel(
            errorMessage: 'unauthorized access',
          );

        case 'invalid-checksum':
          return ErrorModel(
            errorMessage: 'invalid file checksum',
          );

        case 'unknown':
          return ErrorModel(
            errorMessage: 'unknown error occurred',
          );

        default:
          return ErrorModel(
            errorMessage: 'Something went wrong. Try again later.',
          );
      }
    } else {
      return ErrorModel(
        errorMessage: e.toString(),
      );
    }
  }
}
