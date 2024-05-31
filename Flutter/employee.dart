import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:lmpp/pages/login.dart';




class DetailsDisplayScreen extends StatefulWidget {
  final List<String>? columnNames;
  final List<String>? employeeDetails;

  DetailsDisplayScreen({required this.columnNames, required this.employeeDetails});
  

  @override
  _DetailsDisplayScreenState createState() => _DetailsDisplayScreenState();
}

class _DetailsDisplayScreenState extends State<DetailsDisplayScreen> {
  List<String> _leaveNames = ['Select Leave Type'];
  bool _isLeaveStatusVisible = false;
  bool _isSalarySlipVisible=false;
  bool _isleavebal=false;
   List<Map<String, dynamic>> _leaveApplications = []; // Store fetched leave applications
   Map<String, String> _leaveTypeMap = {}; 
   Map<String, dynamic> _salaryDetails = {};
   Map<String, dynamic> _employeeDetails = {};
  String _selectedMonth = DateFormat('MMMM').format(DateTime.now());
int _selectedYear = DateTime.now().year;
 
  void _updateUI() {
    setState(() {}); // Empty setState to trigger UI update
  }


  @override
void initState() {
  super.initState();
  _fetchLeaveApplications(widget.employeeDetails?[getColumnIndex('EMPLOYEE_ID')] ?? ''); // Fetch leave applications when the screen initializes
  _fetchLeaveTypes1(); 
}
 bool _isDrawerOpen = true;

  void _toggleDrawer() {
    setState(() {
      _isDrawerOpen = !_isDrawerOpen;
    });
  }
  @override
Widget build(BuildContext context) {
  return Scaffold(
    body: Row(
      children: [
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          width: _isDrawerOpen ? 300 : 0,
          child: Drawer(
            elevation: 0,
            child: Stack(
              children: [
                Container(
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
                        tileColor: const Color.fromARGB(255, 25, 45, 56),
                        leading: Icon(Icons.dashboard, color: Colors.white),
                        title: Text(
                          'Dashboard',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          setState(() {
                            _isLeaveStatusVisible = false;
                            _isSalarySlipVisible = false;
                            _isleavebal=false;
                          });
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.event_note, color: Colors.white),
                        title: Text(
                          'Apply Leave',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          _showApplyLeaveForm(context);
                          _isSalarySlipVisible = false;
                          _isLeaveStatusVisible = false;
                          _isleavebal=false;
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.history, color: Colors.white),
                        title: Text(
                          'Leave Status',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          setState(() {
                            _isLeaveStatusVisible = true;
                            _isSalarySlipVisible = false;
                            _isleavebal=false;
                          });
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.history, color: Colors.white),
                        title: Text(
                          'Leave Balance',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          setState(() {
                            _isLeaveStatusVisible = false;
                            _isSalarySlipVisible = false;
                            _isleavebal=true;
                          });
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.history, color: Colors.white),
                        title: Text(
                          'My Salary',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          setState(() {
                            _isSalarySlipVisible = true;
                            _isLeaveStatusVisible = false;
                            _isleavebal=false;
                          });
    _fetchSalaryDetailsAndGenerateSlip(context, _selectedMonth, _selectedYear);
                        },
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
              ],
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
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: _isLeaveStatusVisible
                  ? LeaveStatusWidget(
                      leaveApplications: _leaveApplications, 
                      employeeId: widget.employeeDetails?[getColumnIndex('EMPLOYEE_ID')] ?? '', 
                      leaveTypeMap: _leaveTypeMap,
                    )
                    : _isleavebal
                    ? LeaveBalanceWidget(
                      leaveApplications: _leaveApplications,
                      employeeId: widget.employeeDetails?[getColumnIndex('EMPLOYEE_ID')] ?? '', 
                      employeeName: _getFullName(), 
                      designationId: int.parse(widget.employeeDetails?[getColumnIndex('DESIGNATION_ID')] ?? ''),
        dateOfJoining: DateTime.parse(widget.employeeDetails?[getColumnIndex('DOJ')] ?? ''), // Parse string to DateTime
                      leaveTypeMap: _leaveTypeMap,
                    )
                  : _isSalarySlipVisible
                      ? SalarySlipWidget(
                          salaryDetails: _salaryDetails,
                          employeeDetails: _employeeDetails,
                            fetchSalaryDetailsAndGenerateSlip: _fetchSalaryDetailsAndGenerateSlip,

                        )
                      : _buildProfileDetails(),
            ),
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
  Widget _buildProfileDetails() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 10),
        Text(
          'Welcome ${widget.employeeDetails?[getColumnIndex('FIRST_NAME')] ?? 'Unknown'}!',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 80),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildDetailRow(
              icon: Icons.person_2_outlined,
              label: 'Name',
              detail: _getFullName(),
            ),
            SizedBox(width: 20),
            _buildDetailRow(
              icon: Icons.calendar_today_outlined,
              label: 'Date of Joining',
              detail: widget.employeeDetails![getColumnIndex('DOJ')],
            ),
          ],
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildDetailRow(
              icon: Icons.calendar_today_outlined,
              label: 'Date of Birth',
              detail: widget.employeeDetails![getColumnIndex('DOB')],
            ),
            SizedBox(width: 20),
            _buildDetailRow(
              icon: Icons.person_3_outlined,
              label: 'Gender',
              detail: widget.employeeDetails![getColumnIndex('GENDER')],
            ),
          ],
        ),
         SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildDetailRow(
              icon: Icons.person_2_outlined,
              label: 'Fathers Name',
              detail: widget.employeeDetails![getColumnIndex('FATHER')],
            ),
            SizedBox(width: 20),
            _buildDetailRow(
              icon: Icons.person_2_outlined,
              label: 'Mothers Name',
              detail: widget.employeeDetails![getColumnIndex('MOTHER')],
            ),
          ],
        ),
            SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildDetailRow(
              icon: Icons.home_outlined,
              label: 'Present Address',
              detail: widget.employeeDetails![getColumnIndex('ADDR_PRESENT')],
            ),
            SizedBox(width: 20),
            _buildDetailRow(
              icon: Icons.home_outlined,
              label: 'Permanent Address',
              detail: widget.employeeDetails![getColumnIndex('ADDR_PERM')],
            ),
          ],
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildDetailRow(
              icon: Icons.email_outlined,
              label: 'Email',
              detail: widget.employeeDetails![getColumnIndex('EMAIL')],
            ),
            SizedBox(width: 20),
            _buildDetailRow(
              icon: Icons.phone_outlined,
              label: 'Phone Number',
              detail: widget.employeeDetails![getColumnIndex('PHNO')],
            ),
          ],
        ),
      ],
    );
  }

   Future<void> _fetchLeaveTypes1() async {
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


Widget _buildLeaveStatusTable() {
  return LeaveStatusWidget(leaveApplications: _leaveApplications, employeeId: widget.employeeDetails?[getColumnIndex('EMPLOYEE_ID')] ?? '', leaveTypeMap: _leaveTypeMap, );
}

 Future<void> _fetchLeaveApplications(String employeeId) async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.34:3000/api/leavestatus/$employeeId'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> parsedResponse = json.decode(response.body);
        setState(() {
          _leaveApplications = parsedResponse.cast<Map<String, dynamic>>();
        });
        print('Fetched leave applications: $_leaveApplications'); // Add this line to check the fetched data
      } else {
        print('Failed to fetch leave applications: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching leave applications: $e');
    }
  }


