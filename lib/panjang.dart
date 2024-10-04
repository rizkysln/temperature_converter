import 'package:flutter/material.dart';

class PanjangConverterPage extends StatefulWidget {
  @override
  _PanjangConverterPageState createState() => _PanjangConverterPageState();
}

class _PanjangConverterPageState extends State<PanjangConverterPage> {
  final TextEditingController _inputController = TextEditingController();
  String _inputUnit = 'MM';
  String _outputUnit = 'M';
  String _outputValue = '';
  List<String> _history = [];
  String _errorMessage = '';

  static const Map<String, double> unitConversionFactors = {
    'MM': 1,
    'CM': 10,
    'DM': 100,
    'M': 1000,
    'DAM': 10000,
    'HM': 100000,
    'KM': 1000000,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Konversi Panjang'),
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
                labelText: 'Masukkan nilai',
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
                  items: unitConversionFactors.keys
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
                  items: unitConversionFactors.keys
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
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
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

  void _convert() {
    try {
      double inputValue = double.tryParse(_inputController.text) ?? double.nan;
      if (inputValue.isNaN) throw Exception('Nilai tidak valid');

      double inputInMm = inputValue * unitConversionFactors[_inputUnit]!;
      double outputValue = inputInMm / unitConversionFactors[_outputUnit]!;

      setState(() {
        _outputValue = outputValue.toStringAsFixed(2);
        _history.insert(
            0, '${_inputController.text} $_inputUnit = $_outputValue $_outputUnit');
        _errorMessage = '';
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Nilai tidak valid';
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
}
