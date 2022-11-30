SPOOL project.txt
SET ECHO ON

/*
CIS 353 - Database Design Project
Brandon Rodriguez
Caleb Dykstra
Damien Afienko
Erik Haney
Harrison Corbin
*/

DROP TABLE Account CASCADE CONSTRAINTS;
DROP TABLE Media CASCADE CONSTRAINTS;
DROP TABLE Store CASCADE CONSTRAINTS;
DROP TABLE Employee CASCADE CONSTRAINTS;
DROP TABLE MediaReview CASCADE CONSTRAINTS;
DROP TABLE Purchase CASCADE CONSTRAINTS;
DROP TABLE EmployeePhoneNumbers CASCADE CONSTRAINTS;
DROP TABLE StoreMediaInventory CASCADE CONSTRAINTS;
DROP TABLE PurchaseLine CASCADE CONSTRAINTS;

/* create tables */
CREATE TABLE Account (
	accountNumber NUMBER(4),
	afName VARCHAR2(15),
	email VARCHAR2(30),
	/*************************************************
	Account Number is the primary key of Account
	 *****************************************************/	
	CONSTRAINT C1 PRIMARY KEY (accountNumber)
);

CREATE TABLE Media (
	mediaNumber NUMBER(4) PRIMARY KEY,
	mediaName VARCHAR2(50),
	mediaType VARCHAR2(10)
);

