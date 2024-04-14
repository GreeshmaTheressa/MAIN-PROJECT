import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

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
      home: financescreen(),
    );
  }
}

class financescreen extends StatefulWidget {
   final String? employeeId; // Define employeeId as a parameter

  financescreen({this.employeeId}); 
  @override
  _financescreenState createState() => _financescreenState();
}

class _financescreenState extends State<financescreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isDrawerOpen = true;
  bool _showManageDepartment = false;
  bool _showRequestForm = false;
  bool _showManageEmployee = false;
  bool _showManageDesignation = false;
  bool _showLeaveStatus = false;

  List<String> _leaveNames = [];

  @override
  void initState() {
    super.initState();
    _fetchLeaveTypes();
  }

  @override
  Widget build(BuildContext context) {
    print('itscreen - Employee ID: ${widget.employeeId}');
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
                color: Colors.blueGrey,
                padding: EdgeInsets.zero,
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    Container(
                      height: 120,
                      child: DrawerHeader(
                        decoration: BoxDecoration(
                          color: Colors.blueGrey,
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
                      tileColor: Colors.blueGrey,
                      title: Text(
                        'Dashboard',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => financescreen()));
                      },
                    ),
                    ListTile(
                      tileColor: Colors.blueGrey,
                      title: Text(
                        'Employees',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        setState(() {
                          _showRequestForm = false;
                          _showManageDepartment = false;
                          _showManageDesignation = false;
                          _showManageEmployee = true;
                          _showLeaveStatus=false;
                        });
                      },
                    ),
                    ListTile(
                      tileColor: Colors.blueGrey,
                      title: Text(
                        'Departments',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        setState(() {
                          _showRequestForm = false;
                          _showManageDepartment = true;
                          _showManageDesignation = false;
                          _showManageEmployee = false;
                          _showLeaveStatus=false;
                        });
                      },
                    ),
                    ListTile(
                      tileColor: Colors.blueGrey,
                      title: Text(
                        'Designations',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        setState(() {
                          _showRequestForm = false;
                          _showManageDepartment = false;
                          _showManageDesignation = true;
                          _showManageEmployee = false;
                          _showLeaveStatus=false;
                        });
                      },
                    ),
                    ListTile(
                      tileColor: Colors.blueGrey,
                      title: Text(
                        'Leave Requests',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        setState(() {
                          _showRequestForm = true;
                          _showManageDepartment = false;
                          _showManageDesignation = false;
                          _showManageEmployee = false;
                          _showLeaveStatus=false;
                        });
                      },
                    ),
                    ListTile(
                      tileColor: Colors.blueGrey,
                      title: Text(
                        'Apply Leave',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        
                        _showApplyLeaveForm(context);
                      },
                    ),
                    ListTile(
                      tileColor: Colors.blueGrey,
                      title: Text(
                        'Leave Status',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        setState(() {
                          _showLeaveStatus=true;
                          _showRequestForm = false;
                          _showManageDepartment = false;
                          _showManageDesignation = false;
                          _showManageEmployee = false;
                          
                         
                        });
  
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
              child: _showManageDepartment
                  ? ManageDepartmentPage()
                  : (_showManageDesignation
                      ? ManageDesignationPage()
                      : (_showManageEmployee
                          ? ManageEmployeePage()
                          : (_showRequestForm
                              ? LeaveRequestPage()
                              : (_showLeaveStatus
                              ? ManageLeaveStatus(employeeId: widget.employeeId)
                              : MainContent())))),
            ),
          ),
        ],
      ),
    );
  }

  void _showApplyLeaveForm(BuildContext context) async {
    DateTime? startDate;
    DateTime? endDate;
    DateTime applicationDate = DateTime.now();
    String _selectedLeaveType = 'Select Leave Type';

    TextEditingController startDateController = TextEditingController();
    TextEditingController endDateController = TextEditingController();
    TextEditingController applicationDateController =
        TextEditingController(text: "${applicationDate.day.toString().padLeft(2, '0')}-${applicationDate.month.toString().padLeft(2, '0')}-${applicationDate.year}");

     String? employeeId = widget.employeeId; // Initialize employeeId

    showDialog(
  context: context,
  builder: (BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 10,
          backgroundColor: Colors.white,
          child: Container(
            width: 300,
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  "Apply for Leave",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                DropdownButtonFormField(
                  value: _selectedLeaveType,
                  onChanged: (newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedLeaveType = newValue;
                      });
                    }
                  },
                  items: _leaveNames.map((leave_type) {
                    return DropdownMenuItem(
                      value: leave_type,
                      child: Text(leave_type),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Leave Type',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: startDateController,
                  readOnly: true,
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101),
                    );
                    if (picked != null && picked != startDate) {
                      setState(() {
                        startDate = picked;
                        startDateController.text = "${startDate!.day.toString().padLeft(2, '0')}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.year}";  // Corrected line
                      });
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Start Date',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: endDateController,
                  readOnly: true,
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101),
                    );
                    if (picked != null && picked != endDate) {
                      setState(() {
                        endDate = picked;
                        endDateController.text ="${endDate!.day.toString().padLeft(2, '0')}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.year}"; // Corrected line
                      });
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'End Date',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: applicationDateController,
                  readOnly: true,
                  onTap: () async {
                    // Do nothing on tap, as application date should be read-only
                  },
                  decoration: InputDecoration(
                    labelText: 'Application Date',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    ElevatedButton(
  onPressed: () async {
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd'); // Define the date format expected by Oracle
    final String formattedStartDate = startDate != null ? dateFormat.format(startDate!) : ''; // Format the start date
    final String formattedEndDate = endDate != null ? dateFormat.format(endDate!) : ''; // Format the end date
    final String formattedApplicationDate = dateFormat.format(applicationDate);

    final String serverUrl = 'http://192.168.1.7:3000/api/leaveapp';
    try {
      final leaveTypeId = await _fetchLeaveTypeId(_selectedLeaveType);
      if (leaveTypeId == null) {
        print('Leave type ID is null. Cannot proceed with leave application.');
        return; // Exit the function if leaveTypeId is null
      }

      // Include employee ID along with other details in the request body
      final response = await http.post(
        Uri.parse(serverUrl),
        body: {
          'user_id': employeeId,
          'start_date': formattedStartDate,
          'end_date': formattedEndDate,
          'date_of_application': formattedApplicationDate,
          'leave_type_id': leaveTypeId,
        },
      );

      if (response.statusCode == 200) {
        print('Leave applied successfully!');
      } else {
        print('Leave application failed. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }

    Navigator.of(context).pop();
  },
  child: Text('Apply'),
),

                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Cancel'),
                    ),
                  ],
                ),
              ], // Closing the children list of the Column widget here
            ),
          ),
        );
      },
    );
  },
);
  }

  Future<void> _fetchLeaveTypes() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.7:3000/api/manageleave'),
      );

      if (response.statusCode == 200) {
        final parsedResponse = json.decode(response.body);
        if (parsedResponse is List<dynamic>) {
          setState(() {
            _leaveNames = ['Select Leave Type'] +
                parsedResponse
                    .map<String>((leaveType) => leaveType['LEAVE_NAME'] as String)
                    .toList();
          });
          print('Leave names fetched successfully: $_leaveNames');
        } else {
          print('Failed to retrieve leave types: Invalid response format');
        }
      } else {
        print('Failed to retrieve leave types: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching leave types: $e');
    }
  }

