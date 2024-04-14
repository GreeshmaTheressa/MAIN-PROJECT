import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart'; // Import the intl package
import 'package:shared_preferences/shared_preferences.dart';



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
                  
                              });},
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
                             
                              // Show the employee form here
                              : MainContent())))),
            ),
          ),
        ],
      ),
    );
  }
}

class MainContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        padding: EdgeInsets.fromLTRB(5.0, 10.0, 20.0, 180.0),
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
                childAspectRatio: 2.0 / 1.0, // Adjust this ratio for rectangle
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
            Icon(icon, size: 50, color: iconColor),
            SizedBox(width: 10), // Add some space between icon and title
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 2),
                Text(
                  value.toString(),  // Convert int to String here
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
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
  Future<List<Map<String, dynamic>>> _fetchDepartments() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.7:3000/api/managedept'),
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

  void _editDepartment(int index) {
    // Implement edit department functionality
    print('Edit department at index: $index');
  }

  void _deleteDepartment(int index) {
    // Implement delete department functionality
    print('Delete department at index: $index');
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
                          DataColumn(label: _buildDataColumnText('Creation Date')),
                          DataColumn(label: _buildDataColumnText('Action')), // Added action column
                        ],
                        rows: departments.map((department) {
                          // Format the date to display only the date part
                          DateTime creationDate = DateTime.parse(department['CREATION_DATE']);
                          String formattedDate = DateFormat('yyyy-MM-dd').format(creationDate);

                          return DataRow(cells: [
                            DataCell(Text(department['DEPT_NAME'], style: TextStyle(fontWeight: FontWeight.bold))),
                            DataCell(Text(department['DEPT_SHORT_NAME'], style: TextStyle(fontWeight: FontWeight.bold))),
                            DataCell(Text(formattedDate, style: TextStyle(fontStyle: FontStyle.italic))),
                            DataCell(Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () => _editDepartment(departments.indexOf(department)),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteDepartment(departments.indexOf(department)),
                                ),
                              ],
                            )),
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
        Uri.parse('http://192.168.1.7:3000/api/managedes'),
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

  void _editDesignation(int index) {
    // Implement edit department functionality
    print('Edit designation at index: $index');
  }

  void _deleteDesignation(int index) {
    // Implement delete department functionality
    print('Delete designation at index: $index');
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
                            DataCell(Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () => _editDesignation(designations.indexOf(designation)),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteDesignation(designations.indexOf(designation)),
                                ),
                              ],
                            )),
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
      Uri.parse('http://192.168.1.6:3000/api/manageemp'),
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
      Uri.parse('http://192.168.1.6:3000/api/department/$departmentId'),
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
      Uri.parse('http://192.168.1.6:3000/api/designation/$designationId'),
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


  void _editEmployee(int index) {
    // Implement edit department functionality
    print('Edit department at index: $index');
  }

  void _deleteEmployee(int index) {
    // Implement delete department functionality
    print('Delete department at index: $index');
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
                              DataCell(Text(employee['MIDDLE_NAME'].toString(), style: TextStyle(fontWeight: FontWeight.bold))),
                              DataCell(Text(employee['LAST_NAME'].toString(), style: TextStyle(fontWeight: FontWeight.bold))),
                              DataCell(Text(employee['AGE'].toString())),
                              DataCell(Text(employee['GENDER'].toString())),
                              DataCell(Text(employee['EMAIL'].toString())),
                              DataCell(Text(employee['PHNO'].toString())),
                              DataCell(Text(employee['USERNAME'].toString())),
                              DataCell(Text(employee['PASSWORD'].toString())),
                              DataCell(Text(employee['DEPT_SHORT_NAME'].toString())),
                              DataCell(Text(employee['DESIGNATION_NAME'].toString())),
                              DataCell(Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () => _editEmployee(employees.indexOf(employee)),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => _deleteEmployee(employees.indexOf(employee)),
                                  ),
                                ],
                              )),
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
   Map<int, bool?> _approvalStatusMap1 = {};
  Set<int> _disabledButtons1 = {};

  @override
  void initState() {
    super.initState();
    _loadDisabledButtons1();
  }

  void _loadDisabledButtons1() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _disabledButtons1 = prefs.getStringList('disabledButtons')?.map(int.parse).toSet() ?? {};
    });
  }

  void _saveDisabledButtons1() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('disabledButtons', _disabledButtons1.map((id) => id.toString()).toList());
  }

  Future<List<Map<String, dynamic>>> _fetchLeaveRequest2() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.7:3000/api/managereq'),
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
                Uri.parse('http://192.168.1.7:3000/api/emp/$employeeId'),
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
                Uri.parse('http://192.168.1.7:3000/api/users/$userId'),
              );

              if (userDetailsResponse.statusCode == 200) {
                final userDetails = json.decode(userDetailsResponse.body);
                if (userDetails is Map<String, dynamic>) {
                  request['USER_NAME'] = userDetails['NAME'] ?? '-';
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

            // Fetch leave type details based on leave_type_id
            final leaveTypeId = request['LEAVE_TYPE_ID'];
            final leaveTypeResponse = await http.get(
              Uri.parse('http://192.168.1.7:3000/api/leave-type/$leaveTypeId'),
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
      Uri.parse('http://192.168.1.7:3000/api/department/$id'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> departmentDetails = json.decode(response.body);
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
      Uri.parse('http://192.168.1.7:3000/api/designation/$id'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> designationDetails = json.decode(response.body);
      return designationDetails['DESIGNATION_NAME'] ?? '-';
    }
    print('Failed to fetch designation details for designation ID: $id');
    return '-';
  } catch (e) {
    print('Error fetching designation name: $e');
    return '-';
  }
}




  Future<String> _fetchEmployeeName(int employeeId) async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.7:3000/api/employee/$employeeId'),
      );

      if (response.statusCode == 200) {
        final parsedResponse = json.decode(response.body);
        if (parsedResponse is Map<String, dynamic>) {
          final firstName = parsedResponse['FIRST_NAME'] ?? '';
          final middleName = parsedResponse['MIDDLE_NAME'] ?? '';
          final lastName = parsedResponse['LAST_NAME'] ?? '';
          return '$firstName ${middleName.isNotEmpty ? '$middleName ' : ''}$lastName'.trim();
        }
      }
      print('Failed to fetch employee details for employee ID: $employeeId');
      return 'Unknown';
    } catch (e) {
      print('Error fetching employee name: $e');
      return 'Unknown';
    }
  }

