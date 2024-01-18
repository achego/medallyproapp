import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../auth/otp_screen.dart';

class OtpNotifier with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isRegistering = false;
  bool get isRegistering => _isRegistering;

  set isRegistering(bool value) {
    _isRegistering = value;
    notifyListeners();
  }

  User? _user;
  User? get user => _user;

  Future<void> signInWithPhoneNumber(String phoneNumber, context) async {
     Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpScreen(verificationId: '123456'),
            ),
          );
          return;
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            print('The provided phone number is not valid.');
          }
          // Handle other verification failures here
          // Set isRegistering to false to stop the circular progress indicator
          isRegistering = false;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to verify phone number")),
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          if (kDebugMode) {
            print("Code Sent: $verificationId");
          }

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpScreen(verificationId: verificationId),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      // Handle other exceptions here
      // Set isRegistering to false to stop the circular progress indicator
      isRegistering = false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to initiate phone verification")),
      );
    }
  }
}

