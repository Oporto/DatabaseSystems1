DROP TABLE StayIn;
DROP TABLE RoomAccess;
DROP TABLE RoomService;
DROP TABLE ServiceDone;
DROP TABLE Employee;
DROP TABLE EmployeeRank;
DROP TABLE Examine;
DROP TABLE Equipment;
DROP TABLE EquipmentType;
DROP TABLE Room;
DROP TABLE Admission;
DROP TABLE Patient;
DROP TABLE Doctor;



CREATE TABLE Doctor(
    DoctorID number(10),
    Gender varchar2(6) NOT NULL,
    Specialty varchar2(50) NOT NULL,
    FirstName varchar2(30) NOT NULL,
    LastName varchar2(30) NOT NULL,
    CONSTRAINT PK_Doctor PRIMARY KEY (DoctorID),
    CONSTRAINT CHK_gender check (Gender in ('male', 'female'))
);

CREATE TABLE Patient(
    SSN number(9),
    FirstName varchar2(30) NOT NULL,
    LastName varchar2(30) NOT NULL,
    Addr varchar2(50) NOT NULL,
    TelNum number(10) NOT NULL,
    CONSTRAINT PK_Patient PRIMARY KEY (SSN)
);

CREATE TABLE Admission(
    AdmissionNum number(10),
    AdmissionDate date NOT NULL,
    LeaveDate date,
    TotalPayment number(7) NOT NULL,
    InsurancePayment number(7) NOT NULL,
    PatientSSN number(9) NOT NULL,
    FutureVisit date,
    CONSTRAINT PK_Admission PRIMARY KEY (AdmissionNum),
    CONSTRAINT FK_PatientAdmission FOREIGN KEY (PatientSSN) REFERENCES Patient(SSN)
);

CREATE TABLE Room(
    RoomNum number(5),
    OccupiedFlag number(1) NOT NULL,
    CONSTRAINT PK_Room PRIMARY KEY (RoomNum),
    CONSTRAINT CHK_OccupiedFlag check (OccupiedFlag in (0,1))
);

CREATE TABLE EquipmentType(
    TypeID number(4),
    Descr varchar2(100) NOT NULL,
    Model varchar2(50) NOT NULL,
    Instructions varchar2(200) NOT NULL,
    NumberOfUnits number(2) NOT NULL,
    CONSTRAINT PK_EquipmentType PRIMARY KEY (TypeID)
);

CREATE TABLE Equipment(
    SerialNum varchar2(10),
    TypeID number(4) NOT NULL,
    PurchaseYear number(4) NOT NULL,
    LastInspection date,
    RoomNum number(5) NOT NULL,
    CONSTRAINT PK_Equipment PRIMARY KEY (SerialNum),
    CONSTRAINT FK_EquipmentType FOREIGN KEY (TypeId) REFERENCES EquipmentType(TypeID),
    CONSTRAINT FK_EquipmentRoom FOREIGN KEY (RoomNum) REFERENCES Room(RoomNum)
);

CREATE TABLE Examine(
    DoctorID number(10) NOT NULL,
    AdmissionNum number(10) NOT NULL,
    ExamineComment varchar2(500) NOT NULL,
    CONSTRAINT PK_Examine PRIMARY KEY (DoctorID, AdmissionNum),
    CONSTRAINT FK_ExamineDoctor FOREIGN KEY (DoctorID) REFERENCES Doctor(DoctorID),
    CONSTRAINT FK_ExamineAdmission FOREIGN KEY (AdmissionNum) REFERENCES Admission(AdmissionNum)
);

CREATE TABLE EmployeeRank(
    EmpRank number(1),
    RankName varchar2(20),
    CONSTRAINT PK_EmployeeRank PRIMARY KEY (EmpRank),
    CONSTRAINT CHK_RankName CHECK (RankName in ('Regular employees', 'Division managers', 'General managers')),
    CONSTRAINT U1_RankName UNIQUE (RankName)
);

CREATE TABLE Employee(
    EmployeeID number(10),
    FirstName varchar2(30) NOT NULL,
    LastName varchar2(30) NOT NULL,
    Salary number(7) NOT NULL,
    JobTitle varchar2(30) NOT NULL,
    OfficeNum number(3) NOT NULL,
    EmpRank number(1) NOT NULL,
    SupervisorID number(10),
    CONSTRAINT PK_Employee PRIMARY KEY (EmployeeID),
    CONSTRAINT CHK_ISA_Employee CHECK (EmpRank in (0,1,2)),
    CONSTRAINT FK_Supervisor FOREIGN KEY (SupervisorID) REFERENCES Employee(EmployeeID) ON DELETE SET NULL,
    CONSTRAINT FK_EmpRank FOREIGN KEY (EmpRank) REFERENCES EmployeeRank(EmpRank)
);

CREATE TABLE ServiceDone(
    ServiceNum number(5),
    ServiceName varchar2(50) NOT NULL,
    CONSTRAINT PK_ServiceDone PRIMARY KEY (ServiceNum)
);


CREATE TABLE RoomService(
    RoomNum number(5) NOT NULL,
    ServiceNum number(5) NOT NULL,
    CONSTRAINT PK_RoomService PRIMARY KEY (RoomNum, ServiceNum),
    CONSTRAINT FK_RoomServiceRoom FOREIGN KEY (RoomNum) REFERENCES Room(RoomNum),
    CONSTRAINT FK_RoomServiceService FOREIGN KEY (ServiceNum) REFERENCES ServiceDone(ServiceNum)
);

