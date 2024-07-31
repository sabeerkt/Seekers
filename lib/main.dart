import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeker/controller/auth_provider.dart';
import 'package:seeker/controller/base_provider.dart';
import 'package:seeker/controller/connction.dart';
import 'package:seeker/controller/seeker_provider.dart';
import 'package:seeker/firebase_options.dart';
import 'package:seeker/screens/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProviders(),
        ),
        ChangeNotifierProvider(
          create: (context) => InternetConnectivityProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => BaseProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => SeekerProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
