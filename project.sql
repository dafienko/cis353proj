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
	managarENumber NUMBER(4) NOT NULL DEFERRABLE INITIALLY DEFERRED
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
	CONSTRAINT C3 CHECK (rating >= 1 AND rating <= 5)
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
	PRIMARY KEY (purchaseNumber, mediaNumber),
	/*************************************************
	A refund must be a PurchaseLine above $0 and it must 
	not already be a refunded purchaseLine
	 *****************************************************/
	CONSTRAINT C4 CHECK (paidAmt > 0 AND refunded = 0)
);

ALTER TABLE Store
ADD FOREIGN KEY (managarENumber) REFERENCES Employee(employeeNumber)
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

INSERT INTO Store VALUES (1, 'Grand Rapids', 1);

INSERT INTO StoreMediaInventory VALUES (1, 1, 50);
INSERT INTO StoreMediaInventory VALUES (2, 1, 25);

INSERT INTO Account VALUES (1, 'Dave', 'dave@gmail.com');

INSERT INTO EmployeePhoneNumbers VALUES (1, 6161112222);
INSERT INTO EmployeePhoneNumbers VALUES (1, 6161234567);

INSERT INTO Purchase VALUES(1, 10.50, '2022-11-21', 1, 1);
INSERT INTO PurchaseLine VALUES(1, 1, 6.00, 0);
INSERT INTO PurchaseLine VALUES(1, 2, 4.50, 1);

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

COMMIT;
--
SPOOL OFF
