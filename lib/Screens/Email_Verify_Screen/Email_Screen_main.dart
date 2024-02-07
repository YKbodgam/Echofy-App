import 'package:flutter/material.dart';
import 'package:echofy_app/Screens/Email_Verify_Screen/Email_Screen_body.dart';

class EmailVerificationScreen extends StatelessWidget {
  final String email;

  const EmailVerificationScreen({required this.email, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(email_id: email),
    );
  }
}
