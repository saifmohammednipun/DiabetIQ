import 'package:flutter/material.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Index for the bottom navigation bar

  // Handle bottom navigation bar item selection
  void _onItemTapped(int index) {
    if (index == 0) {
      // Navigate to User Screen
      Navigator.pushNamed(context, '/user');
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      appBar: AppBar(
        title: const Text(
          'DiaCare',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white, // AppBar background color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20), // Space between search bar and services

            // DiaCare Services Section
            const Text(
              'DiaCare Services',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10), // Space between title and services

            // Services Grid
            Expanded(
              child: GridView.count(
                crossAxisCount: 2, // Two columns
                mainAxisSpacing: 16, // Vertical spacing
                crossAxisSpacing: 16, // Horizontal spacing
                childAspectRatio: 1.5, // Aspect ratio of each tile
                children: [
                  _buildServiceTile('DiaReport', Icons.report),
                  _buildServiceTile('DiaTrack', Icons.timeline),
                  _buildServiceTile('DiaMed', Icons.medication),
                  _buildServiceTile('DiaChat', Icons.chat),
                  _buildServiceTile('DiaNutri', Icons.restaurant),
                  _buildServiceTile('DiaConsult', Icons.video_call),
                  _buildServiceTile('Others', Icons.more_horiz),
                ],
              ),
            ),
          ],
        ),
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue, // Selected item color
        unselectedItemColor: Colors.grey, // Unselected item color
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'User',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.share),
            label: 'Sharing',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.browse_gallery),
            label: 'Browse',
          ),
        ],
      ),
    );
  }

  // Helper method to build a service tile
  Widget _buildServiceTile(String title, IconData icon) {
  return Card(
    elevation: 4, // Add shadow for depth
    color: Colors.white, // Set the background color of the card to white
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12), // Rounded corners
    ),
    child: InkWell(
      onTap: () {
        if (title == 'DiaChat') {
          // Navigate to DiaChat Screen
          Navigator.pushNamed(context, '/diachat');
        }

        // You can add other navigation logic for other tiles here
        if (title == 'DiaTrack') {
            // Navigate to DiaTrack Screen
            Navigator.pushNamed(context, '/diatrack');
          }

          if (title == 'DiaReport') {
            // Navigate to Others Screen
            Navigator.pushNamed(context, '/health');
          }

      },
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 40,
            color: Colors.blue, // Icon color
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    ),
  );
}
}