import 'dart:core';
import 'package:flutter/material.dart';
import 'package:echofy_app/Screens/Username_Screen/User_Screen_body.dart';

class UsernameScreen extends StatelessWidget {
  final String phone, email, Type;
  const UsernameScreen({
    super.key,
    required this.phone,
    required this.email,
    required this.Type,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(
        phone: phone,
        email: email,
        Type: Type,
      ),
    );
  }
}
