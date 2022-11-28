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

SET FEEDBACK OFF

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
	accountNumber NUMBER(4) PRIMARY KEY,
	afName VARCHAR2(15),
	email VARCHAR2(30)
);

CREATE TABLE Media (
	mediaNumber NUMBER(4) PRIMARY KEY,
	mediaName VARCHAR2(30),
	mediaType VARCHAR2(10)
);

CREATE TABLE Store (
	storeNumber NUMBER(4) PRIMARY KEY,
	location VARCHAR2(15),
	managarENumber NUMBER(4) NOT NULL DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY (managarENumber) REFERENCES Employee(employeeNumber)
);

CREATE TABLE Employee (
	employeeNumber NUMBER(4) PRIMARY KEY,
	efName VARCHAR2(15),
	worksAtSNumber NUMBER(4) NOT NULL DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY (worksAtSNumber) REFERENCES Store(storeNumber) 
);

CREATE TABLE MediaReview (
	accountNumber NUMBER(4),
	mediaNumber NUMBER(4),
	confirmedPurchase BOOLEAN,
	rating NUMBER(1),
	text TEXT(500),
	PRIMARY KEY (accountNumber, mediaNumber),
	FOREIGN KEY (accountNumber) REFERENCES Account(accountNumber),
	FOREIGN KEY (mediaNumber) REFERENCES Media(mediaNumber)
);

CREATE TABLE Purchase (
	purchaseNumber NUMBER(4) PRIMARY KEY,
	totalCost FLOAT(2),
	pDate DATE,
	cashierENumber NUMBER(4) NOT NULL, 
	customerANumber NUMBER(4),
	FOREIGN KEY (cashierENumber) REFERENCES Employee(employeeNumber),
	FOREIGN KEY (customerANumber) REFERENCES Account(accountNumber)
);

CREATE TABLE EmployeePhoneNumbers (
	employeeNumber NUMBER(4),
	phoneNumber NUMBER(10),
	PRIMARY KEY (employeeNumber, phoneNumber),
	FOREIGN KEY (employeeNumber) REFERENCES Employee(employeeNumber)
);

CREATE TABLE StoreMediaInventory (
	mediaNumber NUMBER(4),
	storeNumber NUMBER(4),
	amountInStock NUMBER(3),
	PRIMARY KEY (mediaNumber, storeNumber),
	FOREIGN KEY (mediaNumber) REFERENCES Media(mediaNumber),
	FOREIGN KEY (storeNumber) REFERENCES Store(storeNumber)
);

CREATE TABLE PurchaseLine (
	purchaseNumber NUMBER(4),
	mediaNumber NUMBER(4),
	paidAmt FLOAT(2),
	refunded BOOLEAN,
	PRIMARY KEY (purchaseNumber, mediaNumber),
	FOREIGN KEY (purchaseNumber) REFERENCES Purchase(purchaseNumber),
	FOREIGN KEY (mediaNumber) REFERENCES Media(mediaNumber)
);

/* populate tables */
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD';

INSERT INTO Media VALUES (1, 'Star Wars: episode 1', 'movie');
INSERT INTO Media VALUES (2, 'Harry Potter and the Sorcerer''s Stone', 'book');

INSERT INTO Employee VALUES (1, 'John', 1);

INSERT INTO Store VALUES (1, 'Grand Rapids', 1);

INSERT INTO StoreMediaInventory VALUES (1, 1, 50)
INSERT INTO StoreMediaInventory VALUES (1, 1, 25)

INSERT INTO Account VALUES (1, 'Dave', 'dave@gmail.com');

INSERT INTO EmployeePhoneNumbers VALUES (1, 6161112222);
INSERT INTO EmployeePhoneNumbers VALUES (1, 6161234567);

INSERT INTO Purchase VALUES(1, 10.50, '2022-11-21', 1, 1);
INSERT INTO PurchaseLine VALUES(1, 1, 6.00, FALSE);
INSERT INTO PurchaseLine VALUES(1, 2, 4.50, TRUE);

SET FEEDBACK ON
COMMIT;



COMMIT;
--
SPOOL OFF