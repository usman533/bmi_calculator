import 'package:flutter/material.dart';

void main() => runApp(BMICalculatorApp());

class BMICalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BMI Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BMICalculator(),
    );
  }
}

class BMICalculator extends StatefulWidget {
  @override
  _BMICalculatorState createState() => _BMICalculatorState();
}

class _BMICalculatorState extends State<BMICalculator> {
  String _selectedGender = '';
  double _height = 150;
  int _weight = 70;
  int _age = 25;

  void _incrementWeight() {
    setState(() {
      if (_weight < 120) _weight++;
    });
  }

  void _decrementWeight() {
    setState(() {
      if (_weight > 30) _weight--;
    });
  }

  void _incrementAge() {
    setState(() {
      if (_age < 70) _age++;
    });
  }

  void _decrementAge() {
    setState(() {
      if (_age > 10) _age--;
    });
  }

  void _calculateBMI() {
    if (_selectedGender.isEmpty) {
      return;
    }

    double heightInMeters = _height / 100; // Convert height to meters
    double bmi = _weight / (heightInMeters * heightInMeters); // BMI formula

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BMIResultScreen(
          bmi: bmi,
          weight: _weight, // Pass the weight to the result screen
          onRecalculate: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void _selectGender(String gender) {
    setState(() {
      _selectedGender = gender;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isGenderSelected = _selectedGender.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text('BMI Calculator'),
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Adjusted alignment
          children: <Widget>[
            Column(
              children: [
                Row(
                  children: <Widget>[
                    Expanded(child: _genderContainer('Male')),
                    SizedBox(width: 10),
                    Expanded(child: _genderContainer('Female')),
                  ],
                ),
                SizedBox(height: 20),
                _heightContainer(isGenderSelected),
                SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    Expanded(
                        child: _weightAgeContainer(
                            'Weight',
                            _weight,
                            _incrementWeight,
                            _decrementWeight,
                            isGenderSelected)),
                    SizedBox(width: 10),
                    Expanded(
                        child: _weightAgeContainer('Age', _age, _incrementAge,
                            _decrementAge, isGenderSelected)),
                  ],
                ),
              ],
            ),
            ElevatedButton(
              onPressed: isGenderSelected ? _calculateBMI : null,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('Calculate'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _genderContainer(String gender) {
    return GestureDetector(
      onTap: () => _selectGender(gender),
      child: Container(
        decoration: BoxDecoration(
          color: _selectedGender == gender ? Colors.blue : Colors.grey[800],
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.all(20),
        child: Center(
          child: Text(
            gender,
            style: TextStyle(
              fontSize: 18,
              color:
              _selectedGender == gender ? Colors.white : Colors.grey[400],
            ),
          ),
        ),
      ),
    );
  }

  Widget _heightContainer(bool isEnabled) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          Text(
            'Height',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Colors.blue,
              inactiveTrackColor: Colors.grey,
              thumbColor: Colors.red,
              overlayColor: Colors.red.withAlpha(32),
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
            ),
            child: Slider(
              value: _height,
              min: 100,
              max: 200,
              onChanged: isEnabled
                  ? (value) {
                setState(() {
                  _height = value;
                });
              }
                  : null,
              label: _height.toStringAsFixed(1),
            ),
          ),
          Text(
            '${_height.toStringAsFixed(1)} cm',
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _weightAgeContainer(String label, int value, Function increment,
      Function decrement, bool isEnabled) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          Text(
            label,
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          Text(
            '$value',
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: isEnabled ? () => decrement() : null,
                color: Colors.red,
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: isEnabled ? () => increment() : null,
                color: Colors.green,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BMIResultScreen extends StatelessWidget {
  final double bmi;
  final int weight;
  final VoidCallback onRecalculate;

  BMIResultScreen({
    required this.bmi,
    required this.weight,
    required this.onRecalculate,
  });

  @override
  Widget build(BuildContext context) {
    String result;
    String weightCategory;

    if (bmi < 18.5) {
      result = 'Underweight';
    } else if (bmi >= 18.5 && bmi < 24.9) {
      result = 'Normal weight';
    } else if (bmi >= 25 && bmi < 29.9) {
      result = 'Overweight';
    } else {
      result = 'Obesity';
    }

    if (weight < 50) {
      weightCategory = 'Low';
    } else if (weight >= 50 && weight <= 90) {
      weightCategory = 'Normal';
    } else {
      weightCategory = 'High';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('BMI Result'),
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _bmiContainer(bmi),
            SizedBox(height: 20),
            _weightCategoryContainer(weightCategory),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: onRecalculate,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('Recalculate'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bmiContainer(double bmi) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(20),
      child: Center(
        child: Text(
          'BMI: ${bmi.toStringAsFixed(1)}',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _weightCategoryContainer(String category) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(20),
      child: Center(
        child: Text(
          'Weight Category: $category',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}