String _getFullName() {
  final employeeDetails = widget.employeeDetails;
  final columnNames = widget.columnNames;
  if (employeeDetails != null && columnNames != null) {
    final firstNameIndex = getColumnIndex('FIRST_NAME');
    final middleNameIndex = getColumnIndex('MIDDLE_NAME');
    final lastNameIndex = getColumnIndex('LAST_NAME');

    if (firstNameIndex != -1 && lastNameIndex != -1) {
      final firstName = employeeDetails.length > firstNameIndex ? employeeDetails[firstNameIndex] ?? '' : '';
      final middleName = middleNameIndex != -1 ? (employeeDetails.length > middleNameIndex ? employeeDetails[middleNameIndex] ?? '' : '') : '';
      final lastName = employeeDetails.length > lastNameIndex ? employeeDetails[lastNameIndex] ?? '' : '';

      // Check if middle name is null or empty
      final middleNameStr = middleName.isNotEmpty && middleName != 'null' ? '$middleName ' : '';

      return '$firstName $middleNameStr$lastName'.trim();
    }
  }
  return ''; // Handle the case where employeeDetails or columnNames are null or indices are invalid
}




Widget _buildDetailRow({required IconData icon, required String label, required String detail}) {
  return SizedBox(
    width: 400,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 60,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Icon(
              icon,
              size: 40,
              color: _getIconColor(icon),
            ),
          ),
        ),
        SizedBox(width: 10),
        Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(),
              ),
              SizedBox(height: 4),
              Text(
                detail,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 40),
      ],
    ),
  );
}



  Color _getIconColor(IconData icon) {
    // Assign different colors based on the icon
    if (icon == Icons.person_2_outlined) {
      return Colors.blue;
    } else if (icon == Icons.calendar_today_outlined) {
      return Colors.green;
    } else if (icon == Icons.person_3_outlined) {
      return Colors.orange;
    } else if (icon == Icons.email_outlined) {
      return Colors.red;
    } else if (icon == Icons.phone_outlined) {
      return Colors.purple;
    } else if (icon == Icons.account_circle_outlined) {
      return Colors.teal;
    } else {
      return Colors.black; // Default color
    }
  }

  int getColumnIndex(String columnName) {
    return widget.columnNames!.indexOf(columnName);
  }
