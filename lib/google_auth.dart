import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Istanza globale di FirebaseAnalytics
final analytics = new FirebaseAnalytics();

/// Istanza globale di FirebaseAuth
final firebaseAuth = FirebaseAuth.instance;

/// Istanza globale di GoogleSignIn
final googleSignIn = new GoogleSignIn();


/// Assicura che sia stato effettuato il login.
///
/// Controlla se l'utente è già loggato e a seconda dei casi effettua il
/// SignIn con account Google.
Future<Null> ensureLoggedIn() async {
  GoogleSignInAccount user = googleSignIn.currentUser;
  if (user == null) user = await googleSignIn.signInSilently();
  if (user == null) {
    await googleSignIn.signIn();
    analytics.logLogin();
  }
  if (await firebaseAuth.currentUser() == null) {
    GoogleSignInAuthentication credentials =
    await googleSignIn.currentUser.authentication;
    await firebaseAuth.signInWithGoogle(
      idToken: credentials.idToken,
      accessToken: credentials.accessToken,
    );
  }
}