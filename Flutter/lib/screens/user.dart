import 'package:flutter/material.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'User Profile',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView( // Wrap the entire body in SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Picture and Name
              Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: AssetImage('images/profile.png'), // Profile image
                    ),
                    Positioned(
                      bottom: -8,
                      right: -8,
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.blue,
                        child: IconButton(
                          icon: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                          onPressed: () {
                            // Implement camera functionality or image picker
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: const Text(
                  'John Doe',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Center(
                child: const Text(
                  'johndoe@example.com',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 32),

              // Personal Information Section
              const Text(
                'Personal Info',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const Divider(),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.date_range, color: Colors.blue),
                title: const Text('Date of Birth'),
                subtitle: const Text('January 1, 1990'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // Navigate to edit date of birth
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.phone, color: Colors.blue),
                title: const Text('Phone Number'),
                subtitle: const Text('+1 (123) 456-7890'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // Navigate to edit phone number
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.location_on, color: Colors.blue),
                title: const Text('Address'),
                subtitle: const Text('123 Main St, City, Country'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // Navigate to edit address
                },
              ),
              const SizedBox(height: 32),

              // Health Data Section
              const Text(
                'Health Data',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const Divider(),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.favorite, color: Colors.red),
                title: const Text('Blood Pressure'),
                subtitle: const Text('120/80 mmHg'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // Navigate to health data details
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.thermostat, color: Colors.green),
                title: const Text('Temperature'),
                subtitle: const Text('98.6°F'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // Navigate to health data details
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.accessibility, color: Colors.blue),
                title: const Text('Height'),
                subtitle: const Text('5\'9"'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // Navigate to health data details
                },
              ),
              const SizedBox(height: 32),

              // Edit Profile Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Add profile editing functionality
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text(
                    'Edit Profile',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 40), // Add extra space at the bottom
            ],
          ),
        ),
      ),
    );
  }
}