// Modify the _fetchSalaryDetailsAndGenerateSlip method to include month and year parameters
void _fetchSalaryDetailsAndGenerateSlip(BuildContext context, String month, int year) async {
  try {
    String employeeId = widget.employeeDetails?[getColumnIndex('EMPLOYEE_ID')] ?? '';
    await _fetchLeaveApplications(employeeId); // Fetch leave applications for the employee
    await _fetchSalaryDetails(context, employeeId, month, year); // Pass 'context', 'employeeId', 'month', and 'year' to fetch salary details
    // showDialog is moved to _fetchSalaryDetails, so it's called after _salaryDetails is populated
  } catch (e) {
    print('Error fetching salary details and generating slip: $e');
    // Handle error (e.g., show error message)
  }
}


Future<void> _fetchSalaryDetails(BuildContext context, String employeeId, String month, int year) async {
  try {
    // Fetch salary details
    final salaryResponse = await http.get(
      Uri.parse('http://192.168.1.34:3000/api/managesal/$employeeId'),
    );

    // Fetch employee details
    final employeeResponse = await http.get(
      Uri.parse('http://192.168.1.34:3000/api/employee/$employeeId'),
    );

    // Fetch leave summary for the specified month and year
    final leaveResponse = await http.get(
      Uri.parse('http://192.168.1.34:3000/api/leave-summary?employeeId=$employeeId&month=$month&year=$year'),
    );

    if (salaryResponse.statusCode == 200 && employeeResponse.statusCode == 200 && leaveResponse.statusCode == 200) {
      final dynamic parsedSalaryResponse = json.decode(salaryResponse.body);
      final dynamic parsedEmployeeResponse = json.decode(employeeResponse.body);
      final dynamic parsedLeaveResponse = json.decode(leaveResponse.body);

      // Extract salary details
      final salaryDetails = {
        'basic_pay': parsedSalaryResponse['basic_pay'].toString(),
        'hra': parsedSalaryResponse['hra'].toString(),
        'da': parsedSalaryResponse['da'].toString(),
        'other_allowance': parsedSalaryResponse['other_allowance'].toString(),
        'provident_fund': parsedSalaryResponse['provident_fund'].toString(),
        'professional_tax': parsedSalaryResponse['professional_tax'].toString(),
        'tot_sal': parsedSalaryResponse['tot_sal'].toString(),
        'employee_id': parsedSalaryResponse['employee_id'].toString(),
      };

      // Extract employee details
      final employeeDetails = {
        'employee_id': parsedEmployeeResponse['employee_id'].toString(),
        'employee_name': parsedEmployeeResponse['employee_name'].toString(),
        'dept_name': parsedEmployeeResponse['dept_name'].toString(),
        'designation_name': parsedEmployeeResponse['designation_name'].toString(),
      };

      // Extract total leave days for the specified month and year
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
        _salaryDetails = {
          ...salaryDetails,
          'salary_per_day': salaryPerDay.toStringAsFixed(2), // Add salary per day to the salary details
          'total_leave_days': totalLeaveDays.toString(), // Add total leave days to the salary details
          'total_work_days': totalWorkDays.toString(), // Add total work days to the salary details
          'net_salary': netSalary.toStringAsFixed(0), // Add net salary to the salary details
          'leave_deduction': leaveDeduction.toStringAsFixed(0), // Add leave deduction to the salary details
        };
        _employeeDetails = employeeDetails;
        _isSalarySlipVisible = true;
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


DateTime _calculateProbationEndDate(DateTime startDate, int months) {
  int year = startDate.year;
  int month = startDate.month + months;
  while (month > 12) {
    month -= 12;
    year++;
  }
  return DateTime(year, month, startDate.day);
}

void _showApplyLeaveForm(BuildContext context) async {
  DateTime? startDate;
  DateTime? endDate;
  DateTime applicationDate = DateTime.now(); // Default application date
  String _selectedLeaveType = 'Select Leave Type'; // Variable to store the selected leave type
  String? _leaveBalance; // Variable to store the leave balance
  String? _numberOfDaysAllowed; // Variable to store the number of days allowed
  String? _monthlyLeaveBalance; // Variable to store the monthly leave balance
  String _selectedLeaveName = '';

  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController applicationDateController = TextEditingController(text: "${applicationDate.day.toString().padLeft(2, '0')}-${applicationDate.month.toString().padLeft(2, '0')}-${applicationDate.year}");
  TextEditingController numberOfDaysController = TextEditingController();

  // Fetch leave types from the backend API
  await _fetchLeaveTypes(); // Call the function to populate the leave names

  // Fetch the employee ID from employeeDetails
  String? employeeId = widget.employeeDetails?[getColumnIndex('EMPLOYEE_ID')];
  String? doj = widget.employeeDetails?[getColumnIndex('DOJ')];
  print('DOJ: $doj');

  // Parse the DOJ string to a DateTime object
  DateTime? dojDate;
  if (doj != null) {
    dojDate = DateFormat("yyyy-MM-dd").parse(doj); // Assuming the DOJ is in 'yyyy-MM-dd' format
  }

  int? designationId;
  if (widget.employeeDetails != null) {
    String? designationIdString = widget.employeeDetails![getColumnIndex('DESIGNATION_ID')];
    designationId = designationIdString != null ? int.tryParse(designationIdString) : null;
  }

  // Ensure designationId is of type int
  Designation? designation = await fetchDesignationById(designationId ?? 0);

  if (designation != null) {
    print('Probation Period for Designation ID ${designation.id}: ${designation.probationPeriod} months');
  } else {
    print('Failed to fetch designation details.');
  }

  int probationPeriodMonths = int.tryParse(designation?.probationPeriod ?? '6') ?? 6;

  // Calculate the probation end date based on DOJ and probation period
  DateTime probationEndDate = _calculateProbationEndDate(dojDate ?? applicationDate, probationPeriodMonths);
  print('Probation End Date: $probationEndDate');
  // Check if the current date is on or after the probation end date
  bool isOnOrAfterProbationEndDate = DateTime.now().isAtSameMomentAs(probationEndDate) || DateTime.now().isAfter(probationEndDate);

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
              width: 300, // Set a fixed width for the dialog box
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
                    onChanged: (newValue) async {
                      if (newValue != null) {
                        setState(() {
                          _selectedLeaveType = newValue;
                          _fetchLeaveBalance(newValue, startDate); // Fetch leave balance
                          _selectedLeaveName = newValue;
                        });

                        // Check if the selected leave type is casual leave and if the current date is on or after the probation end date
                        if (_selectedLeaveType == 'Casual Leave' && !isOnOrAfterProbationEndDate) {
                          // If it's casual leave and not on or after the probation end date, show an alert informing the user
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Cannot Apply for Casual Leave'),
                                content: Text('You cannot apply for casual leave until the probation end date.'),
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
                          return; // Exit the function
                        }
                      }
                    },
                    items: _leaveNames.map((leave_type) {
                      return DropdownMenuItem(
                        value: leave_type,
                        child: Text(leave_type),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: 'Leave Type', // Label for the dropdown
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    ),
                  ),
                  SizedBox(height: 10), // Add some space
                  if (_leaveBalance != null)
                    Text(
                      'Leave Balance: $_leaveBalance', // Display leave balance below the drop-down input box when it's not null
                      style: TextStyle(color: Colors.grey),
                    ),
                  if (_numberOfDaysAllowed != null)
                    Text(
                      'Number of Days Allowed: $_numberOfDaysAllowed', // Display number of days allowed below the drop-down input box when leave balance is null
                      style: TextStyle(color: Colors.grey),
                    ),
                  if (_monthlyLeaveBalance != null) // Check if _monthlyLeaveBalance is not null
                    Text(
                      'Monthly Leave Balance: $_monthlyLeaveBalance', // Display monthly leave balance if available
                      style: TextStyle(color: Colors.grey),
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
                          startDateController.text = "${startDate!.day.toString().padLeft(2, '0')}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.year}";
                          _updateNumberOfDays(startDate, endDate, numberOfDaysController); // Update number of days
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
                          endDateController.text = "${endDate!.day.toString().padLeft(2, '0')}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.year}";
                          _updateNumberOfDays(startDate, endDate, numberOfDaysController); // Update number of days
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
                    controller: numberOfDaysController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Number of Days',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
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
                          // Additional check for casual leave on probation end date
                          if (_selectedLeaveType == 'Casual Leave' && !isOnOrAfterProbationEndDate) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Cannot Apply for Casual Leave'),
                                  content: Text('You cannot apply for casual leave until the probation end date.'),
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
                            return; // Exit the function
                          }

                          final DateFormat dateFormat = DateFormat('yyyy-MM-dd'); // Define the date format expected by Oracle
                          final String formattedStartDate = startDate != null ? dateFormat.format(startDate!) : ''; // Format the start date
                          final String formattedEndDate = endDate != null ? dateFormat.format(endDate!) : ''; // Format the end date
                          final String formattedApplicationDate = dateFormat.format(applicationDate);

                          final String serverUrl = 'http://192.168.1.34:3000/api/leaveapp';
                          try {
                            final leaveTypeId = await _fetchLeaveTypeId(_selectedLeaveType);
                            if (leaveTypeId == null) {
                              print('Failed to retrieve leave type ID for $_selectedLeaveType');
                              return;
                            }

                            // Ensure numberOfDays is not null before passing it to the request body
                            final String numberOfDaysValue = numberOfDaysController.text;

                            // Include employee ID along with other details in the request body
                            final response = await http.post(
                              Uri.parse(serverUrl),
                              body: {
                                'employee_id': employeeId,
                                'start_date': formattedStartDate,
                                'end_date': formattedEndDate,
                                'date_of_application': formattedApplicationDate,
                                'leave_type_id': leaveTypeId,
                                'number_of_days': numberOfDaysValue,
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
    Navigator.of(context).pop();

    // Update the leave balance data
    await _fetchLeaveBalance(_selectedLeaveType, startDate);
    
    // Trigger a rebuild of the LeaveBalanceWidget with the new leave balance data
    setState(() {});
  } else if (response.statusCode == 400) {
                              final responseData = json.decode(response.body);
                              final errorMessage = responseData['error'];

                              if (errorMessage.contains('Leave already taken')) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Leave Already Taken'),
                                      content: Text('Leave already taken for $_selectedLeaveName in the current month.'),
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
                              } else {
                                // For other types of leave application errors
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Leave Application Failed'),
                                      content: Text(errorMessage), // Display the error message from the backend
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
                            } else {
                              print('Leave application failed. Status code: ${response.statusCode}');
                            }

                          } catch (error) {
                            print('Error: $error');
                          }
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
                ],
              ),
            ),
          );
        },
      );
    },
  );
}


