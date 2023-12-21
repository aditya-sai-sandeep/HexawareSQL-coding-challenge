
-- CODING CHALLENGE CAR RENTAL SYSTEM
CREATE TABLE Vehicle (
vehicleID INT PRIMARY KEY,
make VARCHAR(50) ,
model VARCHAR(50),
year INT,
dailyRate DECIMAL(5, 2),
status INT CHECK (status IN (0, 1)),
passengerCapacity INT,
engineCapacity INT
);

CREATE TABLE Customer (
customerID INT PRIMARY KEY IDENTITY(1,1),
firstName VARCHAR(50) ,
lastName VARCHAR(50),
email VARCHAR(50),
phoneNumber CHAR(12)
);

CREATE TABLE Lease (
leaseID INT PRIMARY KEY,
vehicleID INT,
customerID INT,
startDate DATE,
endDate DATE,
type VARCHAR(50),
FOREIGN KEY (vehicleID) REFERENCES Vehicle(vehicleID) ON DELETE CASCADE,
FOREIGN KEY (customerID) REFERENCES Customer(customerID) ON DELETE CASCADE
);

CREATE TABLE Payment (
paymentID INT PRIMARY KEY IDENTITY(1,1),
leaseID INT,
paymentDate DATE,
amount DECIMAL(6, 2),
FOREIGN KEY (leaseID) REFERENCES Lease(leaseID) ON DELETE CASCADE
);




INSERT INTO Vehicle (vehicleID, make, model, year, dailyRate, status, passengerCapacity, engineCapacity)
VALUES
    (1, 'Toyota', 'Camry', 2022, 50.00, 1, 4, 1450),
    (2, 'Honda', 'Civic', 2023, 45.00, 1, 7, 1500),
    (3, 'Ford', 'Focus', 2022, 48.00, 0, 4, 1400),
    (4, 'Nissan', 'Altima', 2023, 52.00, 1, 7, 1200),
    (5, 'Chevrolet', 'Malibu', 2022, 47.00, 1, 4, 1800),
    (6, 'Hyundai', 'Sonata', 2023, 49.00, 0, 7, 1400),
    (7, 'BMW', '3 Series', 2023, 60.00, 1, 7, 2499),
    (8, 'Mercedes', 'C-Class', 2022, 58.00, 1, 8, 2599),
    (9, 'Audi', 'A4', 2022, 55.00, 0, 4, 2500),
    (10, 'Lexus', 'ES', 2023, 54.00, 1, 4, 2500);

INSERT INTO Customer (firstName, lastName, email, phoneNumber)
VALUES
    ('John', 'Doe', 'johndoe@example.com', '555-555-5555'),
    ('Jane', 'Smith', 'janesmith@example.com', '555-123-4567'),
    ('Robert', 'Johnson', 'robert@example.com', '555-789-1234'),
    ('Sarah', 'Brown', 'sarah@example.com', '555-456-7890'),
    ('David', 'Lee', 'david@example.com', '555-987-6543'),
    ('Laura', 'Hall', 'laura@example.com', '555-234-5678'),
    ('Michael', 'Davis', 'michael@example.com', '555-876-5432'),
    ('Emma', 'Wilson', 'emma@example.com', '555-432-1098'),
    ('William', 'Taylor', 'william@example.com', '555-321-6547'),
    ('Olivia', 'Adams', 'olivia@example.com', '555-765-4321');


INSERT INTO Lease (leaseID, vehicleID, customerID, startDate, endDate, type)
VALUES
    (1, 1, 1, '2023-01-01', '2023-01-05', 'Daily'),
    (2, 2, 2, '2023-02-15', '2023-02-28', 'Monthly'),
    (3, 3, 3, '2023-03-10', '2023-03-15', 'Daily'),
    (4, 4, 4, '2023-04-20', '2023-04-30', 'Monthly'),
    (5, 5, 5, '2023-05-05', '2023-05-10', 'Daily'),
    (6, 4, 3, '2023-06-15', '2023-06-30', 'Monthly'),
    (7, 7, 7, '2023-07-01', '2023-07-10', 'Daily'),
    (8, 8, 8, '2023-08-12', '2023-08-15', 'Monthly'),
    (9, 3, 3, '2023-09-07', '2023-09-10', 'Daily'),
    (10, 10, 10, '2023-10-10', '2023-10-31', 'Monthly');


