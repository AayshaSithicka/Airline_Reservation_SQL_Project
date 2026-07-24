CREATE DATABASE Airline_Reservation_System;
USE Airline_Reservation_System;
 
-- ============================================================
-- TABLE CREATION
-- ============================================================
 
CREATE TABLE Airlines (
    airline_id INT PRIMARY KEY AUTO_INCREMENT,
    airline_name VARCHAR(100) NOT NULL,
    airline_code VARCHAR(10),
    country VARCHAR(50)
);
 
CREATE TABLE Airports (
    airport_id INT PRIMARY KEY AUTO_INCREMENT,
    airport_name VARCHAR(100),
    airport_code VARCHAR(10),
    city VARCHAR(50),
    country VARCHAR(50)
);
 
CREATE TABLE Aircraft (
    aircraft_id INT PRIMARY KEY AUTO_INCREMENT,
    airline_id INT,
    model_name VARCHAR(50),
    total_seats INT,
    FOREIGN KEY (airline_id) REFERENCES Airlines(airline_id)
);
 
CREATE TABLE Flights (
    flight_id INT PRIMARY KEY AUTO_INCREMENT,
    airline_id INT,
    aircraft_id INT,
    flight_number VARCHAR(10),
    source_airport INT,
    destination_airport INT,
    FOREIGN KEY (airline_id) REFERENCES Airlines(airline_id),
    FOREIGN KEY (aircraft_id) REFERENCES Aircraft(aircraft_id),
    FOREIGN KEY (source_airport) REFERENCES Airports(airport_id),
    FOREIGN KEY (destination_airport) REFERENCES Airports(airport_id)
);
 
CREATE TABLE Flight_Schedule (
    schedule_id INT PRIMARY KEY AUTO_INCREMENT,
    flight_id INT,
    departure_datetime DATETIME,
    arrival_datetime DATETIME,
    flight_status VARCHAR(20),
    FOREIGN KEY (flight_id) REFERENCES Flights(flight_id)
);
 
CREATE TABLE Classes (
    class_id INT PRIMARY KEY AUTO_INCREMENT,
    class_name VARCHAR(20),
    price_multiplier DECIMAL(3,2)
);
 
CREATE TABLE Seats (
    seat_id INT PRIMARY KEY AUTO_INCREMENT,
    aircraft_id INT,
    seat_number VARCHAR(10),
    class_id INT,
    FOREIGN KEY (aircraft_id) REFERENCES Aircraft(aircraft_id),
    FOREIGN KEY (class_id) REFERENCES Classes(class_id)
);
 
CREATE TABLE Passengers (
    passenger_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    gender VARCHAR(10),
    email VARCHAR(100),
    phone VARCHAR(15),
    passport_number VARCHAR(20)
);
 
CREATE TABLE Bookings (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    passenger_id INT,
    schedule_id INT,
    booking_date DATE,
    booking_status VARCHAR(20),
    FOREIGN KEY (passenger_id) REFERENCES Passengers(passenger_id),
    FOREIGN KEY (schedule_id) REFERENCES Flight_Schedule(schedule_id)
);
 
CREATE TABLE Tickets (
    ticket_id INT PRIMARY KEY AUTO_INCREMENT,
    booking_id INT,
    ticket_number VARCHAR(20),
    fare_amount DECIMAL(10,2),
    issue_date DATE,
    FOREIGN KEY (booking_id) REFERENCES Bookings(booking_id)
);
 
CREATE TABLE Seat_Booking (
    seat_booking_id INT PRIMARY KEY AUTO_INCREMENT,
    booking_id INT,
    seat_id INT,
    FOREIGN KEY (booking_id) REFERENCES Bookings(booking_id),
    FOREIGN KEY (seat_id) REFERENCES Seats(seat_id)
);
CREATE TABLE Payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    ticket_id INT,
    amount DECIMAL(10,2),
    payment_date DATE,
    payment_mode VARCHAR(20),
    payment_status VARCHAR(20),
    FOREIGN KEY (ticket_id) REFERENCES Tickets(ticket_id)
);
 
CREATE TABLE Ticket_Cancellation (
    cancellation_id INT PRIMARY KEY AUTO_INCREMENT,
    ticket_id INT,
    cancellation_date DATE,
    reason VARCHAR(150),
    FOREIGN KEY (ticket_id) REFERENCES Tickets(ticket_id)
);
 