bool isBalanceSufficient = true;
String? leaveTypeForAlert; // Variable to store the leave type for which leave is already taken

Future<void> _fetchLeaveBalance(String leaveType, DateTime? startDate) async {
  try {
    final response = await http.get(
      Uri.parse('http://192.168.1.34:3000/api/leavebalance/${widget.employeeDetails?[getColumnIndex('EMPLOYEE_ID')]}/$leaveType'),
    );

    if (response.statusCode == 200) {
      final parsedResponse = json.decode(response.body);
      if (parsedResponse.containsKey('monthly_leave_balance')) {
        double currentMonthlyLeaveBalance = parsedResponse['monthly_leave_balance']?.toDouble() ?? 0.0;

        // Check if leave has already been taken this month for the selected leave type
        if (parsedResponse.containsKey('leave_taken_this_month') &&
            parsedResponse['leave_taken_this_month'] != null &&
            parsedResponse['leave_taken_this_month'] == true &&
            leaveType != 'Unpaid Leave' && leaveType != 'LOP') {
          // Show alert message
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Leave Already Taken'),
                content: Text('Leave already taken for $leaveType in the current month. You can apply for unpaid leave for this type for the current month.'),
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
          setState(() {
            isBalanceSufficient = false; // Disable Apply button for this leave type
            leaveTypeForAlert = leaveType; // Store the leave type for which leave is already taken
          });
          return;
        }
        else if (currentMonthlyLeaveBalance >= 1.0 || leaveType == 'Unpaid Leave' || leaveType == 'LOP') {
          setState(() {
            isBalanceSufficient = true; // Enable Apply button for other leave types
            leaveTypeForAlert = null; // Reset leaveTypeForAlert
          });
        }
      } else {
        print('Monthly leave balance not found');
      }
    } else {
      print('Failed to retrieve leave balance: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching leave balance: $e');
  }
}

// Function to update the number of days
void _updateNumberOfDays(DateTime? startDate, DateTime? endDate, TextEditingController numberOfDaysController) {
  if (startDate != null && endDate != null) {
    final difference = endDate.difference(startDate).inDays + 1; // Add 1 to include both start and end dates
    final numberOfDays = difference.toString();
    numberOfDaysController.text = numberOfDays;
  } else {
    numberOfDaysController.text = '';
  }
}

// Function to fetch leave types
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

// Function to fetch leave type ID
Future<String?> _fetchLeaveTypeId(String leaveName) async {
  try {
    final response = await http.get(
      Uri.parse('http://192.168.1.34:3000/api/manageleave?name=$leaveName'),
    );

    print('API Response: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> parsedResponse = json.decode(response.body);
      final leaveType = parsedResponse.firstWhere((leaveType) => leaveType['LEAVE_NAME'] == leaveName, orElse: () => null);

      if (leaveType != null) {
        final leaveTypeId = leaveType['LEAVE_TYPE_ID'].toString();
        print('Leave Type ID: $leaveTypeId');
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

class LeaveStatusWidget extends StatelessWidget {
  final List<Map<String, dynamic>> leaveApplications;
  final String employeeId;
  final Map<String, String> leaveTypeMap;

  LeaveStatusWidget({
    required this.leaveApplications,
    required this.employeeId,
    required this.leaveTypeMap,
  });

  @override
  Widget build(BuildContext context) {
      print('Leave Applications: $leaveApplications');
  print('Employee ID: $employeeId');
  print('Leave Type Map: $leaveTypeMap');
    
    List<Map<String, dynamic>> filteredLeaveApplications =
        leaveApplications.where((application) => application['EMPLOYEE_ID'].toString() == employeeId).toList();

    print('Filtered Leave Applications: $filteredLeaveApplications');  // Debugging print

    if (filteredLeaveApplications.isEmpty) {
      return Center(child: Text('No leave applications found for this employee.'));
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'View Leave Status',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            _buildDataTable(filteredLeaveApplications),
          ],
        ),
      ),
    );
  }

  Widget _buildDataTable(List<Map<String, dynamic>> filteredLeaveApplications) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.zero,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 32,
          headingRowColor: MaterialStateColor.resolveWith((states) => Colors.grey[200]!), // Grey background for header
          dataRowColor: MaterialStateColor.resolveWith((states) => Colors.white), // White background for data rows
          columns: [
            DataColumn(label: _buildDataColumnText('Application Date')),
            DataColumn(label: _buildDataColumnText('Start Date')),
            DataColumn(label: _buildDataColumnText('End Date')),
            DataColumn(label: _buildDataColumnText('Leave Type')),
            DataColumn(label: _buildDataColumnText('Department Head')),
            DataColumn(label: _buildDataColumnText('Manager')),
            DataColumn(label: _buildDataColumnText('HR')),
            DataColumn(label: _buildDataColumnText('Remarks')),
          ],
          rows: filteredLeaveApplications.map((application) {
            final leaveTypeId = application['LEAVE_TYPE_ID'].toString();
            final leaveName = leaveTypeMap[leaveTypeId] ?? 'Unknown';
            final statuses = _getStatus(application);

            // Check if the status is 'Approved'
            final isApproved = statuses.any((status) => status == 'Approved');

            return DataRow(cells: [
              DataCell(_buildDataCellText(application['DATE_OF_APPLICATION'].toString())),
              DataCell(_buildDataCellText(application['START_DATE'].toString())),
              DataCell(_buildDataCellText(application['END_DATE'].toString())),
              DataCell(_buildDataCellText(leaveName)),
              DataCell(_buildDataCellText(statuses[0])),
              DataCell(_buildDataCellText(statuses[1])),
              DataCell(_buildDataCellText(statuses[2])),
              if (!isApproved) // Only add Remarks cell if not Approved
                DataCell(_buildDataCellText(application['REJECTION_REASON'] ?? '')),
              if (isApproved) // Add an empty cell if Approved
                DataCell(Text('')),
            ]);
          }).toList(),
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

  Widget _buildDataCellText(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.black87,
      ),
    );
  }

  List<String> _getStatus(Map<String, dynamic> application) {
    List<String> statuses = [];

    if (application['APPROVED_BY2'] != null) {
      if (application['APPROVED_BY2'] == 'Rejected') {
        statuses.add('Rejected');
        statuses.add('');
        statuses.add('');
        if (application['REJECTION_REASON'] != null) {
          statuses.add(application['REJECTION_REASON'].toString());
        } else {
          statuses.add('');
        }
      } else {
        statuses.add(application['APPROVED_BY2'].toString());
        if (application['APPROVED_BY3'] != null) {
          if (application['APPROVED_BY3'] == 'Rejected') {
            statuses.add('Rejected');
            statuses.add('');
          } else {
            statuses.add(application['APPROVED_BY3'].toString());
            _addHRStatus(statuses, application['APPROVED_BYHR']);
          }
        } else {
          statuses.add('Pending');
          statuses.add('Pending');
        }
      }
    } else {
      statuses.add('Pending');
      statuses.add('Pending');
      statuses.add('Pending');
    }

    return statuses;
  }

  void _addHRStatus(List<String> statuses, dynamic approvedByHR) {
    if (approvedByHR != null) {
      if (approvedByHR == 'Rejected') {
        statuses.add('Rejected');
      } else {
        statuses.add(approvedByHR.toString());
      }
    } else {
      statuses.add('Pending');
    }
  }
}
class Designation {
  final int id;
  final String name;
  final String probationPeriod;