INSERT INTO Payment (leaseID, paymentDate, amount)
VALUES
    (1, '2023-01-03', 200.00),
    (2, '2023-02-20', 1000.00),
    (3, '2023-03-12', 75.00),
    (4, '2023-04-25', 900.00),
    (5, '2023-05-07', 60.00),
    (6, '2023-06-18', 1200.00),
    (7, '2023-07-03', 40.00),
    (8, '2023-08-14', 1100.00),
    (9, '2023-09-09', 80.00),
    (10, '2023-10-25', 1500.00);

-- select * from Vehicle
-- select * from Customer
-- select * from Lease
-- select * from Payment


-- 1
-- select * from Vehicle
UPDATE Vehicle
SET dailyRate = 68
where make = "Mercedes"
-- select * from Vehicle

-- 2.
DECLARE @CustomerIDToDelete INT;
SET @CustomerIDToDelete = 3; 

-- select * from Customer
-- select * from Lease
-- select * from Payment

DELETE FROM Customer
WHERE customerID = @CustomerIDToDelete;

-- select * from Customer
-- select * from Lease
-- select * from Payment


-- 3.
exec sp_rename 'Payment.paymentDate', 'transactionDate', 'COLUMN';
SELECT * FROM PAYMENT;


-- 4.
select * from customer where email = 'johndoe@example.com'

-- 5.
select * from Lease l
inner join Customer c
on c.customerID = l.customerID
where c.customerID = 1

-- 6
select * from Payment where leaseID in (select leaseID from Lease where customerID in (select customerID from Customer where phoneNumber = '555-555-5555'))

-- 7.
select avg(dailyRate) from Vehicle where status= 1

-- 8
select TOP 1 make,model from Vehicle
order by dailyRate desc

-- 9.
select make,model from Vehicle 
where vehicleID in (
select l.vehicleID from Lease l
inner join Customer c
on c.customerID = l.customerID
where c.customerID=1
)

-- 10.
select TOP 1 * from Payment
order by transactionDate desc

-- 11. 
select * from Payment
where transactionDate like '2023%'

-- 12.
select firstName,lastName from Customer where customerID in 
(
select customerID from Lease where leaseID 
NOT in 
(select leaseID from Payment)
)

-- 13. 
select v.make, v.model, v.Year, v.dailyRate, v.engineCapacity,p.paymentID,p.leaseID 
from Payment p
inner join Lease l
on l.leaseID = p.leaseID
inner join Vehicle v
on v.vehicleID = l.vehicleID

-- 14.
select c.customerID,c.firstName,c.lastName,p.leaseID,p.amount from Payment p
inner join Lease l
on l.leaseID = p.leaseID
inner join Customer c
on c.customerID = l.customerID

-- 15.
select * from Vehicle v
inner join Lease l
on l.vehicleID = v.vehicleID

-- 16.
select v.make, v.model, v.year, CONCAT(c.firstName , ' ',c.lastName) as Name,
    c.email as customerEmail, c.phoneNumber
from Lease l
inner join Vehicle v 
on l.vehicleID = v.vehicleID
inner join Customer c 
on l.customerID = c.customerID
where l.startDate <= GETDATE() AND l.endDate >= GETDATE();


-- 17.
select TOp 1 c.firstName, c.lastName,p.amount from Payment p
inner join Lease l
on l.leaseID = p.leaseID
inner join Customer c
on c.customerID = l.customerID
order by p.amount desc

-- 18.
select v.vehicleID, v.make, v.model, l.startDate AS [lease Start Date], 
l.endDate AS [lease End Date]
from Vehicle v
left join Lease l 
on v.vehicleID = l.vehicleID