CREATE TABLE Refunds (
    refund_id INT PRIMARY KEY AUTO_INCREMENT,
    cancellation_id INT,
    refund_amount DECIMAL(10,2),
    refund_date DATE,
    refund_status VARCHAR(20),
    FOREIGN KEY (cancellation_id) REFERENCES Ticket_Cancellation(cancellation_id)
);
 
CREATE TABLE Baggage (
    baggage_id INT PRIMARY KEY AUTO_INCREMENT,
    ticket_id INT,
    weight_kg DECIMAL(5,2),
    baggage_type VARCHAR(20),
    FOREIGN KEY (ticket_id) REFERENCES Tickets(ticket_id)
);
 
CREATE TABLE Crew (
    crew_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    role VARCHAR(30),
    airline_id INT,
    FOREIGN KEY (airline_id) REFERENCES Airlines(airline_id)
);
 
CREATE TABLE Flight_Crew (
    flight_crew_id INT PRIMARY KEY AUTO_INCREMENT,
    schedule_id INT,
    crew_id INT,
    FOREIGN KEY (schedule_id) REFERENCES Flight_Schedule(schedule_id),
    FOREIGN KEY (crew_id) REFERENCES Crew(crew_id)
);
 
CREATE TABLE Check_In (
    checkin_id INT PRIMARY KEY AUTO_INCREMENT,
    ticket_id INT,
    checkin_time DATETIME,
    boarding_gate VARCHAR(10),
    FOREIGN KEY (ticket_id) REFERENCES Tickets(ticket_id)
);
 
 -- basic
SELECT * FROM Airlines;
SELECT * FROM Airports;
SELECT * FROM Passengers;
SELECT f.flight_number, a.airline_name
FROM Flights f
JOIN Airlines a
ON f.airline_id = a.airline_id
WHERE a.airline_name = 'Air India';

-- SELECT passenger_id, name, age
-- FROM Passengers
-- WHERE age > 60;

SELECT
b.booking_id,
p.name AS passenger_name,
b.booking_status
FROM Bookings b
JOIN Passengers p
ON b.passenger_id = p.passenger_id
WHERE b.booking_status='Confirmed';

SELECT
f.flight_number,
fs.departure_datetime
FROM Flights f
JOIN Flight_Schedule fs
ON f.flight_id=fs.flight_id
WHERE fs.departure_datetime > '2026-07-15 12:00:00';

SELECT
name,
email
FROM Passengers
WHERE email LIKE '%gmail%';

SELECT
passenger_id,
name,
passport_number
FROM Passengers
WHERE passport_number LIKE 'P%';

SELECT
passenger_id,
name,
phone
FROM Passengers
WHERE phone LIKE '%99';

SELECT
f.flight_number,
fs.flight_status
FROM Flights f
JOIN Flight_Schedule fs
ON f.flight_id=fs.flight_id
WHERE fs.flight_status='Delayed';

SELECT
booking_id,
booking_date
FROM Bookings
WHERE booking_date
BETWEEN '2026-06-01'
AND '2026-06-30';

SELECT
passenger_id,
name
FROM Passengers
WHERE name LIKE '_______';

SELECT DISTINCT payment_mode
FROM Payments;

SELECT
baggage_id,
ticket_id,
weight_kg
FROM Baggage
WHERE weight_kg > 20;

SELECT
payment_id,
amount
FROM Payments
WHERE amount >10000;

SELECT
ticket_number,
issue_date
FROM Tickets
WHERE issue_date > '2026-06-20';

SELECT
p.name,
p.gender,
b.booking_status
FROM Passengers p
JOIN Bookings b
ON p.passenger_id=b.passenger_id
WHERE p.gender='Female'
AND b.booking_status='Confirmed';


SELECT
a.airline_name,
COUNT(f.flight_id) AS Total_Flights
FROM Airlines a
JOIN Flights f
ON a.airline_id = f.airline_id
GROUP BY a.airline_name;

