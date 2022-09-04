import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_live/providers/user_provider.dart';
import 'package:go_live/resources/auth_methods.dart';
import 'package:go_live/screens/broadcast_screen.dart';
import 'package:go_live/screens/home_screen.dart';
import 'package:go_live/screens/login_screen.dart';
import 'package:go_live/screens/onboarding_screen.dart';
import 'package:go_live/screens/signup_screen.dart';
import 'package:go_live/utils/colors.dart';
import 'package:go_live/widgets/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'models/user.dart' as model;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    name: 'GoLive',
    options: const FirebaseOptions(
      appId: "1:353938728699:web:da5931f3feed7c769bf25e",
      apiKey: "AIzaSyCEdL1ktDqi1Rf30Ju0dCeEh4OTqv5qGbI",
      messagingSenderId: "353938728699",
      projectId: "go-live-e6585",
    ),
  );

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (_) => UserProvider(),
    ),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GoLive',
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: AppBarTheme.of(context).copyWith(
          backgroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: const TextStyle(
            color: primaryColor,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          iconTheme: const IconThemeData(
            color: primaryColor,
          ),
        ),
      ),
      routes: {
        OnboardingScreen.routeName: (context) => const OnboardingScreen(),
        LoginScreen.routeName: (context) => const LoginScreen(),
        SignupScreen.routeName: (context) => const SignupScreen(),
        HomeScreen.routeName: (context) => const HomeScreen(),
        // BroadcastScreen.routeName:(context) => const BroadcastScreen(isBroadcaster: true, channelId: channelId)
      },
      home: FutureBuilder(
        future: AuthMethods()
            .getCurrentUser(FirebaseAuth.instance.currentUser != null
                ? FirebaseAuth.instance.currentUser!.uid
                : null)
            .then(
          (value) {
            if (value != null) {
              Provider.of<UserProvider>(context, listen: false).setUser(
                model.User.fromMap(value),
              );
            }
            return value;
          },
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingIndicator();
          }

          if (snapshot.hasData) {
            return const HomeScreen();
          }

          return const OnboardingScreen();
        },
      ),
    );
  }
}
