import 'package:echofy_app/Screens/Otp_Verify_Screen/Otp_Screen_body.dart';
import 'package:flutter/material.dart';

class OtpVerificationScreen extends StatelessWidget {
  final String verification_Id;
  final String Phone_no;
  const OtpVerificationScreen({
    super.key,
    required this.verification_Id,
    required this.Phone_no,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(
        verification_Id: verification_Id,
        Phone_number: Phone_no,
      ),
    );
  }
}
