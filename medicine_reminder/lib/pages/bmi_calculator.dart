import 'package:flutter/material.dart';

class BMICalculatorScreen extends StatefulWidget {
  @override
  _BMICalculatorScreenState createState() => _BMICalculatorScreenState();
}

class _BMICalculatorScreenState extends State<BMICalculatorScreen> {
  final TextEditingController _heightFeetController = TextEditingController();
  final TextEditingController _heightInchesController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  double _calculateBMI(double heightInInches, double weightInKg) {
    double heightInMeters = heightInInches * 0.0254;
    return weightInKg / (heightInMeters * heightInMeters);
  }

  String _getHealthStatus(double bmi) {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 24.9) return 'Normal weight';
    if (bmi < 29.9) return 'Overweight';
    return 'Obesity';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'BMI Calculator',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.deepPurpleAccent,
              Colors.blueAccent,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.monitor_weight, color: Colors.white, size: 80),
              SizedBox(height: 10),

              Text(
                "Check Your Body Mass Index",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),

              SizedBox(height: 25),

              // Glass Card
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white70.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 12,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),

                child: Column(
                  children: [
                    _buildTextField(
                        'Height (feet)', 'Enter height in feet', _heightFeetController),
                    SizedBox(height: 15),

                    _buildTextField(
                        'Height (inches)', 'Enter height in inches', _heightInchesController),
                    SizedBox(height: 15),

                    _buildTextField(
                        'Weight (kg)', 'Enter weight in kg', _weightController),
                    SizedBox(height: 25),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent,
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                      ),
                      onPressed: () {
                        double heightFeet =
                            double.tryParse(_heightFeetController.text) ?? 0;
                        double heightInches =
                            double.tryParse(_heightInchesController.text) ?? 0;
                        double weight =
                            double.tryParse(_weightController.text) ?? 0;

                        double totalHeightInInches =
                            (heightFeet * 12) + heightInches;
                        double bmi = _calculateBMI(totalHeightInInches, weight);
                        String healthStatus = _getHealthStatus(bmi);

                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              title: Row(
                                children: [
                                  Icon(Icons.health_and_safety,
                                      color: Colors.deepPurpleAccent),
                                  SizedBox(width: 10),
                                  Text('BMI Result'),
                                ],
                              ),
                              content: Text(
                                'Your BMI is ${bmi.toStringAsFixed(2)}\n\n'
                                    'Health Status: $healthStatus',
                                style: TextStyle(fontSize: 16),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(
                                    'Close',
                                    style: TextStyle(
                                      color: Colors.deepPurpleAccent,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text(
                        'Calculate',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            hintStyle: TextStyle(color: Colors.grey[500]),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
