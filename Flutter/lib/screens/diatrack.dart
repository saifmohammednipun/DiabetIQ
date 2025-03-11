import 'package:flutter/material.dart';

class DiaTrackScreen extends StatefulWidget {
  const DiaTrackScreen({super.key});

  @override
  _DiaTrackScreenState createState() => _DiaTrackScreenState();
}

class _DiaTrackScreenState extends State<DiaTrackScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controller for each field to collect data
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _pulseRateController = TextEditingController();
  final TextEditingController _systolicBPController = TextEditingController();
  final TextEditingController _diastolicBPController = TextEditingController();
  final TextEditingController _glucoseLevelController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  // Variables to hold values for gender and family health history
  String? _gender = 'Male';
  bool _hasFamilyDiabetes = false;
  bool _hasHypertension = false;
  bool _hasFamilyHypertensive = false;
  bool _hasStroke = false;

  // Submit function to collect all data
  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      // If the form is valid, show the entered data
      // For now, print it to the console (You can store it, send it to a backend, etc.)
      print('Age: ${_ageController.text}');
      print('Gender: $_gender');
      print('Pulse Rate: ${_pulseRateController.text}');
      print('Systolic BP: ${_systolicBPController.text}');
      print('Diastolic BP: ${_diastolicBPController.text}');
      print('Glucose Level: ${_glucoseLevelController.text}');
      print('Height: ${_heightController.text}');
      print('Weight: ${_weightController.text}');
      print('Family Diabetes: $_hasFamilyDiabetes');
      print('Hypertension: $_hasHypertension');
      print('Family Hypertensive: $_hasFamilyHypertensive');
      print('Stroke: $_hasStroke');

      // Here, you could navigate to another screen or perform other actions
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      appBar: AppBar(
        title: const Text(
          'DiaTrack Health Survey',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white, // Set AppBar background color to white
        elevation: 0, // Remove the shadow effect
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Age
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(
                  labelText: 'Age',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your age';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Gender Dropdown
              DropdownButtonFormField<String>(
                value: _gender,
                decoration: const InputDecoration(
                  labelText: 'Gender',
                  border: OutlineInputBorder(),
                ),
                items: ['Male', 'Female', 'Other'].map((gender) {
                  return DropdownMenuItem<String>(
                    value: gender,
                    child: Text(gender),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _gender = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Pulse Rate
              TextFormField(
                controller: _pulseRateController,
                decoration: const InputDecoration(
                  labelText: 'Pulse Rate',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your pulse rate';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Systolic BP
              TextFormField(
                controller: _systolicBPController,
                decoration: const InputDecoration(
                  labelText: 'Systolic Blood Pressure',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter systolic blood pressure';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Diastolic BP
              TextFormField(
                controller: _diastolicBPController,
                decoration: const InputDecoration(
                  labelText: 'Diastolic Blood Pressure',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter diastolic blood pressure';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Glucose Level
              TextFormField(
                controller: _glucoseLevelController,
                decoration: const InputDecoration(
                  labelText: 'Glucose Level',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter glucose level';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Height
              TextFormField(
                controller: _heightController,
                decoration: const InputDecoration(
                  labelText: 'Height',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your height';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Weight
              TextFormField(
                controller: _weightController,
                decoration: const InputDecoration(
                  labelText: 'Weight',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your weight';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Family Health History - Diabetes, Hypertension, Stroke
              SwitchListTile(
                title: const Text('Family has Diabetes'),
                value: _hasFamilyDiabetes,
                onChanged: (bool value) {
                  setState(() {
                    _hasFamilyDiabetes = value;
                  });
                },
                activeColor: Colors.blue, // Set the active color of the switch to blue
              ),
              SwitchListTile(
                title: const Text('Hypertensive'),
                value: _hasHypertension,
                onChanged: (bool value) {
                  setState(() {
                    _hasHypertension = value;
                  });
                },
                activeColor: Colors.blue, // Set the active color of the switch to blue
              ),
              SwitchListTile(
                title: const Text('Family has Hypertension'),
                value: _hasFamilyHypertensive,
                onChanged: (bool value) {
                  setState(() {
                    _hasFamilyHypertensive = value;
                  });
                },
                activeColor: Colors.blue, // Set the active color of the switch to blue
              ),
              SwitchListTile(
                title: const Text('Stroke'),
                value: _hasStroke,
                onChanged: (bool value) {
                  setState(() {
                    _hasStroke = value;
                  });
                },
                activeColor: Colors.blue, // Set the active color of the switch to blue
              ),

              const SizedBox(height: 20),

              

              ElevatedButton(
  onPressed: () {
    if (_formKey.currentState?.validate() ?? false) {
      // Submit the form
      _submitForm();

      // After form submission, navigate to the next screen
      // Example: navigating to '/nextScreen'
      Navigator.pushNamed(context, '/result');
    }
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.blue,  // Set button color to blue
    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0), // Increase padding to make the button larger
    minimumSize: const Size(double.infinity, 56), // Set minimum height for the button
  ),
  child: const Text(
    'Submit',
    style: TextStyle(
      color: Colors.white, // Text color
      fontWeight: FontWeight.bold, // Make text bold
      fontSize: 18, // Optional: Increase font size if desired
    ),
  ),
)

            ],
          ),
        ),
      ),
    );
  }
}