CREATE TABLE RoomAccess(
    RoomNum number(5) NOT NULL,
    EmployeeID number(10) NOT NULL,
    CONSTRAINT PK_RoomAccess PRIMARY KEY (RoomNum, EmployeeID),
    CONSTRAINT FK_RoomAccessRoom FOREIGN KEY (RoomNum) REFERENCES Room(RoomNum),
    CONSTRAINT FK_RoomAccessEmployee FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
);

CREATE TABLE StayIn(
    AdmissionNum number(10) NOT NULL,
    RoomNum number(5) NOT NULL,
    StartDate date NOT NULL,
    EndDate date,
    CONSTRAINT PK_StayIn PRIMARY KEY (AdmissionNum,RoomNum,StartDate),
    CONSTRAINT FK_StayInRoom FOREIGN KEY (RoomNum) REFERENCES Room(RoomNum),
    CONSTRAINT FK_StayInAdmission FOREIGN KEY (AdmissionNum) REFERENCES Admission(AdmissionNum)
);

INSERT INTO Patient(SSN, FirstName, LastName, Addr, TelNum)
VALUES (111223333, 'Fiona', 'Hagedorn', '100 Institute Road', 5085081111);
INSERT INTO Patient(SSN, FirstName, LastName, Addr, TelNum)
VALUES (112233334, 'Ian', 'McDonald', '101 Institute Road', 5095091112);
INSERT INTO Patient(SSN, FirstName, LastName, Addr, TelNum)
VALUES (113243335, 'Lip', 'Ferrara', '102 Institute Road', 5105101113);
INSERT INTO Patient(SSN, FirstName, LastName, Addr, TelNum)
VALUES (114253336, 'Carl', 'Resmini', '103 Institute Road', 5115111114);
INSERT INTO Patient(SSN, FirstName, LastName, Addr, TelNum)
VALUES (115263337, 'Mickey', 'Flinn', '104 Institute Road', 5125121115);
INSERT INTO Patient(SSN, FirstName, LastName, Addr, TelNum)
VALUES (116273338, 'Debbie', 'Ladd', '105 Institute Road', 5135131116);
INSERT INTO Patient(SSN, FirstName, LastName, Addr, TelNum)
VALUES (117283338, 'Frank', 'Pinzer', '106 Institute Road', 5145141117);
INSERT INTO Patient(SSN, FirstName, LastName, Addr, TelNum)
VALUES (118293339, 'Jimmy', 'Esworthy', '107 Institute Road', 5155151118);
INSERT INTO Patient(SSN, FirstName, LastName, Addr, TelNum)
VALUES (119393349, 'Kevin', 'McClean', '108 Institute Road', 5165161119);
INSERT INTO Patient(SSN, FirstName, LastName, Addr, TelNum)
VALUES (129493359, 'Mandy', 'Vasco', '109 Institute Road', 5175171129);

INSERT INTO Doctor(DoctorID, Gender, Specialty, FirstName, LastName)
VALUES (1, 'male', 'Feet', 'Ted', 'Hogan');
INSERT INTO Doctor(DoctorID, Gender, Specialty, FirstName, LastName)
VALUES (2, 'female', 'Respiratory', 'Lilly', 'Morrisson');
INSERT INTO Doctor(DoctorID, Gender, Specialty, FirstName, LastName)
VALUES (3, 'male', 'Physical therapy', 'Barney', 'Christakos');
INSERT INTO Doctor(DoctorID, Gender, Specialty, FirstName, LastName)
VALUES (4, 'female', 'Psychology', 'Robin', 'Lemay');
INSERT INTO Doctor(DoctorID, Gender, Specialty, FirstName, LastName)
VALUES (5, 'male', 'Plastic Surgery', 'Marshall', 'Fabbrini');
INSERT INTO Doctor(DoctorID, Gender, Specialty, FirstName, LastName)
VALUES (6, 'female', 'Pediatric', 'Sandy', 'DiCroce');
INSERT INTO Doctor(DoctorID, Gender, Specialty, FirstName, LastName)
VALUES (7, 'male', 'Gynecology', 'James', 'Panos');
INSERT INTO Doctor(DoctorID, Gender, Specialty, FirstName, LastName)
VALUES (8, 'female', 'Neural', 'Virginia', 'Rivers');
INSERT INTO Doctor(DoctorID, Gender, Specialty, FirstName, LastName)
VALUES (9, 'male', 'Dentist', 'Gary', 'Savukinas');
INSERT INTO Doctor(DoctorID, Gender, Specialty, FirstName, LastName)
VALUES (10, 'female', 'Nurse', 'Stella', 'Gauthier');

