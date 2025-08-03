CREATE DATABASE OnlineBookStore

CREATE TABLE books (
	Book_ID VARCHAR(100),
	Title VARCHAR(100),
	Author VARCHAR(50),
	Genre VARCHAR(50),
	Published_Year INT,
	Price NUMERIC(10,2),
	Stock INT
);
COPY books (Book_ID, Title, Author, Genre, Published_Year, Price, Stock)
FROM 'C:\\Books.csv'
CSV HEADER;
SELECT * FROM books



CREATE TABLE costumers(
	Customer_ID INT PRIMARY KEY,
	Name VARCHAR(50),
	Email VARCHAR(50),
	Phone INT,
	City VARCHAR(50),
	Country VARCHAR(80)
);
COPY costumers (Customer_ID, Name, Email, Phone, City, Country)
FROM 'C:\\Customers.csv'
CSV HEADER;
SELECT * FROM costumers


CREATE TABLE oders (
	Order_ID INT PRIMARY KEY,
	Customer_ID INT,
	Book_ID INT,
	Order_Date DATE,
	Quantity INT,
	Total_Amount NUMERIC(10,2)
);
COPY oders (Order_ID, Customer_ID, Book_ID, Order_Date,	Quantity, Total_Amount)
FROM 'C:\\Orders.csv'
CSV HEADER;

--1.retrive all books from 'fiction' genre

SELECT *
FROM books
WHERE genre ILIKE 'fiction'; 

--2.book after 1950
SELECT * FROM books
WHERE published_year >= 1950;

--3.retrive book from nov 2023
SELECT * FROM oders
WHERE order_date BETWEEN '2023-09-01' AND '2023-09-30';

--4.RETRIVE TOTAL NUMBERS OF BOOKS
SELECT SUM(stock) as total_stock
FROM books;

SELECT * FROM books ORDER BY price DESC LIMIT 1;

--5.most frequently order book
SELECT o.book_id, b.Title,COUNT(o.order_id) AS ORDER_COUNT
FROM orders o
JOIN books b ON b.book_id = o.book_id;
GROUP BY o.book_id, b.title;
ORDER BY ORDER_COUNT DESC;


--6.top 3 most expensive book in fantasy genre.
SELECT * FROM books
WHERE genre ILIKE 'Fantasy'
ORDER BY price DESC LIMIT 3; 


--7.retreve the total quantity of books sold by each author
SELECT b.Author , SUM(o.Quantity) AS total_quantity
FROM books b
JOIN orders o ON o.book_id = b.book_id
GROUP BY b.Author
ORDER BY total_quantity DESC;

--8. List of the cities where custumers who spent over 30% are located
SELECT DISTINCT(c.city) , o.total_amount
FROM orders o
JOIN costumers c ON c.Customer_ID = o.Customer_ID
WHERE o.total_amount > 30 ORDER BY o.total_amount;

--9. Find out the customer who spent most on orders
SELECT c.name , sum(o.total_amount) as total_spents
FROM costumers c
JOIN orders o on o.customer_id = c.customer_id
GROUP BY name
ORDER BY total_spents DESC LIMIT 1 ;

--10. calculate the remaining stocks after full filling all orders

SELECT b.title, b.book_id, b.Stock, COALESCE(SUM(o.quantity),0) AS order_quantity,
	b.Stock - COALESCE(SUM(o.quantity),0) AS remaining_quantity
FROM books b
LEFT JOIN orders o ON b.book_id = o.book_id
GROUP BY b.book_id
ORDER BY b.book_id;