CREATE TABLE Store (
	storeNumber NUMBER(4) PRIMARY KEY,
	location VARCHAR2(15),
	managerENumber NUMBER(4) NOT NULL DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE Employee (
	employeeNumber NUMBER(4) PRIMARY KEY,
	efName VARCHAR2(15),
	worksAtSNumber NUMBER(4) NOT NULL DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE MediaReview (
	accountNumber NUMBER(4),
	mediaNumber NUMBER(4),
	confirmedPurchase number(1),
	rating NUMBER(1),
	text VARCHAR2(500),
	PRIMARY KEY (accountNumber, mediaNumber),
	/***********************************************************
	MediaNumber of Media table will have a reference to 
	the mediaReview table if any reviews are written about that media.
	 **************************************************************/	
	CONSTRAINT C2 FOREIGN KEY (MediaNumber) REFERENCES Media (MediaNumber),
	/***********************************************************
	A review must be between 1 and 5 stars
	 **************************************************************/	
	CONSTRAINT C3 CHECK (rating >= 1 AND rating <= 5),
	/***********************************************************
	A review can only be 5 stars if the purchase is confirmed
	 **************************************************************/	
	CONSTRAINT C4 CHECK (confirmedPurchase = 1 OR rating < 5)
);

CREATE TABLE Purchase (
	purchaseNumber NUMBER(4) PRIMARY KEY,
	totalCost FLOAT(2),
	pDate DATE,
	cashierENumber NUMBER(4) NOT NULL, 
	customerANumber NUMBER(4)
);

CREATE TABLE EmployeePhoneNumbers (
	employeeNumber NUMBER(4),
	phoneNumber NUMBER(10),
	PRIMARY KEY (employeeNumber, phoneNumber)
);

CREATE TABLE StoreMediaInventory (
	mediaNumber NUMBER(4),
	storeNumber NUMBER(4),
	amountInStock NUMBER(3),
	PRIMARY KEY (mediaNumber, storeNumber)
);

CREATE TABLE PurchaseLine (
	purchaseNumber NUMBER(4),
	mediaNumber NUMBER(4),
	paidAmt FLOAT(2),
	refunded NUMBER(1),
	PRIMARY KEY (purchaseNumber, mediaNumber)
);

ALTER TABLE Store
ADD FOREIGN KEY (managerENumber) REFERENCES Employee(employeeNumber)
Deferrable initially deferred;

ALTER TABLE Employee
ADD FOREIGN KEY (worksAtSNumber) REFERENCES Store(storeNumber)
Deferrable initially deferred;

ALTER TABLE MediaReview
ADD FOREIGN KEY (accountNumber) REFERENCES Account(accountNumber);

ALTER TABLE Purchase
ADD FOREIGN KEY (cashierENumber) REFERENCES Employee(employeeNumber);
ALTER TABLE Purchase
ADD FOREIGN KEY (customerANumber) REFERENCES Account(accountNumber);

ALTER TABLE EmployeePhoneNumbers
ADD FOREIGN KEY (employeeNumber) REFERENCES Employee(employeeNumber);

ALTER TABLE StoreMediaInventory
ADD FOREIGN KEY (mediaNumber) REFERENCES Media(mediaNumber);
ALTER TABLE StoreMediaInventory
ADD FOREIGN KEY (storeNumber) REFERENCES Store(storeNumber);

ALTER TABLE PurchaseLine
ADD FOREIGN KEY (purchaseNumber) REFERENCES Purchase(purchaseNumber);
ALTER TABLE PurchaseLine
ADD FOREIGN KEY (mediaNumber) REFERENCES Media(mediaNumber);



/* populate tables */

ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD';
SET FEEDBACK OFF

INSERT INTO Media VALUES (1, 'Star Wars: episode 1', 'movie');
INSERT INTO Media VALUES (2, 'Harry Potter and the Sorcerer''s Stone', 'book');

INSERT INTO Employee VALUES (1, 'John', 1);
INSERT INTO Employee VALUES (2, 'Harry', 2);
INSERT INTO Employee VALUES (3, 'Bob', 2);
INSERT INTO Employee VALUES (4, 'Brian', 2);
INSERT INTO Employee VALUES (5, 'Jonny', 2);

INSERT INTO Store VALUES (1, 'Grand Rapids', 1);
INSERT INTO Store VALUES (2, 'Lansing', 2);

INSERT INTO StoreMediaInventory VALUES (1, 1, 50);
INSERT INTO StoreMediaInventory VALUES (2, 1, 25);

INSERT INTO Account VALUES (1, 'Dave', 'dave@gmail.com');
INSERT INTO Account VALUES (2, 'Mike', 'mike@gmail.com');
INSERT INTO Account VALUES (3, 'Erik', 'Erik@gmail.com');
INSERT INTO Account VALUES (4, 'Tree', 'Tree@gmail.com');

INSERT INTO MediaReview VALUES (2, 1, 1, 5, 'Great Movie');
INSERT INTO MediaReview VALUES (3, 2, 1, 3, 'Mid ngl');

INSERT INTO EmployeePhoneNumbers VALUES (1, 6161112222);
INSERT INTO EmployeePhoneNumbers VALUES (1, 6161234567);

INSERT INTO Purchase VALUES(1, 10.50, '2022-11-21', 1, 1);
INSERT INTO PurchaseLine VALUES(1, 1, 6.00, 0);

SET FEEDBACK ON
COMMIT;

/* queries to display tables*/
SELECT * FROM Account;
SELECT * FROM Media; 
SELECT * FROM Store;
SELECT * FROM Employee;
SELECT * FROM MediaReview;
SELECT * FROM Purchase;
SELECT * FROM EmployeePhoneNumbers;
SELECT * FROM StoreMediaInventory;
SELECT * FROM PurchaseLine;


/* queries */
--(66) Aggregation using MAX()
--Find the highest rating
SELECT MAX(rating) as highest_rating
FROM MediaReview;

--(52) Non correlated sub query
-- Find accounts that have not left a media review
SELECT accountNumber 
FROM Account 
WHERE accountNumber NOT IN (SELECT accountNumber FROM MediaReview);

--(40) Self join
--Find pairs of employees that work in the same department
SELECT distinct e1.efName, e1.worksatSNumber, e2.efName, e2.worksAtSNumber
FROM Employee e1, Employee e2
WHERE e1.worksatSNumber = e2.worksAtSNumber AND 
      e1.EmployeeNumber > e2.EmployeeNumber;

--Join involving at least four relations
--Find the account name, account email, employee name, purchase number, and purchase date of every account and employee involved in a sale of "Star Wars: episode 1".
SELECT A.afname, A.email, E.EFName, P.PurchaseNumber, P.PDate
FROM Account A, Media M, Purchase P, PurchaseLine PL, Employee E
WHERE A.accountNumber = P.customeranumber AND
      E.EmployeeNumber = P.CashiereNumber AND
      P.PurchaseNumber = PL.PurchaseNumber AND
      M.MediaName = 'Star Wars: episode 1' AND
      PL.MediaNumber = M.MediaNumber;

--Group by, having, and order by in the same query
--Find the media name and total number of sales of each media product that has at least five sales, and order them from most sales to least sales.
SELECT M.MediaName, COUNT(*)
FROM Media M, PurchaseLine PL
WHERE M.MediaNumber = PL.MediaNumber
GROUP BY M.MediaName
HAVING COUNT(*) > 4
ORDER BY COUNT(*) DESC;

-- Correlated subquery
--Find the account number and name of all accounts who have left a media review.
SELECT A.AccountNumber, A.AFName
FROM Account A
WHERE EXISTS(SELECT MR.AccountNumber 
             FROM MediaReview MR
             WHERE MR.AccountNumber = A.AccountNumber);

--Relational DIVISION query
--Find the store number and location of every store which has all media products in stock.
SELECT S.StoreNumber, S.Location
FROM Store S
WHERE NOT EXISTS((SELECT M.MediaNumber
                  FROM Media M)
                  MINUS
                  (SELECT M.MediaNumber
                  FROM Media M, StoreMediaInventory SI
                  WHERE M.MediaNumber = SI.MediaNumber AND
                  S.StoreNumber = SI.StoreNumber));

--Outer join query
--Find all account numbers and names, and any purchases made by each account.
SELECT A.AccountNumber, A.afname, P.PurchaseNumber
FROM Account A LEFT OUTER JOIN Purchase P ON A.AccountNumber = P.CustomerANumber
ORDER BY A.AccountNumber;

--Insert/delete/update to test ICs
--These are meant to throw errors
INSERT INTO Account VALUES (1, 'Jane', 'jane@jane.com');
INSERT INTO MediaReview VALUES (1, 49, 1, 3, 'Awesome'); 
INSERT INTO MediaReview VALUES (1, 1, 1, 7, 'Awesome'); 
INSERT INTO MediaReview VALUES (1, 1, 0, 5, 'Awesome'); 

COMMIT;
--
SPOOL OFF
