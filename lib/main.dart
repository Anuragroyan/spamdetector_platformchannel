import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(SpamDetectorApp());
}

class SpamDetectorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spam Message Detector',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SpamHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SpamHomePage extends StatefulWidget {
  @override
  _SpamHomePageState createState() => _SpamHomePageState();
}

class _SpamHomePageState extends State<SpamHomePage> {
  static const platform = MethodChannel('spam_detection');
  final TextEditingController _controller = TextEditingController();
  String _result = '';

  Future<void> _detectSpam() async {
    String message = _controller.text.trim();
    if (message.isEmpty) {
      setState(() {
        _result = "Please enter a message.";
      });
      return;
    }

    try {
      final String result = await platform.invokeMethod('detectSpam', {
        'message': message,
      });
      setState(() {
        _result = result;
      });
    } on PlatformException catch (e) {
      setState(() {
        _result = "Error: ${e.message}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Spam Message Detector'),
        titleTextStyle: TextStyle(
          fontSize: 19,
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Type a message to detect spam:',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _controller,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'e.g. Congratulations! You won a free prize.',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _controller.clear();
                  },
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _result = '';
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _detectSpam,
              icon: Icon(Icons.search),
              label: Text('Check Message',
               style: TextStyle(
                 color: Colors.black87,
                 fontSize: 19.0,
                 fontWeight: FontWeight.bold,
               ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal.shade200,
                padding: EdgeInsets.symmetric(vertical: 15),
                textStyle: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 30),
            if (_result.isNotEmpty)
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _result == 'Spam' ? Colors.red[100] : Colors.green[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Result: $_result',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _result == 'Spam' ? Colors.red : Colors.green[800],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

}