  Designation({
    required this.id,
    required this.name,
    required this.probationPeriod,
  });

  factory Designation.fromJson(Map<String, dynamic> json) {
    return Designation(
      id: json['DESIGNATION_ID'],
      name: json['DESIGNATION_NAME'],
      probationPeriod: json['PROBATION'],
    );
  }
}
Future<Designation?> fetchDesignationById(int designationId) async {
  final response = await http.get(Uri.parse('http://192.168.1.34:3000/api/managedes'));

  if (response.statusCode == 200) {
    List<dynamic> designations = json.decode(response.body);

    for (var designation in designations) {
      if (designation['DESIGNATION_ID'] == designationId) {
        return Designation.fromJson(designation);
      }
    }
  } else {
    throw Exception('Failed to load designation');
  }

  return null; // Return null if the designation is not found
}



class LeaveBalanceWidget extends StatelessWidget {
  final String employeeId;
  final String employeeName;
  final DateTime dateOfJoining;
  final int designationId;
  final Map<String, String> leaveTypeMap;
  final List<Map<String, dynamic>> leaveApplications;

  LeaveBalanceWidget({
    required this.employeeId,
    required this.employeeName,
    required this.dateOfJoining,
    required this.designationId,
    required this.leaveTypeMap,
    required this.leaveApplications,
  });

