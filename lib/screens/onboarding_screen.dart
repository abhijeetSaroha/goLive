import 'package:flutter/material.dart';
import 'package:go_live/responsive/responsive.dart';
import 'package:go_live/screens/login_screen.dart';
import 'package:go_live/screens/signup_screen.dart';
import 'package:go_live/widgets/custom_butoon.dart';

class OnboardingScreen extends StatelessWidget {
  static const routeName = '/onboarding';
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Responsive(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Welcome to \n GoLive',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomButton(
                text: 'Log In',
                onTap: () {
                  Navigator.pushNamed(context, LoginScreen.routeName);
                },
              ),
              const SizedBox(
                height: 20,
              ),
              CustomButton(
                text: 'Sign Up',
                onTap: () {
                  Navigator.pushNamed(context, SignupScreen.routeName);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
