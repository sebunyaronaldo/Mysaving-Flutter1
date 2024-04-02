import 'package:firebase_auth/firebase_auth.dart';

import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleRepository {
  final FirebaseAuth _firebaseAuth;

  AppleRepository(this._firebaseAuth);

  Future<void> signInWithAppleAndRedirectToDashboard() async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    print(credential);

    final firebaseCredential = OAuthProvider("apple.com").credential(
      idToken: credential.identityToken,
      accessToken: credential.authorizationCode,
    );

    try {
      await _firebaseAuth.signInWithCredential(firebaseCredential);
    } catch (e) {
      print("Sign-in with Apple error: $e");
    }
  }
}
