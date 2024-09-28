import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const TemperatureConverterApp());
}

class TemperatureConverterApp extends StatefulWidget {
  const TemperatureConverterApp({super.key});

  @override
  _TemperatureConverterAppState createState() => _TemperatureConverterAppState();
}

class _TemperatureConverterAppState extends State<TemperatureConverterApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Temperature Converter',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: Colors.teal, // Text color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.teal,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.grey[900],
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black, backgroundColor: Colors.tealAccent, // Text color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      home: TemperatureConverter(
        onThemeToggle: _toggleTheme,
        isDarkMode: _themeMode == ThemeMode.dark,
      ),
    );
  }
}

class TemperatureConverter extends StatefulWidget {
  final Function(bool) onThemeToggle;
  final bool isDarkMode;

  const TemperatureConverter({super.key, required this.onThemeToggle, required this.isDarkMode});

  @override
  _TemperatureConverterState createState() => _TemperatureConverterState();
}

class _TemperatureConverterState extends State<TemperatureConverter> {
  String _conversionType = "F to C"; // Default to Fahrenheit to Celsius
  final TextEditingController _inputController = TextEditingController();
  String _result = '';
  List<String> _history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  // Load conversion history from SharedPreferences
  void _loadHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _history = prefs.getStringList('conversion_history') ?? [];
    });
  }

  // Save conversion history to SharedPreferences
  void _saveHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('conversion_history', _history);
  }

  void _convertTemperature() {
    double? inputTemperature = double.tryParse(_inputController.text);
    if (inputTemperature == null) {
      // Show error if input is not a valid number
      setState(() {
        _result = "Please enter a valid number.";
      });
      return;
    }

    double convertedTemperature;

    if (_conversionType == "F to C") {
      // Fahrenheit to Celsius conversion
      convertedTemperature = (inputTemperature - 32) * 5 / 9;
      setState(() {
        _result =
        "${inputTemperature.toStringAsFixed(2)} °F = ${convertedTemperature.toStringAsFixed(2)} °C";
        _history.add(
            "F to C: ${inputTemperature.toStringAsFixed(1)} => ${convertedTemperature.toStringAsFixed(1)}");
      });
    } else {
      // Celsius to Fahrenheit conversion
      convertedTemperature = inputTemperature * 9 / 5 + 32;
      setState(() {
        _result =
        "${inputTemperature.toStringAsFixed(2)} °C = ${convertedTemperature.toStringAsFixed(2)} °F";
        _history.add(
            "C to F: ${inputTemperature.toStringAsFixed(1)} => ${convertedTemperature.toStringAsFixed(1)}");
      });
    }

    _saveHistory();
  }

  void _clearHistory() {
    setState(() {
      _history.clear();
    });
    _saveHistory();
  }

  @override
  Widget build(BuildContext context) {
    // Determine screen orientation
    var isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Temperature Converter'),
        actions: [
          // Theme toggle switch
          Icon(widget.isDarkMode
              ? Icons.dark_mode
              : Icons.light_mode),
          Switch(
            value: widget.isDarkMode,
            onChanged: widget.onThemeToggle,
            activeColor: Colors.yellow,
            inactiveThumbColor: Colors.grey,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLandscape
            ? Row(
          children: [
            Expanded(child: _buildConversionSection()),
            const SizedBox(width: 20),
            Expanded(child: _buildHistorySection()),
          ],
        )
            : Column(
          children: [
            _buildConversionSection(),
            const SizedBox(height: 20),
            Expanded(child: _buildHistorySection()),
          ],
        ),
      ),
    );
  }

  Widget _buildConversionSection() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Input field
            TextField(
              controller: _inputController,
              keyboardType:
              const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Enter Temperature',
                prefixIcon: Icon(Icons.thermostat_outlined),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Conversion type (F to C or C to F) radio buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Radio<String>(
                  value: "F to C",
                  groupValue: _conversionType,
                  onChanged: (String? value) {
                    setState(() {
                      _conversionType = value!;
                    });
                  },
                ),
                const Text('Fahrenheit to Celsius'),
                const SizedBox(width: 20),
                Radio<String>(
                  value: "C to F",
                  groupValue: _conversionType,
                  onChanged: (String? value) {
                    setState(() {
                      _conversionType = value!;
                    });
                  },
                ),
                const Text('Celsius to Fahrenheit'),
              ],
            ),

            const SizedBox(height: 16),

            // Convert button with animation
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: ElevatedButton.icon(
                onPressed: _convertTemperature,
                icon: const Icon(Icons.swap_horiz),
                label: const Text('Convert'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Result display
            Text(
              _result,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistorySection() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // History Header with clear button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Conversion History',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_forever, color: Colors.red),
                  onPressed: _history.isNotEmpty
                      ? () {
                    _showClearHistoryConfirmation();
                  }
                      : null,
                ),
              ],
            ),
            const Divider(),

            // Conversion history list
            _history.isNotEmpty
                ? Expanded(
              child: ListView.builder(
                itemCount: _history.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(
                      index % 2 == 0
                          ? Icons.arrow_forward
                          : Icons.arrow_back,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: Text(_history[index]),
                  );
                },
              ),
            )
                : const Expanded(
              child: Center(
                child: Text(
                  'No conversions yet.',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showClearHistoryConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clear History'),
          content: const Text('Are you sure you want to clear the conversion history?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text(
                'Clear',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                _clearHistory();
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
}

