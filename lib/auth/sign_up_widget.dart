import 'package:ebay_demo/provider/google_signin_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class SignUpWidget extends StatelessWidget {
  const SignUpWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Let\'s get started.',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
          ),
          const Spacer(),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              primary: Colors.white,
              onPrimary: Colors.black,
              minimumSize: const Size(double.infinity, 50),
            ),
            onPressed: () {
              final provider =
                  Provider.of<GoogleSignInProvider>(context, listen: false);
              provider.googleLogin();
            },
            icon: const FaIcon(
              FontAwesomeIcons.google,
              color: Colors.red,
            ),
            label: const Text('Sign Up with Google'),
          ),
          const SizedBox(
            height: 40,
          ),
          RichText(
            text: const TextSpan(text: 'Already have an account?', children: [
              TextSpan(
                text: 'Log in',
                style: TextStyle(decoration: TextDecoration.underline),
              ),
            ]),
          )
        ],
      ),
    );
  }
}
