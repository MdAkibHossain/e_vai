import 'package:ebay_demo/screen/products_overview_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ebay_demo/auth/sign_up_widget.dart';

class AuthHome extends StatelessWidget {
  const AuthHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            return const ProductsOverviewScreen();
          } else if (snapshot.hasError) {
            return const Center(child: Text('Something Went Wrong!'));
          } else {
            return const SignUpWidget();
          }
        },
      ),
    );
  }
}
