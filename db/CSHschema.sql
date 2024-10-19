DROP TABLE IF EXISTS ADMINISTRATOR;
DROP TABLE IF EXISTS PATIENT;
DROP TABLE IF EXISTS ADMISSIONTYPE;
DROP TABLE IF EXISTS DEPARTMENT;
DROP TABLE IF EXISTS ADMISSION;
SET datestyle ='DMY';
CREATE TABLE ADMINISTRATOR (
    USERNAME VARCHAR(10) PRIMARY KEY,
    PASSWORD VARCHAR(20) NOT NULL,
    FIRSTNAME VARCHAR(50) NOT NULL,
    LASTNAME VARCHAR(50) NOT NULL,
    EMAIL VARCHAR(20) NOT NULL
);

INSERT INTO ADMINISTRATOR VALUES 
    ('jdoe', 'Pass1234', 'John', 'Doe', 'jdoe@csh.com'),
    ('jsmith', 'Pass5678', 'Jane', 'Smith', 'jsmith@csh.com'),
    ('ajohnson', 'Passabcd', 'Alice', 'Johnson', 'ajohnson@csh.com'),
    ('bbrown', 'Passwxyz', 'Bob', 'Brown', 'bbrown@csh.com'),
    ('cdavis', 'Pass9876', 'Charlie', 'Davis', 'cdavis@csh.com'),
    ('ksmith', 'Pass5566', 'Karen', 'Smith', 'ksmith@csh.com');

CREATE TABLE PATIENT (
    PATIENTID VARCHAR(10) PRIMARY KEY,
    PASSWORD VARCHAR(20) NOT NULL,
    FIRSTNAME VARCHAR(50) NOT NULL,
    LASTNAME VARCHAR(50) NOT NULL,
    MOBILE VARCHAR(20) NOT NULL
);

INSERT INTO PATIENT VALUES 
    ('dwilson', 'Pass5432', 'David', 'Wilson', '4455667788'),
    ('etylor', 'Passlmno', 'Eva', 'Taylor', '5566778899'),
    ('faderson', 'Passrstu', 'Frank', 'Anderson', '6677889900'),
    ('gthomas', 'Pass1357', 'Grace', 'Thomas', '7788990011'),
    ('smartinez', 'Pass2468', 'Stan', 'Martinez', '8899001122'),
    ('lroberts', 'Pass1122', 'Laura', 'Roberts', '9900112233');


CREATE TABLE ADMISSIONTYPE (
    ADMISSIONTYPEID SERIAL PRIMARY KEY,
    ADMISSIONTYPENAME VARCHAR(20) UNIQUE NOT NULL
);

INSERT INTO ADMISSIONTYPE VALUES (1, 'Emergency');
INSERT INTO ADMISSIONTYPE VALUES (2, 'Transfer');
INSERT INTO ADMISSIONTYPE VALUES (3, 'Inpatient');
INSERT INTO ADMISSIONTYPE VALUES (4, 'Outpatient');

CREATE TABLE DEPARTMENT (
    DEPTID SERIAL PRIMARY KEY,
    DEPTNAME VARCHAR(20) UNIQUE NOT NULL
);

INSERT INTO DEPARTMENT VALUES (1, 'General');
INSERT INTO DEPARTMENT VALUES (2, 'Emergency');
INSERT INTO DEPARTMENT VALUES (3, 'Surgery');
INSERT INTO DEPARTMENT VALUES (4, 'Obstetrics');
INSERT INTO DEPARTMENT VALUES (5, 'Rehabilitation');
INSERT INTO DEPARTMENT VALUES (6, 'Paediatrics');

CREATE TABLE ADMISSION (
    ADMISSIONID SERIAL PRIMARY KEY,
    ADMISSIONTYPE INTEGER NOT NULL,
    DEPARTMENT INTEGER NOT NULL,
    PATIENT VARCHAR(10) NOT NULL,
    ADMINISTRATOR VARCHAR(10) NOT NULL,
    FEE DECIMAL(7,2),
    DISCHARGEDATE DATE,
    CONDITION VARCHAR(500),
    
    FOREIGN KEY(ADMISSIONTYPE) REFERENCES ADMISSIONTYPE,
    FOREIGN KEY(DEPARTMENT) REFERENCES DEPARTMENT,
    FOREIGN KEY(PATIENT) REFERENCES PATIENT,
    FOREIGN KEY(ADMINISTRATOR) REFERENCES ADMINISTRATOR
);

