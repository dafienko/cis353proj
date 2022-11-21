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

CREATE TABLE Account (
	accountNumber NUMBER(4) PRIMARY KEY,
	afName VARCHAR2(15),
	email VARCHAR2(30)
);

CREATE TABLE Media (
	mediaNumber NUMBER(4) PRIMARY KEY,
	mediaName VARCHAR2(15),
	mediaType VARCHAR2(10)
);

CREATE TABLE Store (
	storeNumber NUMBER(4) PRIMARY KEY,
	location VARCHAR2(15),
	managarENumber NUMBER(4)
);

CREATE TABLE Employee (
	employeeNumber NUMBER(4) PRIMARY KEY,
	efName VARCHAR2(15),
	worksAtSNumber NUMBER(4)
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
	cashierENumber NUMBER(4), 
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
	purchaseNumber NUMBER(4) PRIMARY KEY,
	mediaNumber NUMBER(4),
	paidAmt FLOAT(2),
	refunded BOOLEAN,
	FOREIGN KEY (mediaNumber) REFERENCES Media(mediaNumber)
);

ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD';

INSERT 

SET FEEDBACK ON
COMMIT;

COMMIT;
--
SPOOL OF