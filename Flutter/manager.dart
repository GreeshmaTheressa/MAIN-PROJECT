import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart'; // Import the intl package
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lmpp/pages/login.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: UserDetailsScreen(),
    );
  }
}

class UserDetailsScreen extends StatefulWidget {
   final String? employeeId; // Define employeeId as a parameter

  UserDetailsScreen({this.employeeId}); 
  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isDrawerOpen = true;
  bool _showManageDepartment = false;
  bool _showRequestForm = false;
  bool _showManageEmployee = false;
  bool _showManageDesignation=false;
  bool _showsal=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Row(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            width: _isDrawerOpen ? 300 : 0,
            child: Drawer(
              elevation: 0,
              child: Container(
                color: const Color.fromARGB(255, 25, 45, 56),
                padding: EdgeInsets.zero,
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    Container(
                      height: 120,
                      child: DrawerHeader(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 25, 45, 56),
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 16),
                            Icon(
                              Icons.business,
                              color: Colors.white,
                              size: 50,
                            ),
                            SizedBox(width: 16),
                            Text(
                              'ELMS',
                              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.dashboard, color: Colors.white),
                      tileColor: Colors.blueGrey,
                      title: Text(
                        'Dashboard',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => UserDetailsScreen()));
                      },
                    ),
                      ListTile(
                        leading: Icon(Icons.person, color: Colors.white),
                      tileColor: Colors.blueGrey,
                      title: Text(
                        'Employees',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {setState(() {
                        _showRequestForm = false;
                        
                                _showManageDepartment = false;
                                _showManageDesignation=false;
                                _showManageEmployee = true;
                                _showsal=false;
                  
                              });},
                    ),
                      ListTile(
                        leading: Icon(Icons.work, color: Colors.white),
                      tileColor: Colors.blueGrey,
                      title: Text(
                        'Departments',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: (){setState(() {
                        _showRequestForm = false;
                        
                                _showManageDepartment = true;
                                _showManageDesignation=false;
                                _showManageEmployee = false;
                                _showsal=false;
                  
                              });},
                    ),
                      ListTile(
                        leading: Icon(Icons.business, color: Colors.white),
                      tileColor: Colors.blueGrey,
                      title: Text(
                        'Designations',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {setState(() {
                        _showRequestForm = false;
                        
                                _showManageDepartment = false;
                                _showManageDesignation=true;
                                _showManageEmployee = false;
                                _showsal=false;
                  
                              });},
                    ),

                    ListTile(
                      leading: Icon(Icons.pending_actions, color: Colors.white),
                      tileColor: Colors.blueGrey,
                      title: Text(
                        'Leave Requests',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {setState(() {
                        _showRequestForm = true;
                        
                                _showManageDepartment = false;
                                _showManageDesignation=false;
                                _showManageEmployee = false;
                                _showsal=false;
                  
                              });},
                    ),
                    ListTile(
                      leading: Icon(Icons.pending_actions, color: Colors.white),
                      tileColor: Colors.blueGrey,
                      title: Text(
                        'Salary Details',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {setState(() {
                        _showRequestForm = false;
                        
                                _showManageDepartment = false;
                                _showManageDesignation=false;
                                _showManageEmployee = false;
                                _showsal=true;
                  
                              });},
                    ),
                   ListTile(
                        leading: Icon(Icons.logout, color: Colors.white),
                        title: Text(
                          'Logout',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          _logout(context);
                        },
                      ),
                  ],
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.arrow_back_ios_new_outlined),
            onPressed: () {
              setState(() {
                _isDrawerOpen = !_isDrawerOpen;
              });
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              child: 
                       (_showManageDepartment
                          ? ManageDepartmentPage()
                         : (_showManageDesignation
                              
                              ? ManageDesignationPage()
                          
                          : (_showManageEmployee
                              
                              ? ManageEmployeePage()
                               : (_showRequestForm
                              ? LeaveRequestPage()
                             : (_showsal
                             ? ViewSalarySlipsPage()
                              // Show the employee form here
                              : MainContent()))))),
            ),
          ),
        ],
      ),
    );
  }
}
void _logout(BuildContext context) {
  // Implement your logout logic here
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => RetrieveEmployeeScreen()), // Replace MainScreen with the actual name of your main screen widget
    (route) => false, // This will remove all previous routes
  );
}
class MainContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        padding: EdgeInsets.fromLTRB(5.0, 10.0, 20.0, 300.0),
        child: Column(
          children: [
            Text(
              'My Dashboard',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 50),
            GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 2.1 / 0.6, // Adjust this ratio for rectangle
              ),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 5, // Number of cards
             itemBuilder: (context, index) {
  String title;
  IconData icon;
  Color iconColor;
  int value;

  switch (index) {
    case 0:
      title = 'Employees';
      icon = Icons.person;
      iconColor = Colors.orange;
      value = 50;
      break;
    case 1:
      title = 'Leave';
      icon = Icons.event;
      iconColor = Colors.blue;
      value = 20;
      break;
    case 2:
      title = 'Approved';
      icon = Icons.check;
      iconColor = Colors.green;
      value = 12;
      break;
    case 3:
      title = 'Pending';
      icon = Icons.info;
      iconColor = Colors.yellow;
      value = 5;
      break;
    case 4:
      title = 'Rejected';
      icon = Icons.delete;
      iconColor = Colors.red;
      value = 2;
      break;
    default:
      title = '';
      icon = Icons.error;
      iconColor = Colors.grey;
      value = 0;  // Assign a default value here
  }

  return Container(
    width: 120,  // Set a fixed width
    height: 0,   // Set a fixed height
    child: DashboardCard(
      icon: icon,
      title: title,
      value: value,  // You can set the actual value here
      iconColor: iconColor,
    ),
  );

              },
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final int value;
  final Color iconColor;

  DashboardCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,  // Increased elevation for shadow
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: iconColor),
            SizedBox(width: 10), // Add some space between icon and title
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 19),
                ),
                SizedBox(height: 2),
                Text(
                  value.toString(),  // Convert int to String here
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ManageDepartmentPage extends StatefulWidget {
  @override
  _ManageDepartmentPageState createState() => _ManageDepartmentPageState();
}

class _ManageDepartmentPageState extends State<ManageDepartmentPage> {
    List<Map<String, dynamic>> departments = []; // Define departments list

  Future<List<Map<String, dynamic>>> _fetchDepartments() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.34:3000/api/managedept'),
      );

      if (response.statusCode == 200) {
        final parsedResponse = json.decode(response.body);
        if (parsedResponse is List<dynamic>) {
          return List<Map<String, dynamic>>.from(parsedResponse);
        } else {
          print('Failed to retrieve department details: Invalid response format');
          return [];
        }
      } else {
        print('Failed to retrieve department details: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

 void _editDepartment(int index) async {
  final TextEditingController deptNameController = TextEditingController();
  final TextEditingController deptShortNameController = TextEditingController();

  try {
    final response = await http.get(
      Uri.parse('http://192.168.1.34:3000/api/managedept'),
    );

    if (response.statusCode == 200) {
      final parsedResponse = json.decode(response.body);
      if (parsedResponse is List<dynamic>) {
        final departments = List<Map<String, dynamic>>.from(parsedResponse);

        // Retrieve current department details
        final department = departments[index];
        deptNameController.text = department['DEPT_NAME'];
        deptShortNameController.text = department['DEPT_SHORT_NAME'];

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Edit Department'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Department Name:'),
                  TextFormField(
                    controller: deptNameController,
                    decoration: InputDecoration(
                      hintText: 'Enter department name',
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text('Department Short Name:'),
                  TextFormField(
                    controller: deptShortNameController,
                    decoration: InputDecoration(
                      hintText: 'Enter department short name',
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    _updateDepartment(
                      department['DEPT_ID'], // Assuming there's a 'DEPT_ID' field in the department object
                      deptNameController.text,
                      deptShortNameController.text,
                    );
                    Navigator.of(context).pop();
                  },
                  child: Text('Save'),
                ),
              ],
            );
          },
        );
      } else {
        print('Failed to retrieve department details: Invalid response format');
      }
    } else {
      print('Failed to retrieve department details: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

void _updateDepartment(int deptId, String newName, String newShortName) async {
  try {
    final response = await http.put(
      Uri.parse('http://192.168.1.34:3000/api/update_department/$deptId'), // Correct endpoint URL
      body: {
        'DEPT_NAME': newName,
        'DEPT_SHORT_NAME': newShortName,
      },
    );

    if (response.statusCode == 200) {
      print('Department updated successfully');
      // Trigger a rebuild of the UI to reflect the changes
      setState(() {});
    } else {
      print('Failed to update department: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}


void _deleteDepartment(int deptId) async {
  try {
print('Deleting department with ID: $deptId');

    final response = await http.delete(
      Uri.parse('http://192.168.1.34:3000/api/delete_department/$deptId'),
    );

    if (response.statusCode == 200) {
      print('Department deleted successfully');
      // Trigger a rebuild of the UI to reflect the changes
      setState(() {});
    } else {
      print('Failed to delete department: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}




      @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.fromLTRB(5.0, 10.0, 20.0, 180.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Manage Department',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Card(
              elevation: 4, // Add elevation for shadow effect
              child: Padding(
                padding: EdgeInsets.all(10),
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: _fetchDepartments(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      final departments = snapshot.data!;
                      return DataTable(
                        headingRowColor: MaterialStateColor.resolveWith((states) => Colors.grey[200]!), // Color for heading row
                        dataRowColor: MaterialStateColor.resolveWith((states) => Colors.white), // Color for data rows
                        columns: [
                          DataColumn(label: _buildDataColumnText('Department Name')),
                          DataColumn(label: _buildDataColumnText('Department Short Name')),
                          DataColumn(label: _buildDataColumnText('Action')), // Added action column
                        ],
                        rows: departments.map((department) {
                          // Format the date to display only the date part

                          return DataRow(cells: [
                            DataCell(Text(department['DEPT_NAME'], style: TextStyle(fontWeight: FontWeight.bold))),
                            DataCell(Text(department['DEPT_SHORT_NAME'], style: TextStyle(fontWeight: FontWeight.bold))),
                     
                          ]);
                        }).toList(),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataColumnText(String text) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }}
class ManageDesignationPage extends StatefulWidget {
  @override
  _ManageDesignationPageState createState() => _ManageDesignationPageState();
}

class _ManageDesignationPageState extends State<ManageDesignationPage> {
  Future<List<Map<String, dynamic>>> _fetchDesignations() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.34:3000/api/managedes'),
      );

      if (response.statusCode == 200) {
        final parsedResponse = json.decode(response.body);
        if (parsedResponse is List<dynamic>) {
          return List<Map<String, dynamic>>.from(parsedResponse);
        } else {
          print('Failed to retrieve department details: Invalid response format');
          return [];
        }
      } else {
        print('Failed to retrieve department details: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

void _editDesignation(int index) async {
  final TextEditingController desNameController = TextEditingController();
  final TextEditingController desShortNameController = TextEditingController();

  try {
    final response = await http.get(
      Uri.parse('http://192.168.1.34:3000/api/managedes'),
    );

    if (response.statusCode == 200) {
      final parsedResponse = json.decode(response.body);
      if (parsedResponse is List<dynamic>) {
        final designations = List<Map<String, dynamic>>.from(parsedResponse);

        // Retrieve current designation details
        final designation = designations[index];
        desNameController.text = designation['DESIGNATION_NAME'];
        desShortNameController.text = designation['DESIGNATION_DESC'];

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Edit Designation'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Designation Name:'),
                  TextFormField(
                    controller: desNameController,
                    decoration: InputDecoration(
                      hintText: 'Enter designation name',
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text('Designation Description:'),
                  TextFormField(
                    controller: desShortNameController,
                    decoration: InputDecoration(
                      hintText: 'Enter designation description',
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    _updateDesignation(
                      designation['DESIGNATION_ID'], // Assuming there's a 'DESIGNATION_ID' field in the designation object
                      desNameController.text,
                      desShortNameController.text,
                    );
                    Navigator.of(context).pop();
                  },
                  child: Text('Save'),
                ),
              ],
            );
          },
        );
      } else {
        print('Failed to retrieve designation details: Invalid response format');
      }
    } else {
      print('Failed to retrieve designation details: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

void _updateDesignation(int desId, String newName, String newShortName) async {
  try {
    final response = await http.put(
      Uri.parse('http://192.168.1.34:3000/api/update_des/$desId'), // Correct endpoint URL
      body: {
        'DESIGNATION_NAME': newName,
        'DESIGNATION_DESC': newShortName,
      },
    );

    if (response.statusCode == 200) {
      print('Designation updated successfully');
      // Trigger a rebuild of the UI to reflect the changes
      setState(() {});
    } else {
      print('Failed to update Designation: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

  void _deleteDesignation(int desId) async {
    try {
print('Deleting Designation with ID: $desId');

    final response = await http.delete(
      Uri.parse('http://192.168.1.34:3000/api/delete_des/$desId'),
    );

    if (response.statusCode == 200) {
      print('Designation deleted successfully');
      // Trigger a rebuild of the UI to reflect the changes
      setState(() {});
    } else {
      print('Failed to delete Designation: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.fromLTRB(5.0, 10.0, 20.0, 180.0), // Adjust padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Manage Designation',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Card(
              elevation: 4, // Add elevation for shadow effect
              child: Padding(
                padding: EdgeInsets.all(10),
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: _fetchDesignations(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      final designations = snapshot.data!;
                      return DataTable(
                        headingRowColor: MaterialStateColor.resolveWith((states) => Colors.grey[200]!), // Color for heading row
                        dataRowColor: MaterialStateColor.resolveWith((states) => Colors.white), // Color for data rows
                        columns: [
                          DataColumn(label: _buildDataColumnText('Designation Name')),
                          DataColumn(label: _buildDataColumnText('Designation Description')),
                         // DataColumn(label: _buildDataColumnText('Creation Date')),
                          DataColumn(label: _buildDataColumnText('Action')), // Added action column
                        ],
                        rows: designations.map((designation) {
                          // Format the date to display only the date part
                          //DateTime creationDate = DateTime.parse(designation['CREATION_DATE']);
                        //  String formattedDate = DateFormat('yyyy-MM-dd').format(creationDate);

                          return DataRow(cells: [
                            DataCell(Text(designation['DESIGNATION_NAME'], style: TextStyle(fontWeight: FontWeight.bold))),
                            DataCell(Text(designation['DESIGNATION_DESC'], style: TextStyle(fontWeight: FontWeight.bold))),
                           // DataCell(Text(formattedDate, style: TextStyle(fontStyle: FontStyle.italic))),
                     
                          ]);
                        }).toList(),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataColumnText(String text) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }}

class ManageEmployeePage extends StatefulWidget {
  @override
  _ManageEmployeePageState createState() => _ManageEmployeePageState();
}

class _ManageEmployeePageState extends State<ManageEmployeePage> {
 Future<List<Map<String, dynamic>>> _fetchEmployees() async {
  try {
    final response = await http.get(
      Uri.parse('http://192.168.1.34:3000/api/manageemp'),
    );

    if (response.statusCode == 200) {
      final parsedResponse = json.decode(response.body);
      if (parsedResponse is List<dynamic>) {
        return Future.wait(parsedResponse.map<Future<Map<String, dynamic>>>((employee) async {
          final departmentName = await getDepartmentName(int.parse(employee['DEPT_ID'].toString()));
          final designationName = await getDesignationName(int.parse(employee['DESIGNATION_ID'].toString()));
          // Add department and designation names to the employee map
          print('Department Name for Employee ${employee['EMPLOYEE_ID']}: $departmentName');
          print('Designation Name for Employee ${employee['EMPLOYEE_ID']}: $designationName');
          employee['DEPT_SHORT_NAME'] = departmentName;
          employee['DESIGNATION_NAME'] = designationName;
          return employee;
        }));
      } else {
        print('Failed to retrieve employee details: Invalid response format');
        return [];
      }
    } else {
      print('Failed to retrieve employee details: ${response.statusCode}');
      return [];
    }
  } catch (e) {
    print('Error: $e');
    return [];
  }
}

Future<String> getDepartmentName(int departmentId) async {
  try {
    final response = await http.get(
      Uri.parse('http://192.168.1.34:3000/api/department/$departmentId'),
    );

    if (response.statusCode == 200) {
      final parsedResponse = json.decode(response.body);
      if (parsedResponse is Map<String, dynamic>) {
        return parsedResponse['DEPT_SHORT_NAME'].toString(); // Ensure department name is converted to string
      }
    }
  } catch (e) {
    print('Error fetching department name: $e');
  }
  return 'Unknown';
}

Future<String> getDesignationName(int designationId) async {
  try {
    final response = await http.get(
      Uri.parse('http://192.168.1.34:3000/api/designation/$designationId'),
    );

    if (response.statusCode == 200) {
      final parsedResponse = json.decode(response.body);
      if (parsedResponse is Map<String, dynamic>) {
        return parsedResponse['DESIGNATION_NAME'].toString(); // Ensure designation name is converted to string
      }
    }
  } catch (e) {
    print('Error fetching designation name: $e');
  }
  return 'Unknown';
}




@override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal, // Allow horizontal scrolling
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(5.0, 10.0, 20.0, 180.0), // Adjust padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Manage Employee',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Card(
                elevation: 4, // Add elevation for shadow effect
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: _fetchEmployees(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        final employees = snapshot.data!;
                        return DataTable(
                          headingRowColor: MaterialStateColor.resolveWith((states) => Colors.grey[200]!), // Color for heading row
                          dataRowColor: MaterialStateColor.resolveWith((states) => Colors.white), // Color for data rows
                          columns: [
                            DataColumn(label: _buildDataColumnText('Employee ID')),
                            DataColumn(label: _buildDataColumnText('First Name')),
                            DataColumn(label: _buildDataColumnText('Middle Name')),
                            DataColumn(label: _buildDataColumnText('Last Name')),
                            DataColumn(label: _buildDataColumnText('Age')),
                            DataColumn(label: _buildDataColumnText('Gender')),
                            DataColumn(label: _buildDataColumnText('Email')),
                            DataColumn(label: _buildDataColumnText('Phone Number')),
                            DataColumn(label: _buildDataColumnText('Username')),
                            DataColumn(label: _buildDataColumnText('Password')),
                            DataColumn(label: _buildDataColumnText('Department')),
                            DataColumn(label: _buildDataColumnText('Designation')),
                            DataColumn(label: _buildDataColumnText('Action')), // Added action column
                          ],
                          rows: employees.map((employee) {
                            return DataRow(cells: [
                              DataCell(Text(employee['EMPLOYEE_ID'].toString(), style: TextStyle(fontWeight: FontWeight.bold))),
                              DataCell(Text(employee['FIRST_NAME'].toString(), style: TextStyle(fontWeight: FontWeight.bold))),
    DataCell(Text(employee['MIDDLE_NAME'] != null ? employee['MIDDLE_NAME'].toString() : '', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataCell(Text(employee['LAST_NAME'].toString(), style: TextStyle(fontWeight: FontWeight.bold))),
                              DataCell(Text(employee['AGE'].toString())),
                              DataCell(Text(employee['GENDER'].toString())),
                              DataCell(Text(employee['EMAIL'].toString())),
                              DataCell(Text(employee['PHNO'].toString())),
                              DataCell(Text(employee['USERNAME'].toString())),
                              DataCell(Text(employee['PASSWORD'].toString())),
                              DataCell(Text(employee['DEPT_SHORT_NAME'].toString())),
                              DataCell(Text(employee['DESIGNATION_NAME'].toString())),
                             
                            ]);
                          }).toList(),
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDataColumnText(String text) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }}




class LeaveRequestPage extends StatefulWidget {
  @override
  _LeaveRequestPageState createState() => _LeaveRequestPageState();
}

class _LeaveRequestPageState extends State<LeaveRequestPage> {
  Map<int, bool?> _approvalStatusMap = {};
  Map<int, String> _rejectionReasonsMap = {};

  @override
  void initState() {
    super.initState();
  }

 
  Future<List<Map<String, dynamic>>> _fetchLeaveRequest() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.34:3000/api/managereq'),
      );

      if (response.statusCode == 200) {
        final parsedResponse = json.decode(response.body);
        if (parsedResponse is List<dynamic>) {
          final List<Map<String, dynamic>> leaveRequests =
              List<Map<String, dynamic>>.from(parsedResponse);


          for (var request in leaveRequests) {
            final employeeId = request['EMPLOYEE_ID'];
            final userId = request['USER_ID'];

            if (employeeId != null) {
              final employeeDetailsResponse = await http.get(
                Uri.parse('http://192.168.1.34:3000/api/emp/$employeeId'),
              );

              if (employeeDetailsResponse.statusCode == 200) {
                final employeeDetails =
                    json.decode(employeeDetailsResponse.body);
                if (employeeDetails is Map<String, dynamic>) {
                  final firstName = employeeDetails['FIRST_NAME'] ?? '';
                  final middleName = employeeDetails['MIDDLE_NAME'] ?? '';
                  final lastName = employeeDetails['LAST_NAME'] ?? '';
                  final employeeName =
                      '$firstName ${middleName.isNotEmpty ? middleName + ' ' : ''}$lastName';
                  request['EMPLOYEE_NAME'] = employeeName;
                  request['EMPLOYEE_EMAIL'] = employeeDetails['EMAIL'];
                  final deptId = employeeDetails['DEPT_ID'];
                  final designationId = employeeDetails['DESIGNATION_ID'];
                  request['DEPARTMENT'] = await _fetchDepartmentName(deptId);
                  request['DESIGNATION'] = await _fetchDesignationName(designationId);
                } else {
                  print('Failed to parse employee details for employee ID: $employeeId');
                }
              } else {
                print('Failed to fetch employee details for employee ID: $employeeId');
              }
            } else if (userId != null) {
              final userDetailsResponse = await http.get(
                Uri.parse('http://192.168.1.34:3000/api/users/$userId'),
              );

              if (userDetailsResponse.statusCode == 200) {
                final userDetails = json.decode(userDetailsResponse.body);
                if (userDetails is Map<String, dynamic>) {
                  request['USER_NAME'] = userDetails['NAME'] ?? '-';
                  request['USER_EMAIL']=userDetails['EMAIL'];
                  final deptId = userDetails['DEPT_ID'];
                  final designationId = userDetails['DESIGNATION_ID'];
                  request['DEPARTMENT'] = await _fetchDepartmentName(deptId);
                  request['DESIGNATION'] = await _fetchDesignationName(designationId);
                } else {
                  print('Failed to parse user details for user ID: $userId');
                }
              } else {
                print('Failed to fetch user details for user ID: $userId');
              }
            }

            final leaveTypeId = request['LEAVE_TYPE_ID'];
            final leaveTypeResponse = await http.get(
              Uri.parse('http://192.168.1.34:3000/api/leave-type/$leaveTypeId'),
            );

            if (leaveTypeResponse.statusCode == 200) {
              final leaveTypeDetails = json.decode(leaveTypeResponse.body);
              if (leaveTypeDetails is Map<String, dynamic>) {
                request['LEAVE_TYPE_NAME'] = leaveTypeDetails['LEAVE_NAME'] ?? '-';
              } else {
                print('Failed to parse leave type details for leave type ID: $leaveTypeId');
              }
            } else {
              print('Failed to fetch leave type details for leave type ID: $leaveTypeId');
            }
          }

          return leaveRequests;
        } else {
          print('Failed to retrieve leave requests: Invalid response format');
          return [];
        }
      } else {
        print('Failed to retrieve leave requests: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  Future<String> _fetchDepartmentName(int id) async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.34:3000/api/department/$id'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> departmentDetails = json.decode(response.body);
        if (departmentDetails['DEPT_SHORT_NAME'] == 'HR') {
          return '';
        }
        return departmentDetails['DEPT_SHORT_NAME'] ?? '-';
      }
      print('Failed to fetch department details for department ID: $id');
      return '-';
    } catch (e) {
      print('Error fetching department name: $e');
      return '-';
    }
  }

  Future<String> _fetchDesignationName(int id) async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.34:3000/api/designation/$id'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> designationDetails = json.decode(response.body);
        if (designationDetails['DESIGNATION_NAME'] == 'HR' ||
            designationDetails['DESIGNATION_NAME'] == 'Dept Head') {
          return '';
        }
        return designationDetails['DESIGNATION_NAME'] ?? '-';
      }
      print('Failed to fetch designation details for designation ID: $id');
      return '-';
    } catch (e) {
      print('Error fetching designation name: $e');
      return '-';
    }
  }


    @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.fromLTRB(5.0, 10.0, 20.0, 180.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'View Leave Requests',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _fetchLeaveRequest(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final requests = snapshot.data!.where((request) {
                    if (request['EMPLOYEE_ID'] != null) {
                      return request['APPROVED_BY2'] == 'Approved';
                    } else if (request['USER_ID'] != null) {
                      return true; // Include user leave requests
                    }
                    return false; // Default to false if neither EMPLOYEE_ID nor USER_ID is present
                  }).toList();
                  return SizedBox(
                    width: double.infinity,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Card(
                        elevation: 4,
                        child: DataTable(
                          headingRowColor: MaterialStateColor.resolveWith((states) => Colors.grey[200]!),
                          dataRowColor: MaterialStateColor.resolveWith((states) => Colors.white),
                          columns: [
                            DataColumn(label: _buildDataColumnText('Application Id')),
                            DataColumn(label: _buildDataColumnText('Application Date')),
                            DataColumn(label: _buildDataColumnText('Employee ID')),
                            DataColumn(label: _buildDataColumnText('Employee Name')),
                            DataColumn(label: _buildDataColumnText('Department')),
                            DataColumn(label: _buildDataColumnText('Designation')),
                            DataColumn(label: _buildDataColumnText('Leave Type')),
                            DataColumn(label: _buildDataColumnText('From Date')),
                            DataColumn(label: _buildDataColumnText('To Date')),
                            DataColumn(label: _buildDataColumnText('Action')),
                            DataColumn(label: _buildDataColumnText('Status')),
                          ],
                          rows: requests
                              .where((leave_application) =>
                                  leave_application['DEPARTMENT'] != '' &&
                                  leave_application['DESIGNATION'] != '')
                              .map((leave_application) {
                            final applicationId = leave_application['APPLICATION_ID'];

                            return DataRow(cells: [
                              DataCell(Text(applicationId.toString())),
                              DataCell(Text(leave_application['DATE_OF_APPLICATION'])),
                              DataCell(Text(leave_application['EMPLOYEE_ID'] != null
                                  ? leave_application['EMPLOYEE_ID'].toString()
                                  : ' ')),
                              DataCell(Text(leave_application['EMPLOYEE_NAME'] != null &&
                                      leave_application['EMPLOYEE_NAME'] != ''
                                  ? leave_application['EMPLOYEE_NAME']
                                  : ' ')),
                              DataCell(Text(leave_application['DEPARTMENT'] ?? ' ')),
                              DataCell(Text(leave_application['DESIGNATION'] ?? ' ')),
                              DataCell(Text(leave_application['LEAVE_TYPE_NAME'] ?? ' ')),
                              DataCell(Text(leave_application['START_DATE'])),
                              DataCell(Text(leave_application['END_DATE'])),
                              DataCell(Row(
  children: [
    ElevatedButton(
     onPressed: () async {
                                      await _updateApprovalStatus(
                                          applicationId, true,
                                          leaveApplicationDetails:
                                              leave_application);
                                      setState(() {
                                        _approvalStatusMap[applicationId] =
                                            true;
                                      });
                                    },
      child: Text('Approve'),
    ),
    SizedBox(width: 10),
    ElevatedButton(
      onPressed: () {
          _showRejectDialog(applicationId,leaveApplicationDetails:
                                              leave_application);
       
      },
      child: Text('Reject'),
    ),
  ],
)),
                              DataCell(
  FutureBuilder<bool?>(
    future: _fetchApprovalStatus(applicationId),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return CircularProgressIndicator();
      } else if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      } else {
        final bool? approvalStatus = snapshot.data;
        if (approvalStatus == null) {
          return Text('Pending'); // Display "Pending" when status is not available
        } else {
          return Text(
            approvalStatus ? 'Approved' : 'Rejected',
            style: TextStyle(
              color: approvalStatus ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          );
        }
      }
    },
  ),
),

                            ]);
                          }).toList(),
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataColumnText(String text) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

 void _showRejectDialog(int applicationId ,{Map<String, dynamic>? leaveApplicationDetails}){
  String rejectReason = '';

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Reject Leave Request'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Reason for Rejection'),
              onChanged: (value) {
                rejectReason = value;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
                await _updateApprovalStatus(applicationId, false,
                    reason: rejectReason,
                    leaveApplicationDetails: leaveApplicationDetails);
                Navigator.of(context).pop(); // Close the dialog
              },
            child: Text('Reject'),
          ),
        ],
      );
    },
  );
}

  Future<void> _updateApprovalStatus(int applicationId, bool approved, {String? reason, Map<String, dynamic>? leaveApplicationDetails}) async {
    try {
      final Map<String, dynamic> requestBody = {
        'approved': approved,
      };
      if (!approved && reason != null) {
        requestBody['reason'] = reason; // Include the reason in the request body if rejecting and reason is provided
      }

      final response = await http.put(
        Uri.parse('http://192.168.1.34:3000/api/${approved ? 'approve-leave3' : 'reject-leave3'}/$applicationId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        print('Leave request with ID $applicationId ${approved ? 'approved' : 'rejected'} successfully');
        // Save the approval status to shared preferences
        final prefs = await SharedPreferences.getInstance();
        prefs.setBool('approvalStatus_$applicationId', approved);
if (!approved && reason != null) {
        setState(() {
          _rejectionReasonsMap[applicationId] = reason;
        });
      }
    // Send email notification
        final subject = approved ? 'Leave Approved' : 'Leave Rejected';
        final reasonText = approved ? '' : '\n\nReason for Rejection: $reason';
        final body = approved
            ? 'Your leave request has been approved by Manager.'
            : 'Your leave request has been rejected by Manager.$reasonText';
        final fromEmail = 'greeshmatheressa123@gmail.com'; // Change to your sender email
        final employeeEmail = leaveApplicationDetails != null
            ? leaveApplicationDetails['EMPLOYEE_EMAIL']
            : ''; // Use the employee's email from leaveApplicationDetails
        final ccRecipients = 'manager@gmail.com'; // Add CC recipients if needed
        final bccRecipients = ''; // Add BCC recipients if needed

        final emailResponse = await http.post(
          Uri.parse('http://192.168.1.34:3000/send-email'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            'fromEmail': fromEmail,
            'employeeEmail': employeeEmail,
            'ccRecipients': ccRecipients,
            'bccRecipients': bccRecipients,
            'subject': subject,
            'body': body,
          }),
        );

        if (emailResponse.statusCode == 200) {
          print('Email sent successfully.');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Email sent successfully.'),
              duration: Duration(seconds: 2), // Adjust the duration as needed
            ),
          );
        } else {
          print('Failed to send email: ${emailResponse.body}');
        }
      } else {
        print('Failed to update approval status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating approval status: $e');
    }
  }

Future<bool?> _fetchApprovalStatus(int applicationId) async {
  try {
    final response = await http.get(
      Uri.parse('http://192.168.1.34:3000/api/fetch-approval-status3/$applicationId'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final String? status = data['status'];
      if (status == 'Approved') {
        return true;
      } else if (status == 'Rejected') {
        return false;
      } else {
        return null; // Status is neither Approved nor Rejected, so return null
      }
    } else {
      print('Failed to fetch approval status: ${response.statusCode}');
      return null; // Return null instead of false when status is not fetched
    }
  } catch (e) {
    print('Error fetching approval status: $e');
    return null; // Return null instead of false in case of error
  }
}


}
class ViewSalarySlipsPage extends StatefulWidget {
  @override
  _ViewSalarySlipsPageState createState() => _ViewSalarySlipsPageState();
}

class _ViewSalarySlipsPageState extends State<ViewSalarySlipsPage> {
  final TextEditingController _employeeIdController = TextEditingController();
  Map<String, dynamic> _employeeSalary = {};
  Map<String, dynamic> _employeeDetails = {};

  void _fetchSalaryDetailsAndGenerateSlip(BuildContext context, String employeeId) async {
    try {
      // Fetch leave applications for the employee
      await _fetchLeaveApplications(employeeId);
      // Fetch salary details for the employee
      await _fetchSalaryDetails(context, employeeId);
    } catch (e) {
      print('Error fetching salary details and generating slip: $e');
      // Handle error (e.g., show error message)
    }
  }

  Future<List<Map<String, dynamic>>> _fetchLeaveApplications(String? employeeId) async {
    try {
      print('ManageLeaveStatus - Employee ID: $employeeId');
      final response = await http.get(
        Uri.parse('http://192.168.1.34:3000/api/leavestatususer/$employeeId'),
      );

      if (response.statusCode == 200) {
        final parsedResponse = json.decode(response.body);
        if (parsedResponse is List<dynamic>) {
          return List<Map<String, dynamic>>.from(parsedResponse);
        } else {
          print('Failed to retrieve leave status details: Invalid response format');
          return [];
        }
      } else {
        print('Failed to retrieve leave status details: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  Future<void> _fetchSalaryDetails(BuildContext context, String employeeId) async {
    try {
      // Fetch salary details
      final salaryResponse = await http.get(
        Uri.parse('http://192.168.1.34:3000/api/managesal/$employeeId'),
      );

      // Fetch employee details
      final employeeResponse = await http.get(
        Uri.parse('http://192.168.1.34:3000/api/employee/$employeeId'),
      );

      // Fetch total leave days
      final leaveResponse = await http.get(
        Uri.parse('http://192.168.1.34:3000/api/leave-summary?employeeId=$employeeId'),
      );

      if (salaryResponse.statusCode == 200 &&
          employeeResponse.statusCode == 200 &&
          leaveResponse.statusCode == 200) {
        final dynamic parsedSalaryResponse = json.decode(salaryResponse.body);
        final dynamic parsedEmployeeResponse = json.decode(employeeResponse.body);
        final dynamic parsedLeaveResponse = json.decode(leaveResponse.body);

        // Extract salary details
        final salaryDetails = {
          'employee_id': parsedSalaryResponse['employee_id'].toString(),
          'basic_pay': parsedSalaryResponse['basic_pay'].toString(),
          'hra': parsedSalaryResponse['hra'].toString(),
          'da': parsedSalaryResponse['da'].toString(),
          'other_allowance': parsedSalaryResponse['other_allowance'].toString(),
          'provident_fund': parsedSalaryResponse['provident_fund'].toString(),
          'professional_tax': parsedSalaryResponse['professional_tax'].toString(),
          'tot_sal': parsedSalaryResponse['tot_sal'].toString(),
        };

        // Extract employee details
        final employeeDetails = {
          'employee_id': parsedEmployeeResponse['employee_id'].toString(),
          'employee_name': parsedEmployeeResponse['employee_name'].toString(),
          'dept_name': parsedEmployeeResponse['dept_name'].toString(),
          'designation_name': parsedEmployeeResponse['designation_name'].toString(),
          // Include other employee details as needed
        };

        // Extract total leave days
        double totalLeaveDays = double.tryParse(parsedLeaveResponse['totalLeaveDays'].toString() ?? '0') ?? 0;

        // Calculate total work days
        double totalWorkDays = 30 - totalLeaveDays;

        // Calculate salary per day
        double totalSalary = double.tryParse(salaryDetails['tot_sal'] ?? '0') ?? 0;
        double salaryPerDay = totalSalary / 30;

        // Calculate net salary
        double netSalary = salaryPerDay * totalWorkDays;

        // Calculate leave deduction
        double leaveDeduction = salaryPerDay * totalLeaveDays;

        // Update state with both salary, employee, and leave details
        setState(() {
          _employeeSalary = {
            ...salaryDetails,
            'salary_per_day': salaryPerDay.toStringAsFixed(2), // Add salary per day to the salary details
            'total_leave_days': totalLeaveDays.toString(), // Add total leave days to the salary details
            'total_work_days': totalWorkDays.toString(), // Add total work days to the salary details
            'net_salary': netSalary.toStringAsFixed(2), // Add net salary to the salary details
            'leave_deduction': leaveDeduction.toStringAsFixed(0), // Add leave deduction to the salary details
          };
          _employeeDetails = employeeDetails;
          // _showsal = true;
        });
      } else {
        print('Failed to retrieve salary or employee details');
        // Handle error
      }
    } catch (e) {
      print('Error fetching salary or employee details: $e');
      // Handle error
    }
  }

  void _searchEmployeeSalary(String employeeId) {
    if (employeeId.isNotEmpty) {
      // Call the method to fetch salary details
      _fetchSalaryDetailsAndGenerateSlip(context, employeeId);
    } else {
      // Handle case when employee ID is empty
      print('Employee ID cannot be empty.');
    }
  }

 @override
Widget build(BuildContext context) {
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(25.0, 20.0, 5.0, 0.0),
          child: Text(
            'View Employee Salary Slip',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 20.0),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.5,
            child: Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _employeeIdController,
                      decoration: InputDecoration(
                        labelText: 'Enter Employee ID',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        _searchEmployeeSalary(_employeeIdController.text);
                      },
                      child: Text('Search'),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (_employeeSalary.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Salary Details',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Container(
  height: MediaQuery.of(context).size.height * 0.9, // Adjust this percentage as needed
  child: SalaryDetailsWidget(
    employeeSalary: _employeeSalary,
    employeeDetails: _employeeDetails,
  ),
),
              ],
            ),
          ),
        ],
        if (_employeeSalary.isEmpty && _employeeIdController.text.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 20.0),
            child: Text('No salary details found for the employee.'),
          ),
      ],
    ),
  );
}
}
class SalaryDetailsWidget extends StatelessWidget {
  final Map<String, dynamic> employeeSalary;
  final Map<String, dynamic> employeeDetails;

  SalaryDetailsWidget({
    required this.employeeSalary,
    required this.employeeDetails,
  });

    @override
Widget build(BuildContext context) {
  return SizedBox(
    width: 600,
    height: 3000,
    child: Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'ELMS',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '123 ABStreet',
            style: TextStyle(
              fontStyle: FontStyle.italic,
            ),
          ),
          SizedBox(height: 16), // Add space between company name/address and Pay Slip heading
          Text(
            'Pay Slip for the Month ${DateFormat('MMMM yyyy').format(DateTime.now())}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16), // Add more space before the rest of the content
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                'Date: ${DateFormat('dd-MM-yyyy').format(DateTime.now())}',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildEmployeeRow('Employee ID'),
          _buildEmployeeRow('Employee Name'),
          _buildEmployeeRow('Department'),
          _buildEmployeeRow('Designation'),
          SizedBox(height: 16),
          _buildEarningsDeductions(),
        ],
      ),
    ),
  );
}
  Widget _buildEmployeeRow(String label) {
    String? value;

    switch (label) {
      case 'Employee ID':
        value = employeeDetails['employee_id'];
        break;
      case 'Employee Name':
        String fullName = employeeDetails['employee_name'] ?? '';
        value = fullName.isNotEmpty ? fullName : 'Unknown';
        break;
      case 'Department':
        value = employeeDetails['dept_name'];
        break;
      case 'Designation':
        value = employeeDetails['designation_name'];
        break;
      default:
        value = ''; // Handle unknown label
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: Text(
              value ?? '',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEarningsDeductions() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Table(
            columnWidths: {
              4: FlexColumnWidth(1),
              1: FlexColumnWidth(0.10),
              2: FlexColumnWidth(1),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey)),
                ),
                children: [
                  TableCell(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        'Earnings',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Center(
                      child: VerticalDivider(color: Colors.grey),
                    ),
                  ),
                  TableCell(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        'Deductions',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              TableRow(
                children: [
                  TableCell(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildRow('Basic Pay', employeeSalary['basic_pay']),
                        _buildRow('HRA', employeeSalary['hra']),
                        _buildRow('DA', employeeSalary['da']),
                        _buildRow('Other Allowance', employeeSalary['other_allowance']),
                      ],
                    ),
                  ),
                  TableCell(
                    child: SizedBox.shrink(),
                  ),
                  TableCell(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildRow('Provident Fund', employeeSalary['provident_fund']),
                        _buildRow('Professional Tax', employeeSalary['professional_tax']),
                        _buildRow('Leave', employeeSalary['leave_deduction']),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 40),
        Text(
          'Net Salary: ${employeeSalary['net_salary']}',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildRow(String label, dynamic value) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              value.toString(),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
