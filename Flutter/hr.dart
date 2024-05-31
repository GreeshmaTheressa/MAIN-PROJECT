import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart'; // Import the intl package
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lmpp/pages/login.dart';
import 'dart:html' as html;
import 'dart:io';
import 'package:universal_html/html.dart' as html;



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
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
 final String? employeeId;

 MainScreen({this.employeeId}); 

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isDrawerOpen = true;
  bool _showAddDepartmentForm = false;
  bool _showAddDesignationForm = false;
  bool _showManageDepartment = false;
  bool _showAddEmployeeForm = false;
  bool _showRequestForm = false;
  bool _showManageEmployee = false;
  bool _showLeaveForm=false;
  bool _showleave=false;
  bool _showLeaveStatus = false;
  bool _showManageDesignation=false;
  bool _showPayComp = false;
  bool _showsal = false;
  bool _showrep=false;
  bool _emprep=false;

  List<String> _leaveNames = [];

  @override
  void initState() {
    super.initState();
    _fetchLeaveTypes();
  }


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
                      tileColor: Colors.blueGrey,
                      leading: Icon(Icons.dashboard, color: Colors.white),
                      title: Text(
                        'Dashboard',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => MainScreen()));
                      },
                    ),
                    /* ListTile(
                      tileColor: Colors.blueGrey,
                      leading: Icon(Icons.event_note, color: Colors.white),
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
                      leading: Icon(Icons.history, color: Colors.white),
                      title: Text(
                        'Leave Status',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        setState(() {
                          _showLeaveStatus=true;
                          
                          _showManageDesignation = false;
                          
                           _showAddDepartmentForm = false;
                                _showAddDesignationForm = false;
                                _showManageDepartment = false;
                                _showAddEmployeeForm = false;
                                 _showRequestForm = false;
                                 _showManageEmployee = false;
                                 _showLeaveForm=false;
                                 _showPayComp = false;
                          _showsal = false;
                          _showrep=false;
                         
                        });
  
                      },
                    ),*/
                    ExpansionTile(
                      leading: Icon(Icons.work, color: Colors.white),
                      title: Text(
                        'Department',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 30),
                          child: ListTile(
                            tileColor: Colors.blueGrey,
                            title: Text(
                              'Add Department',
                              style: TextStyle(color: Colors.white),
                            ),
                            onTap: () {
                              setState(() {
                                _showAddDepartmentForm = true;
                                _showAddDesignationForm = false;
                                _showManageDepartment = false;
                                _showAddEmployeeForm = false;
                                 _showRequestForm = false;
                                 _showManageEmployee = false;
                                 _showLeaveForm=false;
                                 _showLeaveStatus=false;
                                 _showManageDesignation = false;
                                 _showPayComp = false;
                                 _showsal = false;
                                 _showrep=false;
                                 _showleave=false;
                                 _emprep=false;
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 30),
                          child: ListTile(
                            tileColor: Colors.blueGrey,
                            title: Text(
                              'Manage Department',
                              style: TextStyle(color: Colors.white),
                            ),
                            onTap: () {
                              setState(() {
                                _showManageDepartment = true;
                                _showAddDepartmentForm = false;
                                _showAddDesignationForm = false;
                                _showAddEmployeeForm = false;
                                 _showRequestForm = false;
                                 _showManageEmployee = false;
                                 _showLeaveForm=false;
                                 _showManageDesignation = false;
                                 _showLeaveStatus = false;
                                 _showPayComp = false;
                                 _showsal = false;
                                 _showrep=false;
                                 _showleave=false;
                                 _emprep=false;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    ExpansionTile(
                      leading: Icon(Icons.business, color: Colors.white),
                      title: Text(
                        'Designation',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 30),
                          child: ListTile(
                            tileColor: Colors.blueGrey,
                            title: Text(
                              'Add Designation',
                              style: TextStyle(color: Colors.white),
                            ),
                            onTap: () {
                              setState(() {
                                _showAddDepartmentForm = false;
                                _showAddDesignationForm = true;
                                _showManageDepartment = false;
                                _showAddEmployeeForm = false;
                                 _showRequestForm = false;
                                 _showManageEmployee = false;
                                 _showLeaveForm=false;
                                 _showManageDesignation = false;
                                 _showLeaveStatus = false;
                                 _showPayComp = false;
                                 _showsal = false;
                                 _showrep=false;
                                 _showleave=false;
                                 _emprep=false;
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 30),
                          child: ListTile(
                            tileColor: Colors.blueGrey,
                            title: Text(
                              'Manage Designation',
                              style: TextStyle(color: Colors.white),
                            ),
                            onTap: () {
                              setState(() {
                                _showManageDepartment = false;
                                _showAddDepartmentForm = false;
                                _showAddDesignationForm = false;
                                _showAddEmployeeForm = false;
                                 _showRequestForm = false;
                                 _showManageEmployee = false;
                                 _showLeaveForm=false;
                                 _showManageDesignation = true;
                                 _showLeaveStatus = false;
                                 _showPayComp = false;
                                 _showsal = false;
                                 _showrep=false;
                                 _showleave=false;
                                 _emprep=false;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    ExpansionTile(
                      leading: Icon(Icons.person, color: Colors.white),
                      title: Text(
                        'Employees',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 30),
                          child: ListTile(
                            tileColor: Colors.blueGrey,
                            title: Text(
                              'Add Employee',
                              style: TextStyle(color: Colors.white),
                            ),
                            onTap: () {
                              setState(() {
                                _showAddEmployeeForm = true;
                                _showAddDepartmentForm = false;
                                _showAddDesignationForm = false;
                                _showManageDepartment = false;
                                 _showRequestForm = false;
                                 _showManageEmployee = false;
                                 _showLeaveForm=false;
                                 _showManageDesignation = false;
                                 _showLeaveStatus = false;
                                 _showPayComp = false;
                                 _showsal = false;
                                 _showrep=false;
                                 _showleave=false;
                                 _emprep=false;
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 30),
                          child: ListTile(
                            tileColor: Colors.blueGrey,
                            title: Text(
                              'Manage Employee',
                              style: TextStyle(color: Colors.white),
                            ),
                            onTap: () {
                              setState(() {
                                _showAddEmployeeForm = false;
                                _showManageDepartment = false;
                                _showAddDepartmentForm = false;
                                _showAddDesignationForm = false;
                                 _showRequestForm = false;
                                 _showManageEmployee = true;
                                 _showLeaveForm=false;
                                 _showManageDesignation = false;
                                 _showLeaveStatus = false;
                                 _showPayComp = false;
                                 _showsal = false;
                                 _showrep=false;
                                 _showleave=false;
                                 _emprep=false;
                              });
                            },
                          ),
                        ),
                      ],
                    ),

 ExpansionTile(
                      leading: Icon(Icons.person, color: Colors.white),
                      title: Text(
                        'Leave Type',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 30),
                          child: ListTile(
                            tileColor: Colors.blueGrey,
                            title: Text(
                              'Add Leave Type',
                              style: TextStyle(color: Colors.white),
                            ),
                            onTap: () {
                              setState(() {
                                _showAddEmployeeForm = false;
                                _showAddDepartmentForm = false;
                                _showAddDesignationForm = false;
                                _showManageDepartment = false;
                                 _showRequestForm = false;
                                 _showManageEmployee = false;
                                 _showLeaveForm=false;
                                 _showLeaveForm=true;
                                 _showManageDesignation = false;
                                 _showLeaveStatus = false;
                                 _showPayComp = false;
                                 _showsal = false;
                                 _showrep=false;
                                 _showleave=false;
                                 _emprep=false;
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 30),
                          child: ListTile(
                            tileColor: Colors.blueGrey,
                            title: Text(
                              'Manage Leave Type',
                              style: TextStyle(color: Colors.white),
                            ),
                            onTap: () {
                              setState(() {
                                _showleave=true;
                                _showAddEmployeeForm = false;
                                _showManageDepartment = false;
                                _showAddDepartmentForm = false;
                                _showAddDesignationForm = false;
                                 _showRequestForm = false;
                                 _showLeaveForm=false;
                                 _showManageEmployee = false;
                                 _showLeaveForm=false;
                                 _showManageDesignation = false;
                                 _showLeaveStatus = false;
                                 _showPayComp = false;
                                 _showsal = false;
                                 _showrep=false;
                                 _emprep=false;
                              });
                            },
                          ),
                        ),
                      ],
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
                        _showAddEmployeeForm = false;
                                _showManageDepartment = false;
                                _showAddDepartmentForm = false;
                                _showAddDesignationForm = false;
                                _showManageEmployee = false;
                                _showLeaveForm=false;
                                _showManageDesignation = false;
                                _showLeaveStatus = false;
                                _showPayComp = false;
                                _showsal = false;
                                _showrep=false;
                                _showleave=false;
                                _emprep=false;
                              });},
                    ),
                     ListTile(
                      leading: Icon(Icons.payment, color: Colors.white),
                      tileColor: Colors.blueGrey,
                      title: Text(
                        'Pay Components',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {setState(() {
                        _showPayComp = true;
                        _showRequestForm = false;
                        _showAddEmployeeForm = false;
                                _showManageDepartment = false;
                                _showAddDepartmentForm = false;
                                _showAddDesignationForm = false;
                                _showManageEmployee = false;
                                _showLeaveForm=false;
                                _showManageDesignation = false;
                                _showLeaveStatus = false;
                                _showsal = false;
                                _showrep=false;
                                _showleave=false;
                                _emprep=false;
                              });},
                    ),
                    ListTile(
                      leading: Icon(Icons.report, color: Colors.white),
                      tileColor: Colors.blueGrey,
                      title: Text(
                        'Salary Details',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {setState(() {
                        _showPayComp = false;
                        _showRequestForm = false;
                        _showAddEmployeeForm = false;
                                _showManageDepartment = false;
                                _showAddDepartmentForm = false;
                                _showAddDesignationForm = false;
                                _showManageEmployee = false;
                                _showLeaveForm=false;
                                _showManageDesignation = false;
                                _showLeaveStatus = false;
                                _showsal = true;
                                _showrep=false;
                                _showleave=false;
                                _emprep=false;
                              });},
                    ),
                   ExpansionTile(
                      leading: Icon(Icons.person, color: Colors.white),
                      title: Text(
                        'Reports',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 30),
                          child: ListTile(
                            tileColor: Colors.blueGrey,
                            title: Text(
                              'Employees Report',
                              style: TextStyle(color: Colors.white),
                            ),
                            onTap: () {
                              setState(() {
                                _showAddEmployeeForm = false;
                                _showAddDepartmentForm = false;
                                _showAddDesignationForm = false;
                                _showManageDepartment = false;
                                 _showRequestForm = false;
                                 _showManageEmployee = false;
                                 _showLeaveForm=false;
                                 _showLeaveForm=false;
                                 _showManageDesignation = false;
                                 _showLeaveStatus = false;
                                 _showPayComp = false;
                                 _showsal = false;
                                 _showrep=false;
                                 _showleave=false;
                                 _emprep=true;
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 30),
                          child: ListTile(
                            tileColor: Colors.blueGrey,
                            title: Text(
                              'Leave Report',
                              style: TextStyle(color: Colors.white),
                            ),
                            onTap: () {
                              setState(() {
                                _showleave=false;
                                _showAddEmployeeForm = false;
                                _showManageDepartment = false;
                                _showAddDepartmentForm = false;
                                _showAddDesignationForm = false;
                                 _showRequestForm = false;
                                 _showLeaveForm=false;
                                 _showManageEmployee = false;
                                 _showLeaveForm=false;
                                 _showManageDesignation = false;
                                 _showLeaveStatus = false;
                                 _showPayComp = false;
                                 _showsal = false;
                                 _showrep=true;
                                 _emprep=false;
                              });
                            },
                          ),
                        ),
                      ],
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
              child: _showAddDepartmentForm
                  ? AddDepartmentPage()
                  : (_showAddDesignationForm
                      ? AddDesignationPage()
                      : (_showManageDepartment
                          ? ManageDepartmentPage()
                          : (_showManageDesignation
                          ? ManageDesignationPage()
                          : (_showAddEmployeeForm
                              ? AddEmployeePage()
                                : (_showManageEmployee
                              ? ManageEmployeePage()
                              : (_showleave
                              ? ManageLeaveTypePage()
                               : (_showRequestForm
                              ? LeaveRequestPage()
                               : (_showLeaveForm
                              ? AddLeaveType()
                              : (_showLeaveStatus
                      ? ManageLeaveStatus(employeeId: widget.employeeId)
                      :(_showPayComp
                      ? AddPayComp()
                      :(_showsal
                      ? ViewSalarySlipsPage()
                      :(_showrep
                      ? ReportsPage()
                      :(_emprep
                      ? EmployeeReportPage()
                              // Show the employee form here
                              : MainContent()))))))))))))),
            ),
          ),
        ],
      ),
    );
  }

void _logout(BuildContext context) {
  // Implement your logout logic here
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => RetrieveEmployeeScreen()), // Replace MainScreen with the actual name of your main screen widget
    (route) => false, // This will remove all previous routes
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

    final String serverUrl = 'http://192.168.1.34:3000/api/leaveapp';
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Leave applied successfully.'),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.green, // Adjust the duration as needed
            ),
          );
      } else {
        print('Leave application failed. Status code: ${response.statusCode}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Leave application failed.'),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.red, // Adjust the duration as needed
            ),
          );
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
        Uri.parse('http://192.168.1.34:3000/api/manageleave'),
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
      Uri.parse('http://192.168.1.34:3000/api/manageleave?name=$leaveName'),
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

class MainContent extends StatefulWidget {
  @override
  _MainContentState createState() => _MainContentState();
}

class _MainContentState extends State<MainContent> {
  int employeeCount = 0;
  int leaveCount = 0;
  int approvedCount = 0;
  int pendingCount = 0;
  int rejectedCount = 0;

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.1.34:3000/api/counts'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          employeeCount = data['employee'];
          leaveCount = data['leave'];
          approvedCount = data['approved'];
          pendingCount = data['pending'];
          rejectedCount = data['rejected'];
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

   bool _showEmployeeReport = false;
      bool _showLeaveReport = false;


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
                    _showEmployeeReport ? EmployeeReportPage() : (_showLeaveReport ? ReportsPage() : buildDashboard()),

          ],
        ),
      ),
    );
  }

  Widget buildDashboard() {
    return GridView.builder(
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
        Function()? onTap;

        switch (index) {
          case 0:
            title = 'Employees';
            icon = Icons.person;
            iconColor = Colors.orange;
            value = employeeCount;
            onTap = () {
              setState(() {
                _showEmployeeReport = true;
              });
            };
            break;
          case 1:
            title = 'Leave';
            icon = Icons.event;
            iconColor = Colors.blue;
            value = leaveCount;
            onTap = () {
 setState(() {
                _showLeaveReport = true;
              });            
              };
            break;
          case 2:
            title = 'Approved';
            icon = Icons.check;
            iconColor = Colors.green;
            value = approvedCount;
            onTap = null;
            break;
          case 3:
            title = 'Pending';
            icon = Icons.info;
            iconColor = Colors.yellow;
            value = pendingCount;
            onTap = null;
            break;
          case 4:
            title = 'Rejected';
            icon = Icons.delete;
            iconColor = Colors.red;
            value = rejectedCount;
            onTap = null;
            break;
          default:
            title = '';
            icon = Icons.error;
            iconColor = Colors.grey;
            value = 0; // Assign a default value here
            onTap = null;
        }

        return GestureDetector(
          onTap: onTap,
          child: DashboardCard(
            icon: icon,
            title: title,
            value: value, // You can set the actual value here
            iconColor: iconColor,
          ),
        );
      },
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
      elevation: 10, // Increased elevation for shadow
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
                  value.toString(), // Convert int to String here
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


class AddDepartmentPage extends StatefulWidget {
  @override
  _AddDepartmentPageState createState() => _AddDepartmentPageState();
}

class _AddDepartmentPageState extends State<AddDepartmentPage> {
  final TextEditingController _departmentNameController = TextEditingController();
  final TextEditingController _departmentDescriptionController = TextEditingController();

  Future<void> _submitForm() async {
    final String serverUrl = 'http://192.168.1.34:3000/api/dep';
    try {
      final response = await http.post(
        Uri.parse(serverUrl),
        body: {
          'DEPT_SHORT_NAME': _departmentNameController.text,
          'DEPT_NAME': _departmentDescriptionController.text,
        },
      );

      if (response.statusCode == 200) {
        print('Data inserted successfully!');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Data inserted successfully.'),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.green, // Adjust the duration as needed
            ),
          );
      } else {
        print('Data insertion failed. Status code: ${response.statusCode}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Data insertion failed.'),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.red, // Adjust the duration as needed
            ),
          );
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  void dispose() {
    _departmentNameController.dispose();
    _departmentDescriptionController.dispose();
    super.dispose();
  }

@override
Widget build(BuildContext context) {
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(25.0, 20.0, 5.0, 0.0), // Adjust top padding here
          child: Text(
            'Add Department',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 200.0), // Adjust vertical padding here
          child: Container( // Wrap the Card with Container
            width: MediaQuery.of(context).size.width * 0.5, // Set width to 50% of the screen width
            child: Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _departmentNameController,
                      decoration: InputDecoration(
                        labelText: 'Department Name',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                        prefixIcon: Icon(Icons.work_outline_outlined),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _departmentDescriptionController,
                      decoration: InputDecoration(
                        labelText: 'Department Short Name',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                        prefixIcon: Icon(Icons.work_outline_outlined),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end, // Align the button to the right
                      children: [
                        Container(
                          width: 100, // Set the width of the button
                          height: 40, // Set the height of the button
                          child: Material(
                            color: Colors.blueGrey, // Set the color of the button
                            borderRadius: BorderRadius.circular(5.0), // Set the border radius
                            child: InkWell(
                              onTap: _submitForm,
                              child: Center(
                                child: Text(
                                  'Submit',
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
}

class AddDesignationPage extends StatefulWidget {
  @override
  _AddDesignationPageState createState() => _AddDesignationPageState();
}

class _AddDesignationPageState extends State<AddDesignationPage> {
  final TextEditingController _designationNameController = TextEditingController();
  final TextEditingController _designationDescriptionController = TextEditingController();
  final TextEditingController _probationController = TextEditingController();
    final TextEditingController _noticeController = TextEditingController();


  Future<void> _submitForm() async {
    final String serverUrl = 'http://192.168.1.34:3000/api/des';
    try {
      final response = await http.post(
        Uri.parse(serverUrl),
        body: {
          'DESIGNATION_NAME': _designationNameController.text,
          'DESIGNATION_DESC': _designationDescriptionController.text,
          'PROBATION': _probationController.text,
          'NOTICE_PRD': _noticeController.text,
        },
      );

      if (response.statusCode == 200) {
        print('Data inserted successfully!');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Data inserted successfully.'),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.green, // Adjust the duration as needed
            ),
          );
      } else {
        print('Data insertion failed. Status code: ${response.statusCode}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Data insertion failed.'),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.red, // Adjust the duration as needed
            ),
          );
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  void dispose() {
    _designationNameController.dispose();
    _designationDescriptionController.dispose();
    _probationController.dispose();
    _noticeController.dispose();
    super.dispose();
  }

 
@override
Widget build(BuildContext context) {
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(25.0, 20.0, 5.0, 0.0), // Adjust top padding here
          child: Text(
            'Add Designation',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 200.0), // Adjust vertical padding here
          child: Container( // Wrap the Card with Container
            width: MediaQuery.of(context).size.width * 0.5, // Set width to 50% of the screen width
            child: Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _designationNameController,
                      decoration: InputDecoration(
                        labelText: 'Designation Name',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                        prefixIcon: Icon(Icons.work_outline_outlined),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _designationDescriptionController,
                      decoration: InputDecoration(
                        labelText: 'Designation Description',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                        prefixIcon: Icon(Icons.work_outline_outlined),
                      ),
                    ),
                     SizedBox(height: 20),
                    TextFormField(
                      controller: _probationController,
                      decoration: InputDecoration(
                        labelText: 'Probation Period',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                        prefixIcon: Icon(Icons.calendar_today_outlined),
                      ),
                    ),
                     SizedBox(height: 20),
                    TextFormField(
                      controller: _noticeController,
                      decoration: InputDecoration(
                        labelText: 'Notice Period',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                        prefixIcon: Icon(Icons.calendar_today_outlined),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end, // Align the button to the right
                      children: [
                        Container(
                          width: 100, // Set the width of the button
                          height: 40, // Set the height of the button
                          child: Material(
                            color: Colors.blueGrey, // Set the color of the button
                            borderRadius: BorderRadius.circular(5.0), // Set the border radius
                            child: InkWell(
                              onTap: _submitForm,
                              child: Center(
                                child: Text(
                                  'Submit',
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
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
                            DataCell(Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () => _editDepartment(departments.indexOf(department)),
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
  final TextEditingController probationController = TextEditingController();
  final TextEditingController noticeController = TextEditingController();


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
        probationController.text=designation['PROBATION'];
        noticeController.text=designation['NOTICE_PRD'];

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
                  SizedBox(height: 16.0),
                  Text('Probation Period:'),
                  TextFormField(
                    controller: probationController,
                    decoration: InputDecoration(
                      hintText: 'Enter probation period',
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text('Notice Period:'),
                  TextFormField(
                    controller: noticeController,
                    decoration: InputDecoration(
                      hintText: 'Enter notice period',
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
                      probationController.text,
                      noticeController.text,
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

void _updateDesignation(int desId, String newName, String newShortName, String probation, String notice)async {
  try {
    final response = await http.put(
      Uri.parse('http://192.168.1.34:3000/api/update_des/$desId'), // Correct endpoint URL
      body: {
        'DESIGNATION_NAME': newName,
        'DESIGNATION_DESC': newShortName,
        'PROBATION': probation,
        'NOTICE_PRD': notice,
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
                         DataColumn(label: _buildDataColumnText('Probation Period')),
                          DataColumn(label: _buildDataColumnText('Notice Period')),
                          DataColumn(label: _buildDataColumnText('Action')), // Added action column
                        ],
                        rows: designations.map((designation) {
                          // Format the date to display only the date part
                          //DateTime creationDate = DateTime.parse(designation['CREATION_DATE']);
                        //  String formattedDate = DateFormat('yyyy-MM-dd').format(creationDate);

                          return DataRow(cells: [
                            DataCell(Text(designation['DESIGNATION_NAME'], style: TextStyle(fontWeight: FontWeight.bold))),
                            DataCell(Text(designation['DESIGNATION_DESC'], style: TextStyle(fontWeight: FontWeight.bold))),
                            DataCell(Text(designation['PROBATION'], style: TextStyle(fontWeight: FontWeight.bold))),
                            DataCell(Text(designation['NOTICE_PRD'], style: TextStyle(fontWeight: FontWeight.bold))),
                           // DataCell(Text(formattedDate, style: TextStyle(fontStyle: FontStyle.italic))),
                            DataCell(Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () => _editDesignation(designations.indexOf(designation)),
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

class AddEmployeePage extends StatefulWidget {
  @override
  _AddEmployeePageState createState() => _AddEmployeePageState();
}

class _AddEmployeePageState extends State<AddEmployeePage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _selectedGender = 'Select Gender'; // Initialize with a default value
  String _selectedDepartment = 'Select Department'; // Initialize with a default value
  String _selectedDesignation = 'Select Designation'; // Initialize with a default value
  List<String> _genders = ['Select Gender', 'Male', 'Female', 'Transgender'];
  List<String> _departmentNames = ['Select Department']; // Initialize with the default value
  List<String> _designationNames = ['Select Designation']; // Initialize with the default value
  DateTime? _selectedDOB;
  DateTime? _selectedDOJ;
  final TextEditingController _fatherNameController = TextEditingController();
  final TextEditingController _motherNameController = TextEditingController();
  final TextEditingController _presentAddressController = TextEditingController();
  final TextEditingController _permanentAddressController = TextEditingController();
  bool _isAddressSame = false;


  @override
  void initState() {
    super.initState();
    // Call methods to fetch department and designation data
    _fetchDepartments();
    _fetchDesignations();
  }

  Future<void> _fetchDepartments() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.34:3000/api/managedept'),
      );

      if (response.statusCode == 200) {
        final parsedResponse = json.decode(response.body);
        if (parsedResponse is List<dynamic>) {
          setState(() {
            // Extract DEPT_SHORT_NAME from each department object
            _departmentNames = ['Select Department'] +
                parsedResponse
                    .map<String>((dept) => dept['DEPT_SHORT_NAME'] as String)
                    .toList();
          });
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

  Future<void> _fetchDesignations() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.34:3000/api/managedes'),
      );

      if (response.statusCode == 200) {
        final parsedResponse = json.decode(response.body);
        if (parsedResponse is List<dynamic>) {
          setState(() {
            // Extract DESIGNATION_NAME from each designation object
            _designationNames = ['Select Designation'] +
                parsedResponse
                    .map<String>((designation) => designation['DESIGNATION_NAME'] as String)
                    .toList();
          });
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

  Future<void> _submitForm() async {
    final String serverUrl = 'http://192.168.1.34:3000/api/employees';
    try {
      // Retrieve department ID based on selected department name
      final departmentId = await _fetchDepartmentId(_selectedDepartment);
      if (departmentId == null) {
        print('Failed to retrieve department ID for $_selectedDepartment');
        return;
      }

      // Retrieve designation ID based on selected designation name
      final designationId = await _fetchDesignationId(_selectedDesignation);
      if (designationId == null) {
        print('Failed to retrieve designation ID for $_selectedDesignation');
        return;
      }

      final response = await http.post(
        Uri.parse(serverUrl),
        body: {
          'first_name': _firstNameController.text,
          'middle_name': _middleNameController.text,
          'last_name': _lastNameController.text,
          'age': _ageController.text,
          'gender': _selectedGender ?? '', // Check for null to avoid sending null value
          'email': _emailController.text,
          'phno': _phoneController.text,
          'username': _usernameController.text,
          'password': _passwordController.text,
          'dept_id': departmentId,
          'designation_id': designationId,
          'father': _fatherNameController.text,
          'mother': _motherNameController.text,
          'addr_present': _presentAddressController.text,
          'addr_perm': _permanentAddressController.text,
          'dob': _selectedDOB != null ? DateFormat('yyyy-MM-dd').format(_selectedDOB!) : '', // Add date of birth
          'doj': _selectedDOJ != null ? DateFormat('yyyy-MM-dd').format(_selectedDOJ!) : '', // Add date of joining
        },
      );

      if (response.statusCode == 200) {
        print('Data inserted successfully!');
         ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Data inserted successfully.'),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.green, // Adjust the duration as needed
            ),
          );
      } else {
        print('Data insertion failed. Status code: ${response.statusCode}');
         ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to insert data.'),
              duration: Duration(seconds: 2), 
              backgroundColor: Colors.red,// Adjust the duration as needed
            ),
          );
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<String?> _fetchDepartmentId(String departmentName) async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.34:3000/api/managedept?name=$departmentName'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> parsedResponse = json.decode(response.body);
        final department = parsedResponse.firstWhere((dept) => dept['DEPT_SHORT_NAME'] == departmentName,
            orElse: () => null);

        if (department != null) {
          return department['DEPT_ID'].toString();
        } else {
          print('Failed to retrieve department ID for $departmentName');
          return null;
        }
      } else {
        print('Failed to retrieve department ID: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<String?> _fetchDesignationId(String designationName) async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.34:3000/api/managedes?name=$designationName'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> parsedResponse = json.decode(response.body);
        final designation = parsedResponse.firstWhere((desig) => desig['DESIGNATION_NAME'] == designationName,
            orElse: () => null);

        if (designation != null) {
          return designation['DESIGNATION_ID'].toString();
        } else {
          print('Failed to retrieve designation ID for $designationName');
          return null;
        }
      } else {
        print('Failed to retrieve designationID: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _fatherNameController.dispose();
    _motherNameController.dispose();
    _presentAddressController.dispose();
    _permanentAddressController.dispose();
    super.dispose();
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
              'Add Employee',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 20.0),
            child: Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _firstNameController,
                            decoration: InputDecoration(
                              labelText: 'First Name',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                              prefixIcon: Icon(Icons.person),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                         Expanded(
                          child: DropdownButtonFormField(
                            value: _selectedGender,
                            onChanged: (newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _selectedGender = newValue;
                                });
                              }
                            },
                            items: _genders.map((gender) {
                              return DropdownMenuItem(
                                value: gender,
                                child: Text(gender),
                              );
                            }).toList(),
                            decoration: InputDecoration(
                              labelText: 'Gender',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                              prefixIcon: Icon(Icons.person_outline),
                            ),
                          ),
                        ),
                       
                      
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                         Expanded(
                          child: TextFormField(
                            controller: _middleNameController,
                            decoration: InputDecoration(
                              labelText: 'Middle Name',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                              prefixIcon: Icon(Icons.person),
                            ),
                          ),
                        ),
                       
                        SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'Date of Birth',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                              prefixIcon: Icon(Icons.calendar_today),
                            ),
                            onTap: () async {
                              final selectedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                              );
                              if (selectedDate != null) {
                                setState(() {
                                  _selectedDOB = selectedDate;
                                });
                              }
                            },
                            controller: _selectedDOB != null
                                ? TextEditingController(text: DateFormat('yyyy-MM-dd').format(_selectedDOB!))
                                : null,
                          ),
                        ),
                      ]),
                       SizedBox(height: 20),
                       Row(
                          children:[
                        
                        Expanded(
                          child: TextFormField(
                            controller: _lastNameController,
                            decoration: InputDecoration(
                              labelText: 'Last Name',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                              prefixIcon: Icon(Icons.person),
                            ),
                          ),
                        ),
                       
                        SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'Date of Joining',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                              prefixIcon: Icon(Icons.calendar_today),
                            ),
                            onTap: () async {
                              final selectedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                              );
                              if (selectedDate != null) {
                                setState(() {
                                  _selectedDOJ = selectedDate;
                                });
                              }
                            },
                            controller: _selectedDOJ != null
                                ? TextEditingController(text: DateFormat('yyyy-MM-dd').format(_selectedDOJ!))
                                : null,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _fatherNameController,
                            decoration: InputDecoration(
                              labelText: "Father's Name",
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                              prefixIcon: Icon(Icons.person),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: _motherNameController,
                            decoration: InputDecoration(
                              labelText: "Mother's Name",
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                              prefixIcon: Icon(Icons.person),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
  children: [
    Expanded(
      child: TextFormField(
        controller: _presentAddressController,
        maxLines: null,
        decoration: InputDecoration(
          labelText: 'Present Address',
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
          prefixIcon: Icon(Icons.home),
        ),
      ),
    ),
    SizedBox(width: 10),
    Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Checkbox(
                value: _isAddressSame,
                onChanged: (value) {
                  setState(() {
                    _isAddressSame = value ?? false;
                    if (_isAddressSame) {
                      // If checkbox is checked, copy present address to permanent address
                      _permanentAddressController.text = _presentAddressController.text;
                    } else {
                      // If checkbox is unchecked, clear permanent address
                      _permanentAddressController.clear();
                    }
                  });
                },
              ),
              Text('Same as Present Address'),
            ],
          ),
          TextFormField(
            controller: _permanentAddressController,
            maxLines: null,
            enabled: !_isAddressSame, // Disable editing if checkbox is checked
            decoration: InputDecoration(
              labelText: 'Permanent Address',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
              prefixIcon: Icon(Icons.home),
            ),
          ),
        ],
      ),
    ),
  ],
),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                        prefixIcon: Icon(Icons.email),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an email';
                        }
                        // Validate email format
                        if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              labelText: 'Phone',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                              prefixIcon: Icon(Icons.phone),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField(
                            value: _selectedDepartment,
                            onChanged: (newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _selectedDepartment = newValue;
                                });
                              }
                            },
                            items: _departmentNames.map((dept) {
                              return DropdownMenuItem(
                                value: dept,
                                child: Text(dept),
                              );
                            }).toList(),
                            decoration: InputDecoration(
                              labelText: 'Department',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                              prefixIcon: Icon(Icons.business),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: DropdownButtonFormField(
                            value: _selectedDesignation,
                            onChanged: (newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _selectedDesignation = newValue;
                                });
                              }
                            },
                            items: _designationNames.map((desig) {
                              return DropdownMenuItem(
                                value: desig,
                                child: Text(desig),
                              );
                            }).toList(),
                            decoration: InputDecoration(
                              labelText: 'Designation',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                              prefixIcon: Icon(Icons.badge),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              labelText: 'Username',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                              prefixIcon: Icon(Icons.person),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                              prefixIcon: Icon(Icons.lock),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 100,
                          height: 40,
                          child: Material(
                            color: Colors.blueGrey,
                            borderRadius: BorderRadius.circular(5.0),
                            child: InkWell(
                              onTap: _validateAndSubmitForm,
                              child: Center(
                                child: Text(
                                  'Submit',
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
void _validateAndSubmitForm() {
  final String email = _emailController.text.trim();
  final String phone = _phoneController.text.trim();

  if (email.isEmpty) {
    _showAlertDialog('Error', 'Please enter an email');
  } else if (email != email.toLowerCase()) {
    _showAlertDialog('Error', 'Please enter the email address in lowercase letters only');
  } else if (!RegExp(r'^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$').hasMatch(email)) {
    _showAlertDialog('Error', 'Please enter a valid email address');
  } else if (phone.isEmpty) {
    _showAlertDialog('Error', 'Please enter a phone number');
  } else if (phone.length != 10 || !RegExp(r'^[0-9]{10}$').hasMatch(phone)) {
    _showAlertDialog('Error', 'Please enter a valid 10-digit phone number');
  } else {
    // Email and phone are valid, proceed with form submission
    _submitForm();
  }
}



  void _showAlertDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
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

}

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


void _editEmployee(int index) async {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController middleNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController dojController = TextEditingController();
  final TextEditingController fatherNameController = TextEditingController();
  final TextEditingController motherNameController = TextEditingController();
  final TextEditingController presentAddressController = TextEditingController();
  final TextEditingController permanentAddressController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phnoController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String selectedGender = 'Male'; // Default value for the dropdown

  try {
    final response = await http.get(
      Uri.parse('http://192.168.1.34:3000/api/manageemp'),
    );

    if (response.statusCode == 200) {
      final parsedResponse = json.decode(response.body);
      if (parsedResponse is List<dynamic>) {
        final employees = List<Map<String, dynamic>>.from(parsedResponse);

        // Retrieve current employee details
        final employee = employees[index];
        firstNameController.text = employee['FIRST_NAME'] ?? '';
        middleNameController.text = employee['MIDDLE_NAME'] ?? '';
        lastNameController.text = employee['LAST_NAME'] ?? '';
        dobController.text = employee['DOB'] ?? ''; // Assuming 'DOB' is a date string
        dojController.text = employee['DOJ'] ?? ''; // Assuming 'DOJ' is a date string
        fatherNameController.text = employee['FATHER'] ?? '';
        motherNameController.text = employee['MOTHER'] ?? '';
        presentAddressController.text = employee['ADDR_PRESENT'] ?? '';
        permanentAddressController.text = employee['ADDR_PERM'] ?? '';
        selectedGender = employee['GENDER'] ?? 'Male'; // Setting the initial value of the dropdown
        emailController.text = employee['EMAIL'] ?? '';
        phnoController.text = employee['PHNO'] ?? '';
        usernameController.text = employee['USERNAME'] ?? '';
        passwordController.text = employee['PASSWORD'] ?? '';

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Edit Employee'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('First Name:'),
                    TextFormField(
                      controller: firstNameController,
                      decoration: InputDecoration(
                        hintText: 'Enter first name',
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text('Middle Name:'),
                    TextFormField(
                      controller: middleNameController,
                      decoration: InputDecoration(
                        hintText: 'Enter middle name',
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text('Last Name:'),
                    TextFormField(
                      controller: lastNameController,
                      decoration: InputDecoration(
                        hintText: 'Enter last name',
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text('Date of Birth:'),
                    TextFormField(
                      controller: dobController,
                      readOnly: true,
                      onTap: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (pickedDate != null) {
                          dobController.text = pickedDate.toString();
                        }
                      },
                      decoration: InputDecoration(
                        hintText: 'Select date of birth',
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text('Date of Joining:'),
                    TextFormField(
                      controller: dojController,
                      readOnly: true,
                      onTap: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (pickedDate != null) {
                          dojController.text = pickedDate.toString();
                        }
                      },
                      decoration: InputDecoration(
                        hintText: 'Select date of joining',
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text('Father\'s Name:'),
                    TextFormField(
                      controller: fatherNameController,
                      decoration: InputDecoration(
                        hintText: 'Enter father\'s name',
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text('Mother\'s Name:'),
                    TextFormField(
                      controller: motherNameController,
                      decoration: InputDecoration(
                        hintText: 'Enter mother\'s name',
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text('Present Address:'),
                    TextFormField(
                      controller: presentAddressController,
                      decoration: InputDecoration(
                        hintText: 'Enter present address',
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text('Permanent Address:'),
                    TextFormField(
                      controller: permanentAddressController,
                      decoration: InputDecoration(
                        hintText: 'Enter permanent address',
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text('Gender:'),
                    DropdownButtonFormField<String>(
                      value: selectedGender,
                      onChanged: (String? newValue) {
                        selectedGender = newValue!;
                      },
                      items: <String>['Male', 'Female', 'Transgender']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        hintText: 'Select gender',
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text('Email:'),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: 'Enter email',
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text('Phone Number:'),
                    TextFormField(
                      controller: phnoController,
                      decoration: InputDecoration(
                        hintText: 'Enter phone number',
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text('Username:'),
                    TextFormField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        hintText: 'Enter username',
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text('Password:'),
                    TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        hintText: 'Enter password',
                      ),
                      obscureText: true,
                    ),
                  ],
                ),
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
                    _validateAndSubmitForm(
                      employee['EMPLOYEE_ID'], // Assuming there's an 'EMPLOYEE_ID' field in the employee object
                      firstNameController.text,
                      middleNameController.text,
                      lastNameController.text,
                      dobController.text,
                      dojController.text,
                      fatherNameController.text,
                      motherNameController.text,
                      presentAddressController.text,
                      permanentAddressController.text,
                      selectedGender,
                      emailController.text,
                      phnoController.text,
                      usernameController.text,
                      passwordController.text,
                    );
                  },
                  child: Text('Save'),
                ),
              ],
            );
          },
        );
      } else {
        print('Failed to retrieve employee details: Invalid response format');
      }
    } else {
      print('Failed to retrieve employee details: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}


void _validateAndSubmitForm(
  int employeeId,
  String firstName,
  String middleName,
  String lastName,
  String dob,
  String doj,
  String fatherName,
  String motherName,
  String presentAddress,
  String permanentAddress,
  String gender,
  String email,
  String phno,
  String username,
  String password,
) {
  if (email.isEmpty) {
    _showAlertDialog('Error', 'Please enter an email');
  } else if (email != email.toLowerCase()) {
    _showAlertDialog('Error', 'Please enter the email address in lowercase letters only');
  } else if (!RegExp(r'^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$').hasMatch(email)) {
    _showAlertDialog('Error', 'Please enter a valid email address');
  } else if (phno.isEmpty) {
    _showAlertDialog('Error', 'Please enter a phone number');
  } else if (phno.length != 10 || !RegExp(r'^[0-9]{10}$').hasMatch(phno)) {
    _showAlertDialog('Error', 'Please enter a valid 10-digit phone number');
  } else {
    // Email and phone are valid, proceed with form submission
    _submitForm(
      employeeId,
      firstName,
      middleName,
      lastName,
      dob,
      doj,
      fatherName,
      motherName,
      presentAddress,
      permanentAddress,
      gender,
      email,
      phno,
      username,
           password,
    );
        Navigator.of(context).pop();

  }
}

void _submitForm(
  int employeeId,
  String firstName,
  String middleName,
  String lastName,
  String dob,
  String doj,
  String fatherName,
  String motherName,
  String presentAddress,
  String permanentAddress,
  String gender,
  String email,
  String phno,
  String username,
  String password,
) {
  _updateEmployee(
    employeeId,
    firstName,
    middleName,
    lastName,
    dob,
    doj,
    fatherName,
    motherName,
    presentAddress,
    permanentAddress,
    gender,
    email,
    phno,
    username,
    password,
  );
}

void _updateEmployee(
  int employeeId,
  String firstName,
  String middleName,
  String lastName,
  String dob,
  String doj,
  String fatherName,
  String motherName,
  String presentAddress,
  String permanentAddress,
  String gender,
  String email,
  String phno,
  String username,
  String password,
) async {
  try {
    final response = await http.put(
      Uri.parse('http://192.168.1.34:3000/api/update_employee/$employeeId'), // Correct endpoint URL
      body: {
        'FIRST_NAME': firstName,
        'MIDDLE_NAME': middleName,
        'LAST_NAME': lastName,
        'DOB': dob,
        'DOJ': doj,
        'FATHER': fatherName,
        'MOTHER': motherName,
        'ADDR_PRESENT': presentAddress,
        'ADDR_PERM': permanentAddress,
        'GENDER': gender,
        'EMAIL': email,
        'PHNO': phno,
        'USERNAME': username,
        'PASSWORD': password,
      },
    );

    if (response.statusCode == 200) {
      print('Employee updated successfully');
      // Trigger a rebuild of the UI to reflect the changes
      setState(() {});
    } else {
      print('Failed to update employee: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

void _showAlertDialog(String title, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
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

@override
Widget build(BuildContext context) {
  final scrollController = ScrollController();

  return Scrollbar(
    trackVisibility: true,
    controller: scrollController,
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: scrollController,
      child: Container(
        padding: EdgeInsets.fromLTRB(5.0, 10.0, 20.0, 180.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Manage Employee',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Card(
              elevation: 4,
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
                        headingRowColor: MaterialStateColor.resolveWith((states) => Colors.grey[200]!),
                        dataRowColor: MaterialStateColor.resolveWith((states) => Colors.white),
                        columns: [
                          DataColumn(label: _buildDataColumnText('Employee ID')),
                          DataColumn(label: _buildDataColumnText('First Name')),
                          DataColumn(label: _buildDataColumnText('Middle Name')),
                          DataColumn(label: _buildDataColumnText('Last Name')),
                          DataColumn(label: _buildDataColumnText('Date of Birth')),
                          DataColumn(label: _buildDataColumnText('Date of Joining')),
                          DataColumn(label: _buildDataColumnText('Fathers Name')),
                          DataColumn(label: _buildDataColumnText('Mothers Name')),
                          DataColumn(label: _buildDataColumnText('Present Address')),
                          DataColumn(label: _buildDataColumnText('Permanent Address')),
                          DataColumn(label: _buildDataColumnText('Gender')),
                          DataColumn(label: _buildDataColumnText('Email')),
                          DataColumn(label: _buildDataColumnText('Phone Number')),
                          DataColumn(label: _buildDataColumnText('Username')),
                          DataColumn(label: _buildDataColumnText('Password')),
                          DataColumn(label: _buildDataColumnText('Department')),
                          DataColumn(label: _buildDataColumnText('Designation')),
                          DataColumn(label: _buildDataColumnText('Action')),
                        ],
                        rows: employees.map((employee) {
                          return DataRow(cells: [
                            DataCell(Text(employee['EMPLOYEE_ID'].toString(), style: TextStyle(fontWeight: FontWeight.bold))),
                            DataCell(Text(employee['FIRST_NAME'].toString(), style: TextStyle(fontWeight: FontWeight.bold))),
                            DataCell(Text(employee['MIDDLE_NAME'] != null ? employee['MIDDLE_NAME'].toString() : '', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataCell(Text(employee['LAST_NAME'].toString(), style: TextStyle(fontWeight: FontWeight.bold))),
                            DataCell(Text(employee['DOB'].toString())),
                            DataCell(Text(employee['DOJ'].toString())),
                            DataCell(Text(employee['FATHER'].toString())),
                            DataCell(Text(employee['MOTHER'].toString())),
                            DataCell(Text(employee['ADDR_PRESENT'].toString())),
                            DataCell(Text(employee['ADDR_PERM'].toString())),
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
  Map<int, bool?> _approvalStatusMap2 = {};
  Map<int, String> _rejectionReasonsMap = {};

  Future<List<Map<String, dynamic>>> _fetchLeaveRequest1() async {
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
                  request['DESIGNATION'] =
                      await _fetchDesignationName(designationId);
                } else {
                  print(
                      'Failed to parse employee details for employee ID: $employeeId');
                }
              } else {
                print(
                    'Failed to fetch employee details for employee ID: $employeeId');
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
                  request['DESIGNATION'] =
                      await _fetchDesignationName(designationId);
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
              Uri.parse('http://192.168.1.34:3000/api/leave-type/$leaveTypeId'),
            );

            if (leaveTypeResponse.statusCode == 200) {
              final leaveTypeDetails = json.decode(leaveTypeResponse.body);
              if (leaveTypeDetails is Map<String, dynamic>) {
                request['LEAVE_TYPE_NAME'] =
                    leaveTypeDetails['LEAVE_NAME'] ?? '-';
              } else {
                print(
                    'Failed to parse leave type details for leave type ID: $leaveTypeId');
              }
            } else {
              print(
                  'Failed to fetch leave type details for leave type ID: $leaveTypeId');
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
        final Map<String, dynamic> designationDetails =
            json.decode(response.body);
        if (designationDetails['DESIGNATION_NAME'] == 'HR') {
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
        Uri.parse('http://192.168.1.34:3000/api/employee/$employeeId'),
      );

      if (response.statusCode == 200) {
        final parsedResponse = json.decode(response.body);
        if (parsedResponse is Map<String, dynamic>) {
          final firstName = parsedResponse['FIRST_NAME'] ?? '';
          final middleName = parsedResponse['MIDDLE_NAME'] ?? '';
          final lastName = parsedResponse['LAST_NAME'] ?? '';
          return '$firstName ${middleName.isNotEmpty ? '$middleName ' : ''}$lastName'
              .trim();
        }
      }
      print('Failed to fetch employee details for employee ID: $employeeId');
      return 'Unknown';
    } catch (e) {
      print('Error fetching employee name: $e');
      return 'Unknown';
    }
  }

  Future<bool?> _fetchApprovalStatus(int applicationId) async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://192.168.1.34:3000/api/fetch-approval-statushr/$applicationId'),
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

  Future<void> _updateApprovalStatus2(int applicationId, bool approved,
      {String? reason, Map<String, dynamic>? leaveApplicationDetails}) async {
    try {
      final Map<String, dynamic> requestBody = {
        'approved': approved,
      };
      if (!approved && reason != null) {
        requestBody['reason'] =
            reason; // Include the reason in the request body if rejecting and reason is provided
      }

      final response = await http.put(
        Uri.parse(
            'http://192.168.1.34:3000/api/${approved ? 'approve-leave' : 'reject-leave'}/$applicationId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        print(
            'Leave request with ID $applicationId ${approved ? 'approved' : 'rejected'} successfully');
        // Save the approval status to shared preferences
        final prefs = await SharedPreferences.getInstance();
        prefs.setBool('approvalStatus_$applicationId', approved);

        // Update the rejection reasons map if the request was rejected
        if (!approved && reason != null) {
          setState(() {
            _rejectionReasonsMap[applicationId] = reason;
          });
        }

        // Send email notification
        final subject = approved ? 'Leave Approved' : 'Leave Rejected';
        final reasonText = approved ? '' : '\n\nReason for Rejection: $reason';
        final body = approved
            ? 'Your leave request has been approved by HR.'
            : 'Your leave request has been rejected by HR.$reasonText';
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
           ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to send email.'),
              duration: Duration(seconds: 2), // Adjust the duration as needed
            ),
          );
        }
      } else {
        print('Failed to update approval status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating approval status: $e');
    }
  }

  @override
Widget build(BuildContext context) {
  final scrollController = ScrollController();

  return Scrollbar(
    trackVisibility: true,
    controller: scrollController,
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: scrollController,
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
              future: _fetchLeaveRequest1(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final requests = snapshot.data!
                      .where((request) => request['APPROVED_BY3'] == 'Approved')
                      .toList();
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Card(
                      elevation: 4,
                      child: DataTable(
                        headingRowColor: MaterialStateColor.resolveWith(
                            (states) => Colors.grey[200]!),
                        dataRowColor: MaterialStateColor.resolveWith(
                            (states) => Colors.white),
                        columns: [
                          DataColumn(
                              label: _buildDataColumnText('Application Id')),
                          DataColumn(
                              label: _buildDataColumnText('Application Date')),
                          DataColumn(
                              label: _buildDataColumnText('Employee ID')),
                          DataColumn(
                              label: _buildDataColumnText('Employee Name')),
                          DataColumn(
                              label: _buildDataColumnText('Department')),
                          DataColumn(
                              label: _buildDataColumnText('Designation')),
                          DataColumn(
                              label: _buildDataColumnText('Leave Type')),
                          DataColumn(
                              label: _buildDataColumnText('From Date')),
                          DataColumn(
                              label: _buildDataColumnText('To Date')),
                          DataColumn(
                              label: _buildDataColumnText('Action')),
                          DataColumn(
                              label: _buildDataColumnText('Status')),
                        ],
                        rows: requests
                            .where((leave_application) =>
                                leave_application['DEPARTMENT'] != '' &&
                                leave_application['DESIGNATION'] != '')
                            .map((leave_application) {
                          final applicationId =
                              leave_application['APPLICATION_ID'];

                          return DataRow(cells: [
                            DataCell(Text(applicationId.toString())),
                            DataCell(Text(
                                leave_application['DATE_OF_APPLICATION'])),
                            DataCell(Text(
                                leave_application['EMPLOYEE_ID'] != null
                                    ? leave_application['EMPLOYEE_ID']
                                        .toString()
                                    : ' ')),
                            DataCell(Text(leave_application[
                                            'EMPLOYEE_NAME'] !=
                                        null &&
                                    leave_application['EMPLOYEE_NAME'] != ''
                                ? leave_application['EMPLOYEE_NAME']
                                : ' ')),
                            DataCell(
                                Text(leave_application['DEPARTMENT'] ?? ' ')),
                            DataCell(Text(
                                leave_application['DESIGNATION'] ?? ' ')),
                            DataCell(Text(
                                leave_application['LEAVE_TYPE_NAME'] ?? ' ')),
                            DataCell(Text(leave_application['START_DATE'])),
                            DataCell(Text(leave_application['END_DATE'])),
                            DataCell(Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    await _updateApprovalStatus2(
                                        applicationId, true,
                                        leaveApplicationDetails:
                                            leave_application);
                                    setState(() {
                                      _approvalStatusMap2[applicationId] =
                                          true;
                                    });
                                  },
                                  child: Text('Approve'),
                                ),
                                SizedBox(width: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    _showRejectDialog(applicationId,
                                        leaveApplicationDetails:
                                            leave_application);
                                  },
                                  child: Text('Reject'),
                                ),
                              ],
                            )),
                            DataCell(
                              FutureBuilder<bool?>(
                                future:
                                    _fetchApprovalStatus(applicationId),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return Text(
                                        'Error: ${snapshot.error}');
                                  } else {
                                    final bool? approvalStatus =
                                        snapshot.data;
                                    if (approvalStatus == null) {
                                      return Text(
                                          'Pending'); // Display "Pending" when status is not available
                                    } else {
                                      return Text(
                                        approvalStatus
                                            ? 'Approved'
                                            : 'Rejected',
                                        style: TextStyle(
                                          color: approvalStatus
                                              ? Colors.green
                                              : Colors.red,
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
                  );
                }
              },
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
  }

  void _showRejectDialog(int applicationId,
      {Map<String, dynamic>? leaveApplicationDetails}) {
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
                await _updateApprovalStatus2(applicationId, false,
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
}

class AddLeaveType extends StatefulWidget {
  @override
  _AddLeaveTypeState createState() => _AddLeaveTypeState();
}

class _AddLeaveTypeState extends State<AddLeaveType> {
  final TextEditingController _leaveNameController = TextEditingController();
  final TextEditingController _leaveDescriptionController = TextEditingController();
    final TextEditingController _numberDaysAllowedController = TextEditingController();


  Future<void> _submitForm() async {
    final String serverUrl = 'http://192.168.1.34:3000/api/lv';
    try {
      final response = await http.post(
        Uri.parse(serverUrl),
        body: {
          'LEAVE_NAME': _leaveNameController.text,
          'LEAVE_DESCRIPTION': _leaveDescriptionController.text,
          'NUMBER_DAYS_ALLOWED': _numberDaysAllowedController.text,
        },
      );

      if (response.statusCode == 200) {
        print('Data inserted successfully!');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Data inserted successfully.'),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.green, // Adjust the duration as needed
            ),
          );
      } else {
        print('Data insertion failed. Status code: ${response.statusCode}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Data insertion failed.'),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.red, // Adjust the duration as needed
            ),
          );
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  void dispose() {
    _leaveNameController.dispose();
    _leaveDescriptionController.dispose();
        _numberDaysAllowedController.dispose();

    super.dispose();
  }

@override
Widget build(BuildContext context) {
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(25.0, 20.0, 5.0, 0.0), // Adjust top padding here
          child: Text(
            'Add Leave Type',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 200.0), // Adjust vertical padding here
          child: Container( // Wrap the Card with Container
            width: MediaQuery.of(context).size.width * 0.5, // Set width to 50% of the screen width
            child: Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _leaveNameController,
                      decoration: InputDecoration(
                        labelText: 'Leave Name',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                        prefixIcon: Icon(Icons.work_outline_outlined),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _leaveDescriptionController,
                      decoration: InputDecoration(
                        labelText: 'Leave Description',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                        prefixIcon: Icon(Icons.work_outline_outlined),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _numberDaysAllowedController,
                      decoration: InputDecoration(
                        labelText: 'Number of Days',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                        prefixIcon: Icon(Icons.work_outline_outlined),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end, // Align the button to the right
                      children: [
                        Container(
                          width: 100, // Set the width of the button
                          height: 40, // Set the height of the button
                          child: Material(
                            color: Colors.blueGrey, // Set the color of the button
                            borderRadius: BorderRadius.circular(5.0), // Set the border radius
                            child: InkWell(
                              onTap: _submitForm,
                              child: Center(
                                child: Text(
                                  'Submit',
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
}

class ManageLeaveTypePage extends StatefulWidget {
  @override
  _ManageLeaveTypePageState createState() => _ManageLeaveTypePageState();
}

class _ManageLeaveTypePageState extends State<ManageLeaveTypePage> {
    List<Map<String, dynamic>> leavetype = []; // Define departments list

  Future<List<Map<String, dynamic>>> _fetchLeaveTypes() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.34:3000/api/manageleavetype'),
      );

      if (response.statusCode == 200) {
        final parsedResponse = json.decode(response.body);
        if (parsedResponse is List<dynamic>) {
          return List<Map<String, dynamic>>.from(parsedResponse);
        } else {
          print('Failed to retrieve leave type details: Invalid response format');
          return [];
        }
      } else {
        print('Failed to retrieve leave type details: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

 void _editleave(int index) async {
  final TextEditingController leaveNameController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController DaysController = TextEditingController();

  try {
    final response = await http.get(
      Uri.parse('http://192.168.1.34:3000/api/manageleavetype'),
    );

    if (response.statusCode == 200) {
      final parsedResponse = json.decode(response.body);
      if (parsedResponse is List<dynamic>) {
        final leaves = List<Map<String, dynamic>>.from(parsedResponse);

        // Retrieve current department details
        final leave = leaves[index];
        leaveNameController.text = leave['LEAVE_NAME'];
        descController.text = leave['LEAVE_DESCRIPTION'];
        DaysController.text = leave['NUMBER_DAYS_ALLOWED'].toString(); // Convert to string

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Edit Leave Type'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Leave Name:'),
                  TextFormField(
                    controller: leaveNameController,
                    decoration: InputDecoration(
                      hintText: 'Enter leave name',
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text('Leave Description:'),
                  TextFormField(
                    controller: descController,
                    decoration: InputDecoration(
                      hintText: 'Enter leave description',
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text('Number of Days Allowed:'),
                  TextFormField(
                    controller: DaysController,
                    keyboardType: TextInputType.number, // Set keyboard type to number
                    decoration: InputDecoration(
                      hintText: 'Enter days allowed',
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
                    _updateleave(
                      leave['LEAVE_TYPE_ID'],
                      leaveNameController.text,
                      descController.text,
                      int.parse(DaysController.text), // Parse string to int
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
        print('Failed to retrieve leave details: Invalid response format');
      }
    } else {
      print('Failed to retrieve leave details: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}


void _updateleave(int leaveId, String newName, String desc, int days) async {
  try {
    final response = await http.put(
      Uri.parse('http://192.168.1.34:3000/api/update_leave/$leaveId'),
      body: {
        'LEAVE_NAME': newName,
        'LEAVE_DESCRIPTION': desc,
        'NUMBER_DAYS_ALLOWED': days.toString(), // Convert days to a string
      },
    );

    if (response.statusCode == 200) {
      print('Leave updated successfully');
      // Trigger a rebuild of the UI to reflect the changes
      setState(() {});
    } else {
      print('Failed to update leave: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}



void _deleteleave(int leaveId) async {
  try {
print('Deleting leave with ID: $leaveId');

    final response = await http.delete(
      Uri.parse('http://192.168.1.34:3000/api/delete_leave/$leaveId'),
    );

    if (response.statusCode == 200) {
      print('Leave deleted successfully');
      // Trigger a rebuild of the UI to reflect the changes
      setState(() {});
    } else {
      print('Failed to delete leave: ${response.statusCode}');
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
              'Manage Leave Type',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Card(
              elevation: 4, // Add elevation for shadow effect
              child: Padding(
                padding: EdgeInsets.all(10),
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: _fetchLeaveTypes(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      final leaves = snapshot.data!;
                      return DataTable(
                        headingRowColor: MaterialStateColor.resolveWith((states) => Colors.grey[200]!), // Color for heading row
                        dataRowColor: MaterialStateColor.resolveWith((states) => Colors.white), // Color for data rows
                        columns: [
                          DataColumn(label: _buildDataColumnText('Leave Name')),
                          DataColumn(label: _buildDataColumnText('Description')),
                          DataColumn(label: _buildDataColumnText('Days Allowed')),
                          DataColumn(label: _buildDataColumnText('Action')), // Added action column
                        ],
                        rows: leaves.map((leave) {
                          // Format the date to display only the date part

                          return DataRow(cells: [
                        DataCell(Text(leave['LEAVE_NAME'] ?? 'N/A', style: TextStyle(fontWeight: FontWeight.bold))),
DataCell(Text(leave['LEAVE_DESCRIPTION'] ?? 'N/A', style: TextStyle(fontWeight: FontWeight.bold))),
DataCell(Text(leave['NUMBER_DAYS_ALLOWED']?.toString() ?? 'N/A', style: TextStyle(fontWeight: FontWeight.bold))),

                            DataCell(Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () => _editleave(leaves.indexOf(leave)),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => _deleteleave(leave['LEAVE_TYPE_ID']),

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
        Uri.parse('http://192.168.1.34:3000/api/manageleave'),
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
          DataCell(Text(status['APPROVED_BY3'] ?? '')),
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

class AddPayComp extends StatefulWidget {
  @override
  _AddPayCompState createState() => _AddPayCompState();
}

class _AddPayCompState extends State<AddPayComp> {
  final TextEditingController _employeeIdController = TextEditingController();
  final TextEditingController _basicPayController = TextEditingController();
  final TextEditingController _hraController = TextEditingController();
  final TextEditingController _daController = TextEditingController();
  final TextEditingController _otherAllowanceController = TextEditingController();
  final TextEditingController _providentFundController = TextEditingController();
  final TextEditingController _professionalTaxController = TextEditingController();

  Future<void> _submitForm() async {
    final String serverUrl = 'http://192.168.1.34:3000/api/salary';
    try {
      final response = await http.post(
        Uri.parse(serverUrl),
        body: {
          'employee_id': _employeeIdController.text,
          'basic_pay': _basicPayController.text,
          'hra': _hraController.text,
          'da': _daController.text,
          'other_allowance': _otherAllowanceController.text,
          'provident_fund': _providentFundController.text,
          'professional_tax': _professionalTaxController.text,
        },
      );

      if (response.statusCode == 200) {
        print('Data inserted successfully!');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Data inserted successfully.'),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.green, // Adjust the duration as needed
            ),
          );
      } else {
        print('Data insertion failed. Status code: ${response.statusCode}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Data insertion failed.'),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.red, // Adjust the duration as needed
            ),
          );
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  void dispose() {
    _employeeIdController.dispose();
    _basicPayController.dispose();
    _hraController.dispose();
    _daController.dispose();
    _otherAllowanceController.dispose();
    _providentFundController.dispose();
    _professionalTaxController.dispose();
    super.dispose();
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
              'Add Employee Salary Details',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 200.0),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.5,
              child: Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _employeeIdController,
                        decoration: InputDecoration(
                          labelText: 'Employee ID',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                          prefixIcon: Icon(Icons.person),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _basicPayController,
                        decoration: InputDecoration(
                          labelText: 'Basic Pay',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                          prefixIcon: Icon(Icons.monetization_on),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _hraController,
                        decoration: InputDecoration(
                          labelText: 'House Rent Allowance (HRA)',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                          prefixIcon: Icon(Icons.home),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _daController,
                        decoration: InputDecoration(
                          labelText: 'Dearness Allowance (DA)',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                          prefixIcon: Icon(Icons.attach_money),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _otherAllowanceController,
                        decoration: InputDecoration(
                          labelText: 'Other Allowance',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                          prefixIcon: Icon(Icons.money),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _providentFundController,
                        decoration: InputDecoration(
                          labelText: 'Provident Fund (PF)',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                          prefixIcon: Icon(Icons.account_balance_wallet),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _professionalTaxController,
                        decoration: InputDecoration(
                          labelText: 'Professional Tax (PT)',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                          prefixIcon: Icon(Icons.money_off),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: 100,
                            height: 40,
                            child: Material(
                              color: Colors.blueGrey,
                              borderRadius: BorderRadius.circular(5.0),
                              child: InkWell(
                                onTap: _submitForm,
                                child: Center(
                                  child: Text(
                                    'Submit',
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
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
  String _selectedMonth = DateFormat('MMMM').format(DateTime.now());
  String _selectedYear = DateTime.now().year.toString();

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
        Uri.parse('http://192.168.1.34:3000/api/leave-summary?employeeId=$employeeId&month=$_selectedMonth&year=$_selectedYear'),
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
            'net_salary': netSalary.toStringAsFixed(0), // Add net salary to the salary details
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
                      DropdownButtonFormField<String>(
                        value: _selectedMonth,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedMonth = newValue!;
                          });
                        },
                        items: <String>[
                          'January', 'February', 'March', 'April', 'May', 'June',
                          'July', 'August', 'September', 'October', 'November', 'December'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          labelText: 'Select Month',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        value: _selectedYear,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedYear = newValue!;
                          });
                        },
                        items: List<String>.generate(50, (index) => (DateTime.now().year - index).toString())
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          labelText: 'Select Year',
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
    double grossEarnings = _calculateGrossEarnings();
    double grossDeductions = _calculateGrossDeductions();
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
            TableRow(
                children: [
                  TableCell(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Divider(color: Colors.grey),
                        _buildRow('Gross Earnings', grossEarnings),
                      ],
                    ),
                  ),
                  TableCell(
                    child: SizedBox.shrink(),  // Empty cell for the divider
                  ),
                  TableCell(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Divider(color: Colors.grey),
                        _buildRow('Gross Deductions', grossDeductions),
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
         employeeSalary['net_salary'] != null
      ? 'Net Salary: Rupees${convertNumberToWords(int.parse(employeeSalary['net_salary']))}'
      : 'Net Salary: Rupees (Not Available)',          
      style: TextStyle(
            fontSize: 18,
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

  
String convertNumberToWords(int number) {
  if (number == 0) {
    return 'Zero';
  }

  List<String> units = [
    '', 'One', 'Two', 'Three', 'Four', 'Five', 'Six', 'Seven', 'Eight', 'Nine'
  ];

  List<String> teens = [
    'Ten', 'Eleven', 'Twelve', 'Thirteen', 'Fourteen', 'Fifteen', 'Sixteen',
    'Seventeen', 'Eighteen', 'Nineteen'
  ];

  List<String> tens = [
    '', '', 'Twenty', 'Thirty', 'Forty', 'Fifty', 'Sixty', 'Seventy', 'Eighty', 'Ninety'
  ];

  List<String> thousands = [
    '', 'Thousand', 'Million', 'Billion', 'Trillion', 'Quadrillion', 'Quintillion'
  ];

  String words = '';
  int group = 0;

  while (number > 0) {
    int chunk = number % 1000;
    if (chunk != 0) {
      String chunkWords = '';
      
      if (chunk ~/ 100 > 0) {
        chunkWords += units[chunk ~/ 100] + ' Hundred';
        chunk %= 100;
      }

      if (chunk >= 10 && chunk < 20) {
        chunkWords += (chunkWords.isEmpty ? '' : ' ') + teens[chunk - 10];
        chunk = 0; // Handle teens
      } else {
        if (chunk ~/ 10 > 0) {
          chunkWords += (chunkWords.isEmpty ? '' : ' ') + tens[chunk ~/ 10];
          chunk %= 10;
        }
        if (chunk > 0) {
          chunkWords += (chunkWords.isEmpty ? '' : ' ') + units[chunk];
        }
      }

      if (group > 0) {
        chunkWords += ' ${thousands[group]}';
      }

      words = (words.isEmpty ? ' ' : ' ') + chunkWords + words;
    }

    group++;
    number ~/= 1000;
  }

  return words;
}

  double _calculateGrossEarnings() {
    double basicPay = _parseDouble(employeeSalary['basic_pay']);
    double hra = _parseDouble(employeeSalary['hra']);
    double da = _parseDouble(employeeSalary['da']);
    double otherAllowance = _parseDouble(employeeSalary['other_allowance']);
    return basicPay + hra + da + otherAllowance;
  }

  double _calculateGrossDeductions() {
    double providentFund = _parseDouble(employeeSalary['provident_fund']);
    double professionalTax = _parseDouble(employeeSalary['professional_tax']);
    double leaveDeduction = _parseDouble(employeeSalary['leave_deduction']);
    return providentFund + professionalTax + leaveDeduction;
  }

  double _parseDouble(dynamic value) {
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    } else if (value is double) {
      return value;
    } else if (value is int) {
      return value.toDouble();
    } else {
      return 0.0;
    }
  }
}


class EmployeeReportPage extends StatefulWidget {
  @override
  _EmployeeReportPageState createState() => _EmployeeReportPageState();
}

class _EmployeeReportPageState extends State<EmployeeReportPage> {
  String? _selectedGender;
   late String selectedMonth;
  late int selectedYear;


  Future<List<Map<String, dynamic>>> _fetchEmployees() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.34:3000/api/manageemp'),
      );

      if (response.statusCode == 200) {
        final parsedResponse = json.decode(response.body);
        if (parsedResponse is List<dynamic>) {
          return List<Map<String, dynamic>>.from(parsedResponse);
        }
      }
      print('Failed to fetch employees: ${response.statusCode}');
    } catch (e) {
      print('Error fetching employees: $e');
    }
    return [];
  }

  List<Map<String, dynamic>> _filteredEmployees(List<Map<String, dynamic>> employees) {
    if (_selectedGender == null) {
      return employees;
    } else {
      return employees.where((employee) => employee['GENDER'] == _selectedGender).toList();
    }
  }

  Future<void> _downloadLeaveReport() async {
  try {
    // Construct the URL based on the selected gender
    final url = _selectedGender == null
        ? 'http://192.168.1.34:3000/api/generate-emp-report-all'
        : 'http://192.168.1.34:3000/api/generate-emp-report/$_selectedGender';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final pdfPath = jsonResponse['pdfPath'];

      // Implement logic to handle downloaded PDF file here
      // For example, you can open the PDF using a PDF viewer plugin or save it to device storage
      // For simplicity, let's just print the PDF path for now
      print('Leave report PDF downloaded to: $pdfPath');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('PDF downloaded successfully.'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green, // Adjust the duration as needed
        ),
      );
    } else {
      print('Failed to download leave report: ${response.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to download.'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red, // Adjust the duration as needed
        ),
      );
    }
  } catch (e) {
    print('Error downloading leave report: $e');
  }
}



@override
Widget build(BuildContext context) {
  final ScrollController _scrollController = ScrollController();

  return ScrollbarTheme(
    data: ScrollbarThemeData(
      thumbColor: MaterialStateColor.resolveWith((states) => Colors.grey), // Set the color of the scrollbar thumb
      trackColor: MaterialStateColor.resolveWith((states) => Colors.grey[200]!), // Set the color of the scrollbar track
    ),
    child: Container(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Employee Report',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack( // Wrap your existing content with a Stack
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Filter by Gender:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  DropdownButton<String>(
                    value: _selectedGender,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedGender = newValue;
                      });
                    },
                    items: [
                      DropdownMenuItem(
                        child: Text('All'),
                        value: null,
                      ),
                      DropdownMenuItem(
                        child: Text('Male'),
                        value: 'Male',
                      ),
                      DropdownMenuItem(
                        child: Text('Female'),
                        value: 'Female',
                      ),
                    ],
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
                        final List<Map<String, dynamic>> employees = snapshot.data ?? [];
                        final List<Map<String, dynamic>> filteredEmployees = _filteredEmployees(employees);
                       return Scrollbar(
  trackVisibility: true,
  controller: _scrollController, // Provide the ScrollController here
  child: SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    controller: _scrollController, // Provide the same ScrollController here
    child: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTableTheme(
        data: DataTableThemeData(
          headingRowColor: MaterialStateColor.resolveWith((states) => Colors.grey[200]!),
          dataRowColor: MaterialStateColor.resolveWith((states) => Colors.white),
        ),
        child: DataTable(
          dataTextStyle: TextStyle(fontWeight: FontWeight.bold),
          headingTextStyle: TextStyle(fontWeight: FontWeight.bold),
          columns: [
            DataColumn(label: Text('Employee ID')),
            DataColumn(label: Text('Employee Name')),
            DataColumn(label: Text('Date of Joining')),
            DataColumn(label: Text('Date of Birth')),
            DataColumn(label: Text('Gender')),
            DataColumn(label: Text('Email')),
            DataColumn(label: Text('Phone Number')),
            DataColumn(label: Text('Username')),
            DataColumn(label: Text('Password')),
            DataColumn(label: Text('Department')),
            DataColumn(label: Text('Designation')),
          ],
          rows: filteredEmployees.map((employee) {
            final firstName = employee['FIRST_NAME'].toString();
            final middleName = employee['MIDDLE_NAME'];
            final lastName = employee['LAST_NAME'].toString();
            String fullName = '';

            if (firstName.isNotEmpty) {
              fullName = firstName;
            }
            if (middleName != null) {
              if (fullName.isNotEmpty) {
                fullName += ' $middleName';
              } else {
                fullName = middleName.toString();
              }
            }
            if (lastName.isNotEmpty) {
              if (fullName.isNotEmpty) {
                fullName += ' $lastName';
              } else {
                fullName = lastName;
              }
            }
            return DataRow(cells: [
              DataCell(Text(employee['EMPLOYEE_ID'].toString(), style: TextStyle(fontSize: 14))),
              DataCell(Text(fullName, style: TextStyle(fontSize: 14))),
              DataCell(Text(employee['DOJ'].toString(), style: TextStyle(fontSize: 14))),
              DataCell(Text(employee['DOB'].toString(), style: TextStyle(fontSize: 14))),
              DataCell(Text(employee['GENDER'].toString(), style: TextStyle(fontSize: 14))),
              DataCell(Text(employee['EMAIL'].toString(), style: TextStyle(fontSize: 14))),
              DataCell(Text(employee['PHNO'].toString(), style: TextStyle(fontSize: 14))),
              DataCell(Text(employee['USERNAME'].toString(), style: TextStyle(fontSize: 14))),
              DataCell(Text(employee['PASSWORD'].toString(), style: TextStyle(fontSize: 14))),
              DataCell(Text(employee['DEPT_SHORT_NAME'].toString(), style: TextStyle(fontSize: 14))),
              DataCell(Text(employee['DESIGNATION_NAME'].toString(), style: TextStyle(fontSize: 14))),
            ]);
          }).toList(),
        ),
      ),
    ),
  ),
);
                      }
                    },
                  ),
                ],
              ),
              Positioned( // Positioned widget to align the download button
                top: 0,
                right: 0,
                child: Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    width: 140, // Adjust the width to make it square
                    height: 40, // Adjust the height to make it square
                    decoration: BoxDecoration(
                      color: Colors.green,
                      // borderRadius: BorderRadius.circular(8.0), // Optional: Adjust the border radius
                    ),
                    child: ElevatedButton(
                      onPressed: _downloadLeaveReport,
                      style: ElevatedButton.styleFrom(
                        primary: Colors.transparent, // Make the button background transparent
                        shadowColor: Colors.transparent, // Remove the button shadow
                      ),
                      child: Text(
                        'Download',
                        style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

}

class ReportsPage extends StatefulWidget {
  @override
  _ReportsPageState createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  Map<String, String> _leaveTypeMap = {};
  late String currentMonth;
  late int currentYear;
  late String selectedMonth;
  late int selectedYear;
  String selectedStatus = 'All';
  String selectedLeaveType = 'All';

  @override
  void initState() {
    super.initState();
    var now = DateTime.now();
    currentMonth = DateFormat('MMMM').format(now);
    currentYear = now.year;
    selectedMonth = currentMonth;
    selectedYear = currentYear;
    _fetchLeaveTypes();
  }

  Future<void> _fetchLeaveTypes() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.34:3000/api/manageleave'),
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

  Future<List<Map<String, dynamic>>> _fetchMonthlyReports(
      int month, int year, String status, String leaveType) async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.34:3000/api/managereq?month=$month&year=$year&status=$status'),
      );

      if (response.statusCode == 200) {
        final parsedResponse = json.decode(response.body);
        if (parsedResponse is List<dynamic>) {
          final List<Map<String, dynamic>> leaveRequests =
              List<Map<String, dynamic>>.from(parsedResponse);

          for (var request in leaveRequests) {
            final employeeId = request['EMPLOYEE_ID'];

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
                  final deptId = employeeDetails['DEPT_ID'];
                  final deptName = await _fetchDepartmentName(deptId);
                  request['EMPLOYEE_NAME'] = employeeName;
                  request['DEPT_NAME'] = deptName;
                } else {
                  print('Failed to parse employee details for employee ID: $employeeId');
                }
              } else {
                print('Failed to fetch employee details for employee ID: $employeeId');
              }
            }

            // Fetch leave type details based on leave_type_id
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

          leaveRequests.retainWhere((request) {
            final requestStatus = request['APPROVED_BYHR'];
            final requestLeaveType = request['LEAVE_TYPE_ID'].toString();

            bool statusMatches = selectedStatus == 'All' || requestStatus == selectedStatus;
            bool leaveTypeMatches = selectedLeaveType == 'All' || requestLeaveType == selectedLeaveType;

            return statusMatches && leaveTypeMatches;
          });

          // Filter the leave requests based on the selected month and year
          final filteredRequests = leaveRequests.where((request) {
            final applicationDate = DateTime.parse(request['DATE_OF_APPLICATION']);
            return applicationDate.month == month && applicationDate.year == year;
          }).toList();

          return filteredRequests;
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

  Future<String> _fetchDepartmentName(int departmentId) async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.34:3000/api/department/$departmentId'),
      );

      if (response.statusCode == 200) {
        final parsedResponse = json.decode(response.body);
        if (parsedResponse is Map<String, dynamic>) {
          final deptName = parsedResponse['DEPT_SHORT_NAME'] ?? 'Unknown';
          return deptName.toString();
        }
      }
      print('Failed to fetch department details for department ID: $departmentId');
      return 'Unknown';
    } catch (e) {
      print('Error fetching department name: $e');
      return 'Unknown';
    }
  }

  Future<void> _downloadLeaveReport() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.34:3000/api/generate-leave-report/$selectedMonth/$selectedYear/$selectedStatus/$selectedLeaveType'),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final pdfPath = jsonResponse['pdfPath'];

        print('Leave report PDF downloaded to: $pdfPath');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('PDF downloaded successfully.'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        print('Failed to download leave report: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to download.'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Error downloading leave report: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25.0, 20.0, 5.0, 50.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Container(
                width: 140,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.green,
                ),
                child: ElevatedButton(
                  onPressed: _downloadLeaveReport,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  child: Text(
                    'Download',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25.0, 20.0, 5.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Leave Report for $selectedMonth $selectedYear',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Select Month and Year',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      DropdownButton<String>(
                        value: selectedMonth,
                        items: DateFormat.MMMM().dateSymbols.MONTHS.map((String month) {
                          return DropdownMenuItem<String>(
                            value: month,
                            child: Text(month),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            selectedMonth = newValue!;
                          });
                        },
                      ),
                      SizedBox(width: 10),
                      DropdownButton<int>(
                        value: selectedYear,
                        items: List.generate(5, (index) {
                          int year = DateTime.now().year - index;
                          return DropdownMenuItem<int>(
                            value: year,
                            child: Text(year.toString()),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            selectedYear = newValue!;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Select Status',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  DropdownButton<String>(
                    value: selectedStatus,
                    items: ['All', 'Approved', 'Pending', 'Rejected'].map((String status) {
                      return DropdownMenuItem<String>(
                        value: status,
                        child: Text(status),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedStatus = newValue!;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Select Leave Type',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  DropdownButton<String>(
                    value: selectedLeaveType,
                    items: ['All'].map((String type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      );
                    }).toList() + _leaveTypeMap.entries.map((entry) {
                      return DropdownMenuItem<String>(
                        value: entry.key,
                        child: Text(entry.value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedLeaveType = newValue!;
                      });
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25.0, 20.0, 5.0, 200.0),
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _fetchMonthlyReports(
                  DateFormat.MMMM().dateSymbols.MONTHS.indexOf(selectedMonth) + 1,
                  selectedYear,
                  selectedStatus,
                  selectedLeaveType,
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    final reports = snapshot.data ?? [];
                    if (reports.isEmpty) {
                      return Center(child: Text('No leave applications in this month'));
                    }
                    return DataTable(
                      headingRowColor: MaterialStateColor.resolveWith((states) => Colors.grey[200]!),
                      dataRowColor: MaterialStateColor.resolveWith((states) => Colors.white),
                      columns: [
                        DataColumn(label: _buildDataColumnText('Application Date')),
                        DataColumn(label: _buildDataColumnText('Employee Name')),
                        DataColumn(label: _buildDataColumnText('Department')),
                        DataColumn(label: _buildDataColumnText('Leave Type')),
                        DataColumn(label: _buildDataColumnText('Leave Days')),
                        DataColumn(label: _buildDataColumnText('Status')),
                      ],
                      rows: reports.map((report) {
                        final applidate = report['DATE_OF_APPLICATION'].toString();
                        final employeeName = report['EMPLOYEE_NAME'].toString();
                        final deptName = report['DEPT_NAME'].toString();
                        final leaveTypeId = report['LEAVE_TYPE_ID'].toString();
                        final leaveName = _leaveTypeMap[leaveTypeId] ?? 'Unknown';
                        final leaveDays = report['NUMBER_OF_DAYS'].toString();
                        final status = report['APPROVED_BYHR'] == null
                            ? 'Pending'
                            : report['APPROVED_BYHR'].toString();

                        final statusColor = status == 'Approved'
                            ? Colors.green
                            : status == 'Rejected'
                                ? Colors.red
                                : Colors.black;
                        return DataRow(
                          cells: [
                            DataCell(Text(applidate, style: TextStyle(fontWeight: FontWeight.bold))),
                            DataCell(Text(employeeName, style: TextStyle(fontWeight: FontWeight.bold))),
                            DataCell(Text(deptName, style: TextStyle(fontWeight: FontWeight.bold))),
                            DataCell(Text(leaveName, style: TextStyle(fontWeight: FontWeight.bold))),
                            DataCell(Text(leaveDays, style: TextStyle(fontWeight: FontWeight.bold))),
                            DataCell(Text(status, style: TextStyle(fontWeight: FontWeight.bold, color: statusColor))),
                          ],
                          color: MaterialStateColor.resolveWith((states) {
                            final rowIndex = reports.indexOf(report);
                            return (rowIndex % 2 == 0) ? Colors.grey[100]! : Colors.white;
                          }),
                        );
                      }).toList(),
                    );
                  }
                },
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
  }
}
