import 'package:flutter/material.dart';

class SuhuConverterPage extends StatefulWidget {
  @override
  _TemperatureConverterState createState() => _TemperatureConverterState();
}

class _TemperatureConverterState extends State<SuhuConverterPage> {
  final TextEditingController _inputController = TextEditingController();
  String _inputUnit = 'Celsius';
  String _outputUnit = 'Fahrenheit';
  String _outputValue = '';
  List<String> _history = [];
  String _errorMessage = '';

  void _convert() {
    try {
      double inputValue = double.tryParse(_inputController.text) ?? double.nan;
      if (inputValue.isNaN) throw Exception('Invalid input');

      double outputValue;
      if (_inputUnit == 'Celsius') {
        if (_outputUnit == 'Fahrenheit') {
          outputValue = (inputValue * 9 / 5) + 32;
        } else if (_outputUnit == 'Kelvin') {
          outputValue = inputValue + 273.15;
        } else {
          outputValue = inputValue;
        }
      } else if (_inputUnit == 'Fahrenheit') {
        if (_outputUnit == 'Celsius') {
          outputValue = (inputValue - 32) * 5 / 9;
        } else if (_outputUnit == 'Kelvin') {
          outputValue = (inputValue - 32) * 5 / 9 + 273.15;
        } else {
          outputValue = inputValue;
        }
      } else if (_inputUnit == 'Kelvin') {
        if (_outputUnit == 'Celsius') {
          outputValue = inputValue - 273.15;
        } else if (_outputUnit == 'Fahrenheit') {
          outputValue = (inputValue - 273.15) * 9 / 5 + 32;
        } else {
          outputValue = inputValue;
        }
      } else {
        outputValue = inputValue;
      }

      setState(() {
        _outputValue = outputValue.toStringAsFixed(2);
        _history.insert(0, '${_inputController.text} $_inputUnit = $_outputValue $_outputUnit');
        _errorMessage = '';
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Invalid input';
      });
    }
  }

  void _resetFields() {
    _inputController.clear();
    setState(() {
      _outputValue = '';
      _errorMessage = '';
    });
  }

  void _clearHistory() {
    setState(() {
      _history.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Konversi Suhu'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            TextField(
              controller: _inputController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Masukkan Nilai',
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<String>(
                  value: _inputUnit,
                  onChanged: (String? newValue) {
                    setState(() {
                      _inputUnit = newValue!;
                    });
                  },
                  items: <String>['Celsius', 'Fahrenheit', 'Kelvin']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                DropdownButton<String>(
                  value: _outputUnit,
                  onChanged: (String? newValue) {
                    setState(() {
                      _outputUnit = newValue!;
                    });
                  },
                  items: <String>['Celsius', 'Fahrenheit', 'Kelvin']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Text(
              'Hasil: $_outputValue $_outputUnit',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _convert,
                  child: Text('Konversi'),
                ),
                ElevatedButton(
                  onPressed: _resetFields,
                  child: Text('Reset'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Text(
              'Riwayat Konversi',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Expanded(
              child: ListView.builder(
                itemCount: _history.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(_history[index]),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _clearHistory,
              child: Text('Clear History'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}