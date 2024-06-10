/******************* In the Library *********************/

USE library;
ALTER TABLE loans 
ADD FOREIGN KEY (BookID)
REFERENCES books(BookID);

ALTER TABLE loans 
ADD FOREIGN KEY (PatronID)
REFERENCES patrons(PatronID);

/*******************************************************/
/* find the number of availalbe copies of Dracula      */
/*******************************************************/
SELECT Title, count(Title) as available_copies FROM books as b 
LEFT JOIN loans as l ON b.BookID = l.BookID
WHERE b.Title = "Dracula" AND l.ReturnedDate IS NOT NULL
GROUP BY Title;

/* check total copies of the book */
SELECT Title, count(Title) as total_copies FROM books as b 
INNER JOIN loans as l ON b.BookID = l.BookID
WHERE b.Title = "Dracula"
GROUP BY Title;

/* current total loans of the book */
SELECT Title, count(Title) as total_loans FROM books as b 
INNER JOIN loans as l ON b.BookID = l.BookID
WHERE b.Title = "Dracula" AND l.ReturnedDate IS NULL
GROUP BY Title;

/* total available book */
SELECT Title, count(Title) as total_available_books FROM books as b 
LEFT JOIN loans as l ON b.BookID = l.BookID
WHERE l.ReturnedDate IS NOT NULL
GROUP BY Title;

/*******************************************************/
/* Add new books to the library                        */
/*******************************************************/
INSERT INTO books VALUES 
(201, "A Game Of Thrones", "George R. R. Martin", 1996, 2719805889), 
(202, "Terriens (PHOTOGRAPHIE)", "Richard Kalvar", 2007, 2081201135);

/*******************************************************/
/* Check out Books                                     */
/*******************************************************/
INSERT INTO patrons Values ("Shahd", "Hatem", "shahdhdaoud@gmail.com", 201);
INSERT INTO loans (LoanID, BookID, PatronID, LoanDate, DueDate) 
VALUES 
(2001, 201, (SELECT PatronID FROM Patrons WHERE Email = "shahdhdaoud@gmail.com") , "2024-06-09", "2024-07-09"), 
(2002, 202, (SELECT PatronID FROM Patrons WHERE Email = "ccalver8@samoca.org"), "2024-06-10", "2024-07-10");

/********************************************************/
/* Check books for Due back                             */
/* generate a report of books due back on July 13, 2020 */
/* with patron contact information                      */
/********************************************************/

SELECT b.Title, CONCAT(p.FirstName, " ", p.LastName) as full_name, p.Email, l.DueDate FROM books as b
INNER JOIN loans as l ON b.BookID = l.BookID
INNER JOIN patrons as p ON p.PatronID = l.PatronID
WHERE DueDate = "2020-07-13";

/*******************************************************/
/* Return books to the library                         */
/*******************************************************/
UPDATE loans 
SET ReturnedDate = CASE LoanID
WHEN 2001 THEN "2024-07-09"
WHEN 2002 THEN "2024-07-10"
ELSE ReturnedDate
END
WHERE LoanID IN(2001, 2002);

/*******************************************************/
/* Encourage Patrons to check out books                */
/* generate a report of showing 10 patrons who have
checked out the fewest books.                          */
/*******************************************************/

SELECT p.PatronID, CONCAT(p.FirstName, " ", p.LastName) as full_name, count(l.LoanID) as borrowed_books FROM loans as l
INNER JOIN patrons as p ON l.PatronID = p.PatronID
GROUP BY p.PatronID
ORDER BY borrowed_books
LIMIT 10; 

/*******************************************************/
/* Find books to feature for an event                  
 create a list of books from 1890s that are
 currently available                                    */
/*******************************************************/
SELECT b.Title, b.Published, count(b.Title) as total_available_books FROM books as b 
INNER JOIN loans as l ON b.BookID = l.BookID
WHERE l.ReturnedDate IS NOT NULL AND b.Published BETWEEN 1890 AND 1899
GROUP BY Title
ORDER BY Published;

/*******************************************************/
/* Book Statistics 
/* create a report to show how many books were 
published each year.                                    */
/*******************************************************/
SELECT Published, COUNT(DISTINCT(Title)) AS TotalNumberOfPublishedBooks
FROM Books
GROUP BY Published
ORDER BY TotalNumberOfPublishedBooks DESC;


/*************************************************************/
/* Book Statistics                                           */
/* create a report to show 5 most popular Books to check out */
/*************************************************************/
SELECT b.Title, b.Author, b.Published, COUNT(b.Title) AS TotalTimesOfLoans
FROM Books b
JOIN Loans l
ON b.BookID = l.BookID
GROUP BY b.Title
ORDER BY 4 DESC
LIMIT 5;