Future<bool?> _fetchApprovalStatus2(int applicationId) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('approvalStatus_$applicationId');
  } catch (e) {
    print('Error fetching approval status: $e');
    return null;
  }
}

 Future<void> _updateApprovalStatus3(int applicationId, bool approved, {String? reason}) async {
    try {
      final Map<String, dynamic> requestBody = {
        'approved': approved,
      };
      if (!approved && reason != null) {
        requestBody['reason'] = reason; // Include the reason in the request body if rejecting and reason is provided
      }

      final response = await http.put(
        Uri.parse('http://192.168.1.7:3000/api/${approved ? 'approve-leave3' : 'reject-leave3'}/$applicationId'),
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
        setState(() {
          // Update the approval status map
          _approvalStatusMap1[applicationId] = approved;
          // Add ID to disabled set if approved or rejected
          _disabledButtons1.add(applicationId);
          // Save disabled buttons IDs
          _saveDisabledButtons1();
        });
      } else {
        print('Failed to update approval status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating approval status: $e');
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
              future: _fetchLeaveRequest2(),
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
    DataColumn(label: _buildDataColumnText('User ID')),
    DataColumn(label: _buildDataColumnText('User Name')),
    DataColumn(label: _buildDataColumnText('Department')),
    DataColumn(label: _buildDataColumnText('Designation')),
    DataColumn(label: _buildDataColumnText('Leave Type')),
    DataColumn(label: _buildDataColumnText('From Date')),
    DataColumn(label: _buildDataColumnText('To Date')),
    DataColumn(label: _buildDataColumnText('Action')),
    DataColumn(label: _buildDataColumnText('Status')),
  ],
                          rows: requests.where((leave_application) => leave_application['DEPARTMENT'] != '' && leave_application['DESIGNATION'] != '')
                            .map((leave_application) {
                             final applicationId = leave_application['APPLICATION_ID'];
    final bool isDisabled = _disabledButtons1.contains(applicationId);

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
          DataCell(Text(leave_application['USER_ID'] != null ? leave_application['USER_ID'].toString() : ' ')),
                                DataCell(Text(leave_application['USER_NAME'] ?? ' ')),
      DataCell(Text(leave_application['DEPARTMENT'] ?? ' ')),
      DataCell(Text(leave_application['DESIGNATION'] ?? ' ')),
      DataCell(Text(leave_application['LEAVE_TYPE_NAME'] ?? ' ')),
      DataCell(Text(leave_application['START_DATE'])),
      DataCell(Text(leave_application['END_DATE'])),
      DataCell(Row(
        children: [
          ElevatedButton(
            onPressed: isDisabled ? null : () async {
              await _updateApprovalStatus3(applicationId, true);
              setState(() {
                _approvalStatusMap1[applicationId] = true;
                _disabledButtons1.add(applicationId); // Add ID to disabled set
                _saveDisabledButtons1(); // Save disabled buttons IDs
              });
            },
            child: Text('Approve'),
          ),
          SizedBox(width: 10),
          ElevatedButton(
  onPressed: isDisabled ? null : () {
    _showRejectDialog(applicationId);
  },
  child: Text('Reject'),
),

        ],
      )),
      DataCell(FutureBuilder<bool?>(
        future: _fetchApprovalStatus2(applicationId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final bool? approvalStatus = snapshot.data;
            if (approvalStatus == null) {
              return SizedBox(); // If status is not set, display nothing initially
            } else {
              return Text(approvalStatus ? 'Approved' : 'Rejected');
            }
          }
        },
      )),
    ]);
  }).toList(),
)
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
  void _showRejectDialog(int applicationId) {
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
              await _updateApprovalStatus3(applicationId, false, reason: rejectReason);
              Navigator.of(context).pop(); // Close the dialog
              setState(() {
                _disabledButtons1.add(applicationId); // Add ID to disabled set
                _saveDisabledButtons1(); // Save disabled buttons IDs
              });
            },
            child: Text('Reject'),
          ),
        ],
      );
    },
  );
}}