INSERT INTO Room(RoomNum,OccupiedFlag)
VALUES (101, 0);
INSERT INTO Room(RoomNum,OccupiedFlag)
VALUES (102, 1);
INSERT INTO Room(RoomNum,OccupiedFlag)
VALUES (103, 1);
INSERT INTO Room(RoomNum,OccupiedFlag)
VALUES (104, 1);
INSERT INTO Room(RoomNum,OccupiedFlag)
VALUES (201, 1);
INSERT INTO Room(RoomNum,OccupiedFlag)
VALUES (202, 1);
INSERT INTO Room(RoomNum,OccupiedFlag)
VALUES (203, 1);
INSERT INTO Room(RoomNum,OccupiedFlag)
VALUES (204, 1);
INSERT INTO Room(RoomNum,OccupiedFlag)
VALUES (301, 1);
INSERT INTO Room(RoomNum,OccupiedFlag)
VALUES (401, 1);
INSERT INTO Room(RoomNum,OccupiedFlag)
VALUES (501, 0);

INSERT INTO ServiceDone(ServiceNum, ServiceName)
VALUES (1,'MRI');
INSERT INTO ServiceDone(ServiceNum, ServiceName)
VALUES (2,'Ultrasound');
INSERT INTO ServiceDone(ServiceNum, ServiceName)
VALUES (3,'CT Scanner');
INSERT INTO ServiceDone(ServiceNum, ServiceName)
VALUES (4,'Small Surgeries');
INSERT INTO ServiceDone(ServiceNum, ServiceName)
VALUES (5,'Emergency Room');
INSERT INTO ServiceDone(ServiceNum, ServiceName)
VALUES (6,'ICU');

INSERT INTO RoomService(RoomNum, ServiceNum)
VALUES (101,1);
INSERT INTO RoomService(RoomNum, ServiceNum)
VALUES (101,3);
INSERT INTO RoomService(RoomNum, ServiceNum)
VALUES (101,4);
INSERT INTO RoomService(RoomNum, ServiceNum)
VALUES (102,1);
INSERT INTO RoomService(RoomNum, ServiceNum)
VALUES (102,2);
INSERT INTO RoomService(RoomNum, ServiceNum)
VALUES (103,1);
INSERT INTO RoomService(RoomNum, ServiceNum)
VALUES (103,2);
INSERT INTO RoomService(RoomNum, ServiceNum)
VALUES (103,3);
INSERT INTO RoomService(RoomNum, ServiceNum)
VALUES (103,4);
INSERT INTO RoomService(RoomNum, ServiceNum)
VALUES (104,6);
INSERT INTO RoomService(RoomNum, ServiceNum)
VALUES (201,6);
INSERT INTO RoomService(RoomNum, ServiceNum)
VALUES (202,6);
INSERT INTO RoomService(RoomNum, ServiceNum)
VALUES (203,6);
INSERT INTO RoomService(RoomNum, ServiceNum)
VALUES (204,6);
INSERT INTO RoomService(RoomNum, ServiceNum)
VALUES (301,5);
INSERT INTO RoomService(RoomNum, ServiceNum)
VALUES (401,5);
INSERT INTO RoomService(RoomNum, ServiceNum)
VALUES (501,4);

INSERT INTO EquipmentType(TypeID, Descr, Model, Instructions, NumberOfUnits)
VALUES (1, 'MRI Scanner', '2016-AX3', 'Plug it in and turn it on',3);
INSERT INTO EquipmentType(TypeID, Descr, Model, Instructions, NumberOfUnits)
VALUES (2, 'CT Scanner', 'CT-Premium-2018', 'Plug it in and turn it on', 4);
INSERT INTO EquipmentType(TypeID, Descr, Model, Instructions, NumberOfUnits)
VALUES (3, 'Blood Tester', 'BLD-RedCross-ExtraLarge', 'Plug it in and turn it on',3);

INSERT INTO Equipment(SerialNum, TypeID, PurchaseYear, LastInspection, RoomNum)
VALUES ('A01-02X', 1, 2010,TO_DATE('2018/05/03 13:02:44', 'yyyy/mm/dd hh24:mi:ss') ,101);
INSERT INTO Equipment(SerialNum, TypeID, PurchaseYear, LastInspection, RoomNum)
VALUES ('A02-02X', 1, 2011,TO_DATE('2018/05/03 13:12:05', 'yyyy/mm/dd hh24:mi:ss') ,102);
INSERT INTO Equipment(SerialNum, TypeID, PurchaseYear, LastInspection, RoomNum)
VALUES ('A03-02X', 1, 2018,TO_DATE('2018/05/03 13:25:30', 'yyyy/mm/dd hh24:mi:ss') ,103);
INSERT INTO Equipment(SerialNum, TypeID, PurchaseYear, LastInspection, RoomNum)
VALUES ('BB20-01AT', 2, 2018,TO_DATE('2019/02/03 10:02:44', 'yyyy/mm/dd hh24:mi:ss') ,101);
INSERT INTO Equipment(SerialNum, TypeID, PurchaseYear, LastInspection, RoomNum)
VALUES ('BB20-03AT', 2, 2019,TO_DATE('2019/02/03 10:12:30', 'yyyy/mm/dd hh24:mi:ss') ,101);
INSERT INTO Equipment(SerialNum, TypeID, PurchaseYear, LastInspection, RoomNum)
VALUES ('BB20-02AT', 2, 2018,TO_DATE('2019/02/03 10:01:00', 'yyyy/mm/dd hh24:mi:ss') ,103);
INSERT INTO Equipment(SerialNum, TypeID, PurchaseYear, LastInspection, RoomNum)
VALUES ('XY34-330', 3, 2010,TO_DATE('2019/01/10 08:35:05', 'yyyy/mm/dd hh24:mi:ss') ,301);
INSERT INTO Equipment(SerialNum, TypeID, PurchaseYear, LastInspection, RoomNum)
VALUES ('XY34-333', 3, 2015,TO_DATE('2019/01/10 08:45:46', 'yyyy/mm/dd hh24:mi:ss') ,301);
INSERT INTO Equipment(SerialNum, TypeID, PurchaseYear, LastInspection, RoomNum)
VALUES ('XY34-331', 3, 2012,TO_DATE('2019/01/10 08:25:24', 'yyyy/mm/dd hh24:mi:ss') ,401);

