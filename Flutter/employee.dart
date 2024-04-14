import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';



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
   List<Map<String, dynamic>> _leaveApplications = []; // Store fetched leave applications
   Map<String, String> _leaveTypeMap = {}; 
   Map<String, dynamic> _salaryDetails = {};
   Map<String, dynamic> _employeeDetails = {};
  
 
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
                            });
                            _fetchSalaryDetailsAndGenerateSlip(context);
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
    ? LeaveStatusWidget(leaveApplications: _leaveApplications, employeeId: widget.employeeDetails?[getColumnIndex('EMPLOYEE_ID')] ?? '', leaveTypeMap: _leaveTypeMap,) // Pass _leaveApplications here
     : _isSalarySlipVisible
              ? SalarySlipWidget(
                  salaryDetails: _salaryDetails,
                  employeeDetails: _employeeDetails,
                )
    : _buildProfileDetails(),

              ),
            ),
          ),
        ],
      ),
      
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
              icon: Icons.account_circle_outlined,
              label: 'Username',
              detail: widget.employeeDetails![getColumnIndex('USERNAME')],
            ),
          ],
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildDetailRow(
              icon: Icons.calendar_today_outlined,
              label: 'Age',
              detail: widget.employeeDetails![getColumnIndex('AGE')],
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


Widget _buildLeaveStatusTable() {
  return LeaveStatusWidget(leaveApplications: _leaveApplications, employeeId: widget.employeeDetails?[getColumnIndex('EMPLOYEE_ID')] ?? '', leaveTypeMap: _leaveTypeMap, );
}


Future<List<Map<String, dynamic>>> _fetchLeaveApplications(String employeeId) async {
  try {
    final response = await http.get(
      Uri.parse('http://192.168.1.7:3000/api/leavestatus/$employeeId'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> parsedResponse = json.decode(response.body);
      print('Fetched leave applications: $parsedResponse'); // Add this line to check the fetched data
      return parsedResponse.cast<Map<String, dynamic>>();
    } else {
      print('Failed to fetch leave applications: ${response.statusCode}');
      return []; // Return an empty list in case of failure
    }
  } catch (e) {
    print('Error fetching leave applications: $e');
    return []; // Return an empty list in case of error
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
void _fetchSalaryDetailsAndGenerateSlip(BuildContext context) async {
  try {
    String employeeId = widget.employeeDetails?[getColumnIndex('EMPLOYEE_ID')] ?? '';
    await _fetchLeaveApplications(employeeId); // Fetch leave applications for the employee
    await _fetchSalaryDetails(context, employeeId); // Pass 'context' and 'employeeId' to fetch salary details
    // showDialog is moved to _fetchSalaryDetails, so it's called after _salaryDetails is populated
  } catch (e) {
    print('Error fetching salary details and generating slip: $e');
    // Handle error (e.g., show error message)
  }
}
Future<void> _fetchSalaryDetails(BuildContext context, String employeeId) async {
  try {
    // Fetch salary details
    final salaryResponse = await http.get(
      Uri.parse('http://192.168.1.7:3000/api/managesal/$employeeId'),
    );

    // Fetch employee details
    final employeeResponse = await http.get(
      Uri.parse('http://192.168.1.7:3000/api/employee/$employeeId'),
    );

    // Fetch total leave days
    final leaveResponse = await http.get(
      Uri.parse('http://192.168.1.7:3000/api/leave-summary?employeeId=$employeeId'),
    );

    if (salaryResponse.statusCode == 200 && employeeResponse.statusCode == 200 && leaveResponse.statusCode == 200) {
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
        _salaryDetails = {
          ...salaryDetails,
          'salary_per_day': salaryPerDay.toStringAsFixed(2), // Add salary per day to the salary details
          'total_leave_days': totalLeaveDays.toString(), // Add total leave days to the salary details
          'total_work_days': totalWorkDays.toString(), // Add total work days to the salary details
          'net_salary': netSalary.toStringAsFixed(2), // Add net salary to the salary details
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
                          endDateController.text ="${endDate!.day.toString().padLeft(2, '0')}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.year}";
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
                          final DateFormat dateFormat = DateFormat('yyyy-MM-dd'); // Define the date format expected by Oracle
                          final String formattedStartDate = startDate != null ? dateFormat.format(startDate!) : ''; // Format the start date
                          final String formattedEndDate = endDate != null ? dateFormat.format(endDate!) : ''; // Format the end date
                          final String formattedApplicationDate = dateFormat.format(applicationDate);

                          final String serverUrl = 'http://192.168.1.7:3000/api/leaveapp';
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
  Navigator.of(context).pop();
} else if (response.statusCode == 400) {
  final responseData = json.decode(response.body);
  final errorMessage = responseData['error'];

  if (_selectedLeaveType != 'LOP' && int.parse(numberOfDaysController.text) > 1) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Leave Exceeds Limit'),
          content: Text('Only one day can be applied for this leave type.'),
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
  } else if (_selectedLeaveType != 'LOP' && errorMessage.contains('Leave already taken')) {
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
    // For LOP or other types of leave application errors
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
      Uri.parse('http://192.168.1.7:3000/api/leavebalance/${widget.employeeDetails?[getColumnIndex('EMPLOYEE_ID')]}/$leaveType'),
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

// Function to fetch leave type ID
Future<String?> _fetchLeaveTypeId(String leaveName) async {
  try {
    final response = await http.get(
      Uri.parse('http://192.168.1.7:3000/api/manageleave?name=$leaveName'),
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
    List<Map<String, dynamic>> filteredLeaveApplications =
        leaveApplications.where((application) => application['EMPLOYEE_ID'].toString() == employeeId).toList();

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

class SalarySlipWidget extends StatefulWidget {
  final Map<String, dynamic> salaryDetails;
  final Map<String, dynamic> employeeDetails;

  SalarySlipWidget({required this.salaryDetails, required this.employeeDetails});

  @override
  _SalarySlipWidgetState createState() => _SalarySlipWidgetState();
}

class _SalarySlipWidgetState extends State<SalarySlipWidget> {

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
          crossAxisAlignment: CrossAxisAlignment.center,  // Centering text
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
           SizedBox(height: 32),  // Increased space between company address and payslip date
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
            ],
          ),
        ),
        SizedBox(height: 40),  // Add some space between the table and the net salary heading
        Text(
          'Net Salary: ${widget.salaryDetails['net_salary']}',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,  // You can change the color to your preference
          ),
        ),
      ],
    );
  }
}
