import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      appBar: AppBar(
        title: const Text('DiaCare', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,)),
        backgroundColor: Colors.white, // AppBar background color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Login',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20), // Space between title and input fields

            // Email Field
            const Text(
              'Your Email',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8), // Space between label and text field
                 TextField(
              decoration: InputDecoration(
                hintText: 'Ex: jason@example.com',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20), // Space between fields

            // Password Field
            const Text(
              'Your Password',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8), // Space between label and text field
             TextField(
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 30), // Space between password field and button

            // Login Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle login logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Button color
                  padding: const EdgeInsets.symmetric(horizontal: 150, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Rounded corners
                  ),
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white, // Text color
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20), // Space between button and sign up text

            // Sign Up Prompt
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signup');
                },
                child: const Text(
                  'Sign Up if you don’t have an account.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue, // Text color
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}