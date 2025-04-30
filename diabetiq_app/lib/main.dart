import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/chat_screen.dart';
import 'services/api_service.dart';
import 'screens/welcome.dart';
import 'screens/signup.dart';
import 'screens/login.dart';
import 'screens/home.dart';
import 'screens/about.dart';
import 'screens/user.dart';
import 'screens/diatrack.dart';
import 'screens/result.dart';
import 'screens/health.dart';

void main() {
  runApp(const DiabetIQApp());
}

class DiabetIQApp extends StatelessWidget {
  const DiabetIQApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Provider(
//       create: (context) => ApiService(),
//       child: MaterialApp(
//         title: 'DiabetIQ',
//         theme: ThemeData(
//           colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
//           useMaterial3: true,
//         ),
//         home: const ChatScreen(),
//         debugShowCheckedModeBanner: false,
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';

// void main() {
//   runApp(const DiaCareApp());
// }

// class DiaCareApp extends StatelessWidget {
//   const DiaCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => ApiService(),
      child: MaterialApp(
        title: 'DiaCare',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const WelcomeScreen(),
        routes: {
          '/welcome': (context) => const WelcomeScreen(),
          '/signup': (context) => const SignUpScreen(),
          '/login': (context) => const LoginScreen(),
          '/home': (context) => const HomeScreen(),
          '/about': (context) => const AboutScreen(),
          '/user': (context) => const UserScreen(),
          '/diachat': (context) => const ChatScreen(),
          '/diatrack': (context) => const DiaTrackScreen(),
          '/result': (context) => const ResultPage(riskLevel: double.infinity),
          '/health': (context) => const HealthPage(),
        },
      ),
    );
  }
}
