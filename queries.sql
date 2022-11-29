SPOOL queries.txt
SET ECHO ON

/*
Finds Highest Ratings of MediaReviews
Used MAX()
*/
SELECT MAX(rating) as highest_rating
FROM MediaReview;

/*
Finds Accounts that have not left a media review
Used MINUS & ORDER BY
*/

SELECT accountNumber FROM Account
MINUS
SELECT accountNumber FROM MediaReview
ORDER BY accountNumber;

/*
Finds what employees manage each store location
*/

SELECT e1.efName || ' Manages ' || s1.location
	"Managers and Their Stores"
	FROM employee e1, store s1
	WHERE e1.employeeNumber = s1.managerENumber
	ORDER BY e1.efname;


SET ECHO OFF
SPOOL OFF
