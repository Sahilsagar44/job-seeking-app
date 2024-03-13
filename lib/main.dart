
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/Presentation/Screens/SignInScreens/Splash_Screen.dart';
import 'package:untitled2/Themes/Themes.dart';

import 'Presentation/Screens/SignInScreens/Welcome_Screen.dart';
import 'Providers/AuthProvider.dart';
// import your LoginScreen class here
import 'Presentation/Screens/SignInScreens/LoginScreen.dart';
import 'Presentation/Screens/SignInScreens/Switcher.dart';
import 'firebase_options.dart'; // import your SwitcherScreen class here

bool isClient = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Auth(),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightColorScheme,
        // darkTheme: darkColorScheme,
        // themeMode: ThemeMode.system,

        home: const Welcome_Screen(),
      ),
    );
  }
}

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasData) {
          return SwitcherScreen(); // Use your SwitcherScreen here
        } else if (snapshot.hasError) {
          return const Center(
            child: Text("Something Went Wrong"),
          );
        } else {
          return const SplaceScreen(); // Use your LoginScreen here
        }
      },
    );
  }
}


