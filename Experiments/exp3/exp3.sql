/*
EXPERIMENT 03 - DCL AND TCL COMMANDS
Case Study: Banking Transaction Management System
Platform: MySQL 8.0+

AIM:
To create a banking database and demonstrate Data Control Language (DCL)
operations for user permissions and Transaction Control Language (TCL)
operations for safe, consistent banking updates using MySQL.

EXPERIMENT:
Create a BankDB database and BankAccount table. Insert sample bank accounts,
demonstrate GRANT and REVOKE permissions for a teller user, and perform
COMMIT, ROLLBACK, SAVEPOINT and fund-transfer operations.

NOTE:
Run setup and DCL statements as an administrator. Test the teller login
in a separate connection. Run TCL statements in the same session, in order.
Use a disposable lab database. MySQL account and privilege statements can
cause implicit commits and cannot be undone with ROLLBACK.
*/

/* OPERATION 1: Create database and transactional table */
CREATE DATABASE IF NOT EXISTS BankDB;
USE BankDB;

CREATE TABLE BankAccount (
    Account_ID INT PRIMARY KEY,
    Holder_Name VARCHAR(50) NOT NULL,
    Branch VARCHAR(30) NOT NULL,
    Balance DECIMAL(12,2) NOT NULL CHECK (Balance >= 0),
    Account_Type VARCHAR(20) NOT NULL
) ENGINE=InnoDB;

/* OPERATION 2: Insert five accounts (run once on a fresh table) */
INSERT INTO BankAccount
    (Account_ID, Holder_Name, Branch, Balance, Account_Type)
VALUES
    (201, 'Anand', 'Chennai', 50000.00, 'Savings'),
    (202, 'Bhavya', 'Hyderabad', 35000.00, 'Savings'),
    (203, 'Charan', 'Vijayawada', 20000.00, 'Current'),
    (204, 'Deepa', 'Chennai', 45000.00, 'Savings'),
    (205, 'Eshan', 'Bengaluru', 60000.00, 'Current');

/* OPERATION 3: View initial balances */
SELECT Account_ID, Holder_Name, Balance
FROM BankAccount ORDER BY Account_ID;

/* OPERATION 4: Create a temporary teller login.
   Replace the placeholder with a strong lab-only password. */
CREATE USER 'lab_teller3'@'localhost'
IDENTIFIED BY 'REPLACE_WITH_A_STRONG_LAB_PASSWORD';

/* OPERATION 5: Grant read-only access */
GRANT SELECT ON BankDB.BankAccount
TO 'lab_teller3'@'localhost';

/* OPERATION 6: Verify privileges */
SHOW GRANTS FOR 'lab_teller3'@'localhost';

/* OPERATION 7: Test in a SEPARATE connection as lab_teller3.
   SELECT should succeed; UPDATE should fail without UPDATE privilege. */
/*
SELECT Account_ID, Balance FROM BankDB.BankAccount;
UPDATE BankDB.BankAccount
SET Balance = Balance + 100
WHERE Account_ID = 201;
*/

/* OPERATION 8: Revoke read access (administrator session) */
REVOKE SELECT ON BankDB.BankAccount
FROM 'lab_teller3'@'localhost';
SHOW GRANTS FOR 'lab_teller3'@'localhost';

/* OPERATION 9: Commit a deposit */
START TRANSACTION;
UPDATE BankAccount SET Balance = Balance + 5000
WHERE Account_ID = 201;
COMMIT;
SELECT Account_ID, Balance FROM BankAccount WHERE Account_ID = 201;

/* OPERATION 10: Roll back a withdrawal */
START TRANSACTION;
UPDATE BankAccount SET Balance = Balance - 3000
WHERE Account_ID = 202;
ROLLBACK;
SELECT Account_ID, Balance FROM BankAccount WHERE Account_ID = 202;

/* OPERATION 11: Savepoint and partial rollback */
START TRANSACTION;
UPDATE BankAccount SET Balance = Balance + 1000
WHERE Account_ID = 203;
SAVEPOINT after_first_change;
UPDATE BankAccount SET Balance = Balance + 2000
WHERE Account_ID = 204;
ROLLBACK TO SAVEPOINT after_first_change;
COMMIT;
SELECT Account_ID, Balance FROM BankAccount
WHERE Account_ID IN (203, 204) ORDER BY Account_ID;

/* OPERATION 12: Transfer funds.
   This example assumes both accounts exist and the debit has sufficient funds.
   In real applications, verify both affected-row counts and roll back on error. */
START TRANSACTION;
UPDATE BankAccount SET Balance = Balance - 4000
WHERE Account_ID = 201 AND Balance >= 4000;
SELECT ROW_COUNT() AS Debit_Rows_Affected;
UPDATE BankAccount SET Balance = Balance + 4000
WHERE Account_ID = 202;
SELECT ROW_COUNT() AS Credit_Rows_Affected;
COMMIT;
SELECT Account_ID, Balance FROM BankAccount
WHERE Account_ID IN (201, 202) ORDER BY Account_ID;

/* OPERATION 13: Release a savepoint */
START TRANSACTION;
SAVEPOINT test_point;
RELEASE SAVEPOINT test_point;
ROLLBACK;

/* OPERATION 14: Remove the temporary teller login (administrator) */
DROP USER 'lab_teller3'@'localhost';

/* FINAL VERIFICATION */
SELECT Account_ID, Holder_Name, Balance
FROM BankAccount ORDER BY Account_ID;
SELECT SUM(Balance) AS Total_Balance FROM BankAccount;

/*
EXPECTED FINAL BALANCES:
201 = 51000.00
202 = 39000.00
203 = 21000.00
204 = 45000.00
205 = 60000.00
EXPECTED TOTAL = 216000.00
The total rises by 6000 due to the committed deposit of 5000 and addition
of 1000. The 4000 transfer does not change the total.
*/

/* STUDENT PRACTICE
1. Create FinanceLab with an InnoDB Account table.
2. Insert four accounts with unique IDs and positive balances.
3. Create a read-only audit user and verify its grants.
4. Revoke SELECT from the audit user and test the denied query.
5. Deposit 2500 and COMMIT; verify the balance.
6. Withdraw 1000 and ROLLBACK; verify no change.
7. Use two SAVEPOINTs and roll back only the last update.
8. Transfer 1500 and verify total funds remain constant.
9. Attempt a withdrawal greater than the available balance.
10. Explain why GRANT should not be mixed into a transaction for rollback.
*/

/* VIVA VOCE
1. DCL controls access permissions to database objects.
2. GRANT assigns privileges; REVOKE withdraws privileges.
3. TCL controls transaction boundaries and rollback points.
4. COMMIT makes current transaction changes permanent.
5. ROLLBACK cancels uncommitted changes.
6. SAVEPOINT marks a position for partial rollback.
7. ROLLBACK TO SAVEPOINT reverses changes after that marker.
8. ACID means Atomicity, Consistency, Isolation and Durability.
9. InnoDB supports transactions and rollback.
10. A teller with only SELECT permission cannot UPDATE account balances.
*/

/* RESULT:
The BankDB database was created, DCL permissions were assigned, verified
and revoked, and TCL commands were demonstrated using deposits, rollback,
savepoints and a fund transfer.
*/
