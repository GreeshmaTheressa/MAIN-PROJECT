// Import required modules
const express = require('express');
const oracledb = require('oracledb');
const bodyParser = require('body-parser');
const cors = require('cors')

// Create Express app
const app = express();
const port = 3000;

// Middleware
app.use(cors())
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// Oracle Database connection configuration
const dbConfig = {
  user: 'PROJECT1',
  password: 'project123',
  connectString: 'ORCL',
};

app.post('/api/login1', async (req, res) => {
  console.log('Received POST request at /api/login');
  const { username,password } = req.body;

  try {
    // Connect to Oracle Database
    const connection = await oracledb.getConnection(dbConfig);
    console.log('Connected to Oracle Database');

    // Execute the insert query
    const result = await connection.execute(
      'INSERT INTO login (username,password) VALUES (:username,:password)',
      [username,password]
    );
    console.log('Query executed successfully:', result);

    // Commit the transaction
    await connection.commit();
    console.log('Transaction committed successfully');

    // Release the connection
   // await connection.close();
   // console.log('Connection closed successfully');

    // Send a success response
    res.status(200).json({ message: 'Data inserted successfully!' });
  } catch (error) {
    console.error('Error:', error);

    // Send an error response
    res.status(500).json({ error: 'Internal Server Error' });
  }
});