INSERT INTO Admission(AdmissionNum, AdmissionDate, LeaveDate, TotalPayment, InsurancePayment, PatientSSN, FutureVisit)
VALUES (111111113,TO_DATE('2018/05/03 13:02:44', 'yyyy/mm/dd hh24:mi:ss'), TO_DATE('2018/06/03 13:02:44', 'yyyy/mm/dd hh24:mi:ss'), 14050,7000, 111223333, TO_DATE('2018/07/03 13:02:44', 'yyyy/mm/dd hh24:mi:ss'));
INSERT INTO Admission(AdmissionNum, AdmissionDate, LeaveDate, TotalPayment, InsurancePayment, PatientSSN)
VALUES (111111112,TO_DATE('2018/07/03 13:02:44', 'yyyy/mm/dd hh24:mi:ss'), TO_DATE('2018/08/03 13:02:44', 'yyyy/mm/dd hh24:mi:ss'), 13000,9000, 111223333, TO_DATE('2018/07/20 13:02:44', 'yyyy/mm/dd hh24:mi:ss'));
INSERT INTO Admission(AdmissionNum, AdmissionDate, LeaveDate, TotalPayment, InsurancePayment, PatientSSN, FutureVisit)
VALUES (121222223,TO_DATE('2018/05/04 13:02:44', 'yyyy/mm/dd hh24:mi:ss'), TO_DATE('2018/05/05 13:02:44', 'yyyy/mm/dd hh24:mi:ss'), 140,140, 119393349, TO_DATE('2018/05/09 13:02:44', 'yyyy/mm/dd hh24:mi:ss'));
INSERT INTO Admission(AdmissionNum, AdmissionDate, LeaveDate, TotalPayment, InsurancePayment, PatientSSN)
VALUES (211111112,TO_DATE('2018/05/09 13:02:44', 'yyyy/mm/dd hh24:mi:ss'), TO_DATE('2018/05/10 13:02:44', 'yyyy/mm/dd hh24:mi:ss'), 140,140, 119393349);
INSERT INTO Admission(AdmissionNum, AdmissionDate, LeaveDate, TotalPayment, InsurancePayment, PatientSSN, FutureVisit)
VALUES (311111111,TO_DATE('2018/06/04 13:02:44', 'yyyy/mm/dd hh24:mi:ss'), TO_DATE('2018/06/05 13:02:44', 'yyyy/mm/dd hh24:mi:ss'), 1400,130, 118293339, TO_DATE('2018/07/09 13:02:44', 'yyyy/mm/dd hh24:mi:ss'));
INSERT INTO Admission(AdmissionNum, AdmissionDate, LeaveDate, TotalPayment, InsurancePayment, PatientSSN)
VALUES (311111112, TO_DATE('2018/07/09 13:02:44', 'yyyy/mm/dd hh24:mi:ss'), TO_DATE('2018/07/10 13:02:44', 'yyyy/mm/dd hh24:mi:ss'), 12000,1300, 118293339);
INSERT INTO Admission(AdmissionNum, AdmissionDate, LeaveDate, TotalPayment, InsurancePayment, PatientSSN, FutureVisit)
VALUES (411111111,TO_DATE('2018/07/20 13:02:44', 'yyyy/mm/dd hh24:mi:ss'), TO_DATE('2018/07/21 13:02:44', 'yyyy/mm/dd hh24:mi:ss'), 14001,132, 111223333, TO_DATE('2018/07/22 13:02:44', 'yyyy/mm/dd hh24:mi:ss'));
INSERT INTO Admission(AdmissionNum, AdmissionDate, LeaveDate, TotalPayment, InsurancePayment, PatientSSN, FutureVisit)
VALUES (411111112,TO_DATE('2018/07/22 13:02:44', 'yyyy/mm/dd hh24:mi:ss'), TO_DATE('2018/07/23 13:02:44', 'yyyy/mm/dd hh24:mi:ss'), 142,0, 111223333, TO_DATE('2018/07/25 13:02:44', 'yyyy/mm/dd hh24:mi:ss'));
INSERT INTO Admission(AdmissionNum, AdmissionDate, LeaveDate, TotalPayment, InsurancePayment, PatientSSN, FutureVisit)
VALUES (511111111,TO_DATE('2018/08/01 13:02:44', 'yyyy/mm/dd hh24:mi:ss'), TO_DATE('2018/08/02 13:02:44', 'yyyy/mm/dd hh24:mi:ss'), 18001,1320, 116273338, TO_DATE('2018/08/22 13:02:44', 'yyyy/mm/dd hh24:mi:ss'));
INSERT INTO Admission(AdmissionNum, AdmissionDate, LeaveDate, TotalPayment, InsurancePayment, PatientSSN)
VALUES (511111112, TO_DATE('2018/08/22 13:02:44', 'yyyy/mm/dd hh24:mi:ss'), TO_DATE('2018/08/23 13:02:44', 'yyyy/mm/dd hh24:mi:ss'), 118001,13200, 116273338);
INSERT INTO Admission(AdmissionNum, AdmissionDate, LeaveDate, TotalPayment, InsurancePayment, PatientSSN, FutureVisit)
VALUES (511116111,TO_DATE('2018/09/01 13:02:44', 'yyyy/mm/dd hh24:mi:ss'), TO_DATE('2018/09/02 13:02:44', 'yyyy/mm/dd hh24:mi:ss'), 18001,130, 117283338, TO_DATE('2018/09/22 13:02:44', 'yyyy/mm/dd hh24:mi:ss'));
INSERT INTO Admission(AdmissionNum, AdmissionDate, LeaveDate, TotalPayment, InsurancePayment, PatientSSN)
VALUES (511115112, TO_DATE('2018/09/22 13:02:44', 'yyyy/mm/dd hh24:mi:ss'), TO_DATE('2018/09/23 13:02:44', 'yyyy/mm/dd hh24:mi:ss'), 118001,1320, 117283338);