SELECT
a.airline_name,
AVG(t.fare_amount) AS Average_Fare
FROM Airlines a
JOIN Flights f
ON a.airline_id = f.airline_id
JOIN Flight_Schedule fs
ON f.flight_id = fs.flight_id
JOIN Bookings b
ON fs.schedule_id = b.schedule_id
JOIN Tickets t
ON b.booking_id = t.booking_id
GROUP BY a.airline_name;

SELECT
a.airline_name,
SUM(p.amount) AS Total_Revenue
FROM Airlines a
JOIN Flights f
ON a.airline_id = f.airline_id
JOIN Flight_Schedule fs
ON f.flight_id = fs.flight_id
JOIN Bookings b
ON fs.schedule_id = b.schedule_id
JOIN Tickets t
ON b.booking_id = t.booking_id
JOIN Payments p
ON t.ticket_id = p.ticket_id
GROUP BY a.airline_name;

SELECT
c.class_name,
MAX(t.fare_amount) AS Maximum_Fare
FROM Classes c
JOIN Seats s
ON c.class_id = s.class_id
JOIN Seat_Booking sb
ON s.seat_id = sb.seat_id
JOIN Tickets t
ON sb.booking_id = t.booking_id
GROUP BY c.class_name;

SELECT
MIN(weight_kg) AS Minimum_Baggage_Weight
FROM Baggage;

SELECT
a.airline_name,
COUNT(f.flight_id) AS Total_Flights
FROM Airlines a
JOIN Flights f
ON a.airline_id = f.airline_id
GROUP BY a.airline_name
HAVING COUNT(f.flight_id) > 10;

SELECT
p.name,
COUNT(b.booking_id) AS Total_Bookings
FROM Passengers p
JOIN Bookings b
ON p.passenger_id = b.passenger_id
GROUP BY p.name
HAVING COUNT(b.booking_id) > 1;

SELECT
f.flight_number,
COUNT(b.booking_id) AS Total_Bookings
FROM Flights f
JOIN Flight_Schedule fs
ON f.flight_id = fs.flight_id
JOIN Bookings b
ON fs.schedule_id = b.schedule_id
GROUP BY f.flight_number
HAVING COUNT(b.booking_id) > 100;

SELECT
p.name AS Passenger,
f.flight_number,
b.booking_status
FROM Passengers p
JOIN Bookings b
ON p.passenger_id = b.passenger_id
JOIN Flight_Schedule fs
ON b.schedule_id = fs.schedule_id
JOIN Flights f
ON fs.flight_id = f.flight_id;

SELECT
f.flight_number,
a1.airport_name AS Source,
a2.airport_name AS Destination
FROM Flights f
JOIN Airports a1
ON f.source_airport = a1.airport_id
JOIN Airports a2
ON f.destination_airport = a2.airport_id;

SELECT
p.name,
t.ticket_number,
pay.amount
FROM Passengers p
JOIN Bookings b
ON p.passenger_id = b.passenger_id
JOIN Tickets t
ON b.booking_id = t.booking_id
JOIN Payments pay
ON t.ticket_id = pay.ticket_id;

SELECT
p.name,
b.booking_status
FROM Passengers p
JOIN Bookings b
ON p.passenger_id = b.passenger_id
WHERE b.booking_status <> 'Cancelled';

SELECT
f.flight_number,
fs.flight_status
FROM Flights f
JOIN Flight_Schedule fs
ON f.flight_id = fs.flight_id
WHERE fs.flight_status='Scheduled'
OR fs.flight_status='Boarding';

SELECT
p.name,
c.class_name,
pay.amount
FROM Passengers p
JOIN Bookings b
ON p.passenger_id = b.passenger_id
JOIN Seat_Booking sb
ON b.booking_id = sb.booking_id
JOIN Seats s
ON sb.seat_id = s.seat_id
JOIN Classes c
ON s.class_id = c.class_id
JOIN Tickets t
ON b.booking_id = t.booking_id
JOIN Payments pay
ON t.ticket_id = pay.ticket_id
WHERE c.class_name='Business'
AND pay.amount >15000;

SELECT DISTINCT country
FROM Airlines;







SELECT
    p.name AS Passenger,
    SUM(pay.amount) AS Total_Amount,
    RANK() OVER (ORDER BY SUM(pay.amount) DESC) AS Passenger_Rank