  @override
  Widget build(BuildContext context) {
    // Filter leave applications for the current employee
    List<Map<String, dynamic>> filteredLeaveApplications = leaveApplications
        .where((application) => application['EMPLOYEE_ID'].toString() == employeeId)
        .toList();

    return FutureBuilder<Designation?>(
      future: fetchDesignationById(designationId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: Text('No designation found'));
        } else {
          final designation = snapshot.data!;
          return Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildEmployeeDetails(designation.probationPeriod),
                  SizedBox(height: 20),
                  Text(
                    'Leave Balance',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildLeaveBalanceTable(filteredLeaveApplications),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildEmployeeDetails(String probationPeriod) {
    final probationEndDate = _calculateProbationEndDate(dateOfJoining, int.tryParse(probationPeriod) ?? 6);
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.blueAccent),
      ),
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow(Icons.person, 'Employee ID: $employeeId'),
          _buildDetailRow(Icons.person_outline, 'Employee Name: $employeeName'),
          _buildDetailRow(Icons.calendar_today, 'Date of Joining: ${_formatDate(dateOfJoining)}'),
          _buildDetailRow(Icons.schedule, 'Probation Period: $probationPeriod Months'),
          _buildDetailRow(Icons.event, 'Probation End Date: ${_formatDate(probationEndDate)}'),
        ],
      ),
    );
  }

 DateTime _calculateProbationEndDate(DateTime startDate, int months) {
    int year = startDate.year;
    int month = startDate.month + months;
    while (month > 12) {
      month -= 12;
      year++;
    }
    return DateTime(year, month, startDate.day);
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent),
          SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(date);
  }

 Widget _buildLeaveBalanceTable(List<Map<String, dynamic>> filteredLeaveApplications) {
  // Sort the leave applications by the application date in descending order
  filteredLeaveApplications.sort((a, b) => b['DATE_OF_APPLICATION'].compareTo(a['DATE_OF_APPLICATION']));

  return Card(
    elevation: 4,
    margin: EdgeInsets.zero,
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 32,
        headingRowColor:
            MaterialStateColor.resolveWith((states) => Colors.grey[200]!), // Grey background for header
        dataRowColor:
            MaterialStateColor.resolveWith((states) => Colors.white), // White background for data rows
        columns: [
          DataColumn(label: _buildDataColumnText('Application Date')),
          DataColumn(label: _buildDataColumnText('Leave Type')),
          DataColumn(label: _buildDataColumnText('Number of Days')),
          DataColumn(label: _buildDataColumnText('Total Leave Balance')),
          DataColumn(label: _buildDataColumnText('Monthly Leave Balance')),
        ],
        rows: filteredLeaveApplications.map((application) {
          final leaveTypeId = application['LEAVE_TYPE_ID'].toString();
          final leaveName = leaveTypeMap[leaveTypeId] ?? 'Unknown';
          return DataRow(cells: [
            DataCell(_buildDataCellText(application['DATE_OF_APPLICATION'].toString())),
            DataCell(_buildDataCellText(leaveName)),
            DataCell(_buildDataCellText(application['NUMBER_OF_DAYS'].toString())),
            DataCell(_buildDataCellText(application['LEAVE_BAL'].toString())),
            DataCell(_buildDataCellText(
              (leaveName == 'LOP' && application['MONTHLY_LEAVE_BALANCE'] == 0) ? '' : application['MONTHLY_LEAVE_BALANCE'].toString(),
            )),
          ]);
        }).toList(),
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

  Widget _buildDataCellText(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.black87,
      ),
    );
  }
}