// Route to handle form submission with image
app.post('/api/post1', async (req, res) => {
  console.log('Received POST request at /api/post1');
  const { COMPANY_ID, COMPANY_NAME, ADDRESS1, ADDRESS2, ADDRESS3, WEBSITE, MAILID, PHNO, COUNTRY_CODE } = req.body;

  try {
    // Connect to Oracle Database
    const connection = await oracledb.getConnection(dbConfig);
    console.log('Connected to Oracle Database');

    // Execute the insert query
    const result = await connection.execute(
      `INSERT INTO company (COMPANY_ID, COMPANY_NAME, ADDRESS1, ADDRESS2, ADDRESS3, WEBSITE, MAILID, PHNO, COUNTRY_CODE) 
      VALUES (:COMPANY_ID, :COMPANY_NAME, :ADDRESS1, :ADDRESS2, :ADDRESS3, :WEBSITE, :MAILID, :PHNO, :COUNTRY_CODE)`,
      [
        COMPANY_ID,
        COMPANY_NAME,
        ADDRESS1,
        ADDRESS2,
        ADDRESS3,
        WEBSITE,
        MAILID,
        PHNO,
        COUNTRY_CODE,
      ]
    );

    // Commit the transaction
    await connection.commit();
    console.log('Transaction committed successfully');

    // Release the connection
    await connection.close();
    console.log('Connection closed successfully');

    // Send a success response
    res.status(200).json({ message: 'Data inserted successfully!' });
  } catch (error) {
    console.error('Error:', error);

    // Send an error response
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

// Route to retrieve company details by ID
// Route to retrieve company details by ID
app.get('/api/company/:companyId', async (req, res) => {
  console.log('Received GET request at /api/company/:companyId');
  const companyId = req.params.companyId;

  try {
    // Connect to Oracle Database
    const connection = await oracledb.getConnection(dbConfig);
    console.log('Connected to Oracle Database');

    // Execute the query to retrieve company details by ID
    const result = await connection.execute(
      'SELECT * FROM company WHERE COMPANY_ID = :companyId',
      [companyId]
    );

    // Release the connection
    await connection.close();
    console.log('Connection closed successfully');

    if (result.rows.length > 0) {
      // Construct JSON response with column names and values
      const companyDetails = {};
      const columnNames = result.metaData.map(column => column.name);
      const row = result.rows[0];
      columnNames.forEach((columnName, index) => {
        companyDetails[columnName] = row[index];
      });

      // Send company details as JSON response
      res.status(200).json(companyDetails);
    } else {
      res.status(404).json({ error: 'Company not found' });
    }
  } catch (error) {
    console.error('Error:', error);

    // Send an error response
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

app.put('/api/update_company/:companyId', async (req, res) => {
  console.log('Received PUT request at /api/update_company/:companyId');
  
  const companyId = req.params.companyId;
  const {
    COMPANY_NAME,
    ADDRESS1,
    ADDRESS2,
    ADDRESS3,
    WEBSITE,
    MAILID,
    PHNO,
    COUNTRY_CODE
  } = req.body;

  try {
    const connection = await oracledb.getConnection(dbConfig);
    console.log('Connected to Oracle Database');

    const result = await connection.execute(
      `UPDATE company 
       SET COMPANY_NAME = :COMPANY_NAME,
           ADDRESS1 = :ADDRESS1,
           ADDRESS2 = :ADDRESS2,
           ADDRESS3 = :ADDRESS3,
           WEBSITE = :WEBSITE,
           MAILID = :MAILID,
           PHNO = :PHNO,
           COUNTRY_CODE = :COUNTRY_CODE
       WHERE COMPANY_ID = :COMPANY_ID`,
      {
        COMPANY_NAME,
        ADDRESS1,
        ADDRESS2,
        ADDRESS3,
        WEBSITE,
        MAILID,
        PHNO,
        COUNTRY_CODE,
        COMPANY_ID: companyId // Use the companyId from the URL parameter
      }
    );

    await connection.commit();
    console.log('Transaction committed successfully');

    await connection.close();
    console.log('Connection closed successfully');

    res.status(200).json({ message: 'Company details updated successfully!' });
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

app.post('/api/dep', async (req, res) => {
  console.log('Received POST request at /api/dep');
  const { DEPT_SHORT_NAME,DEPT_NAME } = req.body;

  try {
    // Connect to Oracle Database
    const connection = await oracledb.getConnection(dbConfig);
    console.log('Connected to Oracle Database');

    // Execute the insert query
    const result = await connection.execute(
      'INSERT INTO dept (DEPT_SHORT_NAME,DEPT_NAME) VALUES (:DEPT_SHORT_NAME,:DEPT_NAME)',
      [DEPT_SHORT_NAME,DEPT_NAME]
    );
    console.log('Query executed successfully:', result);

    // Commit the transaction
    await connection.commit();
    console.log('Transaction committed successfully');

    // Release the connection
   // await connection.close();
   // console.log('Connection closed successfully');

    // Send a success response
    res.status(200).json({ message: 'Data inserted successfully!' });
  } catch (error) {
    console.error('Error:', error);

    // Send an error response
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

app.get('/api/managedept', async (req, res) => {
  console.log('Received GET request at /api/managedept');

  try {
    // Connect to Oracle Database
    const connection = await oracledb.getConnection(dbConfig);
    console.log('Connected to Oracle Database');

    // Execute the query to retrieve all company details
    const result = await connection.execute(
      'SELECT * FROM dept'
    );

    // Release the connection
    await connection.close();
    console.log('Connection closed successfully');

    if (result.rows.length > 0) {
      // Construct JSON response with array of company details
      const managedept = result.rows.map(row => {
        const deptDetails = {};
        result.metaData.forEach((column, index) => {
          deptDetails[column.name] = row[index];
        });
        return deptDetails;
      });

      // Send company details as JSON response
      res.status(200).json(managedept);
    } else {
      res.status(404).json({ error: 'No department found' });
    }
  } catch (error) {
    console.error('Error:', error);

    // Send an error response
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

app.post('/api/des', async (req, res) => {
  console.log('Received POST request at /api/des');
  const { DESIGNATION_NAME,DESIGNATION_DESC} = req.body;

  try {
    // Connect to Oracle Database
    const connection = await oracledb.getConnection(dbConfig);
    console.log('Connected to Oracle Database');

    // Execute the insert query
    const result = await connection.execute(
      'INSERT INTO designation (DESIGNATION_NAME,DESIGNATION_DESC) VALUES (:DESIGNATION_NAME,:DESIGNATION_DESC)',
      [DESIGNATION_NAME,DESIGNATION_DESC]
    );
    console.log('Query executed successfully:', result);

    // Commit the transaction
    await connection.commit();
    console.log('Transaction committed successfully');

    // Release the connection
   // await connection.close();
   // console.log('Connection closed successfully');

    // Send a success response
    res.status(200).json({ message: 'Data inserted successfully!' });
  } catch (error) {
    console.error('Error:', error);

    // Send an error response
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

app.get('/api/managedes', async (req, res) => {
  console.log('Received GET request at /api/managedes');

  try {
    // Connect to Oracle Database
    const connection = await oracledb.getConnection(dbConfig);
    console.log('Connected to Oracle Database');

    // Execute the query to retrieve all company details
    const result = await connection.execute(
      'SELECT * FROM designation'
    );

    // Release the connection
    await connection.close();
    console.log('Connection closed successfully');

    if (result.rows.length > 0) {
      // Construct JSON response with array of company details
      const managedes = result.rows.map(row => {
        const desDetails = {};
        result.metaData.forEach((column, index) => {
          desDetails[column.name] = row[index];
        });
        return desDetails;
      });

      // Send company details as JSON response
      res.status(200).json(managedes);
    } else {
      res.status(404).json({ error: 'No designation found' });
    }
  } catch (error) {
    console.error('Error:', error);

    // Send an error response
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

// Route to delete a department by ID
/*app.delete('/api/deletedept/:dept_id', async (req, res) => {
  const departmentId = req.params.dept_id;
  
  try {
    const connection = await oracledb.getConnection(dbConfig);
    const result = await connection.execute(
      `DELETE FROM dept WHERE dept_id = :dept_id`, [Number(departmentId)]
    );
    await connection.commit();
    await connection.close();
    
    res.status(200).json({ message: 'Department deleted successfully' });
  } catch (error) {
    console.error("Error deleting department:", error);
    res.status(500).json({ error: 'An error occurred while deleting the department' });
  }
});
*/
app.post('/api/employees', async (req, res) => {
  console.log('Received POST request at /api/employees');
  const { first_name, middle_name, last_name, age, gender, email, phno, username, password, dept_id, designation_id } = req.body;

  try {
    // Connect to Oracle Database
    const connection = await oracledb.getConnection(dbConfig);
    console.log('Connected to Oracle Database');

    // Execute the insert query
    const result = await connection.execute(
      'INSERT INTO employee (first_name, middle_name, last_name, age, gender, email, phno, username, password, dept_id, designation_id) ' +
      'VALUES (:first_name, :middle_name, :last_name, :age, :gender, :email, :phno, :username, :password, :dept_id, :designation_id)',
      [first_name, middle_name, last_name, age, gender, email, phno, username, password, dept_id, designation_id]
    );
    console.log('Query executed successfully:', result);

    // Commit the transaction
    await connection.commit();
    console.log('Transaction committed successfully');

    // Release the connection
    // await connection.close();
    // console.log('Connection closed successfully');

    // Send a success response
    res.status(200).json({ message: 'Data inserted successfully!' });
  } catch (error) {
    console.error('Error:', error);

    // Send an error response
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

app.get('/api/manageemp/:username/:password', async (req, res) => {
  console.log('Received GET request at /api/manageemp/:username/:password');

  const { username, password } = req.params;

  try {
    // Connect to Oracle Database
    const connection = await oracledb.getConnection(dbConfig);
    console.log('Connected to Oracle Database');

    // Execute the query to retrieve employee details along with department and designation names
    const result = await connection.execute(
      `SELECT e.*, d.DEPT_SHORT_NAME, des.DESIGNATION_NAME 
      FROM employee e 
      INNER JOIN dept d ON e.DEPT_ID = d.DEPT_ID
      INNER JOIN designation des ON e.DESIGNATION_ID = des.DESIGNATION_ID
      WHERE e.USERNAME = :username AND e.PASSWORD = :password`,
      { username, password }
    );

    // Release the connection
    await connection.close();
    console.log('Connection closed successfully');

    if (result.rows.length > 0) {
      // Construct JSON response with employee details
      const employeeDetails = {};
      result.metaData.forEach((column, index) => {
        employeeDetails[column.name] = result.rows[0][index];
      });

      // Send employee details as JSON response
      res.status(200).json(employeeDetails);
    } else {
      res.status(404).json({ error: 'Employee not found' });
    }
  } catch (error) {
    console.error('Error:', error);

    // Send an error response
    res.status(500).json({ error: 'Internal Server Error' });
  }
});


app.get('/api/manageemp', async (req, res) => {
  console.log('Received GET request at /api/manageemp');

  try {
    // Connect to Oracle Database
    const connection = await oracledb.getConnection(dbConfig);
    console.log('Connected to Oracle Database');

    // Execute the query to retrieve employee details along with department and designation names
    const result = await connection.execute(
      `SELECT e.*, d.DEPT_SHORT_NAME, des.DESIGNATION_NAME 
      FROM employee e 
      INNER JOIN dept d ON e.DEPT_ID = d.DEPT_ID
      INNER JOIN designation des ON e.DESIGNATION_ID = des.DESIGNATION_ID`
    );

    // Release the connection
    await connection.close();
    console.log('Connection closed successfully');

    if (result.rows.length > 0) {
      // Construct JSON response with array of employee details including department and designation names
      const manageemp = result.rows.map(row => {
        const empDetails = {};
        result.metaData.forEach((column, index) => {
          empDetails[column.name] = row[index];
        });
        return empDetails;
      });

      // Send employee details as JSON response
      res.status(200).json(manageemp);
    } else {
      res.status(404).json({ error: 'No employee found' });
    }
  } catch (error) {
    console.error('Error:', error);

    // Send an error response
    res.status(500).json({ error: 'Internal Server Error' });
  }
});


// Endpoint to fetch department name by ID
app.get('/api/department/:id', async (req, res) => {
  const departmentId = req.params.id;

  try {
    // Connect to Oracle Database
    const connection = await oracledb.getConnection(dbConfig);

    // Execute the query to retrieve department name by ID
    const result = await connection.execute(
      'SELECT DEPT_SHORT_NAME FROM dept WHERE DEPT_ID = :id',
      [departmentId]
    );

    // Release the connection
    await connection.close();

    if (result.rows.length > 0) {
      // Send department name as JSON response
      res.status(200).json({ DEPT_SHORT_NAME: result.rows[0][0] });
    } else {
      res.status(404).json({ error: 'Department not found' });
    }
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

// Endpoint to fetch designation name by ID
app.get('/api/designation/:id', async (req, res) => {
  const designationId = req.params.id;

  try {
    // Connect to Oracle Database
    const connection = await oracledb.getConnection(dbConfig);

    // Execute the query to retrieve designation name by ID
    const result = await connection.execute(
      'SELECT DESIGNATION_NAME FROM designation WHERE DESIGNATION_ID = :id',
      [designationId]
    );

    // Release the connection
    await connection.close();

    if (result.rows.length > 0) {
      // Send designation name as JSON response
      res.status(200).json({ DESIGNATION_NAME: result.rows[0][0] });
    } else {
      res.status(404).json({ error: 'Designation not found' });
    }
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});


app.post('/api/login', async (req, res) => {
  const { username, password } = req.body;

  try {
    // Connect to the Oracle database
    const connection = await oracledb.getConnection(dbConfig);

    // Execute the query to authenticate the user
    const result = await connection.execute(
      `SELECT * FROM users WHERE username = :username AND password = :password`,
      [username, password]
    );

    // Check if the user exists
    if (result.rows.length > 0) {
      // User authenticated successfully
      const userData = {
        username: result.rows[0][0],
        email: result.rows[0][1],
        userType: result.rows[0][2] // Assuming userType is stored in the third column
      };
      res.json(userData);
    } else {
      // User not found or invalid password
      res.status(404).json({ message: 'User not found or invalid password' });
    }

    // Release the Oracle database connection
    await connection.close();
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({ message: 'Internal server error' });
  }
});





app.get('/api/employee/:uname/:password', async (req, res) => {
  try {
    console.log('Received GET request at /api/employee/:uname/:password');
    const { uname, password } = req.params;

    // Connect to Oracle Database
    const connection = await oracledb.getConnection(dbConfig);
    console.log('Connected to Oracle Database');

    // Execute the query to retrieve employee details by username
    const result = await connection.execute(
      'SELECT * FROM employee WHERE USERNAME = :uname AND PASSWORD = :password',
      { uname, password }
    );

    // Release the connection
    await connection.close();
    console.log('Connection closed successfully');

    if (result.rows.length > 0) {
      // Construct JSON response with column names and values
      const employeeDetails = {};
      const columnNames = result.metaData.map(column => column.name);
      const row = result.rows[0];
      columnNames.forEach((columnName, index) => {
        employeeDetails[columnName] = row[index];
      });

      // Send employee details as JSON response
      res.status(200).json(employeeDetails);
    } else {
      res.status(404).json({ error: 'Employee not found' });
    }
  } catch (error) {
    console.error('Error:', error);

    // Send an error response
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

app.get('/api/user/:uname/:password', async (req, res) => {
  try {
    console.log('Received GET request at /api/user/:uname/:password');
    const { uname, password } = req.params;

    // Connect to Oracle Database
    const connection = await oracledb.getConnection(dbConfig);
    console.log('Connected to Oracle Database');

    // Execute the query to authenticate user
    const result = await connection.execute(
      'SELECT * FROM users WHERE USERNAME = :uname AND PASSWORD = :password',
      { uname, password }
    );

    // Release the connection
    await connection.close();
    console.log('Connection closed successfully');

    if (result.rows.length > 0) {
      // Construct JSON response with user details
      const user = result.rows[0];

      // Send user details as JSON response
      res.status(200).json({
        user_id: user[0],
        username: user[1],
        email: user[3],
        category: user[4],
        name: user[5]
      });
    } else {
      // Send 404 error if user not found or invalid credentials
      res.status(404).json({ error: 'User not found or invalid credentials' });
    }
  } catch (error) {
    console.error('Error:', error);

    // Send 500 error for any internal server errors
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

app.get('/api/users/:uname', async (req, res) => {
  try {
    console.log('Received GET request at /api/users/:uname');
    const uname = req.params.uname;

    // Connect to Oracle Database
    const connection = await oracledb.getConnection(dbConfig);
    console.log('Connected to Oracle Database');

    // Execute the query to retrieve employee details by username
    const result = await connection.execute(
      'SELECT * FROM users WHERE USER_ID = :uname',
      [uname]
    );

    // Release the connection
    await connection.close();
    console.log('Connection closed successfully');

    if (result.rows.length > 0) {
      // Construct JSON response with column names and values
      const userDetails = {};
      const columnNames = result.metaData.map(column => column.name);
      const row = result.rows[0];
      columnNames.forEach((columnName, index) => {
        userDetails[columnName] = row[index];
      });

      // Send employee details as JSON response
      res.status(200).json(userDetails);
    } else {
      res.status(404).json({ error: 'User not found' });
    }
  } catch (error) {
    console.error('Error:', error);

    // Send an error response
    res.status(500).json({ error: 'Internal Server Error' });
  }
});


app.get('/api/emp/:uname', async (req, res) => {
  try {
    console.log('Received GET request at /api/emp/:uname');
    const uname = req.params.uname;

    // Connect to Oracle Database
    const connection = await oracledb.getConnection(dbConfig);
    console.log('Connected to Oracle Database');

    // Execute the query to retrieve employee details by username
    const result = await connection.execute(
      'SELECT * FROM employee WHERE EMPLOYEE_ID = :uname',
      [uname]
    );

    // Release the connection
    await connection.close();
    console.log('Connection closed successfully');

    if (result.rows.length > 0) {
      // Construct JSON response with column names and values
      const employeeDetails = {};
      const columnNames = result.metaData.map(column => column.name);
      const row = result.rows[0];
      columnNames.forEach((columnName, index) => {
        employeeDetails[columnName] = row[index];
      });

      // Send employee details as JSON response
      res.status(200).json(employeeDetails);
    } else {
      res.status(404).json({ error: 'User not found' });
    }
  } catch (error) {
    console.error('Error:', error);

    // Send an error response
    res.status(500).json({ error: 'Internal Server Error' });
  }
});



app.post('/api/leave', async (req, res) => {
  console.log('Received POST request at /api/leave');
  const { leave_name, leave_description, number_days_allowed } = req.body;

  try {
    // Connect to Oracle Database
    const connection = await oracledb.getConnection(dbConfig);
    console.log('Connected to Oracle Database');

    // Execute the insert query
    const result = await connection.execute(
      'INSERT INTO leave_type (leave_name, leave_description, number_days_allowed) ' +
      'VALUES (:leave_name, :leave_description, :number_days_allowed)',
      [leave_name, leave_description, number_days_allowed]
    );
    console.log('Query executed successfully:', result);

    // Commit the transaction
    await connection.commit();
    console.log('Transaction committed successfully');

    // Release the connection
    // await connection.close();
    // console.log('Connection closed successfully');

    // Send a success response
    res.status(200).json({ message: 'Data inserted successfully!' });
  } catch (error) {
    console.error('Error:', error);

    // Send an error response
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

app.get('/api/manageleave', async (req, res) => {
  console.log('Received GET request at /api/manageleave');

  try {
    // Connect to Oracle Database
    const connection = await oracledb.getConnection(dbConfig);
    console.log('Connected to Oracle Database');

    // Execute the query to retrieve all company details
    const result = await connection.execute(
      'SELECT * FROM leave_type'
    );

    // Log the retrieved rows and metadata
    console.log('Retrieved rows:', result.rows);
    console.log('Metadata:', result.metaData);

    // Release the connection
    await connection.close();
    console.log('Connection closed successfully');

    if (result.rows.length > 0) {
      // Construct JSON response with array of company details
      const manageleave = result.rows.map(row => {
        const leaveDetails = {};
        result.metaData.forEach((column, index) => {
          leaveDetails[column.name] = row[index];
        });
        return leaveDetails;
      });
      console.log('Manage Leave:', manageleave);
      // Send company details as JSON response
      res.status(200).json(manageleave);
    } else {
      res.status(404).json({ error: 'No leave found' });
    }
  } catch (error) {
    console.error('Error:', error);

    // Send an error response
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

app.get('/api/leave-type/:id', async (req, res) => {
  try {
    console.log('Received GET request at /api/leave-type/:id');
    const id = req.params.id;

    // Connect to Oracle Database
    const connection = await oracledb.getConnection(dbConfig);
    console.log('Connected to Oracle Database');

    // Execute the query to retrieve employee details by username
    const result = await connection.execute(
      'SELECT * FROM leave_type WHERE LEAVE_TYPE_ID = :id',
      [id]
    );

    // Release the connection
    await connection.close();
    console.log('Connection closed successfully');

    if (result.rows.length > 0) {
      // Construct JSON response with column names and values
      const leaveDetails = {};
      const columnNames = result.metaData.map(column => column.name);
      const row = result.rows[0];
      columnNames.forEach((columnName, index) => {
        leaveDetails[columnName] = row[index];
      });

      // Send employee details as JSON response
      res.status(200).json(leaveDetails);
    } else {
      res.status(404).json({ error: 'Employee not found' });
    }
  } catch (error) {
    console.error('Error:', error);

    // Send an error response
    res.status(500).json({ error: 'Internal Server Error' });
  }
});
app.post('/api/leaveapp', async (req, res) => {
  console.log('Received POST request at /api/leaveapp');
  const { employee_id, leave_type_id, start_date, end_date, date_of_application, number_of_days, user_id } = req.body;

  try {
    // Connect to Oracle Database
    const connection = await oracledb.getConnection(dbConfig);
    console.log('Connected to Oracle Database');
    const leaveTypeQuery = 'SELECT leave_name FROM leave_type WHERE leave_type_id = :leave_type_id';
    const leaveTypeResult = await connection.execute(leaveTypeQuery, [leave_type_id]);

    if (leaveTypeResult.rows.length === 0) {
        // Leave type ID not found
        console.log('Leave type not found for ID:', leave_type_id);
        await connection.close();
        return res.status(400).json({ error: 'Invalid leave type ID' });
    }

    const leaveTypeName = leaveTypeResult.rows[0][0];

    // Check if the leave type corresponds to "LOP"
    if (leaveTypeName === 'LOP') {
        // Handle "LOP" leave applications
        console.log('Leave type is LOP. Allowing multiple applications.');
        console.log('Inserting leave application record');
        const result = await connection.execute(
          'INSERT INTO leave_application (employee_id, leave_type_id, start_date, end_date, date_of_application, number_of_days, user_id, monthly_leave_taken) ' +
          'VALUES (:employee_id, :leave_type_id, :start_date, :end_date, :date_of_application, :number_of_days, :user_id, 1)',
          {
            employee_id: employee_id,
            leave_type_id: leave_type_id,
            start_date: start_date,
            end_date: end_date,
            date_of_application: date_of_application,
            number_of_days: number_of_days,
            user_id: user_id
          }
        );

        console.log('Query executed successfully:', result);

        // Update monthly leave balance
        console.log('Updating monthly leave balance');
        await updateMonthlyLeaveBalance(connection, employee_id, number_of_days, leave_type_id, start_date);

        // Update total leave balance
        console.log('Updating total leave balance');
        await updateTotalLeaveBalance(connection, employee_id, leave_type_id, number_of_days);

        // Commit the transaction
        console.log('Committing transaction');
        await connection.commit();
        console.log('Transaction committed successfully');
    } else {
        // Handle other leave types
        console.log('Leave type is not LOP. Applying restrictions or additional logic.');
        const currentMonth = new Date(start_date).getMonth() + 1; // Get current month
        const currentYear = new Date(start_date).getFullYear(); // Get current year

        // Query to check if leave has been taken for the selected leave type in the current month
        const leaveTakenQuery = `
          SELECT COUNT(*) AS leave_count, SUM(number_of_days) AS total_days
          FROM leave_application
          WHERE employee_id = :employee_id
          AND leave_type_id = :leave_type_id
          AND TO_CHAR(TO_DATE(start_date, 'YYYY-MM-DD'), 'MM') = :month
          AND TO_CHAR(TO_DATE(start_date, 'YYYY-MM-DD'), 'YYYY') = :year
        `;

        console.log('Executing leaveTakenQuery:', leaveTakenQuery);

        // Execute the query
        const leaveTakenResult = await connection.execute(leaveTakenQuery, {
          employee_id: employee_id,
          leave_type_id: leave_type_id,
          month: currentMonth,
          year: currentYear
        });

        console.log('Result of leaveTakenQuery:', leaveTakenResult);

        const leaveCount = leaveTakenResult.rows[0][0];
        const totalDaysTaken = leaveTakenResult.rows[0][1] || 0;

        console.log('Leave count:', leaveCount);
        console.log('Total days taken:', totalDaysTaken);
        console.log('Leave Type ID:', leave_type_id);

        // Check if leave type is not LOP and apply restriction
        if (leaveTypeName !== 'LOP' && (leaveCount > 0 || (totalDaysTaken + number_of_days) > 1)) {
          // Leave has already been taken for the selected leave type in the current month
          // or total days exceed the limit
          await connection.close();
          console.log('Leave application failed due to leave restriction.');
          return res.status(400).json({ error: 'Leave restriction: Only one leave application allowed per month with maximum 1 day.' });
        }

        // Proceed with the rest of the code if leave restriction conditions are met
        // Insert leave application record
        console.log('Inserting leave application record');
        const result = await connection.execute(
          'INSERT INTO leave_application (employee_id, leave_type_id, start_date, end_date, date_of_application, number_of_days, user_id, monthly_leave_taken) ' +
          'VALUES (:employee_id, :leave_type_id, :start_date, :end_date, :date_of_application, :number_of_days, :user_id, 1)',
          {
            employee_id: employee_id,
            leave_type_id: leave_type_id,
            start_date: start_date,
            end_date: end_date,
            date_of_application: date_of_application,
            number_of_days: number_of_days,
            user_id: user_id
          }
        );

        console.log('Query executed successfully:', result);

        // Update monthly leave balance
        console.log('Updating monthly leave balance');
        await updateMonthlyLeaveBalance(connection, employee_id, number_of_days, leave_type_id, start_date);

        // Update total leave balance
        console.log('Updating total leave balance');
        await updateTotalLeaveBalance(connection, employee_id, leave_type_id, number_of_days);

        // Commit the transaction
        console.log('Committing transaction');
        await connection.commit();
        console.log('Transaction committed successfully');
    }

    // Release the connection
    await connection.close();
    console.log('Connection closed successfully');

    // Send a success response
    return res.status(200).json({ message: 'Data inserted successfully!' });
  } catch (error) {
    console.error('Error:', error);

    // Send an error response
    return res.status(500).json({ error: 'Internal Server Error' });
  }
});

      


async function updateMonthlyLeaveBalance(connection, employee_id, number_of_days, leave_type_id, start_date_str) {
  try {
    const start_date = new Date(start_date_str); // Convert start_date string to Date object

    const leaveBalQueryResult = await connection.execute(
      `SELECT monthly_leave_balance, start_date FROM leave_application WHERE employee_id = :employee_id AND leave_type_id = :leave_type_id`,
      {
        employee_id: employee_id,
        leave_type_id: leave_type_id
      }
    );

    if (leaveBalQueryResult.rows.length === 0) {
      // Insert new record for the employee and leave type
      let insertQuery = '';
      let insertParams = {};
      if (start_date_str) {
        insertQuery = `INSERT INTO leave_application (employee_id, leave_type_id, start_date, monthly_leave_balance) VALUES (:employee_id, :leave_type_id, :start_date, :monthly_leave_balance)`;
        insertParams = {
          employee_id: employee_id,
          leave_type_id: leave_type_id,
          start_date: start_date_str,
          monthly_leave_balance: leave_type_id === 21 ? 30 : 1 // Initialize to 1 to account for the base allowance
        };
      } else {
        insertQuery = `INSERT INTO leave_application (employee_id, leave_type_id, monthly_leave_balance) VALUES (:employee_id, :leave_type_id, :monthly_leave_balance)`;
        insertParams = {
          employee_id: employee_id,
          leave_type_id: leave_type_id,
          monthly_leave_balance: leave_type_id === 21 ? 30 : 1 // Initialize to 1 to account for the base allowance
        };
      }
      await connection.execute(insertQuery, insertParams);
    } else {
      const currentLeaveStartDate = new Date(leaveBalQueryResult.rows[0][1]);
      if (start_date_str) { // Add the conditional check here
        const currentMonth = start_date.getMonth();
        const currentYear = start_date.getFullYear();
        
        const currentLeaveStartMonth = currentLeaveStartDate.getMonth();
        const currentLeaveStartYear = currentLeaveStartDate.getFullYear();
        
        let monthsDifference = (currentYear - currentLeaveStartYear) * 12 + (currentMonth - currentLeaveStartMonth);

        // Initialize accumulated balance with the base allowance
        let accumulatedBalance = 1;

        // Check if leave is taken in the current month
        if (currentMonth === start_date.getMonth() && currentYear === start_date.getFullYear()) {
          accumulatedBalance = 0; // Leave is taken in the current month, so set balance to 0
        }

        // Calculate the accumulated leave balance to carry forward from previous months
        for (let i = 1; i < monthsDifference; i++) {
          const month = currentLeaveStartMonth + i;
          const year = currentLeaveStartYear + Math.floor(month / 12);
          const monthBalanceResult = await connection.execute(
            `SELECT monthly_leave_balance FROM leave_application WHERE employee_id = :employee_id AND leave_type_id = :leave_type_id AND EXTRACT(YEAR FROM start_date) = :year AND EXTRACT(MONTH FROM start_date) = :month`,
            {
              employee_id: employee_id,
              leave_type_id: leave_type_id,
              year: year,
              month: (month % 12) + 1 // Adjust month to be in [1, 12]
            }
          );
          if (monthBalanceResult.rows.length > 0) {
            accumulatedBalance += monthBalanceResult.rows[0][0];
          }
        }

        // Update monthly leave balance
        await connection.execute(
          `UPDATE leave_application SET monthly_leave_balance = :monthly_leave_balance WHERE employee_id = :employee_id AND leave_type_id = :leave_type_id`,
          {
            monthly_leave_balance: accumulatedBalance,
            employee_id: employee_id,
            leave_type_id: leave_type_id
          }
        );
      }
    }
  } catch (error) {
    console.error('Error:', error);
    // You may handle errors here
  }
}


async function updateTotalLeaveBalance(connection, employee_id, leave_type_id, number_of_days) {
  // Check if leave_bal is null or zero
  const leaveBalQueryResult = await connection.execute(
    `SELECT leave_bal FROM leave_application WHERE employee_id = :employee_id AND leave_type_id = :leave_type_id`,
    {
      employee_id: employee_id,
      leave_type_id: leave_type_id
    }
  );

  if (leaveBalQueryResult.rows.length === 0 || leaveBalQueryResult.rows[0][0] === null || leaveBalQueryResult.rows[0][0] === 0) {
    // Update the leave_bal in leave_application table by subtracting number_of_days from number_days_allowed
    await connection.execute(
      `UPDATE leave_application la
       SET la.leave_bal = (
         SELECT lt.number_days_allowed - la.number_of_days
         FROM leave_type lt
         WHERE lt.leave_type_id = :leave_type_id
       )
       WHERE la.employee_id = :employee_id AND la.leave_type_id = :leave_type_id`,
      {
        leave_type_id: leave_type_id,
        employee_id: employee_id
      }
    );
  } else {
    // Update the leave_bal in leave_application table by subtracting number_of_days from leave_bal
    await connection.execute(
      `UPDATE leave_application 
       SET leave_bal = leave_bal - :number_of_days 
       WHERE employee_id = :employee_id AND leave_type_id = :leave_type_id`,
      {
        number_of_days: number_of_days,
        leave_type_id: leave_type_id,
        employee_id: employee_id
      }
    );
  }
}

app.get('/api/leavebalance/:employeeId/:leaveType', async (req, res) => {
  const { employeeId, leaveType } = req.params;

  try {
    // Connect to Oracle Database
    const connection = await oracledb.getConnection(dbConfig);

    // Query to retrieve leave balance or number of days allowed
    const result = await connection.execute(
      `SELECT la.leave_bal, la.monthly_leave_balance, lt.number_days_allowed FROM leave_application la
       JOIN leave_type lt ON la.leave_type_id = lt.leave_type_id
       WHERE la.employee_id = :employeeId AND lt.leave_name = :leaveType`,
      {
        employeeId: employeeId,
        leaveType: leaveType
      }
    );

    // Release the connection
    await connection.close();

    if (result.rows.length > 0) {
      const leaveBalance = result.rows[0][0]; // Leave balance
      const monthlyLeaveBalance = result.rows[0][1]; // Monthly leave balance
      const numberOfDaysAllowed = result.rows[0][2]; // Number of days allowed
      res.status(200).json({ leave_balance: leaveBalance, monthly_leave_balance: monthlyLeaveBalance, number_days_allowed: numberOfDaysAllowed });
    } else {
      res.status(404).json({ error: 'Leave balance not found' });
    }
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});



app.get('/api/managereq', async (req, res) => {
  console.log('Received GET request at /api/managereq');

  try {
    // Connect to Oracle Database
    const connection = await oracledb.getConnection(dbConfig);
    console.log('Connected to Oracle Database');

    // Execute the query to retrieve leave requests with employee names
    const result = await connection.execute(
      `SELECT 
          la.APPLICATION_ID, 
          la.DATE_OF_APPLICATION, 
          la.EMPLOYEE_ID, 
          e.FIRST_NAME || ' ' || COALESCE(e.MIDDLE_NAME || ' ', '') || e.LAST_NAME AS EMPLOYEE_NAME, 
          la.USER_ID,
          la.LEAVE_TYPE_ID, 
          la.START_DATE, 
          la.END_DATE,
          la.APPROVED_BYHR,
          la.APPROVED_BY2,
          la.APPROVED_BY3,
          d.DEPT_SHORT_NAME,
          des.DESIGNATION_NAME
       FROM 
          leave_application la
       LEFT JOIN 
          employee e ON la.EMPLOYEE_ID = e.EMPLOYEE_ID
       LEFT JOIN
          users u ON la.USER_ID = u.USER_ID
       LEFT JOIN
          dept d ON e.DEPT_ID = d.DEPT_ID
       LEFT JOIN
          designation des ON e.DESIGNATION_ID = des.DESIGNATION_ID`
    );

    // Release the connection
    await connection.close();
    console.log('Connection closed successfully');

    if (result.rows.length > 0) {
      // Construct JSON response with leave request details including employee names
      const managereq = result.rows.map(row => {
        const reqDetails = {};
        result.metaData.forEach((column, index) => {
          reqDetails[column.name] = row[index];
        });
        return reqDetails;
      });

      // Send leave request details as JSON response
      res.status(200).json(managereq);
    } else {
      res.status(404).json({ error: 'No requests found' });
    }
  } catch (error) {
    console.error('Error:', error);

    // Send an error response
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

app.post('/api/lv', async (req, res) => {
  console.log('Received POST request at /api/lv');
  const { LEAVE_NAME,LEAVE_DESCRIPTION,NUMBER_DAYS_ALLOWED } = req.body;

  try {
    // Connect to Oracle Database
    const connection = await oracledb.getConnection(dbConfig);
    console.log('Connected to Oracle Database');

    // Execute the insert query
    const result = await connection.execute(
      'INSERT INTO leave_type (LEAVE_NAME,LEAVE_DESCRIPTION,NUMBER_DAYS_ALLOWED) VALUES (:LEAVE_NAME,:LEAVE_DESCRIPTION,:NUMBER_DAYS_ALLOWED)',
      [LEAVE_NAME,LEAVE_DESCRIPTION,NUMBER_DAYS_ALLOWED]
    );
    console.log('Query executed successfully:', result);

    // Commit the transaction
    await connection.commit();
    console.log('Transaction committed successfully');

    // Release the connection
   // await connection.close();
   // console.log('Connection closed successfully');

    // Send a success response
    res.status(200).json({ message: 'Data inserted successfully!' });
  } catch (error) {
    console.error('Error:', error);

    // Send an error response
    res.status(500).json({ error: 'Internal Server Error' });
  }
});


app.put('/api/approve-leave/:applicationId', async (req, res) => {
  const applicationId = req.params.applicationId;
  const approvalStatus = 'Approved';

  try {
    const connection = await oracledb.getConnection(dbConfig);
    const query = `UPDATE leave_application SET approved_byhr = :approvalStatus WHERE application_id = :applicationId`;
    const result = await connection.execute(query, [approvalStatus, applicationId], { autoCommit: true });
    await connection.close();
    console.log(`Leave request with ID ${applicationId} approved successfully`);
    res.status(200).send(`Leave request with ID ${applicationId} approved successfully`);
  } catch (error) {
    console.error('Error updating approval status:', error);
    res.status(500).send('Failed to update approval status');
  }
});

app.put('/api/reject-leave/:applicationId', async (req, res) => {
  const applicationId = req.params.applicationId;
  const approvalStatus = 'Rejected';

  try {
    const connection = await oracledb.getConnection(dbConfig);
    const query = `UPDATE leave_application SET approved_byhr = :approvalStatus WHERE application_id = :applicationId`;
    const result = await connection.execute(query, [approvalStatus, applicationId], { autoCommit: true });
    await connection.close();
    console.log(`Leave request with ID ${applicationId} rejected successfully`);
    res.status(200).send(`Leave request with ID ${applicationId} rejected successfully`);
  } catch (error) {
    console.error('Error updating approval status:', error);
    res.status(500).send('Failed to update approval status');
  }
});

app.get('/api/approval-status/:applicationId', async (req, res) => {
  const applicationId = req.params.applicationId;

  try {
    const connection = await oracledb.getConnection(dbConfig);
    const selectQuery = `SELECT approved_byhr FROM leave_application WHERE application_id = :applicationId`;
    const selectResult = await connection.execute(selectQuery, [applicationId]);
    await connection.close();

    if (selectResult.rows.length > 0) {
      const approvalStatus = selectResult.rows[0][0];
      console.log(`Approval status for application ID ${applicationId}: ${approvalStatus}`);
      res.status(200).send(approvalStatus);
    } else {
      console.log('No data found for the specified application ID');
      res.status(404).send('No data found for the specified application ID');
    }
  } catch (error) {
    console.error('Error fetching approval status:', error);
    res.status(500).send('Failed to fetch approval status');
  }
});


app.put('/api/approve-leave2/:applicationId', async (req, res) => {
  const applicationId = req.params.applicationId;
  const approvalStatus = 'Approved';

  try {
    const connection = await oracledb.getConnection(dbConfig);
    const query = `UPDATE leave_application SET approved_by2 = :approvalStatus WHERE application_id = :applicationId`;
    const result = await connection.execute(query, [approvalStatus, applicationId], { autoCommit: true });
    await connection.close();
    console.log(`Leave request with ID ${applicationId} approved successfully`);
    res.status(200).send(`Leave request with ID ${applicationId} approved successfully`);
  } catch (error) {
    console.error('Error updating approval status:', error);
    res.status(500).send('Failed to update approval status');
  }
});

app.put('/api/reject-leave2/:applicationId', async (req, res) => {
  const applicationId = req.params.applicationId;
  const approvalStatus = 'Rejected';
  const reason = req.body.reason; // Extract the rejection reason from the request body

  try {
    const connection = await oracledb.getConnection(dbConfig);
    const query = `UPDATE leave_application SET approved_by2 = :approvalStatus, rejection_reason = :reason WHERE application_id = :applicationId`;
    const result = await connection.execute(query, { approvalStatus, reason, applicationId }, { autoCommit: true });
    await connection.close();
    console.log(`Leave request with ID ${applicationId} rejected successfully`);
    res.status(200).send(`Leave request with ID ${applicationId} rejected successfully`);
  } catch (error) {
    console.error('Error updating approval status:', error);
    res.status(500).send('Failed to update approval status');
  }
});


app.put('/api/approve-leave3/:applicationId', async (req, res) => {
  const applicationId = req.params.applicationId;
  const approvalStatus = 'Approved';

  try {
    const connection = await oracledb.getConnection(dbConfig);
    const query = `UPDATE leave_application SET approved_by3 = :approvalStatus WHERE application_id = :applicationId`;
    const result = await connection.execute(query, [approvalStatus, applicationId], { autoCommit: true });
    await connection.close();
    console.log(`Leave request with ID ${applicationId} approved successfully`);
    res.status(200).send(`Leave request with ID ${applicationId} approved successfully`);
  } catch (error) {
    console.error('Error updating approval status:', error);
    res.status(500).send('Failed to update approval status');
  }
});

app.put('/api/reject-leave3/:applicationId', async (req, res) => {
  const applicationId = req.params.applicationId;
  const approvalStatus = 'Rejected';

  try {
    const connection = await oracledb.getConnection(dbConfig);
    const query = `UPDATE leave_application SET approved_by3 = :approvalStatus WHERE application_id = :applicationId`;
    const result = await connection.execute(query, [approvalStatus, applicationId], { autoCommit: true });
    await connection.close();
    console.log(`Leave request with ID ${applicationId} rejected successfully`);
    res.status(200).send(`Leave request with ID ${applicationId} rejected successfully`);
  } catch (error) {
    console.error('Error updating approval status:', error);
    res.status(500).send('Failed to update approval status');
  }
});

app.get('/api/leavestatus/:employeeId', async (req, res) => {
  const employeeId = parseInt(req.params.employeeId); // Convert to integer

  console.log('Received GET request at /api/leavestatus for employee ID:', req.params.employeeId); // Debugging

  try {
    console.log('Parsed employee ID:', employeeId); // Debugging

    // Check if employeeId is a valid number
    if (isNaN(employeeId)) {
      return res.status(400).json({ error: 'Invalid employee ID' });
    }

    // Connect to Oracle Database
    const connection = await oracledb.getConnection(dbConfig);
    console.log('Connected to Oracle Database');

    // Execute the query to retrieve leave applications for the specific employee
    const result = await connection.execute(
      'SELECT * FROM leave_application WHERE EMPLOYEE_ID = :employeeId',
      [employeeId]
    ); // Use bind variable

    // Release the connection
    await connection.close();
    console.log('Connection closed successfully');

    if (result.rows.length > 0) {
      // Construct JSON response with array of leave applications
      const leaveApplications = result.rows.map(row => {
        const leaveAppDetails = {};
        result.metaData.forEach((column, index) => {
          leaveAppDetails[column.name] = row[index];
        });
        return leaveAppDetails;
      });

      // Send leave applications as JSON response
      res.status(200).json(leaveApplications);
    } else {
      res.status(404).json({ error: 'No leave applications found for the employee' });
    }
  } catch (error) {
    console.error('Error:', error);
    // Send an error response
    res.status(500).json({ error: 'Internal Server Error' });
  }
});



app.post('/api/salary', async (req, res) => {
  console.log('Received POST request at /api/salary');
  const { employee_id, basic_pay, hra, da, other_allowance, provident_fund, professional_tax } = req.body;

  try {
    // Connect to Oracle Database
    const connection = await oracledb.getConnection(dbConfig);
    console.log('Connected to Oracle Database');

    // Calculate total salary
    const totalSalary = parseFloat(basic_pay) + parseFloat(hra) + parseFloat(da) + parseFloat(other_allowance) - parseFloat(provident_fund) - parseFloat(professional_tax);

    // Execute the insert query
    const result = await connection.execute(
      `INSERT INTO employee_salary_details (employee_id, basic_pay, hra, da, other_allowance, provident_fund, professional_tax, tot_sal) 
      VALUES (:employee_id, :basic_pay, :hra, :da, :other_allowance, :provident_fund, :professional_tax, :totalSalary)`,
      [employee_id, basic_pay, hra, da, other_allowance, provident_fund, professional_tax, totalSalary]
    );
    console.log('Query executed successfully:', result);

    // Commit the transaction
    await connection.commit();
    console.log('Transaction committed successfully');

    // Release the connection
    // await connection.close();
    // console.log('Connection closed successfully');

    // Send a success response
    res.status(200).json({ message: 'Data inserted successfully!' });
  } catch (error) {
    console.error('Error:', error);

    // Send an error response
    res.status(500).json({ error: 'Internal Server Error' });
  }
});


app.get('/api/managesal/:employeeId', async (req, res) => {
  const employeeId = req.params.employeeId;
  console.log(`Received GET request at /api/managesal for employee ID: ${employeeId}`);

  try {
    // Connect to Oracle Database
    const connection = await oracledb.getConnection(dbConfig);
    console.log('Connected to Oracle Database');

    // Execute the query to retrieve salary details for the specific employee
    const result = await connection.execute(
      'SELECT * FROM employee_salary_details WHERE employee_id = :empId',
      [employeeId]
    );

    // Release the connection
    await connection.close();
    console.log('Connection closed successfully');

    if (result.rows.length > 0) {
      // Construct JSON response with the salary details
      const salaryDetails = {
        employee_id: parseInt(result.rows[0][0]),
        basic_pay: parseInt(result.rows[0][1]),
        hra: parseInt(result.rows[0][2]),
        da: parseInt(result.rows[0][3]),
        other_allowance: parseInt(result.rows[0][4]),
        provident_fund: parseInt(result.rows[0][5]),
        professional_tax: parseInt(result.rows[0][6]),
        tot_sal: parseInt(result.rows[0][7])
      };

      // Log and send the salary details as JSON response
      console.log('Salary Details:', salaryDetails);
      res.status(200).json(salaryDetails);
    } else {
      res.status(404).json({ error: 'Salary details not found for the employee' });
    }
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

app.get('/api/employee/:employeeId', async (req, res) => {
  const employeeId = req.params.employeeId;
  console.log(`Received GET request at /api/employee for employee ID: ${employeeId}`);

  try {
    // Connect to Oracle Database
    const connection = await oracledb.getConnection(dbConfig);
    console.log('Connected to Oracle Database');

    // Execute the query to retrieve employee details for the specific employee
    const result = await connection.execute(
      'SELECT * FROM employee WHERE employee_id = :empId',
      [employeeId]
    );

    // Execute separate queries to fetch department and designation names
    const deptResult = await connection.execute(
      'SELECT dept_short_name FROM dept WHERE dept_id = :deptId',
      [result.rows[0][10]] // Assuming dept_id is in the 10th column of the employee table
    );
    console.log('Department Result:', deptResult);


    const designationResult = await connection.execute(
      'SELECT designation_name FROM designation WHERE designation_id = :desigId',
      [result.rows[0][11]] // Assuming designation_id is in the 11th column of the employee table
    );

    // Release the connection
    await connection.close();
    console.log('Connection closed successfully');

    if (result.rows.length > 0 && deptResult.rows.length > 0 && designationResult.rows.length > 0) {
      // Construct JSON response with the employee details
      const employeeDetails = {
        employee_id: parseInt(result.rows[0][0]),
        // Construct the employee name by combining first, middle, and last names
        employee_name: `${result.rows[0][1]} ${result.rows[0][2] ? result.rows[0][2] + ' ' : ''}${result.rows[0][3]}`,
        dept_name: deptResult.rows[0][0], // Fetch department name from deptResult
        designation_name: designationResult.rows[0][0] // Fetch designation name from designationResult
        // Add more details as needed
      };

      // Log and send the employee details as JSON response
      console.log('Employee Details:', employeeDetails);
      res.status(200).json(employeeDetails);
    } else {
      res.status(404).json({ error: 'Employee details not found' });
    }
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

app.get('/api/leave-summary', async (req, res) => {
  const employeeId = req.query.employeeId; // Retrieve employeeId from query parameters

  console.log(`Received request for employeeId: ${employeeId}`);
  console.log(`Full request URL: ${req.protocol}://${req.get('host')}${req.originalUrl}`);

  if (!employeeId) {
    return res.status(400).json({ error: 'Employee ID is required' });
  }

  try {
    // Connect to the Oracle database
    const connection = await oracledb.getConnection(dbConfig);

    // Query to get the sum of leave days for leave_type_id = 41, approved_byhr = 'Approved', and specific employee
    const query = `
      SELECT SUM(number_of_days) AS total_leave_days
      FROM leave_application
      WHERE leave_type_id = 41
      AND approved_byhr = 'Approved'
      AND employee_id = :employeeId
    `;

    // Bind the employeeId parameter to the query
    const result = await connection.execute(query, { employeeId });

    // Get the total leave days from the query result
    const totalLeaveDays = result.rows[0][0];
    console.log('Total leave days:', totalLeaveDays);

    // Release the Oracle database connection
    await connection.close();

    // Send the total leave days as a response
    res.json({ totalLeaveDays });
  } catch (error) {
    console.error('Error fetching leave summary:', error);

    // Check for specific Oracle error code
    if (error.errorNum === 942) {
      return res.status(400).json({ error: 'Table or column does not exist' });
    }

    res.status(500).json({ error: 'Internal server error' });
  }
});




// Start the server
app.listen(port, '192.168.1.7', () => {
  console.log(`Server is running at http://192.168.1.7:${port}`);
});