INSERT INTO EmployeeRank(EmpRank, RankName)
VALUES (0, 'Regular employees');
INSERT INTO EmployeeRank(EmpRank, RankName)
VALUES (1, 'Division managers');
INSERT INTO EmployeeRank(EmpRank, RankName)
VALUES (2, 'General managers');



INSERT INTO Employee(EmployeeID, FirstName, LastName, Salary, JobTitle, OfficeNum, EmpRank)
VALUES (20, 'Greg', 'TopDog', 1000000, 'TopDeskJob', 1, 2);
INSERT INTO Employee(EmployeeID, FirstName, LastName, Salary, JobTitle, OfficeNum, EmpRank)
VALUES (2, 'Grug', 'AlsoTopDog', 1000000, 'TopDeskJob', 2, 2);

INSERT INTO Employee(EmployeeID, FirstName, LastName, Salary, JobTitle, OfficeNum, EmpRank, SupervisorID)
VALUES (234567890, 'Matt', 'bossman', 100000, 'MidDeskJob', 10, 1, 20);
INSERT INTO Employee(EmployeeID, FirstName, LastName, Salary, JobTitle, OfficeNum, EmpRank, SupervisorID)
VALUES (234567891, 'Pedro', 'bossman', 100000, 'MidDeskJob', 11, 1, 20);
INSERT INTO Employee(EmployeeID, FirstName, LastName, Salary, JobTitle, OfficeNum, EmpRank, SupervisorID)
VALUES (234567892, 'Nico', 'bossman', 100000, 'MidDeskJob', 12, 1, 2);
INSERT INTO Employee(EmployeeID, FirstName, LastName, Salary, JobTitle, OfficeNum, EmpRank, SupervisorID)
VALUES (10, 'Momo', 'bossman', 100000, 'MidDeskJob', 13, 1, 2);


INSERT INTO Employee(EmployeeID, FirstName, LastName, Salary, JobTitle, OfficeNum, EmpRank, SupervisorID)
VALUES (1, 'Jon', 'Smith', 60000, 'DeskJob', 124, 0, 234567890);
INSERT INTO Employee(EmployeeID, FirstName, LastName, Salary, JobTitle, OfficeNum, EmpRank, SupervisorID)
VALUES (11, 'John', 'Smith', 60000, 'DeskJob', 123, 0, 234567890);
INSERT INTO Employee(EmployeeID, FirstName, LastName, Salary, JobTitle, OfficeNum, EmpRank, SupervisorID)
VALUES (12, 'Joe', 'mith', 60000, 'DeskJob', 125, 0, 234567890);
INSERT INTO Employee(EmployeeID, FirstName, LastName, Salary, JobTitle, OfficeNum, EmpRank, SupervisorID)
VALUES (13, 'Jim', 'Sith', 60000, 'DeskJob', 126, 0, 234567890);
INSERT INTO Employee(EmployeeID, FirstName, LastName, Salary, JobTitle, OfficeNum, EmpRank, SupervisorID)
VALUES (14, 'Jonny', 'Smit', 60000, 'DeskJob', 127, 0, 234567891);
INSERT INTO Employee(EmployeeID, FirstName, LastName, Salary, JobTitle, OfficeNum, EmpRank, SupervisorID)
VALUES (15, 'Josh', 'Smi', 60000, 'FrontDeskJob', 128, 0, 234567891);
INSERT INTO Employee(EmployeeID, FirstName, LastName, Salary, JobTitle, OfficeNum, EmpRank, SupervisorID)
VALUES (16, 'Matt', 'freed', 60000, 'DeskJob', 129, 0, 234567891);
INSERT INTO Employee(EmployeeID, FirstName, LastName, Salary, JobTitle, OfficeNum, EmpRank, SupervisorID)
VALUES (17, 'pedro', 'yeet', 60000, 'DeskJob', 130, 0, 234567892);
INSERT INTO Employee(EmployeeID, FirstName, LastName, Salary, JobTitle, OfficeNum, EmpRank, SupervisorID)
VALUES (18, 'andy', 'dwyer', 60000, 'DeskJob', 131, 0, 234567892);
INSERT INTO Employee(EmployeeID, FirstName, LastName, Salary, JobTitle, OfficeNum, EmpRank, SupervisorID)
VALUES (19, 'jimbo', 'jimboagain', 60000, 'FrontDeskJob', 132, 0, 10);

