#!/usr/bin/env python3
import psycopg2

#####################################################
##  Database Connection
#####################################################

'''
Connect to the database using the connection string
'''
def openConnection():
    userid = "y24s2c9120_aphi0710"
    passwd = "GqsCu2gz"
    myHost = "awsprddbs4836.shared.sydney.edu.au"

    # Create a connection to the database
    c = None
    # Parses the config file and connects using the connect string
    try:
        c = psycopg2.connect(
            database=userid, user=userid,
            password=passwd, host=myHost
        )
    except psycopg2.Error as sqle:
        print("psycopg2.Error : " + sqle.pgerror)
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
                        USERNAME, FIRSTNAME, LASTNAME, EMAIL
                    FROM 
                        ADMINISTRATOR
                    WHERE 
                        USERNAME = %s 
                    AND 
                        PASSWORD = %s
                """, (login, password)
            )
            user = x.fetchone()
            if(user): print(f"Login successful for user: {user}")
            else: print("Login failed. No matching user found.")
            return user
    
    except psycopg2.Error as e: 
        print(f"Error querying database: {e}")
    finally:
        if(c): c.close()
    
    return None

'''
List all the associated admissions records in the database by staff
'''
def findAdmissionsByAdmin(login):

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