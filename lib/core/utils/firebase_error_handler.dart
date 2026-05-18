class FirebaseErrorHandler {

  static String getMessage(String code) {

    switch (code) {

      case 'email-already-in-use':
        return 'This email is already registered';

      case 'invalid-email':
        return 'Invalid email address';

      case 'weak-password':
        return 'Password is too weak';

      case 'user-not-found':
        return 'No user found for this email';

      case 'wrong-password':
        return 'Wrong password';

      case 'invalid-credential':
        return 'Invalid email or password';

      default:
        return 'Something went wrong';
    }
  }
}