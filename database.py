#!/usr/bin/env python3
import psycopg2

#####################################################
##  Database Connection
#####################################################

'''
Connect to the database using the connection string
'''
def openConnection():
    userid = "y24s2c9120_shaz0913"
    passwd = "Saifali@2001"
    myHost = "awsprddbs4836.shared.sydney.edu.au"

    # Create a connection to the database
    c = None
    # Parses the config file and connects using the connect string
    try:
        c = psycopg2.connect(
            database=userid, user=userid,
            password=passwd, host=myHost
        )
    except psycopg2.Error as e:
        print("psycopg2.Error :", e.pgerror)
    return c

# Validate staff based on username and password
def checkLogin(login, password):
    c = openConnection()
    if(not c): return None
    try:
        with c.cursor() as x:
            x.execute(
                """
                    SELECT 
                        USERNAME, FIRSTNAME, 
                        LASTNAME, EMAIL
                    FROM ADMINISTRATOR
                    WHERE USERNAME = %s
                    AND PASSWORD = %s
                """, (login, password)
            )
            user = x.fetchone()
            output = "Success" if(user) else "Fail"
            return user
    
    except psycopg2.Error as e:
        print("psycopg2.Error :", e.pgerror)
    finally:
        if(c): c.close()
    
    return

# List all the associated admissions records in the database by staff
def findAdmissionsByAdmin(login):
    c = openConnection()
    if(not c): return None
    try:
        with c.cursor() as x:
            x.execute(
                """
                    SELECT 
                        A.ADMISSIONID AS "ID", C.ADMISSIONTYPENAME AS "Type",
                        D.DEPTNAME AS "Department", 
                        A.DISCHARGEDATE AS "Discharge Date",
                        A.FEE AS "Fee", 
                        CONCAT(B.FIRSTNAME, ' ', B.LASTNAME) AS "Patient",
                        A.CONDITION AS "Condition"
                    FROM ADMISSION AS A

                    INNER JOIN PATIENT AS B
                    ON A.PATIENT = B.PATIENTID

                    INNER JOIN ADMISSIONTYPE AS C
                    ON A.ADMISSIONTYPE = C.ADMISSIONTYPEID

                    INNER JOIN DEPARTMENT AS D
                    ON A.DEPARTMENT = D.DEPTID

                    WHERE A.ADMINISTRATOR = %s

                    ORDER BY A.DISCHARGEDATE DESC NULLS LAST, 
                    B.FIRSTNAME ASC, B.LASTNAME ASC,
                    C.ADMISSIONTYPENAME DESC;
                """, (login,)
            )
            info = x.fetchall()
            output = "Success" if(info) else "Fail"
            return info
    
    except psycopg2.Error as e:
        print("psycopg2.Error :", e.pgerror)
    finally:
        if(c): c.close()
    
    return

'''
Find a list of admissions based on the searchString provided as parameter
See assignment description for search specification
'''
def findAdmissionsByCriteria(searchString):

    return


'''
Add a new addmission 
'''
def addAdmission(type, department, patient, condition, admin):
    
    return


'''
Update an existing admission
'''
def updateAdmission(id, type, department, dischargeDate, fee, patient, condition):
    

    return