INSERT INTO RoomAccess(RoomNum, EmployeeID)
VALUES (101, 10);
INSERT INTO RoomAccess(RoomNum, EmployeeID)
VALUES (101, 2);
INSERT INTO RoomAccess(RoomNum, EmployeeID)
VALUES (102, 10);
INSERT INTO RoomAccess(RoomNum, EmployeeID)
VALUES (102, 2);
INSERT INTO RoomAccess(RoomNum, EmployeeID)
VALUES (103, 10);
INSERT INTO RoomAccess(RoomNum, EmployeeID)
VALUES (103, 2);
INSERT INTO RoomAccess(RoomNum, EmployeeID)
VALUES (104, 10);
INSERT INTO RoomAccess(RoomNum, EmployeeID)
VALUES (104, 2);
INSERT INTO RoomAccess(RoomNum, EmployeeID)
VALUES (501, 234567890);
INSERT INTO RoomAccess(RoomNum, EmployeeID)
VALUES (101, 234567891);
INSERT INTO RoomAccess(RoomNum, EmployeeID)
VALUES (201, 234567891);
INSERT INTO RoomAccess(RoomNum, EmployeeID)
VALUES (202, 234567891);
INSERT INTO RoomAccess(RoomNum, EmployeeID)
VALUES (203, 234567891);
INSERT INTO RoomAccess(RoomNum, EmployeeID)
VALUES (204, 234567891);

INSERT INTO Examine(DoctorID, AdmissionNum, ExamineComment)
VALUES (1, 111111113, 'Feet looks fine');
INSERT INTO Examine(DoctorID, AdmissionNum, ExamineComment)
VALUES (2, 111111113, 'Needs to stop smoking');
INSERT INTO Examine(DoctorID, AdmissionNum, ExamineComment)
VALUES (3, 111111113, 'Recommend Cardio');
INSERT INTO Examine(DoctorID, AdmissionNum, ExamineComment)
VALUES (4, 111111112, 'Happy as it could be');
INSERT INTO Examine(DoctorID, AdmissionNum, ExamineComment)
VALUES (1, 111111112, 'Feet not fine');
INSERT INTO Examine(DoctorID, AdmissionNum, ExamineComment)
VALUES (2, 111111112, 'Stopped smoking');
INSERT INTO Examine(DoctorID, AdmissionNum, ExamineComment)
VALUES (3, 111111112, 'Recommend Weight Training');
INSERT INTO Examine(DoctorID, AdmissionNum, ExamineComment)
VALUES (4, 411111111, 'Happy as it could be');
INSERT INTO Examine(DoctorID, AdmissionNum, ExamineComment)
VALUES (2, 411111111, 'Perfect Lungs');
INSERT INTO Examine(DoctorID, AdmissionNum, ExamineComment)
VALUES (3, 411111111, 'Recommend Swimming');
INSERT INTO Examine(DoctorID, AdmissionNum, ExamineComment)
VALUES (4, 411111111, 'Happier');
INSERT INTO Examine(DoctorID, AdmissionNum, ExamineComment)
VALUES (3, 411111112, 'Recommend Soccer');
INSERT INTO Examine(DoctorID, AdmissionNum, ExamineComment)
VALUES (4, 411111112, 'Happierer');

Insert INTO StayIn(AdmissionNum,RoomNum, StartDate, EndDate)
Values (111111113,104,TO_DATE('2018/05/03 13:02:44', 'yyyy/mm/dd hh24:mi:ss'),TO_DATE('2018/06/03 13:02:44', 'yyyy/mm/dd hh24:mi:ss'));
Insert INTO StayIn(AdmissionNum,RoomNum, StartDate, EndDate)
Values (111111113,201,TO_DATE('2018/05/03 13:02:44', 'yyyy/mm/dd hh24:mi:ss'),TO_DATE('2018/06/03 13:02:44', 'yyyy/mm/dd hh24:mi:ss'));
Insert INTO StayIn(AdmissionNum,RoomNum, StartDate, EndDate)
Values (111111113,202,TO_DATE('2018/05/03 13:02:44', 'yyyy/mm/dd hh24:mi:ss'),TO_DATE('2018/06/03 13:02:44', 'yyyy/mm/dd hh24:mi:ss'));
Insert INTO StayIn(AdmissionNum,RoomNum, StartDate, EndDate)
Values (111111113,204,TO_DATE('2018/05/03 13:02:44', 'yyyy/mm/dd hh24:mi:ss'),TO_DATE('2018/06/03 13:02:44', 'yyyy/mm/dd hh24:mi:ss'));
Insert INTO StayIn(AdmissionNum,RoomNum, StartDate, EndDate)
Values (111111112,202,TO_DATE('2018/07/03 13:02:44', 'yyyy/mm/dd hh24:mi:ss'),TO_DATE('2018/08/03 13:02:44', 'yyyy/mm/dd hh24:mi:ss'));
Insert INTO StayIn(AdmissionNum,RoomNum, StartDate, EndDate)
Values (121222223,401,TO_DATE('2018/05/04 13:02:44', 'yyyy/mm/dd hh24:mi:ss'),TO_DATE('2018/05/05 13:02:44', 'yyyy/mm/dd hh24:mi:ss'));


