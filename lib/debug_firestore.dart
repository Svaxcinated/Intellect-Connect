import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DebugFirestorePage extends StatefulWidget {
  const DebugFirestorePage({Key? key}) : super(key: key);

  @override
  State<DebugFirestorePage> createState() => _DebugFirestorePageState();
}

class _DebugFirestorePageState extends State<DebugFirestorePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _status = 'Testing connection...';
  List<String> _logs = [];

  @override
  void initState() {
    super.initState();
    _testFirestore();
  }

  void _addLog(String message) {
    setState(() {
      _logs.add('${DateTime.now().toString().substring(11, 19)}: $message');
    });
  }

  Future<void> _testFirestore() async {
    try {
      _addLog('Starting Firestore test...');
      
      // Test 1: Check if Firestore is accessible
      _addLog('Testing basic Firestore access...');
      await _firestore.collection('test').get();
      _addLog('✅ Firestore is accessible');
      
      // Test 2: Try to create a test document
      _addLog('Testing document creation...');
      await _firestore.collection('test').add({
        'message': 'Hello from Flutter!',
        'timestamp': FieldValue.serverTimestamp(),
        'test': true,
      });
      _addLog('✅ Document created successfully');
      
      // Test 3: Try to read the document
      _addLog('Testing document reading...');
      final querySnapshot = await _firestore.collection('test').get();
      _addLog('✅ Read ${querySnapshot.docs.length} documents');
      
      // Test 4: Check if user is authenticated
      _addLog('Checking authentication status...');
      final user = _auth.currentUser;
      if (user != null) {
        _addLog('✅ User is authenticated: ${user.email}');
      } else {
        _addLog('⚠️ No user is currently authenticated');
      }
      
      // Test 5: Try to access users collection
      _addLog('Testing users collection access...');
      try {
        final usersSnapshot = await _firestore.collection('users').get();
        _addLog('✅ Users collection accessible: ${usersSnapshot.docs.length} users found');
      } catch (e) {
        _addLog('❌ Users collection error: $e');
      }
      
      // Test 6: Try to access subjects collection
      _addLog('Testing subjects collection access...');
      try {
        final subjectsSnapshot = await _firestore.collection('subjects').get();
        _addLog('✅ Subjects collection accessible: ${subjectsSnapshot.docs.length} subjects found');
      } catch (e) {
        _addLog('❌ Subjects collection error: $e');
      }
      
      setState(() {
        _status = 'All tests completed!';
      });
      
    } catch (e) {
      _addLog('❌ Error: $e');
      setState(() {
        _status = 'Test failed: $e';
      });
    }
  }

  Future<void> _createSampleData() async {
    try {
      _addLog('Creating sample data...');
      
      // Create sample subjects
      await _firestore.collection('subjects').add({
        'subjectId': 'db_001',
        'name': 'Database Magic',
        'displayName': 'Database Magic 🗄️',
        'description': 'Learn the fundamentals of database systems',
        'icon': 'storage',
        'color': '#2196F3',
        'gradeLevels': ['Grade 3', 'Grade 4', 'Grade 5', 'Grade 6'],
        'isActive': true,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      
      await _firestore.collection('subjects').add({
        'subjectId': 'net_001',
        'name': 'Networking Fun',
        'displayName': 'Networking Fun 🌐',
        'description': 'Explore computer networks and connectivity',
        'icon': 'dns',
        'color': '#4CAF50',
        'gradeLevels': ['Grade 4', 'Grade 5', 'Grade 6'],
        'isActive': true,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      
      _addLog('✅ Sample subjects created');
      
      // Create sample achievements
      await _firestore.collection('achievements').add({
        'achievementId': 'first_session',
        'name': 'First Steps',
        'description': 'Complete your first learning session',
        'icon': '🎯',
        'points': 10,
        'criteria': 'Complete 1 session',
        'isActive': true,
        'createdAt': FieldValue.serverTimestamp(),
      });
      
      _addLog('✅ Sample achievements created');
      
    } catch (e) {
      _addLog('❌ Error creating sample data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firestore Debug'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Status: $_status',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _testFirestore,
                  child: const Text('Run Tests'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _createSampleData,
                  child: const Text('Create Sample Data'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Debug Logs:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListView.builder(
                  itemCount: _logs.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(
                        _logs[index],
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Call this when the user types in the address field
Future<List<String>> fetchAddressSuggestions(String query) async {
  final url = Uri.parse('https://photon.komoot.io/api/?q=$query&lang=en&limit=5');
  final response = await http.get(url);
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final features = data['features'] as List;
    return features.map<String>((feature) {
      final props = feature['properties'];
      // Combine name, city, country for display
      return [
        props['name'],
        if (props['city'] != null) props['city'],
        if (props['state'] != null) props['state'],
        if (props['country'] != null) props['country'],
      ].where((e) => e != null).join(', ');
    }).toList();
  } else {
    return [];
  }
} 