INSERT INTO ADMISSION (ADMISSIONTYPE, DEPARTMENT, FEE, PATIENT, ADMINISTRATOR, DISCHARGEDATE, CONDITION) VALUES
    (4, 1, 666.00, 'lroberts', 'jdoe', '28/02/2024', 'a red patch on my skin that looks irritated. It started small but has been spreading and feels warm to the touch'),
    (2, 1, 100.00, 'gthomas', 'jdoe', '11/09/2021', NULL),
    (1, 2, NULL, 'lroberts','jsmith', '02/09/2019', 'Admitted to the emergency department after suffering head trauma from a fall, requiring a CT scan and observation for potential concussion.'),
    (2, 3, 7688.00, 'dwilson','ajohnson', '01/12/2022', NULL),
    (2, 6, 1600.00, 'faderson', 'ajohnson', '03/09/2014', 'Child admitted to the hospital with a severe asthma attack, requiring oxygen therapy and nebulizer treatment.'),
    (4, 1, 90.00, 'gthomas', 'ksmith', '04/07/2021', 'Routine follow-up consultation to review progress after recent knee surgery, with positive recovery observed.'),
    (1, 2, 1450.00, 'smartinez', 'jsmith', NULL, 'Admitted to the emergency department with severe food poisoning, requiring IV fluids and anti-nausea medication for recovery.'),
    (4, 5, 180.95, 'dwilson', 'cdavis', '06/11/2021', 'Attended a physiotherapy session as part of an ongoing rehabilitation program following shoulder surgery.'),
    (3, 1, 2000.00, 'etylor', 'ajohnson', '10/09/2021', NULL),
    (2, 4, 8290.00, 'gthomas', 'jsmith', '01/09/2024', 'Postpartum care following a natural childbirth, including monitoring of both the mother and the newborn for potential complications.'),
    (2, 6, 1800.00, 'faderson', 'bbrown',  NULL, 'Child admitted to the paediatrics department for severe pneumonia, requiring intravenous antibiotics and respiratory therapy.'),
    (4, 1, 75.00, 'gthomas', 'bbrown', '19/11/2023', 'Routine general practitioner consultation for a follow-up after a recent bout of seasonal allergies.'),
    (3, 3, 7000.50, 'smartinez', 'jdoe', '15/10/2024', NULL),
    (1, 2, NULL, 'etylor', 'jdoe', NULL, 'I am having intense, crushing pain in my chest that feels like an elephant is sitting on it. It is spreading to my left arm and neck.');

CREATE OR REPLACE FUNCTION admit_view(p_login VARCHAR)
RETURNS TABLE (
    ID INTEGER,
    Type VARCHAR(20),
    Department VARCHAR(20),
    "Discharge Date" DATE,
    Fee DECIMAL(7,2),
    Patient VARCHAR(101),
    Condition VARCHAR(500)
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        A.AdmissionID AS "ID",  
        C.ADMISSIONTYPENAME AS "Type",
        D.DEPTNAME AS "Department", 
        A.DISCHARGEDATE AS "Discharge Date",
        A.FEE AS "Fee", 
        CONCAT(B.FIRSTNAME, ' ', B.LASTNAME)::VARCHAR(101) AS "Patient",
        A.CONDITION AS "Condition"
    FROM ADMISSION AS A
    INNER JOIN PATIENT AS B
        ON A.PATIENT = B.PATIENTID
    INNER JOIN ADMISSIONTYPE AS C
        ON A.ADMISSIONTYPE = C.ADMISSIONTYPEID
    INNER JOIN DEPARTMENT AS D
        ON A.DEPARTMENT = D.DEPTID
    WHERE A.ADMINISTRATOR = p_login
    ORDER BY A.DISCHARGEDATE DESC NULLS LAST, 
             B.FIRSTNAME ASC, 
             B.LASTNAME ASC,
             C.ADMISSIONTYPENAME DESC;
END;
$$;