/*Q1 Report the hospital rooms (the room number) that are currently occupied*/
SELECT RoomNum FROM Room WHERE OccupiedFlag = 1;
/*Q2 For a given division manager (say, ID = 10), report all regular employees that are supervised by this manager. Display the employees ID, names, and salary.*/
SELECT EmployeeID, FirstName, LastName, Salary FROM Employee WHERE SupervisorID = 10;
/*Q3 For each patient, report the sum of amounts paid by the insurance company for that patient, i.e., report the patients SSN, and the sum of insurance payments over all visits.*/
SELECT SUM(InsurancePayment) AS Total_Insurance_Payment, PatientSSN FROM Admission GROUP BY PatientSSN;
/*Q4 Report the number of visits done for each patient, i.e., for each patient, report the patient SSN, first and last names, and the count of visits done by this patient.*/
SELECT COUNT(AdmissionNum) AS Number_of_Visits, PatientSSN, FirstName, LastName FROM Admission, Patient WHERE Admission.PatientSSN = Patient.SSN GROUP BY PatientSSN, FirstName, LastName;
/*Q5 Report the room number that has an equipment unit with serial number ‘A01-02X’.*/
SELECT RoomNum FROM Equipment WHERE SerialNum = 'A01-02X';
/*Q6 Report the employee who has access to the largest number of rooms. We need the employee ID, and the number of rooms (s)he can access.*/
SELECT AccessCount, EmployeeID FROM (SELECT Count(EmployeeID) AS AccessCount, EmployeeID FROM RoomAccess GROUP BY EmployeeID) WHERE AccessCount >= (SELECT Max(AccessCount) FROM (SELECT Count(EmployeeID) AS AccessCount, EmployeeID FROM RoomAccess GROUP BY EmployeeID));
/*Q7 Report the number of regular employees, division managers, and general managers in the hospital*/
SELECT COUNT(*) AS Count, RankName AS Type FROM Employee, EmployeeRank WHERE Employee.EmpRank = EmployeeRank.EmpRank GROUP BY EmployeeRank.RankName;
/*Q8 For patients who have a scheduled future visit (which is part of their most recent visit), report that patient (SSN, and first and last names) and the visit date. Do not report patients who do not have scheduled visit.*/
SELECT FirstName, LastName, SSN, MAX(FutureVisit) AS RecentAssignedFutureVisit FROM Patient, Admission WHERE SSN = PatientSSN AND FutureVisit IS NOT NULL GROUP BY FirstName, LastName, SSN;
/*Q9 For each equipment type that has more than 3 units, report the equipment type ID, model, and the number of units this type has.*/
SELECT TypeID, Model, NumberOfUnits FROM EquipmentType WHERE NumberOfUnits > 3;
/*Q10 Report the date of the coming future visit for patient with SSN = 111-22-3333*/
SELECT FutureVisit FROM Admission WHERE rownum = 1 AND PatientSSN = 111223333 ORDER BY AdmissionDate ASC;
/*Q11 For patient with SSN = 111-22-3333, report the doctors (only ID) who have examined this patient more than 2 times.*/
SELECT DoctorID FROM Examine e ,Admission a WHERE a.PatientSSN = 111223333 AND e.AdmissionNum = a.AdmissionNum GROUP BY e.DoctorID HAVING Count(*) > 2;
/*Q12 Report the equipment types (only the ID) for which the hospital has purchased equipments (units) in both 2010 and 2011. Do not report duplication.*/
SELECT TypeID FROM (SELECT Distinct TypeID, PurchaseYear FROM Equipment WHERE PurchaseYear = 2010 OR PurchaseYear = 2011) GROUP BY TypeID HAVING Count(*) = 2;


CREATE VIEW CriticalCases as  
    SELECT Admission.PatientSSN as Patient_SSN, Patient.FirstName as FirstName, Patient.LastName as LastName, count(Admission.AdmissionNum) as numberOfAdmissionsToICU
    FROM Admission, RoomService, StayIn, Patient
    WHERE  Admission.AdmissionNum = StayIn.AdmissionNum AND StayIn.RoomNum = RoomService.RoomNum AND RoomService.ServiceNum = 6 AND Patient.SSN = Admission.PatientSSN
    GROUP BY Admission.PatientSSN, Patient.FirstName, Patient.LastName
    HAVING count(Admission.AdmissionNum)>= 2;




CREATE VIEW DoctorsLoad AS
  SELECT DoctorID, Gender, 'Overloaded' AS DoctorLoad
  FROM (
    SELECT DISTINCT Doctor.DoctorID, Doctor.Gender, Examine.AdmissionNum FROM Examine, Doctor
    WHERE Examine.DoctorID = Doctor.DoctorID
  ) GROUP BY DoctorID, Gender
  HAVING Count(*)>10
  UNION
  SELECT DoctorID, Gender, 'Underloaded' AS DoctorLoad
  FROM (
    SELECT DISTINCT Doctor.DoctorID, Doctor.Gender, Examine.AdmissionNum FROM Examine, Doctor
    WHERE Examine.DoctorID = Doctor.DoctorID
  )
  GROUP BY DoctorID, Gender
  HAVING Count(*)<10;