class SalarySlipWidget extends StatefulWidget {
  final Map<String, dynamic> salaryDetails;
  final Map<String, dynamic> employeeDetails;
  final Function fetchSalaryDetailsAndGenerateSlip; // Define a Function parameter

  SalarySlipWidget(
      {required this.salaryDetails,
      required this.employeeDetails,
      required this.fetchSalaryDetailsAndGenerateSlip});

  @override
  _SalarySlipWidgetState createState() => _SalarySlipWidgetState();
}

class _SalarySlipWidgetState extends State<SalarySlipWidget> {
  late String _selectedMonth;
  late int _selectedYear;

  @override
  void initState() {
    super.initState();
    // Set initial values for month and year
    _selectedMonth = DateFormat('MMMM').format(DateTime.now());
    _selectedYear = DateTime.now().year;
  }

  void callFetchSalaryDetailsAndGenerateSlip() {
    widget.fetchSalaryDetailsAndGenerateSlip(
        context, _selectedMonth, _selectedYear);
  }

  @override
  Widget build(BuildContext context) {
    // Define a list of months
    List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    // Define a list of years, you can adjust the range according to your requirements
    List<int> years = List.generate(10, (index) => DateTime.now().year - index);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(
            top: 20, left: 20), // Add padding to position the dropdown menu
        child: Align(
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'View Payslip',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Dropdown menu for selecting month and year
              Row(
                children: [
                  DropdownButton<String>(
                    value: _selectedMonth,
                    items: months.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedMonth = newValue!;
                        callFetchSalaryDetailsAndGenerateSlip();
                      });
                    },
                  ),
                  SizedBox(width: 16),
                  DropdownButton<int>(
                    value: _selectedYear,
                    items: years.map((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(value.toString()),
                      );
                    }).toList(),
                    onChanged: (int? newValue) {
                      setState(() {
                        _selectedYear = newValue!;
                        callFetchSalaryDetailsAndGenerateSlip();
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 16), // Add space between dropdown menu and ELMS text
              SizedBox(
                width: 600,
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Logo widget with adjusted left padding
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 100), // Adjusted padding for the logo
                            child: Container(
                              width: 90, // Adjust the width as needed
                              height: 90, // Adjust the height as needed
                              // Replace the placeholder AssetImage with your actual logo asset
                              child: Image.asset('lib/assets/company_logo.png'),
                            ),
                          ),
                          SizedBox(width: 16),
                          // ELMS text with padding
                          Padding(
                            padding: const EdgeInsets.only(right: 180),
                            child: Text(
                              'ELMS',
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        '123 ABStreet',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      SizedBox(height: 16), // Add space before the Pay Slip heading
                      Text(
                        'Pay Slip for the Month $_selectedMonth $_selectedYear',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16), // Add space before the rest of the content
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmployeeRow(String label) {
    String? value;

    switch (label) {
      case 'Employee ID':
        value = widget.employeeDetails['employee_id'];
        break;
      case 'Employee Name':
        String fullName = widget.employeeDetails['employee_name'] ?? '';
        value = fullName.isNotEmpty ? fullName : 'Unknown';
        break;
      case 'Department':
        value = widget.employeeDetails['dept_name'];
        break;
      case 'Designation':
        value = widget.employeeDetails['designation_name'];
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
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(0.10),  // Adjust the width of the divider as needed
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
                    child: Center(child: VerticalDivider(color: Colors.grey)),  // Vertical divider here
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
                        _buildRow('Basic Pay', widget.salaryDetails['basic_pay']),
                        _buildRow('HRA', widget.salaryDetails['hra']),
                        _buildRow('DA', widget.salaryDetails['da']),
                        _buildRow('Other Allowance', widget.salaryDetails['other_allowance']),
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
                        _buildRow('Provident Fund', widget.salaryDetails['provident_fund']),
                        _buildRow('Professional Tax', widget.salaryDetails['professional_tax']),
                        _buildRow('Leave', widget.salaryDetails['leave_deduction']),
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
        SizedBox(height: 40),  // Add some space between the table and the net salary heading
        Text(
 widget.salaryDetails['net_salary'] != null
      ? 'Net Salary: Rupees${convertNumberToWords(int.parse(widget.salaryDetails['net_salary']))}'
      : 'Net Salary: Rupees (Not Available)',          
      style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,  // You can change the color to your preference
          ),
        ),
        SizedBox(height: 40),
      ],
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
    double basicPay = _parseDouble(widget.salaryDetails['basic_pay']);
    double hra = _parseDouble(widget.salaryDetails['hra']);
    double da = _parseDouble(widget.salaryDetails['da']);
    double otherAllowance = _parseDouble(widget.salaryDetails['other_allowance']);
    return basicPay + hra + da + otherAllowance;
  }

  double _calculateGrossDeductions() {
    double providentFund = _parseDouble(widget.salaryDetails['provident_fund']);
    double professionalTax = _parseDouble(widget.salaryDetails['professional_tax']);
    double leaveDeduction = _parseDouble(widget.salaryDetails['leave_deduction']);
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

