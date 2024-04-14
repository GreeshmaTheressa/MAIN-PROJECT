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
  bool _showLeaveStatus = false;
  bool _showManageDesignation=false;
  bool _showPayComp = false;

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
                     ListTile(
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
                          
                         
                        });
  
                      },
                    ),
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
                              });
                            },
                          ),
                        ),
                      ],
                    ),


                    ListTile(
                      leading: Icon(Icons.local_hospital, color: Colors.white),
                      tileColor: Colors.blueGrey,
                      title: Text(
                        'Leave Type',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {setState(() {
                        _showRequestForm = false;
                        _showAddEmployeeForm = false;
                                _showManageDepartment = false;
                                _showAddDepartmentForm = false;
                                _showAddDesignationForm = false;
                                _showManageEmployee = false;
                                _showLeaveForm=true;
                                _showManageDesignation = false;
                                _showLeaveStatus = false;
                                _showPayComp = false;
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
                        _showAddEmployeeForm = false;
                                _showManageDepartment = false;
                                _showAddDepartmentForm = false;
                                _showAddDesignationForm = false;
                                _showManageEmployee = false;
                                _showLeaveForm=false;
                                _showManageDesignation = false;
                                _showLeaveStatus = false;
                                _showPayComp = false;
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
                              });},
                    ),
                    ListTile(
                      leading: Icon(Icons.report, color: Colors.white),
                      tileColor: Colors.blueGrey,
                      title: Text(
                        'Reports',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {},
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
                               : (_showRequestForm
                              ? LeaveRequestPage()
                               : (_showLeaveForm
                              ? AddLeaveType()
                              : (_showLeaveStatus
                      ? ManageLeaveStatus(employeeId: widget.employeeId)
                      :(_showPayComp
                      ? AddPayComp()
                              // Show the employee form here
                              : MainContent()))))))))),
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


class AddDepartmentPage extends StatefulWidget {
  @override
  _AddDepartmentPageState createState() => _AddDepartmentPageState();
}

class _AddDepartmentPageState extends State<AddDepartmentPage> {
  final TextEditingController _departmentNameController = TextEditingController();
  final TextEditingController _departmentDescriptionController = TextEditingController();

  Future<void> _submitForm() async {
    final String serverUrl = 'http://192.168.1.7:3000/api/dep';
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
      } else {
        print('Data insertion failed. Status code: ${response.statusCode}');
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

  Future<void> _submitForm() async {
    final String serverUrl = 'http://192.168.1.7:3000/api/des';
    try {
      final response = await http.post(
        Uri.parse(serverUrl),
        body: {
          'DESIGNATION_NAME': _designationNameController.text,
          'DESIGNATION_DESC': _designationDescriptionController.text,
        },
      );

      if (response.statusCode == 200) {
        print('Data inserted successfully!');
      } else {
        print('Data insertion failed. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  void dispose() {
    _designationNameController.dispose();
    _designationDescriptionController.dispose();
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

  final List<String> _genders = ['Select Gender','Male', 'Female', 'Other'];
  List<String> _departmentNames = ['Select Department']; // Initialize with the default value
  List<String> _designationNames = ['Select Designation']; // Initialize with the default value

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
        Uri.parse('http://192.168.1.7:3000/api/managedept'),
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
        Uri.parse('http://192.168.1.7:3000/api/managedes'),
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
    final String serverUrl = 'http://192.168.1.7:3000/api/employees';
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
        },
      );

      if (response.statusCode == 200) {
        print('Data inserted successfully!');
      } else {
        print('Data insertion failed. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

 Future<String?> _fetchDepartmentId(String departmentName) async {
  try {
    final response = await http.get(
      Uri.parse('http://192.168.1.7:3000/api/managedept?name=$departmentName'),
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
      Uri.parse('http://192.168.1.7:3000/api/managedes?name=$designationName'),
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
      print('Failed to retrieve designation ID: ${response.statusCode}');
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
                            controller: _lastNameController,
                            decoration: InputDecoration(
                              labelText: 'Last Name',
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
                        SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: _ageController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Age',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                              prefixIcon: Icon(Icons.calendar_today),
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
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                              prefixIcon: Icon(Icons.email),
                            ),
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
                                  _selectedDepartment= newValue;
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
        ],
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
   Map<int, bool?> _approvalStatusMap2 = {};
  Set<int> _disabledButtons2 = {};

  @override
  void initState() {
    super.initState();
    _loadDisabledButtons2();
  }

  void _loadDisabledButtons2() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _disabledButtons2 = prefs.getStringList('disabledButtons')?.map(int.parse).toSet() ?? {};
    });
  }

  void _saveDisabledButtons1() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('disabledButtons', _disabledButtons2.map((id) => id.toString()).toList());
  }
  Future<List<Map<String, dynamic>>> _fetchLeaveRequest1() async {
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

  Future<bool?> _fetchApprovalStatus3(int applicationId) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('approvalStatus_$applicationId');
  } catch (e) {
    print('Error fetching approval status: $e');
    return null;
  }
}

 Future<void> _updateApprovalStatus2(int applicationId, bool approved, {String? reason}) async {
    try {
      final Map<String, dynamic> requestBody = {
        'approved': approved,
      };
      if (!approved && reason != null) {
        requestBody['reason'] = reason; // Include the reason in the request body if rejecting and reason is provided
      }

      final response = await http.put(
        Uri.parse('http://192.168.1.7:3000/api/${approved ? 'approve-leave' : 'reject-leave'}/$applicationId'),
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
          _approvalStatusMap2[applicationId] = approved;
          // Add ID to disabled set if approved or rejected
          _disabledButtons2.add(applicationId);
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
              future: _fetchLeaveRequest1(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final requests = snapshot.data!.where((request) => request['APPROVED_BY3'] == 'Approved').toList();
                  return SizedBox(
                    width: double.infinity,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Card(
                        elevation: 4, // Add elevation for shadow effect
                        child: DataTable(
                          headingRowColor: MaterialStateColor.resolveWith((states) => Colors.grey[200]!), // Color for heading row
                          dataRowColor: MaterialStateColor.resolveWith((states) => Colors.white), // Color for data rows
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
    final bool isDisabled = _disabledButtons2.contains(applicationId);

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
              await _updateApprovalStatus2(applicationId, true);
              setState(() {
                _approvalStatusMap2[applicationId] = true;
                _disabledButtons2.add(applicationId); // Add ID to disabled set
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
        future: _fetchApprovalStatus3(applicationId),
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
              await _updateApprovalStatus2(applicationId, false, reason: rejectReason);
              Navigator.of(context).pop(); // Close the dialog
              setState(() {
                _disabledButtons2.add(applicationId); // Add ID to disabled set
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
class AddLeaveType extends StatefulWidget {
  @override
  _AddLeaveTypeState createState() => _AddLeaveTypeState();
}

class _AddLeaveTypeState extends State<AddLeaveType> {
  final TextEditingController _leaveNameController = TextEditingController();
  final TextEditingController _leaveDescriptionController = TextEditingController();
    final TextEditingController _numberDaysAllowedController = TextEditingController();


  Future<void> _submitForm() async {
    final String serverUrl = 'http://192.168.1.7:3000/api/lv';
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
      } else {
        print('Data insertion failed. Status code: ${response.statusCode}');
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
    final String serverUrl = 'http://192.168.1.7:3000/api/salary';
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
      } else {
        print('Data insertion failed. Status code: ${response.statusCode}');
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
