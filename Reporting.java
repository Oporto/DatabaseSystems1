import java.sql.DriverManager;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Scanner;

public class Reporting {

    public static void main(String[] argv) {

        String username = argv[1];
        String password = argv[2];
        
        
        System.out.println("-------- Oracle JDBC Connection Testing ------");
        System.out.println("-------- Step 1: Registering Oracle Driver ------");
        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            return;
        }

        System.out.println("Oracle JDBC Driver Registered Successfully !");


        System.out.println("-------- Step 2: Building a Connection ------");
        Connection connection = null;
        try {
            connection = DriverManager.getConnection(
                    "jdbc:oracle:thin:@oracle.wpi.edu:1521:orcl", username,
                    password);
        } catch (SQLException e) {
            System.out.println("Connection Failed! Check output console");
            e.printStackTrace();
            return;
        }
        if (connection == null) {
            System.out.println("Failed to make connection!");
        }
        //Start of program after connection is set
        switch (argv[3]){
            case 1:
                ReportPatients(connection);
                break;
            case 2:
                ReportDoctor(connection);
                break;
            case 3:
                ReportAdmissions(connection);
                break;
            case 4:
                UpdateAdmissions(connection);
                break;
        }
    }
    //Reports patients basic information
    /**
     * User Input: Enter Patient SSN: <and wait for user’s input>
     * Output:  Patient SSN: ….
                Patient First Name: …
                Patient Last Name: …
                Patient Address: …
     */
    private static void ReportPatients(Connection connection){
        Statement stmt = null;
        String query = "Select FirstName, LastName, Address FROM Patient WHERE SSN = ";
        Scanner reader = new Scanner(System.in);  // Reading from System.in
        System.out.println("Enter Patient SSN: ");
        int ssn = reader.nextInt();
        query = query.concat(ssn);
        try {
            stmt = connection.createStatement();
            ResultSet rs = stmt.executeQuery(query);
            while (rs.next()) {
                String FirstName = rs.getString("FirstName");
                String LastName = rs.getString("LastName");
                String Address = rs.getString("Address");
                System.out.println("Patient SSN: " + ssn);
                System.out.println("Patient First Name: " + FirstName);
                System.out.println("Patient Last Name: " + LastName);
                System.out.println("Patient Address: " + Address);
            }
        } catch (SQLException e ) {
            JDBCTutorialUtilities.printSQLException(e);
        } finally {
            if (stmt != null) { stmt.close(); }
        }
    }
    //Reports Doctors basic information
    /**
     * User Input: Enter Doctor ID: <and wait for user’s input>
     * Output:  Doctor ID: ….
                Doctor First Name: …
                Doctor Last Name: …
                Doctor Gender: …
     */
    private static void ReportDoctors(Connection connection){
        Statement stmt = null;
        String query = "Select FirstName, LastName, Gender FROM Doctor WHERE DoctorID = ";
        Scanner reader = new Scanner(System.in);  // Reading from System.in
        System.out.println("Enter DoctorID: ");
        int id = reader.nextInt();
        query = query.concat(id);
        try {
            stmt = connection.createStatement();
            ResultSet rs = stmt.executeQuery(query);
            while (rs.next()) {
                String FirstName = rs.getString("FirstName");
                String LastName = rs.getString("LastName");
                String Gender = rs.getString("Gender");
                System.out.println("Doctor ID: " + ssn);
                System.out.println("Doctor First Name: " + FirstName);
                System.out.println("Doctor Last Name: " + LastName);
                System.out.println("Doctor Gender: " + Gender);
            }
        } catch (SQLException e ) {
            JDBCTutorialUtilities.printSQLException(e);
        } finally {
            if (stmt != null) { stmt.close(); }
        }
    }
    //Report Admissions Information
    /**
     * User Input: Enter Admission Number: <and wait for user’s input>
     * Output:  Admission Number: ….
                Patient SSN: …
                Admission date (start date): …..
                Total Payment: …
                Rooms:
                    RoomNum: … FromDate:…. ToDate:…..
                    RoomNum: … FromDate:…. ToDate: ….
                …
                Doctors examined the patient in this admission:
                    Doctor ID: …
                    Doctor ID: …
                …. 
     */
    private static void ReportAdmissions(Connection connection){
        Statement stmt = null;
        String query = "Select PatientSSN, AdmissionDate, TotalPayment FROM Admission WHERE AdmissionNum = ";
        Scanner reader = new Scanner(System.in);  // Reading from System.in
        System.out.println("Enter Admission Number: ");
        int num = reader.nextInt();
        query = query.concat(num);
        try {
            stmt = connection.createStatement();
            ResultSet rs = stmt.executeQuery(query);
            while (rs.next()) {
                String SSN = rs.getString("PatientSSN");
                String Date = rs.getString("AdmissionDate");
                String Payment = rs.getString("TotalPayment");
                System.out.println("Admission Number: " + num);
                System.out.println("Patient SSN: " + SSN);
                System.out.println("Admission Date (Start Date): " + Date);
                System.out.println("Total Payment: " + Payment);
            }
        } catch (SQLException e ) {
            JDBCTutorialUtilities.printSQLException(e);
        } finally {
            if (stmt != null) { stmt.close(); }
        }
        System.out.println("Rooms:");
        query = "Select RoomNum, StartDate, EndDate FROM StayIn WHERE AdmissionNum = ";
        query = query.concat(num);
        try {
            stmt = connection.createStatement();
            ResultSet rs = stmt.executeQuery(query);
            while (rs.next()) {
                String num = rs.getString("RoomNum");
                String start = rs.getString("StartDate");
                String end = rs.getString("EndDate");
                System.out.println("RoomNum: " + RoomNum + "StartDate: " + start + "EndDate: " + end);
            }
        } catch (SQLException e ) {
            JDBCTutorialUtilities.printSQLException(e);
        } finally {
            if (stmt != null) { stmt.close(); }
        }
        System.out.println("Doctors examined the patient in this admission:")
        query = "Select DoctorID FROM Examine WHERE AdmissionNum = ";
        query = query.concat(num);
        try {
            stmt = connection.createStatement();
            ResultSet rs = stmt.executeQuery(query);
            while (rs.next()) {
                int id = rs.getInt("DoctorID");
                System.out.println("DoctorID: " + id);
            }
        } catch (SQLException e ) {
            JDBCTutorialUtilities.printSQLException(e);
        } finally {
            if (stmt != null) { stmt.close(); }
        }
    }
    //Update Admissions Payment 
    /**
     * User Input:
     *      Enter Admission Number: <and wait for user’s input>
            Enter the new total payment: <and wait for user’s input> 
     */
    private static void UpdateAdmissions(Connection connection){
        PreparedStatement pstm = connection.prepareStatement("UPDATE Admission SET TotalPayment = ? WHERE AdmissionNum = ?");
        Scanner reader = new Scanner(System.in);  // Reading from System.in
        System.out.println("Enter Admission Number: ");
        int num = reader.nextInt();
        System.out.println("Enter the new total payment: ");
        int payment = reader.nextInt();
        pstm.setInt(1,num);
        pstm.setInt(2,payment);
        try{
            pstm.executeUpdate();
        } catch (SQLException e ) {
            JDBCTutorialUtilities.printSQLException(e);
        } finally {
            if (psmt != null) { stmt.close(); }
        }
    }
    
}
