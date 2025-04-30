import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart'; // For Google Sign-In

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // final GoogleSignIn _googleSignIn = GoogleSignIn(); // Google Sign-In instance
  bool _isPasswordVisible = false; // Track password visibility

  // // Function to handle Google Sign-In
  // Future<void> _signUpWithGoogle() async {
  //   try {
  //     final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
  //     if (googleUser != null) {
  //       // Handle successful Google Sign-In
  //       print("Signed in with Google: ${googleUser.email}");
  //       // You can now use the user's email or other details for your app logic
  //     }
  //   } catch (error) {
  //     print("Error signing in with Google: $error");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'DiabetIQ',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white, // AppBar background color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sign Up',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20), // Space between title and input fields
            // Name Field
            const Text(
              'Your Name',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8), // Space between label and text field
            TextField(
              decoration: InputDecoration(
                hintText: 'Ex: Jason Malta',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20), // Space between fields
            // Email Field
            const Text(
              'Your Email',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
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
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8), // Space between label and text field
            TextField(
              obscureText: !_isPasswordVisible, // Toggle password visibility
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible =
                          !_isPasswordVisible; // Toggle visibility
                    });
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ), // Space between password field and button
            // Sign Up Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/home');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Button color
                  padding: const EdgeInsets.symmetric(
                    horizontal: 140,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Rounded corners
                  ),
                ),
                child: const Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Text color
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ), // Space between button and Google Sign-In
            // OR Divider
            const Row(
              children: [
                Expanded(child: Divider()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text('OR', style: TextStyle(color: Colors.grey)),
                ),
                Expanded(child: Divider()),
              ],
            ),
            const SizedBox(
              height: 20,
            ), // Space between divider and Google Sign-In
            // // Sign Up with Google Button
            // Center(
            //   child: ElevatedButton(
            //     onPressed: _signUpWithGoogle,
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: Colors.white, // Button color
            //       padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(30), // Rounded corners
            //       ),
            //     ),
            //     child: Row(
            //       mainAxisSize: MainAxisSize.min,
            //       children: [
            //         Image.asset(
            //           'images/google_logo.png', // Path to Google logo
            //           width: 28,
            //           height: 28,
            //         ),
            //         const SizedBox(width:20),
            //         const Text(
            //           'Sign Up with your Gmail',
            //           style: TextStyle(
            //             fontSize: 18,
            //             color: Colors.black87, // Text color
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            // const SizedBox(height: 20), // Space between Google Sign-In and login text

            // Login Prompt
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: const Text(
                  'Login if you already have an account.',
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