FROM Passengers p
JOIN Bookings b
ON p.passenger_id = b.passenger_id
JOIN Tickets t
ON b.booking_id = t.booking_id
JOIN Payments pay
ON t.ticket_id = pay.ticket_id
GROUP BY p.passenger_id, p.name;

SELECT *
FROM
(
    SELECT
        a.airline_name,
        SUM(pay.amount) AS Total_Revenue,
        DENSE_RANK() OVER (ORDER BY SUM(pay.amount) DESC) AS Revenue_Rank
    FROM Airlines a
    JOIN Flights f
    ON a.airline_id = f.airline_id
    JOIN Flight_Schedule fs
    ON f.flight_id = fs.flight_id
    JOIN Bookings b
    ON fs.schedule_id = b.schedule_id
    JOIN Tickets t
    ON b.booking_id = t.booking_id
    JOIN Payments pay
    ON t.ticket_id = pay.ticket_id
    GROUP BY a.airline_name
) AS AirlineRevenue
WHERE Revenue_Rank <= 3;

SELECT
    a.airline_name,
    SUM(pay.amount) AS Revenue,
    SUM(SUM(pay.amount))
    OVER(ORDER BY a.airline_name) AS Cumulative_Revenue
FROM Airlines a
JOIN Flights f
ON a.airline_id=f.airline_id
JOIN Flight_Schedule fs
ON f.flight_id=fs.flight_id
JOIN Bookings b
ON fs.schedule_id=b.schedule_id
JOIN Tickets t
ON b.booking_id=t.booking_id
JOIN Payments pay
ON t.ticket_id=pay.ticket_id
GROUP BY a.airline_name;

SELECT
    p.name,
    t.ticket_number,
    t.fare_amount
FROM Passengers p
JOIN Bookings b
ON p.passenger_id=b.passenger_id
JOIN Tickets t
ON b.booking_id=t.booking_id
WHERE t.fare_amount >
(
    SELECT AVG(fare_amount)
    FROM Tickets
);

SELECT
    f.flight_number,
    COUNT(b.booking_id) AS Total_Bookings
FROM Flights f
JOIN Flight_Schedule fs
ON f.flight_id=fs.flight_id
JOIN Bookings b
ON fs.schedule_id=b.schedule_id
GROUP BY f.flight_number
HAVING COUNT(b.booking_id) >
(
    SELECT AVG(Bookings_Count)
    FROM
    (
        SELECT COUNT(*) AS Bookings_Count
        FROM Bookings
        GROUP BY schedule_id
    ) AS AvgBooking
);

CREATE VIEW Passenger_Booking_Details AS
SELECT
    p.name AS Passenger,
    f.flight_number AS Flight,
    b.booking_status,
    t.ticket_number
FROM Passengers p
JOIN Bookings b
ON p.passenger_id=b.passenger_id
JOIN Flight_Schedule fs
ON b.schedule_id=fs.schedule_id
JOIN Flights f
ON fs.flight_id=f.flight_id
JOIN Tickets t
ON b.booking_id=t.booking_id;

DELIMITER //

CREATE PROCEDURE GetPassengerBooking(IN pid INT)
BEGIN
SELECT
    p.name,
    f.flight_number,
    b.booking_status,
    t.ticket_number
FROM Passengers p
JOIN Bookings b
ON p.passenger_id=b.passenger_id
JOIN Flight_Schedule fs
ON b.schedule_id=fs.schedule_id
JOIN Flights f
ON fs.flight_id=f.flight_id
JOIN Tickets t
ON b.booking_id=t.booking_id
WHERE p.passenger_id=pid;
END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER CheckPaymentAmount
BEFORE INSERT
ON Payments
FOR EACH ROW
BEGIN
    IF NEW.amount < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT='Payment amount cannot be negative';
    END IF;
END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER UpdateBookingStatus
AFTER INSERT
ON Ticket_Cancellation
FOR EACH ROW
BEGIN
UPDATE Bookings
SET booking_status='Cancelled'
WHERE booking_id=
(
SELECT booking_id
FROM Tickets
WHERE ticket_id=NEW.ticket_id
);
END //

DELIMITER ;

SELECT
    b.booking_id,
    p.name,
    b.booking_date
FROM Bookings b
JOIN Passengers p
ON b.passenger_id=p.passenger_id
ORDER BY b.booking_date
LIMIT 10 OFFSET 10;