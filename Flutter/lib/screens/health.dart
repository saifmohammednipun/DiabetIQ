import 'package:flutter/material.dart';

class HealthPage extends StatelessWidget {
  const HealthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
           appBar: AppBar(
        title: const Text(
          'DiaCare',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white, // AppBar background color
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              'All Health Data',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildHealthCard('Pulse Rate', '70', 'per min', Icons.monitor_heart, Colors.orange),
            _buildHealthCard('Blood Pressure', '110/75', 'mmHg', Icons.bloodtype, Colors.red),
            _buildHealthCard('BMI', '21.6', 'kg/m²', Icons.calculate, Colors.blue),
            _buildHealthCard('Glucose Level', '70', 'mg/dL', Icons.touch_app, Colors.pink),
            _buildHealthCard('Sleep', '5 hr 24', 'min', Icons.bed, Colors.green),
            _buildHealthCard('Step Count', '2,224', 'steps', Icons.directions_walk, Colors.black),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Summary'),
          BottomNavigationBarItem(icon: Icon(Icons.share), label: 'Sharing'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Browse'),
        ],
      ),
    );
  }

  Widget _buildHealthCard(String title, String value, String unit, IconData icon, Color color) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      value,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 4),
                    Text(unit, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                  ],
                ),
              ],
            ),
            Icon(icon, color: color, size: 30),
          ],
        ),
      ),
    );
  }
}