SELECT * FROM CriticalCases WHERE numberOfAdmissionsToICU > 4;

SELECT Doctor.DoctorID, Doctor.FirstName, Doctor.LastName
FROM Doctor, DoctorsLoad
WHERE Doctor.DoctorID = DoctorsLoad.DoctorID
AND Doctor.Gender = 'female';

SELECT Examine.ExamineComment, Examine.DoctorID, CriticalCases.Patient_SSN
FROM Examine, CriticalCases, DoctorsLoad, Admission
WHERE Examine.DoctorID = DoctorsLoad.DoctorID AND DoctorLoad = 'Underloaded' AND Admission.AdmissionNum = Examine.AdmissionNum AND Admission.PatientSSN = CriticalCases.Patient_SSN;

CREATE or Replace Trigger requiredComment
    Before Insert on Examine
    For Each Row 
    DECLARE
        ICUcount number(2);
    Begin 
        SELECT count(*) into ICUcount From  StayIn, RoomService, ServiceDone
        WHERE :new.AdmissionNum = StayIn.AdmissionNum AND StayIn.RoomNum = RoomService.RoomNum 
        AND ServiceDone.ServiceNum = RoomService.ServiceNum AND ServiceDone.ServiceName = 'ICU';

        IF (:new.ExamineComment is null and ICUcount > 0 )
            Then 
                RAISE VALUE_ERROR;
        End If;
    End;
/

CREATE or Replace Trigger set_insurance
BEFORE INSERT OR UPDATE ON Admission
FOR EACH ROW
BEGIN
  :new.InsurancePayment := :new.TotalPayment*0.65;
END;
/

CREATE or Replace Trigger check_supervisor
BEFORE INSERT OR UPDATE ON Employee
FOR EACH ROW
DECLARE
  rank number(1);
BEGIN
  
  IF (:new.SupervisorID IS NOT NULL)  THEN
    SELECT EmpRank INTO rank
    FROM Employee
    WHERE Employee.EmployeeID = :new.SupervisorID;
    
    IF rank != :new.EmpRank + 1 THEN
      RAISE VALUE_ERROR;
    End if;
    
  ELSE
    IF :new.EmpRank != 2 THEN
      RAISE VALUE_ERROR;
    END IF;

  END IF;
  
END;
/


Create or Replace Trigger autoDate
Before Insert On Admission
For Each Row
DECLARE
    Service number;
Begin
    Select count(*) into Service
    From RoomService, StayIn
    WHERE :New.AdmissionNum = StayIn.AdmissionNum And StayIn.RoomNum = RoomService.RoomNum And RoomService.ServiceNum = 5;

    If (Service > 0) Then
    :new.FutureVisit := ADD_MONTHS(:new.AdmissionDate, 2);
    End if;
End;
/

CREATE OR REPLACE TRIGGER equipment_year
BEFORE INSERT OR UPDATE ON Equipment
FOR EACH ROW
DECLARE
  equipment_type varchar2(100);
BEGIN
  SELECT descr INTO equipment_type
  FROM EquipmentType
  WHERE TypeID = :new.TypeID;
  
  IF (equipment_type = 'CT Scanner' OR equipment_type = 'Ultrasound')
  THEN
    IF (:new.PurchaseYear IS NULL OR :new.PurchaseYear <= 2006)
    THEN
      RAISE VALUE_ERROR;
    END IF;
  END IF;
END;
/

SET serveroutput ON;
CREATE OR REPLACE TRIGGER print_on_exit
AFTER UPDATE ON Admission
FOR EACH ROW
WHEN (new.LeaveDate IS NOT NULL)
DECLARE
  firstname varchar2(30);
  lastname varchar2(30);
  address varchar2(50);
  n_examines number;
  iterative number;
  doc_firstname varchar2(30);
  doc_lastname varchar2(30);
  exam_comment varchar2(500);
BEGIN

  SELECT FirstName, LastName, Address INTO firstname, lastname, address FROM Patient WHERE SSN = :new.PatientSSN;
  dbms_output.put_line('Patient: ' || firstname || ' ' || lastname || ' of address '||address||' left the hospital. These are the comments from the doctors: ');
  
  SELECT Count(*) INTO n_examines FROM Doctor, Examine
    WHERE Examine.AdmissionNum = :new.AdmissionNum AND
    Examine.DoctorID = Doctor.DoctorID;
  iterative := 1;
  WHILE iterative <= n_examines
  LOOP
    SELECT Doctor.FirstName, Doctor.LastName,
    Examine.ExamineComment INTO doc_firstname, doc_lastname, exam_comment FROM Doctor, Examine
    WHERE Examine.AdmissionNum = :new.AdmissionNum AND
    Examine.DoctorID = Doctor.DoctorID AND ROWNUM = iterative ORDER BY Doctor.DoctorID;
    dbms_output.put_line('Doctor: '|| doc_firstname || ' ' || doc_lastname || ' gave comment: ' || exam_comment;
    iterative := iterative + 1;
  END LOOP;
END;
/





DROP VIEW CriticalCases;
DROP VIEW DoctorsLoad;








    
