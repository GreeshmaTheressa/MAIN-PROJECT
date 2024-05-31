import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lmpp/pages/financedept.dart';
import 'package:lottie/lottie.dart';
import 'package:lmpp/pages/employee.dart'; // Import the new file
import 'package:lmpp/pages/hr.dart'; // Import the new file
import 'package:lmpp/pages/manager.dart'; // Import the new file
import 'package:lmpp/pages/itdept.dart'; // Import the new file




void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ELMS',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RetrieveEmployeeScreen(),
    );
  }
}



class RetrieveEmployeeScreen extends StatefulWidget {
  @override
  _RetrieveEmployeeScreenState createState() => _RetrieveEmployeeScreenState();
}

class _RetrieveEmployeeScreenState extends State<RetrieveEmployeeScreen> {
  TextEditingController _empunameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  List<String>? _columnNames;
  List<String>? _employeeDetails;
  bool _isLoading = false;
  bool _obscurePassword = true;

  Future<void> _retrieveDetails(String uname, String password) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.34:3000/api/employee/$uname/$password'),
      );

      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final parsedResponse = json.decode(response.body);
        if (parsedResponse is Map<String, dynamic>) {
          _loginSuccess(parsedResponse);
        } else {
          _loginFailure('Invalid response format');
        }
      } else if (response.statusCode == 404) {
        // Employee not found, try in users table
        await _checkUserLogin(uname, password);
      } else {
        _loginFailure('Failed to retrieve employee details: ${response.statusCode}');
      }
    } catch (e) {
      _loginFailure('Error: $e');
    }
  }

  Future<void> _checkUserLogin(String uname, String password) async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.34:3000/api/user/$uname/$password'),
      );

      print('User Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final parsedResponse = json.decode(response.body);
        if (parsedResponse != null && parsedResponse is Map<String, dynamic>) {
          _loginSuccessForUser(parsedResponse);
        } else {
          _loginFailure('Invalid user response format');
        }
      } else if (response.statusCode == 404) {
        _loginFailure('User not found');
      } else {
        _loginFailure('Failed to retrieve user details: ${response.statusCode}');
      }
    } catch (e) {
      _loginFailure('Error: $e');
    }
  }

  void _loginSuccess(Map<String, dynamic> parsedResponse) {
    setState(() {
      _columnNames = parsedResponse.keys.toList();
      _employeeDetails = parsedResponse.values.map((value) => value.toString()).toList();
      _isLoading = false;
    });

    if (_columnNames != null && _employeeDetails != null) {
      // Check if employee details exist
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailsDisplayScreen(
            columnNames: _columnNames!,
            employeeDetails: _employeeDetails!,
          ),
        ),
      );
    } else {
      // Handle case when employee details are not found
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Employee not found or invalid credentials'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
void _loginSuccessForUser(Map<String, dynamic> parsedResponse) {
  // Extract the category of the logged-in user
  String category = parsedResponse['category'];
  
  // Extract the employee ID if available
  int? employeeIdInt = parsedResponse['user_id'];
  String? employeeId = employeeIdInt != null ? employeeIdInt.toString() : null;

  // Navigate based on user category
  switch (category) {
    case 'it':
      if (employeeId != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => itscreen(employeeId: employeeId), // Navigate to IT screen with employeeId
          ),
        );
      } else {
        _showErrorDialog('Employee ID not found for IT category');
      }
      break;
    case 'hr':
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MainScreen(employeeId: employeeId), // Navigate to HR screen with employeeId
        ),
      );
      break;
    case 'manager':
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserDetailsScreen(employeeId: employeeId), // Navigate to Manager screen with employeeId
        ),
      );
      break;
    case 'finance':
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => financescreen(employeeId: employeeId), // Navigate to Finance screen with employeeId
        ),
      );
      break;
    default:
      _showErrorDialog('Unknown user category');
  }
}

void _showErrorDialog(String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}




  void _loginFailure(String error) {
    setState(() {
      _isLoading = false;
    });

    // Show error message to the user, you can use a dialog or a snackbar to display the error.
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(error),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          SizedBox.expand(
            child: Lottie.asset(
              'lib/assets/loganim.json', // Path to your Lottie animation file
              fit: BoxFit.cover,
            ),
          ),
           Positioned(
      top: 10.0,
      left: 0,
      right: 0,
      child: Center(
        child: Text(
          'ELMS',
          style: TextStyle(
            fontSize: 50,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),  
        ),
      ),
    ),

          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              
              child: Container(
                width: 500,
                height: 400,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  color: Colors.white.withOpacity(0.8),
                ),
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(height: 20),
                   Text(
            'LOGIN', // Title text
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
                    SizedBox(height: 25),
                    TextFormField(
                      controller: _empunameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 30, width: 10),
                    Center(
                      child: SizedBox
                      (
                        width: 150.0,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            _retrieveDetails(
                              _empunameController.text,
                              _passwordController.text,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(50, 0),
                            padding: EdgeInsets.symmetric(vertical: 20.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            primary: Colors.blue,
                          ),
                          child: Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8.0),
                    if (_isLoading)
                      CircularProgressIndicator(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _empunameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
