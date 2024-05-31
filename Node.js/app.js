// Import required modules
const express = require('express');
const oracledb = require('oracledb');
const bodyParser = require('body-parser');
const cors = require('cors')
const multer = require('multer');
const fs = require('fs');

// Multer configuration
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, 'uploads/');
  },
  filename: function (req, file, cb) {
    cb(null, Date.now() + '-' + file.originalname);
  }
});

const upload = multer({ storage: storage });

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



app.get('/api/counts', async (req, res) => {
  try {
    // Connect to Oracle Database
    const connection = await oracledb.getConnection(dbConfig);
    console.log('Connected to Oracle Database');

    // Execute the query to fetch counts
    const query = `
      SELECT
      (SELECT COUNT(*) FROM employee) AS employee,
      (SELECT COUNT(*) FROM leave_application) AS leave,
        (SELECT COUNT(*) FROM leave_application WHERE APPROVED_BYHR = 'Approved') AS approved,
        (SELECT COUNT(*) FROM leave_application WHERE APPROVED_BYHR = ' ' OR APPROVED_BYHR IS NULL) AS pending,
        (SELECT COUNT(*) FROM leave_application WHERE APPROVED_BYHR = 'Rejected') AS rejected
      FROM dual
    `;
    const result = await connection.execute(query);

    // Extract counts from the result
    const counts = {
      employee: result.rows[0][0],
      leave: result.rows[0][1],
      approved: result.rows[0][2],
      pending: result.rows[0][3],
      rejected: result.rows[0][4]
    };

    // Release the connection
    await connection.close();
    console.log('Connection closed successfully');

    // Send counts as JSON response
    res.json(counts);
  } catch (error) {
    console.error('Error:', error);

    // Send an error response
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

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
app.put('/api/update_department/:deptId', async (req, res) => {
  console.log('Received PUT request at /api/update_department/:deptId');
  
  const deptId = req.params.deptId;
  const {
    DEPT_NAME,
    DEPT_SHORT_NAME,
    // Add other department details here if needed
  } = req.body;

  try {
    const connection = await oracledb.getConnection(dbConfig);
    console.log('Connected to Oracle Database');

    const result = await connection.execute(
      `UPDATE dept 
       SET DEPT_NAME = :DEPT_NAME,
           DEPT_SHORT_NAME = :DEPT_SHORT_NAME
       WHERE DEPT_ID = :DEPT_ID`,
      {
        DEPT_NAME,
        DEPT_SHORT_NAME,
        DEPT_ID: deptId // Use the deptId from the URL parameter
      }
    );

    await connection.commit();
    console.log('Transaction committed successfully');

    await connection.close();
    console.log('Connection closed successfully');

    res.status(200).json({ message: 'Department details updated successfully!' });
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

app.delete('/api/delete_department/:deptId', async (req, res) => {
  console.log('Received DELETE request at /api/delete_department/:deptId');
  
  const deptId = req.params.deptId;
  console.log('Department ID:', deptId); // Log department ID
  
  try {
    const connection = await oracledb.getConnection(dbConfig);
    console.log('Connected to Oracle Database');

    const result = await connection.execute(
      `DELETE FROM dept WHERE DEPT_ID = :deptId`,
      { deptId }
    );

    await connection.commit();
    console.log('Transaction committed successfully');

    await connection.close();
    console.log('Connection closed successfully');

    res.status(200).json({ message: 'Department deleted successfully!' });
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});



app.post('/api/des', async (req, res) => {
  console.log('Received POST request at /api/des');
  const { DESIGNATION_NAME,DESIGNATION_DESC,PROBATION,NOTICE_PRD} = req.body;

  try {
    // Connect to Oracle Database
    const connection = await oracledb.getConnection(dbConfig);
    console.log('Connected to Oracle Database');

    // Execute the insert query
    const result = await connection.execute(
      'INSERT INTO designation (DESIGNATION_NAME,DESIGNATION_DESC,PROBATION,NOTICE_PRD) VALUES (:DESIGNATION_NAME,:DESIGNATION_DESC,:PROBATION,:NOTICE_PRD)',
      [DESIGNATION_NAME,DESIGNATION_DESC,PROBATION,NOTICE_PRD]
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

app.put('/api/update_des/:desId', async (req, res) => {
  console.log('Received PUT request at /api/update_des/:desId');
  
  const desId = req.params.desId;
  const {
    DESIGNATION_NAME,
    DESIGNATION_DESC,
    PROBATION,
    NOTICE_PRD,
    // Add other department details here if needed
  } = req.body;

  try {
    const connection = await oracledb.getConnection(dbConfig);
    console.log('Connected to Oracle Database');

    const result = await connection.execute(
      `UPDATE designation 
       SET DESIGNATION_NAME = :DESIGNATION_NAME,
       DESIGNATION_DESC = :DESIGNATION_DESC,
       PROBATION=:PROBATION,
       NOTICE_PRD=:NOTICE_PRD
       WHERE DESIGNATION_ID = :DESIGNATION_ID`,
      {
        DESIGNATION_NAME,
        DESIGNATION_DESC,
        PROBATION,
        NOTICE_PRD,
        DESIGNATION_ID: desId // Use the deptId from the URL parameter
      }
    );

    await connection.commit();
    console.log('Transaction committed successfully');

    await connection.close();
    console.log('Connection closed successfully');

    res.status(200).json({ message: 'Designation details updated successfully!' });
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

app.delete('/api/delete_des/:desId', async (req, res) => {
  console.log('Received DELETE request at /api/delete_des/:desId');
  
  const desId = req.params.desId;
  console.log('Designation ID:', desId); // Log department ID
  
  try {
    const connection = await oracledb.getConnection(dbConfig);
    console.log('Connected to Oracle Database');

    const result = await connection.execute(
      `DELETE FROM designation WHERE DESIGNATION_ID = :desId`,
      { desId }
    );

    await connection.commit();
    console.log('Transaction committed successfully');

    await connection.close();
    console.log('Connection closed successfully');

    res.status(200).json({ message: 'Department deleted successfully!' });
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});


app.get('/api/manageleavetype', async (req, res) => {
  console.log('Received GET request at /api/manageleavetype');

  try {
    // Connect to Oracle Database
    const connection = await oracledb.getConnection(dbConfig);
    console.log('Connected to Oracle Database');

    // Execute the query to retrieve all company details
    const result = await connection.execute(
      'SELECT * FROM leave_type'
    );

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

app.put('/api/update_leave/:leaveId', async (req, res) => {
  console.log('Received PUT request at /api/update_leave/:leaveId');
  
  const leaveId = req.params.leaveId;
  const {
    LEAVE_NAME,
    LEAVE_DESCRIPTION,
    NUMBER_DAYS_ALLOWED,
    // Add other department details here if needed
  } = req.body;

  try {
    const connection = await oracledb.getConnection(dbConfig);
    console.log('Connected to Oracle Database');

    const result = await connection.execute(
      `UPDATE leave_type 
       SET LEAVE_NAME = :LEAVE_NAME,
       LEAVE_DESCRIPTION = :LEAVE_DESCRIPTION,
       NUMBER_DAYS_ALLOWED = :NUMBER_DAYS_ALLOWED
       WHERE LEAVE_TYPE_ID = :LEAVE_TYPE_ID`,
      {
        LEAVE_NAME,
        LEAVE_DESCRIPTION,
        NUMBER_DAYS_ALLOWED,
        LEAVE_TYPE_ID: leaveId // Use the deptId from the URL parameter
      }
    );

    await connection.commit();
    console.log('Transaction committed successfully');

    await connection.close();
    console.log('Connection closed successfully');

    res.status(200).json({ message: 'Department details updated successfully!' });
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

app.delete('/api/delete_leave/:leaveId', async (req, res) => {
  console.log('Received DELETE request at /api/delete_leave/:leaveId');
  
  const leaveId = req.params.leaveId;
  console.log('Leave ID:', leaveId); // Log department ID
  
  try {
    const connection = await oracledb.getConnection(dbConfig);
    console.log('Connected to Oracle Database');

    const result = await connection.execute(
      `DELETE FROM leave_type WHERE LEAVE_TYPE_ID = :leaveId`,
      { leaveId }
    );

    await connection.commit();
    console.log('Transaction committed successfully');

    await connection.close();
    console.log('Connection closed successfully');

    res.status(200).json({ message: 'Department deleted successfully!' });
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});



app.post('/api/employees', async (req, res) => {
  console.log('Received POST request at /api/employees');
  const { first_name, middle_name, last_name, dob, gender, email, phno, username, password, dept_id, designation_id, doj, father, mother, addr_present, addr_perm } = req.body;

  try {
    // Connect to Oracle Database
    const connection = await oracledb.getConnection(dbConfig);
    console.log('Connected to Oracle Database');

    // Execute the insert query
    const result = await connection.execute(
      'INSERT INTO employee (first_name, middle_name, last_name, dob, gender, email, phno, username, password, dept_id, designation_id, doj, father, mother, addr_present, addr_perm) ' +
      'VALUES (:first_name, :middle_name, :last_name, :dob, :gender, :email, :phno, :username, :password, :dept_id, :designation_id, :doj, :father, :mother, :addr_present, :addr_perm)',
      [first_name, middle_name, last_name, dob, gender, email, phno, username, password, dept_id, designation_id ,doj, father, mother, addr_present, addr_perm]
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

app.put('/api/update_employee/:employeeId', async (req, res) => {
  console.log('Received PUT request at /api/update_employee/:employeeId');

  const employeeId = req.params.employeeId;
  const {
    FIRST_NAME,
    MIDDLE_NAME,
    LAST_NAME,
    DOB,
    DOJ,
    FATHER,
    MOTHER,
    ADDR_PRESENT,
    ADDR_PERM,
    GENDER,
    EMAIL,
    PHNO,
    USERNAME,
    PASSWORD,
   // dept_id,
   // designation_id
  } = req.body;

  try {
    // Connect to Oracle Database
    const connection = await oracledb.getConnection(dbConfig);
    console.log('Connected to Oracle Database');

    // Execute the update query
    const result = await connection.execute(
      `UPDATE employee 
       SET FIRST_NAME = :FIRST_NAME,
       MIDDLE_NAME = :MIDDLE_NAME,
       LAST_NAME = :LAST_NAME,
       DOB=:DOB,
       DOJ=:DOJ,
       FATHER=:FATHER,
       MOTHER=:MOTHER,
       ADDR_PRESENT=:ADDR_PRESENT,
       ADDR_PERM=:ADDR_PERM,       
       GENDER = :GENDER,
       EMAIL = :EMAIL,
       PHNO = :PHNO,
       USERNAME = :USERNAME,
       PASSWORD = :PASSWORD
           
       WHERE EMPLOYEE_ID = :EMPLOYEE_ID`,
      {
        FIRST_NAME,
        MIDDLE_NAME,
        LAST_NAME,
        DOB,
    DOJ,
    FATHER,
    MOTHER,
    ADDR_PRESENT,
    ADDR_PERM,
        GENDER,
        EMAIL,
        PHNO,
        USERNAME,
        PASSWORD,
        //dept_id,
       // designation_id,
        EMPLOYEE_ID: employeeId // Use the employee_id from the URL parameter
      }
    );

    // Commit the transaction
    await connection.commit();
    console.log('Transaction committed successfully');

    // Release the connection
    await connection.close();
    console.log('Connection closed successfully');

    // Send a success response
    res.status(200).json({ message: 'Employee details updated successfully!' });
  } catch (error) {
    console.error('Error:', error);

    // Send an error response
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

app.delete('/api/delete_emp/:employeeId', async (req, res) => {
  console.log('Received DELETE request at /api/delete_emp/:employeeId');
  
  const employeeId = req.params.employeeId;
  console.log('Employee ID:', employeeId); // Log department ID
  
  try {
    const connection = await oracledb.getConnection(dbConfig);
    console.log('Connected to Oracle Database');

    const result = await connection.execute(
      `DELETE FROM employee WHERE EMPLOYEE_ID = :employeeId`,
      { employeeId }
    );

    await connection.commit();
    console.log('Transaction committed successfully');

    await connection.close();
    console.log('Connection closed successfully');

    res.status(200).json({ message: 'Employee deleted successfully!' });
  } catch (error) {
    console.error('Error:', error);
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
  // Calculate the total number of days taken for the specified leave type
  const totalDaysTakenQuery = `
    SELECT SUM(number_of_days) AS total_days_taken
    FROM leave_application
    WHERE employee_id = :employee_id AND leave_type_id = :leave_type_id
  `;
  const totalDaysTakenResult = await connection.execute(totalDaysTakenQuery, {
    employee_id: employee_id,
    leave_type_id: leave_type_id
  });
  const totalDaysTaken = totalDaysTakenResult.rows[0][0] || 0;

  // Fetch the number_days_allowed from the leave_type table
  const numberDaysAllowedQuery = `
    SELECT number_days_allowed
    FROM leave_type
    WHERE leave_type_id = :leave_type_id
  `;
  const numberDaysAllowedResult = await connection.execute(numberDaysAllowedQuery, {
    leave_type_id: leave_type_id
  });
  const numberDaysAllowed = numberDaysAllowedResult.rows[0][0] || 0;

  // Calculate the remaining leave balance
  const remainingBalance = numberDaysAllowed - totalDaysTaken;

  // Update the leave_bal in leave_application table
  await connection.execute(
    `UPDATE leave_application 
     SET leave_bal = :remaining_balance 
     WHERE employee_id = :employee_id AND leave_type_id = :leave_type_id`,
    {
      remaining_balance: remainingBalance,
      leave_type_id: leave_type_id,
      employee_id: employee_id
    }
  );
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
          la.NUMBER_OF_DAYS,
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
  const rejectionReason = req.body.reason; // Get the rejection reason from the request body
  const approvalStatus = 'Rejected';

  try {
    const connection = await oracledb.getConnection(dbConfig);
    const query = `UPDATE leave_application SET approved_byhr = :approvalStatus, rejection_reason = :rejectionReason WHERE application_id = :applicationId`;
    const result = await connection.execute(query, [approvalStatus, rejectionReason, applicationId], { autoCommit: true });
    await connection.close();
    console.log(`Leave request with ID ${applicationId} rejected successfully`);
    res.status(200).send(`Leave request with ID ${applicationId} rejected successfully`);
  } catch (error) {
    console.error('Error updating approval status:', error);
    res.status(500).send('Failed to update approval status');
  }
});

app.get('/api/fetch-approval-statushr/:applicationId', async (req, res) => {
  const applicationId = req.params.applicationId;

  try {
    const connection = await oracledb.getConnection(dbConfig);
    const query = `SELECT approved_byhr FROM leave_application WHERE application_id = :applicationId`;
    const result = await connection.execute(query, [applicationId]);
    await connection.close();
    const status = result.rows[0][0]; // Assuming status is in the first column
    res.status(200).json({ status });
  } catch (error) {
    console.error('Error fetching approval status:', error);
    res.status(500).send('Failed to fetch approval status');
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


// Update the approve-leave2 endpoint
app.put('/api/approve-leave2/:applicationId', async (req, res) => {
  const applicationId = req.params.applicationId;
  const approvalStatus = 'Approved'; // Set the approval status

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

// Update the reject-leave2 endpoint
app.put('/api/reject-leave2/:applicationId', async (req, res) => {
  const applicationId = req.params.applicationId;
  const rejectionReason = req.body.reason; // Get the rejection reason from the request body
  const approvalStatus = 'Rejected'; // Set the rejection status

  try {
    const connection = await oracledb.getConnection(dbConfig);
    const query = `UPDATE leave_application SET approved_by2 = :approvalStatus, rejection_reason = :rejectionReason WHERE application_id = :applicationId`;
    const result = await connection.execute(query, [approvalStatus, rejectionReason, applicationId], { autoCommit: true });
    await connection.close();
    console.log(`Leave request with ID ${applicationId} rejected successfully`);
    res.status(200).send(`Leave request with ID ${applicationId} rejected successfully`);
  } catch (error) {
    console.error('Error updating approval status:', error);
    res.status(500).send('Failed to update approval status');
  }
});

// Add a new endpoint to fetch approval status
app.get('/api/fetch-approval-status/:applicationId', async (req, res) => {
  const applicationId = req.params.applicationId;

  try {
    const connection = await oracledb.getConnection(dbConfig);
    const query = `SELECT approved_by2 FROM leave_application WHERE application_id = :applicationId`;
    const result = await connection.execute(query, [applicationId]);
    await connection.close();
    const status = result.rows[0][0]; // Assuming status is in the first column
    res.status(200).json({ status });
  } catch (error) {
    console.error('Error fetching approval status:', error);
    res.status(500).send('Failed to fetch approval status');
  }
});


app.put('/api/approve-leave3/:applicationId', async (req, res) => {
  const applicationId = req.params.applicationId;
  const approvalStatus = 'Approved'; // Set the approval status

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

// Update the reject-leave3 endpoint
app.put('/api/reject-leave3/:applicationId', async (req, res) => {
  const applicationId = req.params.applicationId;
  const rejectionReason = req.body.reason; // Get the rejection reason from the request body
  const approvalStatus = 'Rejected'; // Set the rejection status

  try {
    const connection = await oracledb.getConnection(dbConfig);
    const query = `UPDATE leave_application SET approved_by3 = :approvalStatus, rejection_reason = :rejectionReason WHERE application_id = :applicationId`;
    const result = await connection.execute(query, [approvalStatus, rejectionReason, applicationId], { autoCommit: true });
    await connection.close();
    console.log(`Leave request with ID ${applicationId} rejected successfully`);
    res.status(200).send(`Leave request with ID ${applicationId} rejected successfully`);
  } catch (error) {
    console.error('Error updating approval status:', error);
    res.status(500).send('Failed to update approval status');
  }
});

// Add a new endpoint to fetch approval status
app.get('/api/fetch-approval-status3/:applicationId', async (req, res) => {
  const applicationId = req.params.applicationId;

  try {
    const connection = await oracledb.getConnection(dbConfig);
    const query = `SELECT approved_by3 FROM leave_application WHERE application_id = :applicationId`;
    const result = await connection.execute(query, [applicationId]);
    await connection.close();
    const status = result.rows[0][0]; // Assuming status is in the first column
    res.status(200).json({ status });
  } catch (error) {
    console.error('Error fetching approval status:', error);
    res.status(500).send('Failed to fetch approval status');
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
        employee_id: parseInt(result.rows[0][7]),
        basic_pay: parseInt(result.rows[0][0]),
        hra: parseInt(result.rows[0][1]),
        da: parseInt(result.rows[0][2]),
        other_allowance: parseInt(result.rows[0][3]),
        provident_fund: parseInt(result.rows[0][4]),
        professional_tax: parseInt(result.rows[0][5]),
        tot_sal: parseInt(result.rows[0][6])
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
      [result.rows[0][11]] // Assuming dept_id is in the 10th column of the employee table
    );
    console.log('Department Result:', deptResult);


    const designationResult = await connection.execute(
      'SELECT designation_name FROM designation WHERE designation_id = :desigId',
      [result.rows[0][12]] // Assuming designation_id is in the 11th column of the employee table
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
  const employeeId = req.query.employeeId;
  const monthName = req.query.month; // Month is passed as a string
  const year = req.query.year; // Year is also passed as a string

  console.log(`Received request for employeeId: ${employeeId}`);
  console.log(`Received month: ${monthName}`);
  console.log(`Received year: ${year}`);
  console.log(`Full request URL: ${req.protocol}://${req.get('host')}${req.originalUrl}`);

  // Validate employeeId
  if (!employeeId) {
    return res.status(400).json({ error: 'Employee ID is required' });
  }

  // Convert month name to a number
  const monthMap = {
    'January': 1,
    'February': 2,
    'March': 3,
    'April': 4,
    'May': 5,
    'June': 6,
    'July': 7,
    'August': 8,
    'September': 9,
    'October': 10,
    'November': 11,
    'December': 12
  };

  const month = monthMap[monthName];
  if (!month) {
    return res.status(400).json({ error: 'Invalid month name' });
  }

  // Convert year to an integer
  const yearInt = parseInt(year, 10);
  if (isNaN(yearInt)) {
    return res.status(400).json({ error: 'Invalid year' });
  }

  console.log(`Parsed month: ${month}, Parsed year: ${yearInt}`);

  try {
    // Connect to the Oracle database
    const connection = await oracledb.getConnection(dbConfig);
    console.log('Connected to the database successfully');

    // Query to get the sum of leave days for leave_type_id = 41, approved_byhr = 'Approved', and specific employee
    const query = `
      SELECT SUM(number_of_days) AS total_leave_days
      FROM leave_application
      WHERE leave_type_id = 41
      AND approved_byhr = 'Approved'
      AND employee_id = :employeeId
      AND EXTRACT(MONTH FROM TO_DATE(start_date, 'YYYY-MM-DD')) = :month
      AND EXTRACT(YEAR FROM TO_DATE(start_date, 'YYYY-MM-DD')) = :year
    `;

    console.log(`Executing query with employeeId: ${employeeId}, month: ${month}, year: ${yearInt}`);

    // Bind the parameters to the query
    const result = await connection.execute(query, { 
      employeeId: employeeId,
      month: month,
      year: yearInt
    });

    console.log('Query executed successfully:', result);

    // Get the total leave days from the query result
    const totalLeaveDays = result.rows[0][0];
    console.log('Total leave days:', totalLeaveDays);

    // Release the Oracle database connection
    await connection.close();
    console.log('Database connection closed');

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



app.get('/api/monthly_leave_reports/:employeeId', async (req, res) => {
  const employeeId = parseInt(req.params.employeeId); // Convert to integer

  console.log('Received GET request at /api/monthly_leave_reports for employee ID:', req.params.employeeId); // Debugging

  try {
    console.log('Parsed employee ID:', employeeId); // Debugging

    // Check if employeeId is a valid number
    if (isNaN(employeeId)) {
      return res.status(400).json({ error: 'Invalid employee ID' });
    }

    // Get the current month and year
    const now = new Date();
    const currentMonth = now.getMonth() + 1; // Months are 0-indexed, so add 1 to get the current month
    const currentYear = now.getFullYear();

    // Connect to Oracle Database
    const connection = await oracledb.getConnection(dbConfig);
    console.log('Connected to Oracle Database');

    // Execute the query to retrieve monthly leave reports for the specific employee
    const result = await connection.execute(
      `SELECT * FROM leave_application 
       WHERE EMPLOYEE_ID = :employeeId 
       AND EXTRACT(MONTH FROM START_DATE) = :month 
       AND EXTRACT(YEAR FROM START_DATE) = :year`,
      [employeeId, currentMonth, currentYear]
    ); // Use bind variables

    // Release the connection
    await connection.close();
    console.log('Connection closed successfully');

    if (result.rows.length > 0) {
      // Construct JSON response with array of monthly leave reports
      const monthlyLeaveReports = result.rows.map(row => {
        const leaveReportDetails = {};
        result.metaData.forEach((column, index) => {
          leaveReportDetails[column.name] = row[index];
        });
        return leaveReportDetails;
      });

      // Send monthly leave reports as JSON response
      res.status(200).json(monthlyLeaveReports);
    } else {
      res.status(404).json({ error: 'No monthly leave reports found for the employee for the current month' });
    }
  } catch (error) {
    console.error('Error:', error);
    // Send an error response
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

const nodemailer = require('nodemailer');

let transporter = nodemailer.createTransport({
  service: 'Gmail', // Or use any other SMTP service provider
  auth: {
      user: 'greeshmatheressa123@gmail.com',
      pass: 'tgnn evba lpvw tzwo'
  }
});

// Define a route to handle POST requests for sending emails
app.post('/send-email', (req, res) => {
  const { fromEmail, employeeEmail, ccRecipients, bccRecipients, subject, body } = req.body;

  // Setup email data
  let mailOptions = {
      from: fromEmail,
      to: employeeEmail,
      cc: ccRecipients,
      bcc: bccRecipients,
      subject: subject,
      text: body
  };

  // Send email
  transporter.sendMail(mailOptions, (error, info) => {
      if (error) {
          console.log(error);
          res.status(500).send('Failed to send email.');
      } else {
          console.log('Email sent: %s', info.messageId);
          res.status(200).send('Email sent successfully.');
      }
  });
});

/*const router = express.Router();
const nodemailer = require('nodemailer');

// Create a transporter object using SMTP
const transporter = nodemailer.createTransport({
  service: 'Gmail', // Or use any other SMTP service provider
  auth: {
    user: 'greeshmatheressa123@gmail.com', // Enter your email
    pass: 'tgnn evba lpvw tzwo' // Enter your email password
  }
});

// Route to send email
router.post('/send-email', async (req, res) => {
  const { recipientEmail, subject, body } = req.body;

  // Create email message
  const mailOptions = {
    from: 'greeshmatheressa123@gmail.com',
    to: recipientEmail,
    subject: subject,
    text: body
  };

  try {
    // Send email
    const info = await transporter.sendMail(mailOptions);
    console.log('Email sent: ' + info.response);
    res.status(200).send('Email sent successfully.');
  } catch (error) {
    console.log('Error sending email: ', error);
    res.status(500).send('Failed to send email.');
  }
});

module.exports = router;*/


app.get('/api/req', async (req, res) => {
  console.log('Received GET request at /api/req');

  try {
    // Extract status from request query
    const { status } = req.query;

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
          la.NUMBER_OF_DAYS,
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
          designation des ON e.DESIGNATION_ID = des.DESIGNATION_ID
       WHERE
          la.APPROVED_BYHR = :status`, // Replace ":status" with the actual status parameter
      [status]
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


app.get('/api/pending', async (req, res) => {
  console.log('Received GET request at /api/pending');

  try {
    // Extract status from request query
    const { status } = req.query;

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
          la.NUMBER_OF_DAYS,
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
          designation des ON e.DESIGNATION_ID = des.DESIGNATION_ID
       WHERE
       la.APPROVED_BYHR IS NULL`,
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



const { PDFDocument, StandardFonts, rgb } = require('pdf-lib');
const path = require('path');
const axios = require('axios');
const pdfDirectory = path.join(__dirname, 'pdfs');
if (!fs.existsSync(pdfDirectory)) {
  fs.mkdirSync(pdfDirectory);
}


const fetchLeaveData = (month, year, status, leaveType) => {
  let url;

  if (status === 'Pending') {
    url = `http://192.168.1.34:3000/api/pending?month=${month}&year=${year}`;
  } else if (status === 'All') {
    url = `http://192.168.1.34:3000/api/managereq?month=${month}&year=${year}`;
  } else {
    url = `http://192.168.1.34:3000/api/req?month=${month}&year=${year}`;
    if (status) {
      url += `&status=${status}`;
    }
  }

  if (leaveType && leaveType !== 'All') {
    url += `&leaveType=${leaveType}`;
  }

  return axios.get(url)
    .then(response => response.data)
    .catch(error => {
      console.error('Error fetching leave data:', error);
      return [];
    });
};

const fetchEmployeeDetails = (employeeId) => {
  return axios.get(`http://192.168.1.34:3000/api/employee/${employeeId}`)
    .then(response => {
      console.log('Employee Details Response:', response.data);
      const employeeName = response.data?.employee_name || 'Unknown';
      const deptName = response.data?.dept_name || 'Unknown';
      return { employeeName, deptName };
    })
    .catch(error => {
      console.error(`Error fetching employee details for ID ${employeeId}:`, error);
      return { employeeName: 'Unknown', deptName: 'Unknown' };
    });
};

const fetchLeaveTypeDetails = (leaveTypeId) => {
  return axios.get(`http://192.168.1.34:3000/api/leave-type/${leaveTypeId}`)
    .then(response => response.data)
    .catch(error => {
      console.error(`Error fetching leave type details for ID ${leaveTypeId}:`, error);
      return null;
    });
};

app.get('/api/generate-leave-report/:month/:year/:status?', (req, res) => {
  const { month, year, status } = req.params;
  const leaveType = req.query.leaveType || 'All';  // Get leave type from query parameters

  console.log(`Generating leave report for ${month}-${year} with status ${status || 'all'} and leave type ${leaveType}`);

  fetchLeaveData(month, year, status, leaveType).then(leaveData => {
    PDFDocument.create().then(async pdfDoc => {
      // Use A4 dimensions: 595.28 x 841.89 points
      let page = pdfDoc.addPage([595.28, 841.89]);
      const cellPadding = 5; 
      const logoPath = path.join(__dirname, 'company_logo.png');
      const logoImageBytes = fs.readFileSync(logoPath);

      const logoImage = await pdfDoc.embedPng(logoImageBytes);
      const font = await pdfDoc.embedFont(StandardFonts.Helvetica);
      const boldFont = await pdfDoc.embedFont(StandardFonts.HelveticaBold);

      const logoScale = 0.1;
      const logoDims = logoImage.scale(logoScale);
      page.drawImage(logoImage, {
        x: 50,
        y: page.getHeight() - logoDims.height - 50,
        width: logoDims.width,
        height: logoDims.height,
      });

      const companyName = "Your Company Name";
      const companyAddressLine1 = "1234 Company Address";
      const companyAddressLine2 = "City";
      const companyAddressLine3 = "Country";

      page.drawText(companyName, {
        x: 50 + logoDims.width + 10,
        y: page.getHeight() - 90,
        size: 18,
        font: boldFont,
        color: rgb(0, 0, 0),
      });

      page.drawText(companyAddressLine1, {
        x: 50 + logoDims.width + 10,
        y: page.getHeight() - 120,
        size: 12,
        font: font,
        color: rgb(0, 0, 0),
      });

      page.drawText(companyAddressLine2, {
        x: 50 + logoDims.width + 10,
        y: page.getHeight() - 140,
        size: 12,
        font: font,
        color: rgb(0, 0, 0),
      });

      page.drawText(companyAddressLine3, {
        x: 50 + logoDims.width + 10,
        y: page.getHeight() - 160,
        size: 12,
        font: font,
        color: rgb(0, 0, 0),
      });

      const { width, height } = page.getSize();
      const fontSize = 12;
      const margin = 50;
      let yPosition = height - margin - logoDims.height - 100;

      page.drawText(`Leave Report for ${month} ${year} (${status || 'All'}) (${leaveType})`, {
        x: margin,
        y: yPosition,
        size: 24,
        font: boldFont,
        color: rgb(0, 0, 1),
      });

      yPosition -= 60;

      const headers = ['Application Date', 'Employee Name', 'Department', 'Leave Type', 'Leave Days'];
      const maxWidths = [110, 150, 90, 90, 90]; // Max widths for other columns
      const leaveDaysMaxWidth = width - margin - (maxWidths.reduce((a, b) => a + b, 0)) - 20; // Adjust for padding and line thickness
      const leaveDaysWidth = Math.min(leaveDaysMaxWidth, 80); // Leave Days column width

      const columnWidths = [...maxWidths, leaveDaysWidth];

      // Draw headers
      headers.forEach((header, headerIndex) => {
        const headerX = margin + columnWidths.slice(0, headerIndex).reduce((a, b) => a + b, 0);
        const headerY = yPosition + 30; // Adjust header position as needed
        const headerHeight = 30; // Adjust header height as needed

        // Draw header background
        page.drawRectangle({
          x: headerX,
          y: headerY - headerHeight,
          width: columnWidths[headerIndex],
          height: headerHeight,
          color: rgb(0.8, 0.8, 0.8), // Light gray background
          borderColor: rgb(0, 0, 0),
          borderWidth: 1,
        });

        // Draw header text
        page.drawText(header, {
          x: headerX + cellPadding,
          y: headerY - headerHeight + cellPadding,
          size: fontSize,
          font: boldFont,
          color: rgb(0, 0, 0), // Black text color
        });
      });

      const processLeaveData = (index) => {
        if (index >= leaveData.length) {
          // Save PDF and send response
          return pdfDoc.save().then(pdfBytes => {
            const pdfFilePath = path.join(pdfDirectory, `leave_report_${month}_${year}${status ? `_${status}` : ''}${leaveType !== 'All' ? `_${leaveType}` : ''}.pdf`);
            fs.writeFileSync(pdfFilePath, pdfBytes);

            console.log('Leave report PDF generated successfully');

            res.status(200).json({ pdfPath: pdfFilePath });
          }).catch(error => {
            console.error('Error saving PDF:', error);
            res.status(500).send('Error generating leave report PDF');
          });
        }

        const leave = leaveData[index];

        fetchEmployeeDetails(leave.EMPLOYEE_ID).then(({ employeeName, deptName }) => {
          fetchLeaveTypeDetails(leave.LEAVE_TYPE_ID).then(leaveTypeDetails => {
            const leaveTypeName = leaveTypeDetails ? (leaveTypeDetails.LEAVE_NAME || 'Unknown') : 'Unknown';

            const leaveDetails = [
              leave.DATE_OF_APPLICATION || 'N/A',
              employeeName,
              deptName,
              leaveTypeName,
              leave.NUMBER_OF_DAYS ? leave.NUMBER_OF_DAYS.toString() : 'N/A',
            ];

            // Draw cells
            leaveDetails.forEach((detail, detailIndex) => {
              const cellX = margin + columnWidths.slice(0, detailIndex).reduce((a, b) => a + b, 0);
              const cellY = yPosition;
              const cellHeight = 30; // Adjust as needed

              // Draw cell background
              const bgColor = index % 2 === 0 ? rgb(0.9, 0.9, 0.9) : rgb(1, 1, 1); // Alternate row colors
              page.drawRectangle
              ({
                x: cellX,
                y: cellY - cellHeight,
                width: columnWidths[detailIndex],
                height: cellHeight,
                color: bgColor,
                borderColor: rgb(0, 0, 0),
                borderWidth: 1,
              });

              // Draw cell content
              page.drawText(detail.toString(), {
                x: cellX + cellPadding,
                y: cellY - cellHeight + cellPadding,
                size: fontSize,
                font: font,
                color: rgb(0, 0, 0), // Black text color
              });
            });

            // Draw horizontal line between rows
            page.drawLine({
              start: { x: margin, y: yPosition - 2 },
              end: { x: width - margin, y: yPosition - 2 },
              thickness: 0.5,
              color: rgb(0.8, 0.8, 0.8),
            });

            yPosition -= 30; // Increased spacing between rows

            if (yPosition < margin) {
              // Add new page if there's not enough space
              page = pdfDoc.addPage([595.28, 841.89]);
              yPosition = page.getHeight() - margin;
            }

            // Process next leave data
            processLeaveData(index + 1);
          }).catch(error => {
            console.error('Error fetching leave type details:', error);
            res.status(500).send('Error generating leave report PDF');
          });
        }).catch(error => {
          console.error('Error fetching employee details:', error);
          res.status(500).send('Error generating leave report PDF');
        });
      };

      // Start processing leave data
      processLeaveData(0);
    }).catch(error => {
      console.error('Error creating PDF document:', error);
      res.status(500).send('Error generating leave report PDF');
    });
  }).catch(error => {
    console.error('Error fetching leave data:', error);
    res.status(500).send('Error generating leave report PDF');
  });
});


app.get('/api/emprprt/:employeeId', async (req, res) => {
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
      [result.rows[0][11]] // Assuming dept_id is in the 10th column of the employee table
    );
    console.log('Department Result:', deptResult);


    const designationResult = await connection.execute(
      'SELECT designation_name FROM designation WHERE designation_id = :desigId',
      [result.rows[0][12]] // Assuming designation_id is in the 11th column of the employee table
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
        doj: result.rows[0][13],
        dob: result.rows[0][4],
        gender: result.rows[0][5],
        email: result.rows[0][6],
        phno: result.rows[0][7],
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


app.get('/api/empall', async (req, res) => {
  console.log('Received GET request at /api/empall');

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


app.get('/api/empdata', async (req, res) => {
  console.log('Received GET request at /api/empdata');
  const gender = req.query.gender;

  try {
    // Connect to Oracle Database
    const connection = await oracledb.getConnection(dbConfig);
    console.log('Connected to Oracle Database');

    // Execute the query to retrieve employee details along with department and designation names
    let query;
    let binds;
    if (gender === undefined || gender === '') {
      query = `SELECT e.*, d.DEPT_SHORT_NAME, des.DESIGNATION_NAME 
              FROM employee e 
              INNER JOIN dept d ON e.DEPT_ID = d.DEPT_ID
              INNER JOIN designation des ON e.DESIGNATION_ID = des.DESIGNATION_ID`;
      binds = {};
    } else {
      query = `SELECT e.*, d.DEPT_SHORT_NAME, des.DESIGNATION_NAME 
              FROM employee e 
              INNER JOIN dept d ON e.DEPT_ID = d.DEPT_ID
              INNER JOIN designation des ON e.DESIGNATION_ID = des.DESIGNATION_ID
              WHERE e.GENDER = :gender`;
      binds = { gender };
    }

    const result = await connection.execute(query, binds);

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
      // Send an empty array as response when no employees are found
      res.status(200).json([]);
    }
  } catch (error) {
    console.error('Error fetching employee data:', error);

    // Send an error response
    res.status(500).json({ error: 'Internal Server Error' });
  }
});




const fetchEmpDetails = (employeeId) => {
  return axios.get(`http://192.168.1.34:3000/api/emprprt/${employeeId}`)
    .then(response => {
      console.log('Employee Details Response:', response.data);
      const employeeId = response.data?.employee_id || 'Unknown';
      const employeeName = response.data?.employee_name || 'Unknown';
      const dateOfJoining = response.data?.doj || 'Unknown';
      const dateOfBirth = response.data?.dob || 'Unknown';
      const gender = response.data?.gender || 'Unknown';
      const email = response.data?.email || 'Unknown';
      const phoneNumber = response.data?.phno || 'Unknown';
      const username = response.data?.username || 'Unknown';
      const password = response.data?.password || 'Unknown';
      const department = response.data?.department || 'Unknown';
      const designation = response.data?.designation || 'Unknown';
      return { employeeId, employeeName, dateOfJoining, dateOfBirth, gender, email, phoneNumber, username, password, department, designation };
    })
    .catch(error => {
      console.error(`Error fetching employee details for ID ${employeeId}:`, error);
      return { 
        employeeId: 'Unknown',
        employeeName: 'Unknown', 
        dateOfJoining: 'Unknown',
        dateOfBirth: 'Unknown',
        gender: 'Unknown',
        email: 'Unknown',
        phoneNumber: 'Unknown',
        username: 'Unknown',
        password: 'Unknown',
        department: 'Unknown',
        designation: 'Unknown',
      };
    });
};


const fetchEmployeeData = (gender) => {
  let url;
  if (gender === null || gender === undefined) {
    url = 'http://192.168.1.34:3000/api/empall'; // Use the endpoint for fetching all employees
  } else {
    url = `http://192.168.1.34:3000/api/empdata?gender=${gender}`; // Use the endpoint for fetching specific gender
  }
  return axios.get(url)
    .then(response => response.data)
    .catch(error => {
      console.error('Error fetching employee data:', error);
      return [];
    });
};



app.get('/api/generate-emp-report/:gender', (req, res) => {
  const { gender } = req.params;

  let reportTitle = '';
  let pdfFileName = '';

  if (gender === null || gender === undefined) {
    reportTitle = 'Employee Report';
    pdfFileName = 'employee_report_all.pdf';
  } else {
    reportTitle = `Employee Report for ${gender}`;
    pdfFileName = `employee_report_${gender}.pdf`;
  }

  // Fetch employee data based on gender
  fetchEmployeeData(gender).then(async (employeeData) => {
    console.log('Employee Data:', employeeData); 
    const pdfDoc = await PDFDocument.create();
    let page = pdfDoc.addPage([595.28, 841.89]); // Use A4 dimensions: 595.28 x 841.89 points
    const cellPadding = 5;
    const logoPath = path.join(__dirname, 'company_logo.png');
    const logoImageBytes = fs.readFileSync(logoPath);
    const logoImage = await pdfDoc.embedPng(logoImageBytes);
    const font = await pdfDoc.embedFont(StandardFonts.Helvetica);
    const boldFont = await pdfDoc.embedFont(StandardFonts.HelveticaBold);
    const logoScale = 0.1;
    const logoDims = logoImage.scale(logoScale);

    // Draw company logo and details
    page.drawImage(logoImage, {
      x: 50,
      y: page.getHeight() - logoDims.height - 50,
      width: logoDims.width,
      height: logoDims.height,
    });
    const companyName = "Your Company Name";
    const companyAddressLine1 = "1234 Company Address";
    const companyAddressLine2 = "City";
    const companyAddressLine3 = "Country";
    page.drawText(companyName, {
      x: 50 + logoDims.width + 10,
      y: page.getHeight() - 90,
      size: 18,
      font: boldFont,
      color: rgb(0, 0, 0),
    });
    page.drawText(companyAddressLine1, {
      x: 50 + logoDims.width + 10,
      y: page.getHeight() - 120,
      size: 12,
      font: font,
      color: rgb(0, 0, 0),
    });
    page.drawText(companyAddressLine2, {
      x: 50 + logoDims.width + 10,
      y: page.getHeight() - 140,
      size: 12,
      font: font,
      color: rgb(0, 0, 0),
    });
    page.drawText(companyAddressLine3, {
      x: 50 + logoDims.width + 10,
      y: page.getHeight() - 160,
      size: 12,
      font: font,
      color: rgb(0, 0, 0),
    });

    const { width, height } = page.getSize();
    const fontSize = 12;
    const margin = 50;
    let yPosition = height - margin - logoDims.height - 100;

    // Draw report title
    page.drawText(`Employee Report for ${gender}`, {
      x: margin,
      y: yPosition,
      size: 24,
      font: boldFont,
      color: rgb(0, 0, 1),
    });
    yPosition -= 60; // Move Y position down after drawing headers
    // Draw headers for employee data
    const headers = [
      'ID', 'Name', 'DOJ', 'DOB', 
      'Email', 'Ph No'
    ];
    const columnWidths = [50, 130, 70, 70, 170,75]; // Max widths for columns

    // Draw headers
    headers.forEach((header, headerIndex) => {
      const headerX = margin + columnWidths.slice(0, headerIndex).reduce((a, b) => a + b, 0);
      const headerY = yPosition + 30; // Adjust header position as needed
      const headerHeight = 30; // Adjust header height as needed

      // Draw header background
      page.drawRectangle({
        x: headerX-30,
        y: headerY - headerHeight,
        width: columnWidths[headerIndex],
        height: headerHeight,
        color: rgb(0.8, 0.8, 0.8), // Light gray background
        borderColor: rgb(0, 0, 0),
        borderWidth: 1,
      });

      // Draw header text
      page.drawText(header, {
        x: headerX-25 ,
        y: headerY - headerHeight + cellPadding,
        size: fontSize,
        font: boldFont,
        color: rgb(0, 0, 0), // Black text color
      });
    });



    const processEmployeeData = (index) => {
      if (index >= employeeData.length) {
        // Save PDF and send response
        return pdfDoc.save().then(pdfBytes => {
          const pdfFilePath = path.join(pdfDirectory, `employee_report_${gender}.pdf`);
          fs.writeFileSync(pdfFilePath, pdfBytes);

          console.log('Employee report PDF generated successfully');

          res.status(200).json({ pdfPath: pdfFilePath });
        }).catch(error => {
          console.error('Error saving PDF:', error);
          res.status(500).send('Error generating employee report PDF');
        });
      }

      const employee = employeeData[index];

      fetchEmpDetails(employee.EMPLOYEE_ID).then(details => {
        // Draw employee details
        const employeeDetails = [
          details.employeeId,
          details.employeeName,
          details.dateOfJoining,
          details.dateOfBirth,
          details.email,
          details.phoneNumber,
         
        ];

        // Draw cells
        employeeDetails.forEach((detail, detailIndex) => {
          const cellX = margin + columnWidths.slice(0, detailIndex).reduce((a, b) => a + b, 0);
          const cellY = yPosition;
          const cellHeight = 30; // Adjust as needed

          // Draw cell background
          const bgColor = index % 2 === 0 ? rgb(0.9, 0.9, 0.9) : rgb(1, 1, 1); // Alternate row colors
          page.drawRectangle({
            x: cellX-30,
            y: cellY - cellHeight,
            width: columnWidths[detailIndex],
            height: cellHeight,
            color: bgColor,
            borderColor: rgb(0, 0, 0),
            borderWidth: 1,
          });

          // Draw cell content
          page.drawText(detail.toString(), {
            x: cellX-25,
            y: cellY - cellHeight + cellPadding,
            size: fontSize,
            font: font,
            color: rgb(0, 0, 0), // Black text color
          });
        });

        // Draw horizontal line between rows
        page.drawLine({
          start: { x: margin, y: yPosition - 2 },
          end: { x: width - margin, y: yPosition - 2 },
          thickness: 0.5,
          color: rgb(0.8, 0.8, 0.8),
        });

        yPosition -= 30; // Increased spacing between rows

        if (yPosition < margin) {
          // Add new page if there's not enough space
          page = pdfDoc.addPage([595.28, 841.89]);
          yPosition = page.getHeight() - margin;
        }

        // Process next employee data
        processEmployeeData(index + 1);
      }).catch(error => {
        console.error('Error fetching employee details:', error);
        res.status(500).send('Error generating employee report PDF');
      });
    };

    // Start processing employee data
    processEmployeeData(0);
  }).catch(error => {
    console.error('Error fetching employee data:', error);
    res.status(500).send('Error generating employee report PDF');
  });
});


app.get('/api/generate-emp-report-all', (req, res) => {
  const { gender } = req.params;

 

  // Fetch employee data based on gender
  fetchEmployeeData().then(async (employeeData) => {
    console.log('Employee Data:', employeeData); 
    const pdfDoc = await PDFDocument.create();
    let page = pdfDoc.addPage([595.28, 841.89]); // Use A4 dimensions: 595.28 x 841.89 points
    const cellPadding = 5;
    const logoPath = path.join(__dirname, 'company_logo.png');
    const logoImageBytes = fs.readFileSync(logoPath);
    const logoImage = await pdfDoc.embedPng(logoImageBytes);
    const font = await pdfDoc.embedFont(StandardFonts.Helvetica);
    const boldFont = await pdfDoc.embedFont(StandardFonts.HelveticaBold);
    const logoScale = 0.1;
    const logoDims = logoImage.scale(logoScale);

    // Draw company logo and details
    page.drawImage(logoImage, {
      x: 50,
      y: page.getHeight() - logoDims.height - 50,
      width: logoDims.width,
      height: logoDims.height,
    });
    const companyName = "Your Company Name";
    const companyAddressLine1 = "1234 Company Address";
    const companyAddressLine2 = "City";
    const companyAddressLine3 = "Country";
    page.drawText(companyName, {
      x: 50 + logoDims.width + 10,
      y: page.getHeight() - 90,
      size: 18,
      font: boldFont,
      color: rgb(0, 0, 0),
    });
    page.drawText(companyAddressLine1, {
      x: 50 + logoDims.width + 10,
      y: page.getHeight() - 120,
      size: 12,
      font: font,
      color: rgb(0, 0, 0),
    });
    page.drawText(companyAddressLine2, {
      x: 50 + logoDims.width + 10,
      y: page.getHeight() - 140,
      size: 12,
      font: font,
      color: rgb(0, 0, 0),
    });
    page.drawText(companyAddressLine3, {
      x: 50 + logoDims.width + 10,
      y: page.getHeight() - 160,
      size: 12,
      font: font,
      color: rgb(0, 0, 0),
    });

    const { width, height } = page.getSize();
    const fontSize = 12;
    const margin = 50;
    let yPosition = height - margin - logoDims.height - 100;

    // Draw report title
    page.drawText(`Employee Report`, {
      x: margin,
      y: yPosition,
      size: 24,
      font: boldFont,
      color: rgb(0, 0, 1),
    });
    yPosition -= 60; // Move Y position down after drawing headers
    // Draw headers for employee data
    const headers = [
      'ID', 'Name', 'DOJ', 'DOB', 
      'Email', 'Ph No'
    ];
    const columnWidths = [50, 130, 70, 70, 170,75]; // Max widths for columns

    // Draw headers
    headers.forEach((header, headerIndex) => {
      const headerX = margin + columnWidths.slice(0, headerIndex).reduce((a, b) => a + b, 0);
      const headerY = yPosition + 30; // Adjust header position as needed
      const headerHeight = 30; // Adjust header height as needed

      // Draw header background
      page.drawRectangle({
        x: headerX-30,
        y: headerY - headerHeight,
        width: columnWidths[headerIndex],
        height: headerHeight,
        color: rgb(0.8, 0.8, 0.8), // Light gray background
        borderColor: rgb(0, 0, 0),
        borderWidth: 1,
      });

      // Draw header text
      page.drawText(header, {
        x: headerX-25 ,
        y: headerY - headerHeight + cellPadding,
        size: fontSize,
        font: boldFont,
        color: rgb(0, 0, 0), // Black text color
      });
    });



    const processEmployeeData = (index) => {
      if (index >= employeeData.length) {
        // Save PDF and send response
        return pdfDoc.save().then(pdfBytes => {
          const pdfFilePath = path.join(pdfDirectory, `employee_report.pdf`);
          fs.writeFileSync(pdfFilePath, pdfBytes);

          console.log('Employee report PDF generated successfully');

          res.status(200).json({ pdfPath: pdfFilePath });
        }).catch(error => {
          console.error('Error saving PDF:', error);
          res.status(500).send('Error generating employee report PDF');
        });
      }

      const employee = employeeData[index];

      fetchEmpDetails(employee.EMPLOYEE_ID).then(details => {
        // Draw employee details
        const employeeDetails = [
          details.employeeId,
          details.employeeName,
          details.dateOfJoining,
          details.dateOfBirth,
          details.email,
          details.phoneNumber,
         
        ];

        // Draw cells
        employeeDetails.forEach((detail, detailIndex) => {
          const cellX = margin + columnWidths.slice(0, detailIndex).reduce((a, b) => a + b, 0);
          const cellY = yPosition;
          const cellHeight = 30; // Adjust as needed

          // Draw cell background
          const bgColor = index % 2 === 0 ? rgb(0.9, 0.9, 0.9) : rgb(1, 1, 1); // Alternate row colors
          page.drawRectangle({
            x: cellX-30,
            y: cellY - cellHeight,
            width: columnWidths[detailIndex],
            height: cellHeight,
            color: bgColor,
            borderColor: rgb(0, 0, 0),
            borderWidth: 1,
          });

          // Draw cell content
          page.drawText(detail.toString(), {
            x: cellX-25,
            y: cellY - cellHeight + cellPadding,
            size: fontSize,
            font: font,
            color: rgb(0, 0, 0), // Black text color
          });
        });

        // Draw horizontal line between rows
        page.drawLine({
          start: { x: margin, y: yPosition - 2 },
          end: { x: width - margin, y: yPosition - 2 },
          thickness: 0.5,
          color: rgb(0.8, 0.8, 0.8),
        });

        yPosition -= 30; // Increased spacing between rows

        if (yPosition < margin) {
          // Add new page if there's not enough space
          page = pdfDoc.addPage([595.28, 841.89]);
          yPosition = page.getHeight() - margin;
        }

        // Process next employee data
        processEmployeeData(index + 1);
      }).catch(error => {
        console.error('Error fetching employee details:', error);
        res.status(500).send('Error generating employee report PDF');
      });
    };

    // Start processing employee data
    processEmployeeData(0);
  }).catch(error => {
    console.error('Error fetching employee data:', error);
    res.status(500).send('Error generating employee report PDF');
  });
});




app.listen(port, '192.168.1.34', () => {
  console.log(`Server is running at http://192.168.1.34:${port}`);
});
