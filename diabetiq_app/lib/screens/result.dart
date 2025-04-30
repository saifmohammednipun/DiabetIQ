import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final double riskLevel;

  const ResultPage({super.key, required this.riskLevel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Result', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Image.asset(
                    'images/blood.png',
                    width: 150,
                    height: 150,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Diabetic Risk',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),
                  _buildRiskMeter(),
                  const SizedBox(height: 20),
                  Text(
                    _getRiskText(),
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Next Steps',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'It can be important to discuss your risk of diabetes with a medical professional.',
            ),
            const SizedBox(height: 10),
            const Text(
              'Your doctor or care team can provide resources to help you manage your diabetes.',
            ),
            const SizedBox(height: 10),
            const Text(
              'The result of your questionnaires are not a diagnosis.',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 130, vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                  backgroundColor: Colors.blue,
                ),
                child: const Text('Export PDF' , style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Summary'),
          BottomNavigationBarItem(icon: Icon(Icons.share), label: 'Sharing'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Browse'),
        ],
      ),
    );
  }

  Widget _buildRiskMeter() {
    return Column(
      children: [
        Container(
          height: 30,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.black, width: 2),
          ),
          child: Row(
            children: [
              _buildRiskSegment(0.33, Colors.white, 'None'),
              _buildRiskSegment(0.33, Colors.white, 'Moderate'),
              _buildRiskSegment(0.34, Colors.blue, 'Severe'),
            ],
          ),
        ),
        const SizedBox(height: 10),
        // Text(
        //   _getRiskStage(),
        //   style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        // ),
      ],
    );
  }

  Widget _buildRiskSegment(double widthFactor, Color color, String label) {
    return Expanded(
      flex: (widthFactor * 100).toInt(),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(riskLevel > widthFactor ? 1 : 0.3),
          border: Border(
            right: BorderSide(color: Colors.black, width: 1),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  String _getRiskText() {
    if (riskLevel < 0.33) {
      return 'Your answers indicate no significant risk of diabetes.';
    } else if (riskLevel < 0.66) {
      return 'Your answers indicate you may be experiencing symptoms of moderate diabetes at this time.';
    } else {
      return 'Your answers indicate a high risk of diabetes. Consult a medical professional immediately.';
    }
  }

  // String _getRiskStage() {
  //   if (riskLevel < 0.33) {
  //     return 'None';
  //   } else if (riskLevel < 0.66) {
  //     return 'Moderate';
  //   } else {
  //     return 'Severe';
  //   }
  // }
}
