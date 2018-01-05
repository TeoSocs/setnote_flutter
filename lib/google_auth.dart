import 'dart:async';

import 'package:google_sign_in/google_sign_in.dart';

final googleSignIn = new GoogleSignIn();

Future<Null> ensureGoogleLogin() async {
  GoogleSignInAccount user = googleSignIn.currentUser;
  if (user == null) user = await googleSignIn.signInSilently();
  if (user == null) {
    await googleSignIn.signIn();
  }
}