Future<String?> _fetchLeaveTypeId(String leaveName) async {
  try {
    final response = await http.get(
      Uri.parse('http://192.168.1.7:3000/api/manageleave?name=$leaveName'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> parsedResponse = json.decode(response.body);
      final leaveType = parsedResponse.firstWhere(
        (leaveType) => leaveType['LEAVE_NAME'] == leaveName,
        orElse: () => null,
      );

      if (leaveType != null) {
        final leaveTypeId = leaveType['LEAVE_TYPE_ID'].toString();
        return leaveTypeId;
      } else {
        print('Failed to retrieve leave type ID for $leaveName');
        return null;
      }
    } else {
      print('Failed to retrieve leave type ID: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Error: $e');
    return null;
  }
}
}

class MainContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              'Dashboard',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                DashboardCard(icon: Icons.person, title: 'Employees', value: '55', iconColor: Colors.orange),
                DashboardCard(icon: Icons.airplane_ticket, title: 'Leave', value: '25', iconColor: Colors.green),
                DashboardCard(icon: Icons.check, title: 'Approved', value: '34', iconColor: Colors.blue),
                DashboardCard(icon: Icons.info, title: 'Pending', value: '12', iconColor: Colors.orange),
                DashboardCard(icon: Icons.delete, title: 'Canceled', value: '15', iconColor: Colors.red),
              ],
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
  final String value;
  final Color iconColor;

  DashboardCard({required this.icon, required this.title, required this.value, required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      height: 10,
      padding: EdgeInsets.all(16),
      child: Card(
        elevation: 3,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 70, color: iconColor),
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                value,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
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
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Manage Department',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _fetchDepartments(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final departments = snapshot.data!;
                  return DataTable(
                    columns: [
                      DataColumn(label: Text('Department Name')),
                      DataColumn(label: Text('Department Short Name')),
                      DataColumn(label: Text('Creation Date')),
                      DataColumn(label: Text('Action')), // Added action column
                    ],
                    rows: departments.map((department) {
                      // Format the date to display only the date part
                      DateTime creationDate = DateTime.parse(department['CREATION_DATE']);
                      String formattedDate = DateFormat('yyyy-MM-dd').format(creationDate);

                      return DataRow(cells: [
                        DataCell(Text(department['DEPT_NAME'])),
                        DataCell(Text(department['DEPT_SHORT_NAME'])),
                        DataCell(Text(formattedDate)), // Display the formatted date
                        DataCell(Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () => _editDepartment(departments.indexOf(department)),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
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
          ],
        ),
      ),
    );
  }
}

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
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Manage Designation',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _fetchDesignations(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final designations = snapshot.data!;
                  return DataTable(
                    columns: [
                      DataColumn(label: Text('Designation Name')),
                      DataColumn(label: Text('Designation Description')),
                      DataColumn(label: Text('Creation Date')),
                      DataColumn(label: Text('Action')), // Added action column
                    ],
                    rows: designations.map((designation) {
                      // Format the date to display only the date part
                      DateTime creationDate = DateTime.parse(designation['CREATION_DATE']);
                      String formattedDate = DateFormat('yyyy-MM-dd').format(creationDate);

                      return DataRow(cells: [
                        DataCell(Text(designation['DESIGNATION_NAME'])),
                        DataCell(Text(designation['DESIGNATION_DESC'])),
                        DataCell(Text(formattedDate)), // Display the formatted date
                        DataCell(Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () => _editDesignation(designations.indexOf(designation)),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
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
          ],
        ),
      ),
    );
  }
}



class ManageEmployeePage extends StatefulWidget {
  @override
  _ManageEmployeePageState createState() => _ManageEmployeePageState();
}

class _ManageEmployeePageState extends State<ManageEmployeePage> {
 Future<List<Map<String, dynamic>>> _fetchEmployees() async {
  try {
    final response = await http.get(
      Uri.parse('http://192.168.1.7:3000/api/manageemp'),
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
      Uri.parse('http://192.168.1.7:3000/api/department/$departmentId'),
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
      Uri.parse('http://192.168.1.7:3000/api/designation/$designationId'),
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
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Manage Employee',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            FutureBuilder<List<Map<String, dynamic>>>(
  future: _fetchEmployees(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
      return Center(child: Text('Error: ${snapshot.error}'));
    } else {
      final employees = snapshot.data!;
      print('Data types of employee values:');
      print(employees.map((e) => e.map((k, v) => MapEntry(k, v.runtimeType))));
      return DataTable(
        columns: [
          DataColumn(label: Text('Employee ID')),
          DataColumn(label: Text('First Name')),
          DataColumn(label: Text('Middle Name')),
          DataColumn(label: Text('Last Name')),
          DataColumn(label: Text('Age')),
          DataColumn(label: Text('Gender')),
          DataColumn(label: Text('Email')),
          DataColumn(label: Text('Phone Number')),
          DataColumn(label: Text('Username')),
          DataColumn(label: Text('Password')),
          DataColumn(label: Text('Department')),
          DataColumn(label: Text('Designation')),
          DataColumn(label: Text('Action')), // Added action column
        ],
       // Rows inside DataTable widget
rows: employees.map((employee) {
  return DataRow(cells: [
    DataCell(Text(employee['EMPLOYEE_ID'].toString())),
    DataCell(Text(employee['FIRST_NAME'].toString())),
    DataCell(Text(employee['MIDDLE_NAME'].toString())),
    DataCell(Text(employee['LAST_NAME'].toString())),
    DataCell(Text(employee['AGE'].toString())),
    DataCell(Text(employee['GENDER'].toString())),
    DataCell(Text(employee['EMAIL'].toString())),
    DataCell(Text(employee['PHNO'].toString())),
    DataCell(Text(employee['USERNAME'].toString())),
    DataCell(Text(employee['PASSWORD'].toString())),
    DataCell(Text(employee['DEPT_SHORT_NAME'].toString())), // Display department name
    DataCell(Text(employee['DESIGNATION_NAME'].toString())), // Display designation name
    DataCell(Row(
      children: [
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: () => _editEmployee(employees.indexOf(employee)),
        ),
        IconButton(
          icon: Icon(Icons.delete),
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

          ],
        ),
      ),
    ),
  );
}}



class LeaveRequestPage extends StatefulWidget {
  @override
  _LeaveRequestPageState createState() => _LeaveRequestPageState();
}

class _LeaveRequestPageState extends State<LeaveRequestPage> {
  Future<List<Map<String, dynamic>>> _fetchLeaveRequest() async {
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
      // Check if the department is HR, and return null to filter out the request
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
      Uri.parse('http://192.168.1.7:3000/api/designation/$id'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> designationDetails = json.decode(response.body);
      // Check if the designation is HR or Department Head, and return null to filter out the request
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

  Future<void> _updateApprovalStatus2(int applicationId, bool approved) async {
    try {
      final response = await http.put(
        Uri.parse('http://192.168.1.7:3000/api/${approved ? 'approve-leave2' : 'reject-leave2'}/$applicationId'),
        // No need to send body as the applicationId is sent as part of the URL
      );

      if (response.statusCode == 200) {
        print('Leave request with ID $applicationId ${approved ? 'approved' : 'rejected'} successfully');
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
        padding: EdgeInsets.all(20.0),
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
                  final requests = snapshot.data!.where((request) => request['DEPARTMENT'] == 'IT').toList();
                  return SizedBox(
                    width: double.infinity,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: [
                          DataColumn(label: Text('Application Id')),
                          DataColumn(label: Text('Application Date')),
                          DataColumn(label: Text('Employee ID')),
                          DataColumn(label: Text('Employee Name')),
                          DataColumn(label: Text('User ID')),
                          DataColumn(label: Text('User Name')),
                          DataColumn(label: Text('Department')),
                          DataColumn(label: Text('Designation')),
                          DataColumn(label: Text('Leave Type')),
                          DataColumn(label: Text('From Date')),
                          DataColumn(label: Text('To Date')),
                          DataColumn(label: Text('Action')),
                        ],
                        rows: requests
        .where((leave_application) =>
            leave_application['DEPARTMENT'] != '' &&
            leave_application['DESIGNATION'] != '')
        .map((leave_application) {
                          return DataRow(cells: [
                            DataCell(Text(leave_application['APPLICATION_ID'].toString())),
                            DataCell(Text(leave_application['DATE_OF_APPLICATION'])),
                            DataCell(Text(leave_application['EMPLOYEE_ID'] != null ? leave_application['EMPLOYEE_ID'].toString() : ' ')),
                            DataCell(Text(leave_application['EMPLOYEE_NAME'] != null && leave_application['EMPLOYEE_NAME'] != '' ? leave_application['EMPLOYEE_NAME'] : ' ')), 
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
                                  onPressed: () async {
                                    await _updateApprovalStatus2(
                                        leave_application['APPLICATION_ID'], true);
                                  },
                                  child: Text('Approve'),
                                ),
                                SizedBox(width: 10),
                                ElevatedButton(
                                  onPressed: () async {
                                    await _updateApprovalStatus2(
                                        leave_application['APPLICATION_ID'], false);
                                  },
                                  child: Text('Reject'),
                                ),
                              ],
                            )),
                          ]);
                        }).toList(),
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
}

class ManageLeaveStatus extends StatefulWidget {
  final String? employeeId; // Add employeeId parameter here

  ManageLeaveStatus({this.employeeId}); // Constructor

  @override
  _ManageLeaveStatusState createState() => _ManageLeaveStatusState();
}

class _ManageLeaveStatusState extends State<ManageLeaveStatus> {
  Map<String, String> _leaveTypeMap = {};

   @override
  void initState() {
    super.initState();
    _fetchLeaveTypes(); // Fetch leave types and populate the map
  }

   Future<void> _fetchLeaveTypes() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.7:3000/api/manageleave'),
      );

      if (response.statusCode == 200) {
        final parsedResponse = json.decode(response.body);
        if (parsedResponse is List<dynamic>) {
          setState(() {
            _leaveTypeMap = Map.fromIterable(
              parsedResponse,
              key: (leaveType) => leaveType['LEAVE_TYPE_ID'].toString(),
              value: (leaveType) => leaveType['LEAVE_NAME'].toString(),
            );
          });
          print('Leave types fetched successfully: $_leaveTypeMap');
        } else {
          print('Failed to retrieve leave types: Invalid response format');
        }
      } else {
        print('Failed to retrieve leave types: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching leave types: $e');
    }
  }
  Future<List<Map<String, dynamic>>> _fetchStatus(String? employeeId) async {
    try {
      print('ManageLeaveStatus - Employee ID: $employeeId');
      final response = await http.get(
        Uri.parse('http://192.168.1.7:3000/api/leavestatususer/$employeeId'),
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



  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'View Leave Status',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _fetchStatus(widget.employeeId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final leaves = snapshot.data!;
                  return DataTable(
                    columns: [
                       DataColumn(label: Text('Application Date')),
        DataColumn(label: Text('Start Date')),
        DataColumn(label: Text('End Date')),
        DataColumn(label: Text('Leave Type')),
        DataColumn(label: Text('Status')),
                    ],
                    rows: leaves.map((status) {
                      // Format the date to display only the date part
                      //DateTime creationDate = DateTime.parse(status['CREATION_DATE']);
                     // String formattedDate = DateFormat('yyyy-MM-dd').format(creationDate);
 final leaveTypeId = status['LEAVE_TYPE_ID'].toString();
                      final leaveName = _leaveTypeMap[leaveTypeId] ?? 'Unknown';
                      return DataRow(cells: [
                       DataCell(Text(status['DATE_OF_APPLICATION'])),
          DataCell(Text(status['START_DATE'])),
          DataCell(Text(status['END_DATE'])),
          DataCell(Text(leaveName)),
          DataCell(Text(status['APPROVED_BYHR'] ?? '')),
                        //DataCell(Text(formattedDate)), // Display the formatted date
                   
                      ]);
                    }).toList(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}