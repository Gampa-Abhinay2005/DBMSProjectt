-- Travel Booking System
	
-- Creating Tables

CREATE TABLE Users (
    user_id SERIAL PRIMARY KEY NOT NULL,
    userName VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    address TEXT,
    phone_number VARCHAR(20),
    age INTEGER,
    Email VARCHAR(255) UNIQUE,
    RegistrationDate DATE,
    Last_login_date DATE,
    Account_Status VARCHAR(20)
);
select * from users;
CREATE TABLE Payment_Details (
    payment_id SERIAL PRIMARY KEY NOT NULL,
    payment_date DATE ,
    mode_of_payment VARCHAR(50),
    payment_amount NUMERIC(10, 2) NOT NULL,
    payment_status VARCHAR(20)
);

CREATE TABLE Flight(
    flight_id SERIAL PRIMARY KEY NOT NULL,
    Airline VARCHAR(255) NOT NULL,
    Departure_airport VARCHAR(255) NOT NULL,
    Arrival_airport VARCHAR(255) NOT NULL,
    Departure_date_time TIMESTAMP ,
    Arrival_date_time TIMESTAMP ,
    Airline_type VARCHAR(50) ,
    Flight_status VARCHAR(20) 
);

CREATE TABLE Booking_Information (
    booking_id SERIAL PRIMARY KEY NOT NULL,
    user_id INTEGER REFERENCES Users(user_id),
    total_cost NUMERIC(10, 2),
    payment_id INTEGER REFERENCES Payment_details(payment_id),
    booking_date DATE,
    flight_id INTEGER REFERENCES Flight(flight_id),
    Departure_date DATE,
    Arrival_date DATE ,
    Departure_terminal VARCHAR(15),
    Arrival_terminal VARCHAR(15)
);

CREATE TABLE Reviews_and_Ratings (
    review_id SERIAL PRIMARY KEY NOT NULL,
    user_id INTEGER REFERENCES Users(user_id),
    flight_id INTEGER REFERENCES Flight(flight_id),
    review_text TEXT,
    review_date DATE,
    rating INTEGER CHECK(rating BETWEEN 1 AND 5),
    rating_status VARCHAR(20)
);

CREATE TABLE Multi_flight_connections (
    ConnectionID SERIAL PRIMARY KEY NOT NULL,
    original_flight_id INTEGER REFERENCES Flight(flight_id),
    Connected_flight_id INTEGER REFERENCES Flight(flight_id) ,
    Leg_number INTEGER NOT NULL,
    Layover_duration INTERVAL,
    Layover_airport VARCHAR(255)
);
DROP TABLE multi_flight_connections CASCADE;
CREATE TABLE Passengers_list (
    user_id INTEGER REFERENCES Users(user_id),
    booking_id INTEGER REFERENCES Booking_Information(booking_id),
    name VARCHAR(255) NOT NULL,
    age INTEGER NOT NULL,
    gender VARCHAR(10) NOT NULL,
    passenger_type VARCHAR(20),
    PRIMARY KEY (user_id, booking_id)
);

CREATE TABLE Seat_class (
    flight_id INTEGER REFERENCES Flight(flight_id),
    type_of_seat VARCHAR(50),
    seat_number VARCHAR(10) NOT NULL,
    Price NUMERIC(10, 2) NOT NULL,
    availability_status VARCHAR(20) NOT NULL,
    seat_status VARCHAR(20),
    seat_features VARCHAR(255),
    PRIMARY KEY (flight_id, type_of_seat, seat_number)
);

CREATE TABLE Food_options_table (
    Food_id SERIAL PRIMARY KEY NOT NULL,
    flight_id INTEGER REFERENCES Flight(flight_id),
    food_type VARCHAR(50),
    description TEXT,
    Price NUMERIC(10, 2) NOT NULL,
    availability_status VARCHAR(20),
    dietary_instructions VARCHAR(255),
    food_status VARCHAR(20)
);


CREATE TABLE Promotions_table (
    promotion_id SERIAL PRIMARY KEY NOT NULL,
    Promo_code VARCHAR(50) NOT NULL,
    discount_amount NUMERIC(10, 2) NOT NULL,
    valid_from DATE NOT NULL,
    valid_until DATE NOT NULL,
    description TEXT,
    booking_id INTEGER REFERENCES Booking_Information(booking_id)
);

CREATE TABLE Login_Attempts (
    attempt_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(user_id),
    login_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    login_success BOOLEAN
);


-- Inserting 5 values each into the table
INSERT INTO Flight (Airline, Departure_airport, Arrival_airport, Departure_date_time, Arrival_date_time, Airline_type, Flight_status)
VALUES ('Delta Airlines', 'JFK', 'LAX', '2024-05-01 08:00:00', '2024-05-01 11:30:00', 'Domestic', 'On Time'),
       ('United Airlines', 'ORD', 'SFO', '2024-05-02 10:00:00', '2024-05-02 13:30:00', 'Domestic', 'Delayed'),
       ('Emirates', 'DXB', 'JFK', '2024-05-03 15:00:00', '2024-05-03 20:30:00', 'International', 'On Time'),
       ('British Airways', 'LHR', 'JFK', '2024-05-04 14:00:00', '2024-05-04 17:30:00', 'International', 'On Time'),
       ('Air France', 'CDG', 'LAX', '2024-05-05 16:00:00', '2024-05-05 20:30:00', 'International', 'On Time');
INSERT INTO Flight(Airline, Departure_airport, Arrival_airport, Departure_date_time, Arrival_date_time, Airline_type, Flight_status)
VALUES ('Delta Airlines', 'JFK', 'LAX', '2024-05-10 8:00:00', '2024-05-10 11:30:00', 'Domestic', 'On Time'),
		('Delta Airlines', 'LAX', 'SFO', '2024-05-10 14:30:00', '2024-05-10 16:30:00', 'Domestic', 'On Time');
INSERT INTO Flight(Airline, Departure_airport, Arrival_airport, Departure_date_time, Arrival_date_time, Airline_type, Flight_status)
VALUES 
('American Airlines', 'LAX', 'ORD', '2024-05-11 10:00:00', '2024-05-11 16:30:00', 'Domestic', 'On Time'),
('United Airlines', 'SFO', 'DEN', '2024-05-11 12:30:00', '2024-05-11 15:00:00', 'Domestic', 'On Time'),
('Southwest Airlines', 'ATL', 'HOU', '2024-05-11 14:00:00', '2024-05-11 16:30:00', 'Domestic', 'On Time'),
('JetBlue Airways', 'BOS', 'MCO', '2024-05-11 9:30:00', '2024-05-11 13:00:00', 'Domestic', 'On Time'),
('Delta Airlines', 'SEA', 'LAS', '2024-05-11 11:15:00', '2024-05-11 14:00:00', 'Domestic', 'On Time'),
('Alaska Airlines', 'PDX', 'SAN', '2024-05-11 13:45:00', '2024-05-11 16:15:00', 'Domestic', 'On Time'),
('Frontier Airlines', 'MIA', 'JFK', '2024-05-11 12:00:00', '2024-05-11 15:30:00', 'Domestic', 'On Time'),
('Spirit Airlines', 'DFW', 'ORD', '2024-05-11 14:45:00', '2024-05-11 17:30:00', 'Domestic', 'On Time'),
('Allegiant Air', 'PHX', 'LAS', '2024-05-11 15:30:00', '2024-05-11 18:00:00', 'Domestic', 'On Time'),
('Hawaiian Airlines', 'HNL', 'LAX', '2024-05-11 17:00:00', '2024-05-11 21:30:00', 'Domestic', 'On Time');
INSERT INTO Flight(Airline, Departure_airport, Arrival_airport, Departure_date_time, Arrival_date_time, Airline_type, Flight_status)
VALUES 
('Delta Airlines', 'JFK', 'LAX', '2024-05-20 08:00:00', '2024-05-20 11:30:00', 'Domestic', 'On Time'),
('Delta Airlines', 'LAX', 'SFO', '2024-05-20 14:30:00', '2024-05-20 16:30:00', 'Domestic', 'On Time'),
('United Airlines', 'SFO', 'JFK', '2024-05-20 12:00:00', '2024-05-20 18:30:00', 'Domestic', 'On Time'),
('American Airlines', 'ORD', 'LAX', '2024-05-20 09:00:00', '2024-05-20 13:30:00', 'Domestic', 'On Time'),
('American Airlines', 'LAX', 'JFK', '2024-05-20 16:00:00', '2024-05-20 22:30:00', 'Domestic', 'On Time'),
('JetBlue Airways', 'JFK', 'MIA', '2024-05-20 10:30:00', '2024-05-20 13:30:00', 'Domestic', 'On Time'),
('JetBlue Airways', 'MIA', 'LAX', '2024-05-20 14:00:00', '2024-05-20 17:00:00', 'Domestic', 'On Time'),
('Southwest Airlines', 'LAX', 'LAS', '2024-05-20 09:30:00', '2024-05-20 10:30:00', 'Domestic', 'On Time'),
('Southwest Airlines', 'LAS', 'SFO', '2024-05-20 11:00:00', '2024-05-20 13:00:00', 'Domestic', 'On Time'),
('Alaska Airlines', 'SFO', 'SEA', '2024-05-20 14:30:00', '2024-05-20 16:00:00', 'Domestic', 'On Time');

SELECT * FROM flight;
SELECT * FROM flight;
INSERT INTO Seat_class(flight_id, type_of_seat, seat_number, Price, availability_status, seat_status, seat_features)
VALUES 
(7,'Economy', 'E1', 200.00, 'Available', 'Occupied', 'Window seat'),
(7,'Economy', 'E2', 200.00, 'Available', 'Empty', 'Aisle seat'),
(8,'Economy', 'E3', 250.00, 'Available', 'Empty', 'Window seat');
INSERT INTO Seat_class(flight_id, type_of_seat, seat_number, Price, availability_status, seat_status, seat_features)
VALUES 
(9, 'Economy', 'E4', 230.00, 'Available', 'Empty', 'Middle seat'),
(9, 'Business', 'B1', 500.00, 'Available', 'Occupied', 'Lie-flat seat'),
(10, 'Economy', 'E5', 240.00, 'Available', 'Empty', 'Window seat'),
(10, 'First Class', 'F1', 700.00, 'Available', 'Empty', 'Luxury suite seat'),
(11, 'Economy', 'E6', 220.00, 'Available', 'Empty', 'Aisle seat'),
(11, 'Business', 'B2', 550.00, 'Available', 'Empty', 'Reclining seat'),
(12, 'Economy', 'E7', 210.00, 'Available', 'Empty', 'Aisle seat'),
(12, 'First Class', 'F2', 750.00, 'Available', 'Empty', 'Private cabin seat'),
(13, 'Economy', 'E8', 260.00, 'Available', 'Empty', 'Middle seat'),
(13, 'Business', 'B3', 600.00, 'Available', 'Empty', 'Premium seat'),
(14, 'Economy', 'E9', 270.00, 'Available', 'Empty', 'Window seat'),
(14, 'First Class', 'F3', 800.00, 'Available', 'Empty', 'Luxury suite seat'),
(15, 'Economy', 'E10', 280.00, 'Available', 'Empty', 'Middle seat'),
(15, 'Business', 'B4', 650.00, 'Available', 'Empty', 'Reclining seat'),
(16, 'Economy', 'E11', 290.00, 'Available', 'Empty', 'Aisle seat'),
(16, 'First Class', 'F4', 850.00, 'Available', 'Empty', 'Private cabin seat'),
(17, 'Economy', 'E12', 300.00, 'Available', 'Empty', 'Window seat'),
(17, 'Business', 'B5', 700.00, 'Available', 'Empty', 'Premium seat'),
(18, 'Economy', 'E13', 310.00, 'Available', 'Empty', 'Middle seat'),
(18, 'First Class', 'F5', 900.00, 'Available', 'Empty', 'Luxury suite seat');
INSERT INTO Seat_class(flight_id, type_of_seat, seat_number, Price, availability_status, seat_status, seat_features)
VALUES 
(18, 'Economy', 'E14', 320.00, 'Available', 'Empty', 'Middle seat'),
(18, 'Business', 'B6', 950.00, 'Available', 'Empty', 'Luxury suite seat'),
(19, 'Economy', 'E15', 330.00, 'Available', 'Empty', 'Window seat'),
(19, 'First Class', 'F6', 1000.00, 'Available', 'Empty', 'Private cabin seat'),
(20, 'Economy', 'E16', 340.00, 'Available', 'Empty', 'Middle seat'),
(20, 'Business', 'B7', 900.00, 'Available', 'Empty', 'Reclining seat'),
(21, 'Economy', 'E17', 310.00, 'Available', 'Empty', 'Window seat'),
(21, 'First Class', 'F7', 1050.00, 'Available', 'Empty', 'Luxury suite seat'),
(22, 'Economy', 'E18', 330.00, 'Available', 'Empty', 'Middle seat'),
(22, 'Business', 'B8', 920.00, 'Available', 'Empty', 'Premium seat'),
(23, 'Economy', 'E19', 320.00, 'Available', 'Empty', 'Aisle seat'),
(23, 'First Class', 'F8', 1100.00, 'Available', 'Empty', 'Private cabin seat'),
(24, 'Economy', 'E20', 340.00, 'Available', 'Empty', 'Window seat'),
(24, 'Business', 'B9', 950.00, 'Available', 'Empty', 'Reclining seat'),
(25, 'Economy', 'E21', 310.00, 'Available', 'Empty', 'Middle seat'),
(25, 'First Class', 'F9', 1000.00, 'Available', 'Empty', 'Luxury suite seat'),
(26, 'Economy', 'E22', 320.00, 'Available', 'Empty', 'Aisle seat'),
(26, 'Business', 'B10', 900.00, 'Available', 'Empty', 'Premium seat'),
(27, 'Economy', 'E23', 330.00, 'Available', 'Empty', 'Window seat'),
(27, 'First Class', 'F10', 1050.00, 'Available', 'Empty', 'Private cabin seat'),
(28, 'Economy', 'E24', 310.00, 'Available', 'Empty', 'Middle seat'),
(28, 'Business', 'B11', 920.00, 'Available', 'Empty', 'Reclining seat');

INSERT INTO Food_options_table(flight_id, food_type, description, Price, availability_status, dietary_instructions, food_status)
VALUES 
(7,'Meal', 'Chicken Sandwich', 15.00, 'Available', 'No allergies', 'Served'),
(8,'Snack', 'Bag of Chips', 5.00, 'Available', 'No dietary restrictions', 'Served'),
(7,'Meal', 'Vegetarian Pasta', 20.00, 'Available', 'Vegetarian', 'Served');
INSERT INTO Food_options_table(flight_id, food_type, description, Price, availability_status, dietary_instructions, food_status)
VALUES 
(9, 'Meal', 'Beef Steak', 25.00, 'Available', 'No allergies', 'Served'),
(9, 'Snack', 'Cookies', 7.00, 'Available', 'No dietary restrictions', 'Served'),
(10, 'Meal', 'Salmon Fillet', 30.00, 'Available', 'Pescatarian', 'Served'),
(10, 'Snack', 'Fruit Cup', 8.00, 'Available', 'No dietary restrictions', 'Served'),
(11, 'Meal', 'Vegetable Stir Fry', 20.00, 'Available', 'Vegetarian', 'Served'),
(11, 'Snack', 'Pretzels', 6.00, 'Available', 'No dietary restrictions', 'Served'),
(12, 'Meal', 'Lobster Tail', 40.00, 'Available', 'No allergies', 'Served'),
(12, 'Snack', 'Granola Bar', 5.00, 'Available', 'No dietary restrictions', 'Served'),
(13, 'Meal', 'Pork Chop', 28.00, 'Available', 'No allergies', 'Served'),
(13, 'Snack', 'Cheese Platter', 10.00, 'Available', 'No dietary restrictions', 'Served'),
(14, 'Meal', 'Chicken Alfredo', 35.00, 'Available', 'No allergies', 'Served'),
(14, 'Snack', 'Mixed Nuts', 9.00, 'Available', 'No dietary restrictions', 'Served'),
(15, 'Meal', 'Steak and Potatoes', 45.00, 'Available', 'No allergies', 'Served'),
(15, 'Snack', 'Chocolate Bar', 4.00, 'Available', 'No dietary restrictions', 'Served'),
(16, 'Meal', 'Shrimp Scampi', 32.00, 'Available', 'No allergies', 'Served'),
(16, 'Snack', 'Trail Mix', 6.00, 'Available', 'No dietary restrictions', 'Served'),
(17, 'Meal', 'BBQ Ribs', 38.00, 'Available', 'No allergies', 'Served'),
(17, 'Snack', 'Popcorn', 3.00, 'Available', 'No dietary restrictions', 'Served'),
(18, 'Meal', 'Grilled Salmon', 40.00, 'Available', 'Pescatarian', 'Served'),
(18, 'Snack', 'Pretzel Sticks', 5.00, 'Available', 'No dietary restrictions', 'Served');

INSERT INTO Food_options_table(flight_id, food_type, description, Price, availability_status, dietary_instructions, food_status)
VALUES 
(18, 'Meal', 'Beef Steak', 30.00, 'Available', 'No allergies', 'Served'),
(18, 'Snack', 'Cookies', 8.00, 'Available', 'No dietary restrictions', 'Served'),
(19, 'Meal', 'Chicken Alfredo', 35.00, 'Available', 'No allergies', 'Served'),
(19, 'Snack', 'Mixed Nuts', 9.00, 'Available', 'No dietary restrictions', 'Served'),
(20, 'Meal', 'Shrimp Scampi', 32.00, 'Available', 'No allergies', 'Served'),
(20, 'Snack', 'Trail Mix', 7.00, 'Available', 'No dietary restrictions', 'Served'),
(21, 'Meal', 'BBQ Ribs', 38.00, 'Available', 'No allergies', 'Served'),
(21, 'Snack', 'Popcorn', 5.00, 'Available', 'No dietary restrictions', 'Served'),
(22, 'Meal', 'Grilled Salmon', 40.00, 'Available', 'Pescatarian', 'Served'),
(22, 'Snack', 'Pretzel Sticks', 6.00, 'Available', 'No dietary restrictions', 'Served'),
(23, 'Meal', 'Vegetable Stir Fry', 20.00, 'Available', 'Vegetarian', 'Served'),
(23, 'Snack', 'Pretzels', 4.00, 'Available', 'No dietary restrictions', 'Served'),
(24, 'Meal', 'Lobster Tail', 45.00, 'Available', 'No allergies', 'Served'),
(24, 'Snack', 'Granola Bar', 5.00, 'Available', 'No dietary restrictions', 'Served'),
(25, 'Meal', 'Pork Chop', 28.00, 'Available', 'No allergies', 'Served'),
(25, 'Snack', 'Cheese Platter', 10.00, 'Available', 'No dietary restrictions', 'Served'),
(26, 'Meal', 'Chicken Sandwich', 15.00, 'Available', 'No allergies', 'Served'),
(26, 'Snack', 'Bag of Chips', 4.00, 'Available', 'No dietary restrictions', 'Served'),
(27, 'Meal', 'Vegetarian Pasta', 20.00, 'Available', 'Vegetarian', 'Served'),
(27, 'Snack', 'Fruit Cup', 7.00, 'Available', 'No dietary restrictions', 'Served'),
(28, 'Meal', 'Salmon Fillet', 30.00, 'Available', 'Pescatarian', 'Served'),
(28, 'Snack', 'Chocolate Bar', 3.00, 'Available', 'No dietary restrictions', 'Served');


INSERT INTO Multi_flight_connections (original_flight_id, connected_flight_id, leg_number, layover_duration, layover_airport)
VALUES (7, 8, 1, '3 hours', 'LAX');
INSERT INTO Multi_flight_connections (original_flight_id, connected_flight_id, leg_number, layover_duration, layover_airport)
VALUES (19, 20,1,'3 hours', 'LAX'),
       (22, 23, 1, '2.5 hours', 'LAX'),
	   (26, 27, 1, '0.5 hours', 'LAX'),
	   (27,28,1, '1.5	hours', 'SFO');
SELECT * FROM multi_flight_connections;
SELECT * FROM flight; 

INSERT INTO Users (userName, password, first_name, last_name, address, phone_number, age, Email, RegistrationDate, Last_login_date, Account_Status)
VALUES ('john_doe', 'password123', 'John', 'Doe', '123 Main St, Anytown', '123-456-7890', 30, 'john.doe@example.com', '2024-04-01', '2024-04-25', 'Active'),
       ('jane_smith', 'securepwd456', 'Jane', 'Smith', '456 Elm St, Othertown', '987-654-3210', 25, 'jane.smith@example.com', '2024-03-15', '2024-04-24', 'Active'),
       ('mike_jones', 'strongpass789', 'Mike', 'Jones', '789 Oak Ave, Anycity', '555-123-4567', 35, 'mike.jones@example.com', '2024-02-10', '2024-04-23', 'Active'),
       ('sarah_brown', 'password123', 'Sarah', 'Brown', '456 Pine St, Somewhere', '111-222-3333', 28, 'sarah.brown@example.com', '2024-01-05', '2024-04-22', 'Active'),
       ('chris_evans', 'captainamerica', 'Chris', 'Evans', '789 Cedar St, Nowhere', '999-888-7777', 40, 'chris.evans@example.com', '2023-12-20', '2024-04-21', 'Active');
SELECT * FROM Users;

INSERT INTO Payment_Details (payment_date, mode_of_payment, payment_amount, payment_status)
VALUES ('2024-04-25', 'Credit Card', 1500.00, 'Success'),
       ('2024-04-24', 'PayPal', 1200.00, 'Success'),
       ('2024-04-23', 'Credit Card', 800.00, 'Success'),
       ('2024-04-22', 'Credit Card', 1000.00, 'Failed'), -- This payment failed
       ('2024-04-21', 'Debit Card', 1300.00, 'Success');

SELECT * FROM Payment_Details;

INSERT INTO Booking_Information (user_id, total_cost, payment_id, booking_date, flight_id, Departure_date, Arrival_date, Departure_terminal, Arrival_terminal)
VALUES (1, 1500.00, 1, '2024-04-25', 1, '2024-05-01', '2024-05-01', 'A', 'B'),  -- Booking by John Doe
       (2, 1200.00, 2, '2024-04-24', 2, '2024-05-02', '2024-05-02', 'C', 'D'),  -- Booking by Jane Smith
       (3, 800.00, 3, '2024-04-23', 3, '2024-05-03', '2024-05-03', 'E', 'F'),   -- Booking by Mike Jones
       (4, 1000.00, 4, '2024-04-22', 4, '2024-05-04', '2024-05-04', 'G', 'H'), -- Booking by Sarah Brown (failed payment)
       (5, 1300.00, 5, '2024-04-21', 5, '2024-05-05', '2024-05-05', 'I', 'J'); -- Booking by Chris Evans
SELECT * FROM Booking_Information

INSERT INTO Reviews_and_Ratings (user_id, flight_id, review_text, review_date, rating, rating_status)
VALUES (1, 1, 'Great flight experience!', '2024-05-01', 5, 'Approved'),    -- Review by John Doe for Delta Airlines flight
       (2, 2, 'Delayed but good service.', '2024-05-02', 4, 'Approved'),  -- Review by Jane Smith for United Airlines flight
       (3, 3, 'Smooth international flight.', '2024-05-03', 5, 'Approved'), -- Review by Mike Jones for Emirates flight
       (5, 5, 'On time and comfortable.', '2024-05-05', 5, 'Approved'); -- Review by Chris Evans for Air France flight

SELECT * FROM Reviews_and_ratings;
-- Delta Airlines (JFK -> LAX) connected to Emirates (LAX -> DXB)


-- Emirates (LAX -> DXB) connected to Delta Airlines (DXB -> JFK)
INSERT INTO Multi_flight_connections (original_flight_id, connected_flight_id, leg_number, layover_duration, layover_airport)
VALUES ((SELECT flight_id FROM Flight WHERE Airline = 'Emirates' AND Departure_airport = 'LAX' AND Arrival_airport = 'DXB'), 
        (SELECT flight_id FROM Flight WHERE Airline = 'Delta Airlines' AND Departure_airport = 'DXB' AND Arrival_airport = 'JFK'), 
        1, '2 hours', 'DXB');

SELECT * FROM seat_class;
select * FROM Multi_flight_connections;
INSERT INTO Passengers_list (user_id, booking_id, name, age, gender, passenger_type)
VALUES (1, 1, 'John Doe', 30, 'Male', 'Adult'),
       (2, 2, 'Jane Smith', 25, 'Female', 'Adult'),
       (3, 3, 'Mike Jones', 35, 'Male', 'Adult'),
       (4, 4, 'Sarah Brown', 28, 'Female', 'Adult'),
       (5, 5, 'Chris Evans', 40, 'Male', 'Adult');
SELECT * FROM check_seat_avilability1(27);
SELECT * FROM passengers_list;

INSERT INTO Seat_class (flight_id, type_of_seat, seat_number, Price, availability_status, seat_status, seat_features)
VALUES (1, 'Economy', 'A1', 200.00, 'Available', 'Occupied', 'Extra legroom'),
       (1, 'Business', 'B1', 500.00, 'Available', 'Available', 'Lounge access'),
       (2, 'Economy', 'C1', 180.00, 'Available', 'Available', 'In-flight entertainment'),
       (2, 'First Class', 'D1', 1000.00, 'Available', 'Occupied', 'Private suite'),
       (3, 'Economy', 'E1', 250.00, 'Available', 'Available', 'In-flight meals'),
       (4, 'Business', 'F1', 600.00, 'Available', 'Available', 'Priority boarding'),
       (5, 'Economy', 'G1', 220.00, 'Available', 'Available', 'Extra storage'),
       (5, 'First Class', 'H1', 1200.00, 'Available', 'Available', 'Personal chef');

SELECT * FROM Seat_class;
INSERT INTO Food_options_table (flight_id, food_type, description, Price, availability_status, dietary_instructions, food_status)
VALUES (1, 'Meal', 'Chicken with rice', 15.00, 'Available', 'No nuts', 'Served'),
       (2, 'Snack', 'Sandwich and juice', 8.00, 'Available', 'No preferences', 'Served'),
       (3, 'Meal', 'Pasta with salad', 20.00, 'Available', 'Vegetarian', 'Served'),
       (4, 'Meal', 'Steak with sides', 30.00, 'Available', 'No allergies', 'Served'),
       (5, 'Snack', 'Cheese platter', 12.00, 'Available', 'No restrictions', 'Served');

SELECT * FROM Food_options_table;
INSERT INTO Promotions_table (Promo_code, discount_amount, valid_from, valid_until, description, booking_id)
VALUES ('FLY50', 50.00, '2024-04-21', '2024-05-21', 'Get 50% off on next booking', 5),
       ('SUMMER25', 25.00, '2024-05-01', '2024-06-01', 'Summer discount', 3),
       ('TRAVEL10', 10.00, '2024-04-15', '2024-05-15', 'Travel promotion', 1),
       ('WELCOME15', 15.00, '2024-04-01', '2024-05-01', 'Welcome offer', 2),
       ('SPRING20', 20.00, '2024-03-25', '2024-04-25', 'Spring discount', 4);
SELECT * FROM promotions_table;

INSERT INTO Login_Attempts (user_id, login_time, login_success) VALUES
(1, '2024-04-30 08:30:00', true),
(2, '2024-04-30 09:15:00', false),
(3, '2024-04-30 10:00:00', true),
(1, '2024-04-30 11:30:00', true),
(2, '2024-04-30 12:45:00', true);

SELECT * FROM Login_Attempts;


-- FUNCTIONS:

-- 1) GET THE average rating for a given flight_id
CREATE OR REPLACE FUNCTION get_average_rating(p_flight_id INTEGER)
RETURNS NUMERIC
AS $$
DECLARE
    avg_rating NUMERIC;
BEGIN
    SELECT AVG(rating) INTO avg_rating
    FROM Reviews_and_Ratings
    WHERE flight_id = p_flight_id;

    RETURN avg_rating;
END;
$$ LANGUAGE plpgsql;
select get_average_rating(3);

SELECT * FROM reviews_and_ratings;


-- 2) Function to calculate totalCost of booking based on booking_id
CREATE OR REPLACE FUNCTION CalculateTotalCost(p_booking_id INT)
RETURNS NUMERIC(10,2) AS $$
DECLARE 
    total_cost NUMERIC(10, 2);
    v_discount_amount NUMERIC(10,2);
    v_num_passengers INT;
BEGIN 
    -- Calculate total cost without considering number of passengers
    SELECT COALESCE(SUM(sc.price), 0) + COALESCE(SUM(ft.price),0)
    INTO total_cost
    FROM Seat_class sc
    LEFT JOIN Booking_Information bi ON sc.flight_id = bi.flight_id
    LEFT JOIN Food_options_table ft ON ft.flight_id = bi.flight_id
    WHERE bi.booking_id = p_booking_id;

    -- Retrieve discount amount
    SELECT Promotions_table.discount_amount
    INTO v_discount_amount
    FROM Promotions_table
    WHERE Promotions_table.booking_id = p_booking_id;

    -- Apply discount if available
    IF v_discount_amount IS NOT NULL THEN 
        total_cost := total_cost - v_discount_amount;
    END IF;

    -- Retrieve number of passengers from Passengers_list table
    SELECT COUNT(*) INTO v_num_passengers
    FROM Passengers_list
    WHERE booking_id = p_booking_id;

    -- Multiply total cost by number of passengers
    total_cost := total_cost * v_num_passengers;

    RETURN total_cost;
END;
$$ LANGUAGE plpgsql;



SELECT 
bi.booking_id , CalculateTotalCost(bi.booking_id) AS total_Cost
FROM booking_information bi
where bi.booking_id = 1;



-- 3)Function to get user_bookings
CREATE OR REPLACE FUNCTION GetUserBookings(p_user_id INT) RETURNS TABLE(
	booking_id INT,
	flight_id INT,
	booking_date DATE,
	total_cost NUMERIC(10,2),
	Booking_status VARCHAR(20)
) AS $$
DECLARE 
	status VARCHAR(20);
BEGIN 
	RETURN Query
	SELECT bi.booking_id, bi.flight_id, bi.booking_date, bi.total_cost as total_cost,
		CASE 
			WHEN pd.payment_status = 'Success' THEN 'Confirmed'
			ELSE 'Pending'
		END:: VARCHAR(20) AS booking_status
	FROM booking_information bi
	JOIN Payment_Details pd on bi.payment_id = pd.payment_id
	WHERE bi.user_id = p_user_id;
END;
$$ Language Plpgsql;

SELECT GetUserBookings(3);
CREATE OR REPLACE FUNCTION check_seat_availability1(flight_id_param INTEGER)
RETURNS BOOLEAN AS $$
DECLARE
    available_seats_count INTEGER;
BEGIN
    -- Count the number of available seats for the specified flight ID
    SELECT COUNT(*) INTO available_seats_count
    FROM seat_class
    WHERE 
	seat_class.flight_id = flight_id_param
      AND (seat_class.availability_status = 'Available');

    -- Check if there are available seats (count > 0)
    IF available_seats_count > 0 THEN
        RETURN TRUE; -- Seats are available
    ELSE
        RETURN FALSE; -- No seats available
    END IF;
END;
$$ LANGUAGE plpgsql;
SELECT * FROM check_seat_availability1(27);
SELECT * FROM seat_class;
SELECT * FROM flight;
-- 4) Function to check the seat availability

CREATE OR REPLACE FUNCTION check_seat_availability(
    flight_id_input INTEGER,
    type_of_seat_input VARCHAR(50)
) RETURNS INTEGER AS $$
DECLARE
    available_seat_count INTEGER;
BEGIN
    -- Initialize available_seat_count to 0
    available_seat_count := 0;
    
    -- Check seat availability for the given flight ID and seat type
    SELECT COUNT(*) INTO available_seat_count
    FROM Seat_class
    WHERE flight_id = flight_id_input
    AND type_of_seat = type_of_seat_input
    AND availability_status = 'Available';
    
    -- Return the count of available seats
    RETURN available_seat_count;
END;
$$ LANGUAGE PLPGSQL;
SELECT * FROM check_seat_availability(1,'Business');
-- 5) Function to search flights given departure and arrival airport and departure date and number of passengers
CREATE OR REPLACE FUNCTION search_flights(
    departure_airport_code VARCHAR(255),
    arrival_airport_code VARCHAR(255),
    departure_date DATE,
    num_passengers INT
)
RETURNS TABLE(
    flight_id INT,
    airline VARCHAR(255),
    departure_airport VARCHAR(255),
    arrival_airport VARCHAR(255),
    departure_date_time TIMESTAMP,
    arrival_date_time TIMESTAMP,
    airline_type VARCHAR(50),
    flight_status VARCHAR(20)
)
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        f.flight_id,
        f.airline,
        f.departure_airport,
        f.arrival_airport,
        f.departure_date_time,
        f.arrival_date_time,
        f.airline_type,
        f.flight_status
    FROM 
        flight f
    WHERE
        f.departure_airport = departure_airport_code
        AND f.arrival_airport = arrival_airport_code
        AND DATE(f.departure_date_time) = departure_date
        AND EXISTS (
            SELECT 1 
            FROM seat_class s 
            WHERE s.flight_id = f.flight_id 
              AND s.availability_status = 'Available'
            GROUP BY s.flight_id
            HAVING COUNT(s.flight_id) >= num_passengers
        )
    
    
    ORDER BY
        departure_date_time ASC;
END;
$$ LANGUAGE plpgsql;


drop function search_flights;


SELECT * FROM flight;
SELECT * FROM search_flights(
    departure_airport_code := 'DXB',
    arrival_airport_code := 'LAX',
    departure_date := '2024-05-01',
    num_passengers := 2
);

CREATE OR REPLACE FUNCTION search_multi_connected_flights1(
    departure_airport_code VARCHAR(255),
    arrival_airport_code VARCHAR(255),
    departure_date DATE,
    num_passengers INT
)
RETURNS TABLE(
    original_flight_id INT,
    original_airline VARCHAR(255),
    original_departure_airport VARCHAR(255),
    original_arrival_airport VARCHAR(255),
    original_departure_date_time TIMESTAMP,
    original_arrival_date_time TIMESTAMP,
    original_airline_type VARCHAR(50),
    original_flight_status VARCHAR(20),
    connected_flight_id INT,
    connected_airline VARCHAR(255),
    connected_departure_airport VARCHAR(255),
    connected_arrival_airport VARCHAR(255),
    connected_departure_date_time TIMESTAMP,
    connected_arrival_date_time TIMESTAMP,
    connected_airline_type VARCHAR(50),
    connected_flight_status VARCHAR(20),
    connection_id INT,
    leg_number INT,
    layover_duration INTERVAL,
    layover_airport VARCHAR(255)
)
AS $$
BEGIN
    RAISE NOTICE 'Inside function before query execution';

    RETURN QUERY
    -- Multi-connected flights
    SELECT 
        f.flight_id AS original_flight_id,
        f.airline AS original_airline,
        f.departure_airport AS original_departure_airport,
        f.arrival_airport AS original_arrival_airport,
        f.departure_date_time AS original_departure_date_time,
        f.arrival_date_time AS original_arrival_date_time,
        f.airline_type AS original_airline_type,
        f.flight_status AS original_flight_status,
        f2.flight_id AS connected_flight_id,
        f2.airline AS connected_airline,
        f2.departure_airport AS connected_departure_airport,
        f2.arrival_airport AS connected_arrival_airport,
        f2.departure_date_time AS connected_departure_date_time,
        f2.arrival_date_time AS connected_arrival_date_time,
        f2.airline_type AS connected_airline_type,
        f2.flight_status AS connected_flight_status,
        m.connectionid AS connection_id,
        m.leg_number AS leg_number,
        m.layover_duration AS layover_duration,
        m.layover_airport AS layover_airport
    FROM 
        flight f
    JOIN multi_flight_connections m ON f.flight_id = m.original_flight_id
    JOIN flight f2 ON f2.flight_id = m.connected_flight_id
	WHERE f.departure_airport = departure_airport_code AND
	f.arrival_airport = f2.departure_airport
	AND f.arrival_airport = m.layover_airport
	AND departure_date= DATE(f.departure_date_time);
   
END;
$$ LANGUAGE plpgsql;
SELECT * FROM multi_flight_connections;
SELECT * FROM multi_flight_connections;
select * from FLIGHT WHERE FLIGHT_ID = 7;
SELECT * FROM search_multi_connected_flights1(
    'JFK'::VARCHAR, 
    'SFO'::VARCHAR, 
    '2024-05-10' :: DATE,
    1::INT
);
SELECT * FROM multi_flight_connections;
SELECT * FROM flight;


SELECT * FROM flight;
SELECT * FROM search_multi_connected_flights(
    departure_airport_code := 'DXB',
    arrival_airport_code := 'LAX',
    departure_date := '2024-05-01',
    num_passengers := 2
);


-- 6) Function to get the seats and the ratings given the flightid
CREATE OR REPLACE FUNCTION get_seat_rating_with_average(p_flight_id INTEGER)
RETURNS TABLE (
	flight_id INT,
    seat_number VARCHAR(10),
    type_of_seat VARCHAR(50),
    seat_price NUMERIC(10,2),
	availability_status VARCHAR(20),
    seat_status VARCHAR(20),
    seat_features VARCHAR(255),
    average_rating NUMERIC
)
AS $$
BEGIN
    RETURN QUERY
    SELECT 
		sc.flight_id,
        sc.seat_number,
        sc.type_of_seat,
        sc.Price AS seat_price,
        sc.availability_status,
		sc.seat_status,
		sc.seat_features,
        get_average_rating(p_flight_id) AS average_rating
    FROM 
        Seat_class sc
    WHERE 
        sc.flight_id = p_flight_id;
END;
$$ LANGUAGE plpgsql;

DROP function get_seat_rating_with_average;
SELECT * FROM get_seat_rating_with_average(1);

-- 7) Function to get the food options for the flight given flight_id
CREATE OR REPLACE FUNCTION get_food_options_for_flight(
    p_flight_id INTEGER,
    p_seat_number VARCHAR(10),
    p_type_of_seat VARCHAR(50)
)
RETURNS TABLE (
    flight_id INTEGER,
    food_id INTEGER,
    food_type VARCHAR(50),
    description TEXT,
    price NUMERIC(10, 2),
    availability_status VARCHAR(20),
    dietary_instructions VARCHAR(255),
    seat_number VARCHAR(10),
    type_of_seat VARCHAR(50)
)
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        fo.flight_id,
        fo.Food_id,
        fo.food_type,
        fo.description,
        fo.Price,
        fo.availability_status,
        fo.dietary_instructions,
        p_seat_number AS seat_number,
        p_type_of_seat AS type_of_seat
    FROM 
        Food_options_table fo
    WHERE 
        fo.flight_id = p_flight_id;
END;
$$ LANGUAGE plpgsql;
DROP function get_food_options_for_flight;
SELECT * FROM get_food_options_for_flight(5, 'G1', 'Economy');
-- 8) Function to calculate the total payment amount given flight_id and seat_number
CREATE OR REPLACE FUNCTION calculate_total_payment_amount(
    p_flight_id INTEGER,
    p_seat_number VARCHAR(10)
) RETURNS TABLE (
    total_cost NUMERIC(10, 2),
    flight_id INTEGER,
    departure_date DATE,
    arrival_date DATE,
	seat_number VARCHAR(10)
)
AS $$
BEGIN
    RETURN QUERY
    SELECT
        price AS total_cost,
        F.flight_id,
        DATE(F.departure_date_time),
        DATE(F.arrival_date_time),
		SC.seat_number
    FROM
        Seat_class SC
    INNER JOIN
        Flight F ON SC.flight_id = F.flight_id
    WHERE
        SC.flight_id = p_flight_id
        AND SC.seat_number = p_seat_number;
END;
$$ LANGUAGE plpgsql;
DROP FUNCTION calculate_total_payment_amount;
SELECT calculate_total_payment_amount(1, 'A1') AS total_payment_amount;


-- 
CREATE OR REPLACE FUNCTION calculate_total_payment_amount_given_food(
    p_flight_id INTEGER,
    p_food_id INTEGER,
    p_seat_num VARCHAR(10),
    p_type_of_seat VARCHAR(50)
) RETURNS TABLE (
    total_cost NUMERIC(10, 2),
    flight_id INTEGER,
    departure_date DATE,
    arrival_date DATE,
    seat_number VARCHAR(10),
    food_id INTEGER,
    food_type VARCHAR(50)
)
AS $$
BEGIN
    RETURN QUERY
    SELECT
        (SC.price + COALESCE(FO.price, 0)) AS total_cost,
        F.flight_id,
        DATE(F.departure_date_time),
        DATE(F.arrival_date_time),
        SC.seat_number,
        p_food_id,
        FO.food_type
    FROM
        Seat_class SC
    INNER JOIN
        Flight F ON SC.flight_id = F.flight_id
    LEFT JOIN
        Food_options_table FO ON FO.flight_id = F.flight_id AND FO.food_id = p_food_id
    WHERE
        SC.flight_id = p_flight_id
        AND SC.seat_number = p_seat_num
        AND SC.type_of_seat = p_type_of_seat;
END;
$$ LANGUAGE plpgsql;
SELECT * FROM flight;
-- PROCUDURES:

-- 1) Procedure for booking a flight. 
--  This will handle thr booking process by inserting a new booking record into the Booking_Information_table
--  updating the seat_availability and processing the payment
CREATE OR REPLACE PROCEDURE book_flight(
    IN p_user_id INT,
    IN p_flight_id INT,
    IN p_num_passengers INT,
    IN p_payment_mode VARCHAR(50),
    IN p_passenger_name VARCHAR(255),
    IN p_passenger_age INT,
    IN p_passenger_gender VARCHAR(10),
    IN p_passenger_type VARCHAR(20),
    IN p_new_departure_terminal VARCHAR(15), -- New departure terminal
    IN p_new_arrival_terminal VARCHAR(15)   -- New arrival terminal
)
LANGUAGE plpgsql 
AS $$
DECLARE 
    v_total_cost NUMERIC(10, 2);
    v_food_cost NUMERIC(10, 2);
    v_discount_amount NUMERIC(10, 2);
    v_arrival_terminal VARCHAR(15);
    v_departure_terminal VARCHAR(15);
    v_arrival_date DATE;
    v_departure_date DATE;
    v_payment_id INT;
    v_booking_id INT;
BEGIN
    -- Calculate total cost based on seat prices
    SELECT COALESCE(SUM(sc.price * p_num_passengers), 0)
    INTO v_total_cost
    FROM Seat_class sc
    WHERE sc.flight_id = p_flight_id
    LIMIT 1;

    -- Calculate food cost based on selected food options
    SELECT COALESCE(SUM(ft.price * p_num_passengers), 0)
    INTO v_food_cost
    FROM Food_options_table ft
    WHERE ft.flight_id = p_flight_id
    LIMIT 1;

    -- Add food cost to total cost
    v_total_cost := v_total_cost + v_food_cost;

    -- Retrieve discount amount from promotions
    SELECT COALESCE(SUM(pt.discount_amount), 0)
    INTO v_discount_amount
    FROM Promotions_table pt
    JOIN Booking_Information bi ON pt.booking_id = bi.booking_id
    WHERE bi.flight_id = p_flight_id  -- Assuming you fetch booking_id based on flight_id
    LIMIT 1;

    -- Apply discount if applicable
    v_total_cost := v_total_cost - v_discount_amount;

    -- Fetch arrival_terminal, departure_terminal, arrival_date, and departure_date from Flight table
    SELECT DATE(arrival_date_time), DATE(departure_date_time)
    INTO v_arrival_date, v_departure_date
    FROM Flight
    WHERE flight_id = p_flight_id;

    -- Update terminals if new values are provided
    
    v_departure_terminal := p_new_departure_terminal;
    

    v_arrival_terminal := p_new_arrival_terminal;
 

    -- Insert payment details with default values for payment_amount and payment_status
    INSERT INTO Payment_details(payment_date, mode_of_payment, payment_amount, payment_status)
    VALUES (CURRENT_DATE, p_payment_mode, v_total_cost, 'successful')
    RETURNING payment_id INTO v_payment_id;  -- Retrieve the generated payment_id

    -- Insert booking information with fetched payment_id, arrival_terminal, departure_terminal, arrival_date, and departure_date
    INSERT INTO Booking_Information(user_id, total_cost, payment_id, booking_date, flight_id, departure_date, arrival_date, departure_terminal, arrival_terminal)
    VALUES (p_user_id, v_total_cost, v_payment_id, CURRENT_DATE, p_flight_id, v_departure_date, v_arrival_date, v_departure_terminal, v_arrival_terminal)
    RETURNING booking_id INTO v_booking_id;  -- Retrieve the generated booking_id

    -- Update seat availability for the number of passengers booked
    UPDATE Seat_class
    SET availability_status = 'booked'
    WHERE flight_id = p_flight_id
    AND availability_status = 'available'
    AND seat_number IN (
        SELECT seat_number
        FROM Seat_class
        WHERE flight_id = p_flight_id
        AND availability_status = 'available'
        LIMIT p_num_passengers
    );

    -- Insert passenger details into Passengers_list
    INSERT INTO Passengers_list(user_id, booking_id, name, age, gender, passenger_type)
    VALUES (p_user_id, v_booking_id, p_passenger_name, p_passenger_age, p_passenger_gender, p_passenger_type);

    RAISE NOTICE 'Booking successful! Booking ID: %, Total cost: $%', v_booking_id, v_total_cost;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error booking flight: %', SQLERRM;
END;
$$;



-- Sample call to book_flight function
CALL book_flight(
    p_user_id := 1,  -- Replace with actual user ID
    p_flight_id := 4,  -- Replace with actual flight ID
    p_num_passengers := 2,
    p_payment_mode := 'Credit Card',  -- Replace with actual payment mode
    p_passenger_name := 'John Doe',
    p_passenger_age := 30,
    p_passenger_gender := 'Male',
    p_passenger_type := 'Adult',
    p_new_departure_terminal := 'A',-- Replace with new departure terminal if needed
    p_new_arrival_terminal := 'B'-- Replace with new arrival terminal if needed
);



SELECT * FROM booking_information;
SELECT * FROM payment_details;

DELETE FROM payment_details where payment_id = 6;
DELETE FROM booking_information where booking_id = 6;

SELECT * FROM seat_Class;

-- 2) Procedure to make booking with seat and food

CREATE OR REPLACE PROCEDURE MakeBookingWithSeatAndFood(
    userID INT, 
    flightID INT, 
    seatType VARCHAR(50), 
    seatNumber VARCHAR(10), 
    foodID INT,
    passengerName VARCHAR(255),
    passengerAge INT,
    passengerGender VARCHAR(10),
    passengerType VARCHAR(20),
    paymentMode VARCHAR(50),
    departureDate DATE,
    arrivalDate DATE,
    totalCost NUMERIC(10, 2)
) AS $$
DECLARE
    bookingID INT;
    paymentID INT;
BEGIN
    -- Check if the seat is available
    IF NOT EXISTS (
        SELECT 1
        FROM Seat_class
        WHERE flight_id = flightID AND type_of_seat = seatType AND seat_number = seatNumber
    ) THEN
        RAISE EXCEPTION 'Seat % is not available for flight %.', seatNumber, flightID;
    END IF;

    -- Add a new booking
    INSERT INTO Booking_Information (user_id, flight_id, booking_date, departure_date, arrival_date, Total_cost)
    VALUES (userID, flightID, CURRENT_DATE, departureDate, arrivalDate, totalCost)
    RETURNING booking_id INTO bookingID;

    -- Update seat availability status
    UPDATE Seat_class
    SET availability_status = 'booked'
    WHERE flight_id = flightID AND type_of_seat = seatType AND seat_number = seatNumber;

    -- Add payment details
    INSERT INTO Payment_Details (payment_date, Mode_of_payment, payment_amount, payment_status)
    VALUES (CURRENT_DATE, paymentMode, totalCost, 'successful')
    RETURNING payment_id INTO paymentID;

    -- Update booking with payment ID
    UPDATE Booking_Information
    SET payment_id = paymentID
    WHERE booking_id = bookingID;

    -- Add passenger details
    INSERT INTO Passengers_list (user_id, booking_id, name, age, gender, passenger_type)
    VALUES (userID, bookingID, passengerName, passengerAge, passengerGender, passengerType);

    -- Place food order
    INSERT INTO Food_options_table (flight_id, food_id, food_status)
    VALUES (flightID, foodID, 'available upon request');
    
    COMMIT;
    
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error in booking: %', SQLERRM;
        ROLLBACK;
END;
$$ LANGUAGE plpgsql;
-- Sample call to MakeBookingWithSeatAndFood procedure
CALL MakeBookingWithSeatAndFood(
    userID := 1,  -- Replace with actual user ID
    flightID := 5,  -- Replace with actual flight ID
    seatType := 'Business',  -- Replace with actual seat type
    seatNumber := 'A1',  -- Replace with actual seat number
    foodID := 2,-- Replace with actual food ID
    passengerName := 'John Doe',  -- Replace with actual passenger name
    passengerAge := 35,  -- Replace with actual passenger age
    passengerGender := 'Male',  -- Replace with actual passenger gender
    passengerType := 'Adult',  -- Replace with actual passenger type
    paymentMode := 'Credit Card',  -- Replace with actual payment mode
    departureDate := '2024-05-01',  -- Replace with actual departure date
    arrivalDate := '2024-05-01',  -- Replace with actual arrival date
    totalCost := 250.00  -- Replace with actual total cost
);
SELECT * FROM food_options_table;


-- 3) Procedure to cancels a booking, updates seat availability 


CREATE OR REPLACE PROCEDURE CancelBooking(
    bookingID INT
) AS $$
BEGIN
    -- Update seat availability status to 'available'
    UPDATE Seat_class
    SET availability_status = 'available'
    WHERE seat_number IN (
        SELECT seat_number
        FROM Booking_Information
        WHERE booking_id = bookingID
    );

    -- Cancel food orders associated with the booking
    DELETE FROM Food_options_table
    WHERE booking_id = bookingID;

    -- Cancel the booking
    DELETE FROM Booking_Information
    WHERE booking_id = bookingID;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error cancelling booking: %', SQLERRM;
        ROLLBACK;
END;
$$ LANGUAGE plpgsql;



-- 4) Procedure to update booking details
CREATE OR REPLACE PROCEDURE UpdateBookingDetails(
    bookingID INT,
    newPassengerName VARCHAR(255),
    newPassengerAge INT,
    newPaymentMode VARCHAR(50)
) AS $$
BEGIN
    -- Update passenger details
    UPDATE Passengers_list
    SET name = newPassengerName, age = newPassengerAge
    WHERE booking_id = bookingID;

    -- Update payment details
    UPDATE Payment_Details
    SET Mode_of_payment = newPaymentMode
    WHERE payment_id = (
        SELECT payment_id
        FROM Booking_Information
        WHERE booking_id = bookingID
    );

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error updating booking details: %', SQLERRM;
        ROLLBACK;
END;
$$ LANGUAGE plpgsql;


-- 5) Procedure to retrive reviews and ratings for a given flightID
CREATE OR REPLACE PROCEDURE GetFlightReviews(
    flightID INT
) AS $$
DECLARE
    reviewCursor CURSOR FOR
        SELECT user_id, rating, review_text, review_date
        FROM Reviews
        WHERE flight_id = flightID;
    reviewRecord RECORD;
BEGIN
    OPEN reviewCursor;
    LOOP
        FETCH reviewCursor INTO reviewRecord;
        EXIT WHEN NOT FOUND;
        RAISE NOTICE 'User ID: %, Rating: %, Review: %, Date: %', reviewRecord.user_id, reviewRecord.rating, reviewRecord.review_text, reviewRecord.review_date;
    END LOOP;
    CLOSE reviewCursor;
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error retrieving flight reviews: %', SQLERRM;
END;
$$ LANGUAGE plpgsql;

-- 6)proceedure to add payments from the frontend into the payments table
CREATE OR REPLACE PROCEDURE insert_payment(
    IN p_mode_of_payment VARCHAR(50),
    IN p_amount NUMERIC(10, 2)
)
LANGUAGE SQL
AS $$
    INSERT INTO payment_details (payment_date, mode_of_payment, payment_amount, payment_status)
    VALUES (CURRENT_DATE, p_mode_of_payment, p_amount, 'successful');
$$;
call insert_payment('credit_card', 500.00);
SELECT * FROM payment_details;






-- ROLES AND PRIVILEGES

-- Create Admin role
CREATE ROLE admin WITH SUPERUSER LOGIN PASSWORD 'admin_pass';

-- Create Customer Support role
CREATE ROLE customer_support WITH LOGIN PASSWORD 'support_pass';

-- Create Finance role
CREATE ROLE finance WITH LOGIN PASSWORD 'finance_pass';

-- Create Flight Management role
CREATE ROLE flight_management WITH LOGIN PASSWORD 'flight_pass';

-- Create Review Management role
CREATE ROLE review_management WITH LOGIN PASSWORD 'review_pass';

-- Create Booking Management role
CREATE ROLE booking_management WITH LOGIN PASSWORD 'booking_pass';

-- Create Inventory Management role
CREATE ROLE inventory_management WITH LOGIN PASSWORD 'inventory_pass';

-- Create Security Management role
CREATE ROLE security_management WITH LOGIN PASSWORD 'security_pass';

-- Grant privileges to Admin role
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO admin;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO admin;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO admin;

-- Grant privileges to Customer Support role
GRANT SELECT ON users, booking_information TO customer_support;
GRANT SELECT ON payment_details TO customer_support;

-- Grant privileges to Finance role
GRANT SELECT, UPDATE ON payment_details TO finance;
-- Grant additional privileges to Finance role
GRANT DELETE, INSERT ON payment_details TO finance;

-- Grant privileges to Flight Management role
GRANT ALL PRIVILEGES ON flight, multi_flight_connections TO flight_management;

-- Grant privileges to Review Management role
GRANT SELECT, UPDATE ON reviews_and_ratings TO review_management;
-- Grant privileges to Booking Management role
GRANT ALL PRIVILEGES ON booking_information, promotions_table TO booking_management;

-- Grant privileges to Inventory Management role
GRANT ALL PRIVILEGES ON seat_class, food_options_table TO inventory_management;

-- Grant privileges to Security Management role
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO security_management;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO security_management;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO security_management;



-- Functions and triggers

-- 1)Create a trigger to update average rating when a new review is added
CREATE OR REPLACE FUNCTION update_average_rating()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
        UPDATE Reviews_and_Ratings r
        SET average_rating = (SELECT AVG(rating) FROM Reviews_and_Ratings WHERE flight_id = NEW.flight_id)
        WHERE r.flight_id = NEW.flight_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create the trigger on Reviews_and_Ratings table
CREATE TRIGGER update_average_rating_trigger
AFTER INSERT OR UPDATE ON Reviews_and_Ratings
FOR EACH ROW
EXECUTE FUNCTION update_average_rating();
-- 2) Create a trigger to update total cost when a booking information is updated
CREATE OR REPLACE FUNCTION update_total_cost()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
        UPDATE booking_information bi
        SET total_cost = CalculateTotalCost(bi.booking_id)
        WHERE bi.booking_id = NEW.booking_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
SELECT * FROM Payment_details;
-- Create the trigger on booking_information table
CREATE TRIGGER update_total_cost_trigger
AFTER INSERT OR UPDATE ON booking_information
FOR EACH ROW
EXECUTE FUNCTION update_total_cost();


-- 3) Trigger to set flight delay status 
CREATE TEMPORARY TABLE IF NOT EXISTS Flight_Delay_Status (
    flight_id INT,
    delay_status VARCHAR(20)
);
CREATE OR REPLACE FUNCTION update_flight_delay_status()
RETURNS TRIGGER AS $$
BEGIN
    -- Calculate delay in minutes
    NEW.delay_minutes := EXTRACT(EPOCH FROM (NEW.actual_departure_time - NEW.scheduled_departure_time)) / 60;

    -- Update delay status based on delay threshold
    IF NEW.delay_minutes > 30 THEN
        INSERT INTO Flight_Delay_Status (flight_id, delay_status)
        VALUES (NEW.flight_id, 'Delayed');
    ELSE
        INSERT INTO Flight_Delay_Status (flight_id, delay_status)
        VALUES (NEW.flight_id, 'On Time');
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create the trigger on Flight table
CREATE TRIGGER update_flight_delay_status_trigger
BEFORE INSERT OR UPDATE ON Flight
FOR EACH ROW
EXECUTE FUNCTION update_flight_delay_status();
DROP trigger update_flight_delay_status_trigger ON flight cascade;
DROP FUNCTION update_flight_delay_status;

-- 4) Create a trigger to enforce referential integrity between tables
CREATE OR REPLACE FUNCTION enforce_referential_integrity()
RETURNS TRIGGER AS $$
BEGIN
    -- Check if the referenced record exists in the related table
    IF NOT EXISTS (
        SELECT 1
        FROM related_table
        WHERE related_column = NEW.referenced_column
    ) THEN
        RAISE EXCEPTION 'Referential integrity violation: Record not found in related_table.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create the trigger on main_table
CREATE TRIGGER enforce_referential_integrity_trigger
BEFORE INSERT OR UPDATE ON booking_information
FOR EACH ROW
EXECUTE FUNCTION enforce_referential_integrity();
DROP FUNCTION enforce_referential_integrity;
DROP trigger enforce_referential_integrity_trigger ON booking_information CASCADE;
-- 5) Trigger to prevent dupliate rows with same user
CREATE OR REPLACE FUNCTION prevent_duplicate_users()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM users
        WHERE email = NEW.email
            AND user_id != NEW.user_id -- Exclude the current record for updates
    ) THEN
        RAISE EXCEPTION 'Duplicate user: User with the same email already exists.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER prevent_duplicate_users_trigger
BEFORE INSERT OR UPDATE ON users
FOR EACH ROW
EXECUTE FUNCTION prevent_duplicate_users();

-- 6) Trigger to update last_login_date of the user
CREATE OR REPLACE FUNCTION update_last_login()
RETURNS TRIGGER AS $$
BEGIN
    -- Update last_login_date for the user who just logged in
    UPDATE Users
    SET last_login_date = CURRENT_TIMESTAMP  -- Use CURRENT_TIMESTAMP directly
    WHERE user_id = NEW.user_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER on_login_attempt
AFTER INSERT ON Login_Attempts
FOR EACH ROW
EXECUTE FUNCTION update_last_login();
DROP Trigger on_login_attempt on login_attempts CASCADE;

-- 7) Trigger to remove a row from promotions_table is promo code is expired
CREATE OR REPLACE FUNCTION remove_expired_promo_code()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'UPDATE' AND OLD.valid_until IS NOT NULL AND NEW.valid_until IS NULL THEN
        DELETE FROM Promotions_table
        WHERE promotion_id = OLD.promotion_id;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_promo_validity
AFTER INSERT OR UPDATE OF valid_until ON Promotions_table
FOR EACH ROW
EXECUTE FUNCTION remove_expired_promo_code();

-- 9) Trigger to failed log in attempts
CREATE OR REPLACE FUNCTION log_failed_login_attempts()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.login_success = false THEN
        INSERT INTO Failed_login_attempts (user_id, login_time)
        VALUES (NEW.user_id, NEW.login_time);
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER on_failed_login
AFTER INSERT ON login_attempts
FOR EACH ROW
EXECUTE FUNCTION log_failed_login_attempts();

-- 8) Triggers to handle foreign key violations
-- Trigger for Booking_Information Table
CREATE OR REPLACE FUNCTION check_booking_foreign_keys()
RETURNS TRIGGER AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM users WHERE user_id = NEW.user_id
    ) THEN
        RAISE EXCEPTION 'User ID does not exist in the users table';
    END IF;
    
    IF NOT EXISTS (
        SELECT 1 FROM flight WHERE flight_id = NEW.flight_id
    ) THEN
        RAISE EXCEPTION 'Flight ID does not exist in the flight table';
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_booking_foreign_keys_before_insert
BEFORE INSERT ON Booking_Information
FOR EACH ROW
EXECUTE FUNCTION check_booking_foreign_keys();

-- Trigger for Reviews and Ratings Table
CREATE OR REPLACE FUNCTION check_reviews_foreign_keys()
RETURNS TRIGGER AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM users WHERE user_id = NEW.user_id
    ) THEN
        RAISE EXCEPTION 'User ID does not exist in the users table';
    END IF;
    
    IF NOT EXISTS (
        SELECT 1 FROM flight WHERE flight_id = NEW.flight_id
    ) THEN
        RAISE EXCEPTION 'Flight ID does not exist in the flight table';
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_reviews_foreign_keys_before_insert
BEFORE INSERT ON Reviews_and_ratings
FOR EACH ROW
EXECUTE FUNCTION check_reviews_foreign_keys();

-- Trigger for Seat_class Table
CREATE OR REPLACE FUNCTION check_seat_class_foreign_keys()
RETURNS TRIGGER AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM flight WHERE flight_id = NEW.flight_id
    ) THEN
        RAISE EXCEPTION 'Flight ID does not exist in the flight table';
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_seat_class_foreign_keys_before_insert
BEFORE INSERT ON Seat_class
FOR EACH ROW
EXECUTE FUNCTION check_seat_class_foreign_keys();

-- Trigger for Multi_flight_connections Table
CREATE OR REPLACE FUNCTION check_multi_flight_connections_foreign_keys()
RETURNS TRIGGER AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM flight WHERE flight_id = NEW.original_flight_id
    ) THEN
        RAISE EXCEPTION 'Original Flight ID does not exist in the flight table';
    END IF;
    
    IF NOT EXISTS (
        SELECT 1 FROM flight WHERE flight_id = NEW.connected_flight_id
    ) THEN
        RAISE EXCEPTION 'Connected Flight ID does not exist in the flight table';
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_multi_flight_connections_foreign_keys_before_insert
BEFORE INSERT ON Multi_flight_connections
FOR EACH ROW
EXECUTE FUNCTION check_multi_flight_connections_foreign_keys();

-- Trigger for Passengers_list Table
CREATE OR REPLACE FUNCTION check_passengers_list_foreign_keys()
RETURNS TRIGGER AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM users WHERE user_id = NEW.user_id
    ) THEN
        RAISE EXCEPTION 'User ID does not exist in the users table';
    END IF;
    
    IF NOT EXISTS (
        SELECT 1 FROM Booking_Information WHERE booking_id = NEW.booking_id
    ) THEN
        RAISE EXCEPTION 'Booking ID does not exist in the Booking_Information table';
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_passengers_list_foreign_keys_before_insert
BEFORE INSERT ON Passengers_list
FOR EACH ROW
EXECUTE FUNCTION check_passengers_list_foreign_keys();

-- Trigger for Food_options_table Table
CREATE OR REPLACE FUNCTION check_food_options_foreign_keys()
RETURNS TRIGGER AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM flight WHERE flight_id = NEW.flight_id
    ) THEN
        RAISE EXCEPTION 'Flight ID does not exist in the flight table';
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_food_options_foreign_keys_before_insert
BEFORE INSERT ON Food_options_table
FOR EACH ROW
EXECUTE FUNCTION check_food_options_foreign_keys();

-- Trigger for Promotions_table Table
CREATE OR REPLACE FUNCTION check_promotions_foreign_keys()
RETURNS TRIGGER AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM Booking_Information WHERE booking_id = NEW.booking_id
    ) THEN
        RAISE EXCEPTION 'Booking ID does not exist in the Booking_Information table';
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_promotions_foreign_keys_before_insert
BEFORE INSERT ON Promotions_table
FOR EACH ROW
EXECUTE FUNCTION check_promotions_foreign_keys();











-- VIEWS 
-- 1) User Booking Summary view: This view gives the booking data for each user including total number of bookings and total amount spent.
CREATE VIEW User_Booking_summary AS 
SELECT 
	u.user_id,
	u.username,
	u.first_name,
	u.last_name,
	COUNT(b.booking_id) AS total_bookings,
	SUM(b.Total_cost) AS total_spent
FROM
	users u
LEFT JOIN 
	Booking_Information b on u.user_id = b.user_id
GROUP BY
	u.user_id, u.username, u.first_name, u.last_name;

SELECT * FROM User_Booking_summary;

-- 2) Booking_details_view: Aggregates booking information along with user information, flight details, payment information and passenger information

CREATE VIEW Booking_details_view AS
SELECT b.booking_id, u.username, u.first_name, u.last_name, u.email,
		f.airline, f.departure_airport, f.arrival_airport,
		b.departure_date, b.arrival_date, b.departure_terminal, b.arrival_terminal,
		p.payment_date, p.Mode_of_payment, p.payment_amount, p.payment_status,
		STRING_AGG(pas.name || '(' || pas.age || ', ' || pas.gender || ')', ': ') AS passengers
FROM Booking_information b
JOIN users u on b.user_id = u.user_id
JOIN flight f on b.flight_id = f.flight_id
JOIN Payment_details p on b.payment_id = p.payment_id
JOIN Passengers_list pas on b.booking_id = pas.booking_id
GROUP BY b.booking_id, u.username, u.first_name, u.last_name, u.email,
		f.airline, f.departure_airport, f.arrival_airport,
		b.departure_date, b.arrival_date, b.departure_terminal, b.arrival_terminal,
		p.payment_date, p.Mode_of_payment, p.payment_amount, p.payment_status;
		
SELECT * FROM Booking_details_view;

-- 3) Available Food options view

CREATE VIEW Available_food_options_view AS
SELECT f.flight_id, f.airline, fo.food_type, fo.description, fo.Price
FROM flight f 
LEFT JOIN Food_options_table fo on f.flight_id = fo.flight_id
WHERE fo.availability_status = 'Available';

SELECT * FROM Available_food_options_view;

-- 4) Flight_availability_view
CREATE VIEW flight_availability_view AS
SELECT 
    f.flight_id,
    f.airline,
    DATE(f.departure_date_time) AS departure_date,
    DATE(f.arrival_date_time) AS arrival_date,
    COUNT(s.seat_number) AS total_seats,
    SUM(CASE WHEN s.availability_status = 'Available' THEN 1 ELSE 0 END) AS available_seats
FROM 
    flight f
LEFT JOIN 
    Seat_class s ON f.flight_id = s.flight_id 
GROUP BY 
    f.flight_id,
    f.airline,
    DATE(f.departure_date_time),
    DATE(f.arrival_date_time);
	
SELECT * FROM flight_availability_view;



-- 5) Passenger_count_by_flight_view:

CREATE VIEW passengers_count_by_flight_view AS
SELECT b.flight_id, f.airline, COUNT(pl.user_id) AS passenger_count
FROM booking_information b
JOIN flight f ON f.flight_id = b.flight_id
JOIN passengers_list pl on b.booking_id = pl.booking_id
GROUP BY b.flight_id, f.airline;

SELECT * FROM passengers_count_by_flight_view;

-- 6) User Review summary view

CREATE VIEW User_review_summary_view AS
SELECT f.flight_id, f.airline, f.departure_airport, f.arrival_airport,
		AVG(rr.rating) AS average_rating,
		COUNT(rr.review_id) AS total_reviews
FROM flight f 
LEFT JOIN Reviews_and_ratings rr on f.flight_id = rr.flight_id
GROUP BY f.flight_id, f.airline, f.departure_airport, f.arrival_airport;

SELECT * FROM user_review_summary_view;

-- 7) View to display user_information with last login date
CREATE VIEW User_Last_Login_Info AS
SELECT u.user_id, u.username, u.first_name, u.last_name, u.email,
       l.login_time AS last_login_date
FROM users u
LEFT JOIN login_attempts l on l.user_id = u.user_id;
SELECT * FROM user_last_login_info;

-- 8) View to display flight details with seat information
CREATE VIEW Flight_Seat_Info AS
SELECT f.flight_id, f.airline, f.departure_airport, f.arrival_airport,
       s.type_of_seat, s.price, s.availability_status, s.seat_status
FROM Flight f
JOIN Seat_class s ON f.flight_id = s.flight_id;
SELECT * FROM flight_seat_info;

-- 9) View to display promotions with booking_information
CREATE VIEW Promotions_Booking_Info AS
SELECT p.promotion_id, p.promo_code, p.discount_amount, p.valid_from, p.valid_until,
       b.booking_id, b.Total_cost, b.booking_date, b.departure_date, b.arrival_date
FROM Promotions_table p
JOIN Booking_Information b ON p.booking_id = b.booking_id;
SELECT * FROM Promotions_Booking_info;

-- 10) View to show multi-flight COnnections with flight details
CREATE VIEW Multi_Flight_Connections_Details AS
SELECT m.ConnectionID, m.original_flight_id, m.connected_flight_id,
       f1.airline AS original_airline, f1.departure_airport AS original_departure,
       f2.airline AS connected_airline, f2.arrival_airport AS connected_arrival
FROM Multi_flight_connections m
JOIN Flight f1 ON m.original_flight_id = f1.flight_id
JOIN Flight f2 ON m.connected_flight_id = f2.flight_id;

SELECT * FROM Multi_flight_connections_details;


-- INDEXING
-- 1) INDEX ON booking_date
CREATE INDEX idx_booking_booking_date ON Booking_Information(booking_date DESC);
-- Query that uses the index
EXPLAIN ANALYZE
SELECT u.user_id, u.userName, b.booking_id, b.booking_date, f.Airline, f.Departure_airport, f.Arrival_airport
FROM Users u
JOIN Booking_Information b ON u.user_id = b.user_id
JOIN Flight f ON b.flight_id = f.flight_id
WHERE u.user_id = 1
ORDER BY b.booking_date DESC;


-- 2) INDEX on flight_status
CREATE INDEX idx_flight_flight_status ON Flight(Flight_status);
-- Query that uses this index
SELECT 
    f.flight_id,
    f.Airline,
    COUNT(DISTINCT b.booking_id) AS total_bookings,
    COUNT(DISTINCT r.review_id) AS total_reviews,
    AVG(r.rating) AS average_rating
FROM 
    Flight f
LEFT JOIN 
    Booking_Information b ON f.flight_id = b.flight_id
LEFT JOIN 
    Reviews_and_Ratings r ON f.flight_id = r.flight_id
WHERE 
    f.Flight_status = 'On Time'
GROUP BY 
    f.flight_id, f.Airline;
SELECT * FROM flight;


-- 3) INDEX ON departure_airport of flight
CREATE INDEX idx_flight_departure_airport ON Flight(Departure_airport);
-- The frequent query that uses this index
SELECT 
    f.flight_id,
    f.Airline,
    f.Departure_date_time,
    f.Arrival_date_time,
    f.Departure_airport,
    f.Arrival_airport
FROM 
    Flight f
WHERE 
    f.Departure_airport = 'JFK';

SELECT * FROM flight;

-- 4) INDEX on user_name of users table
CREATE INDEX idx_users_username ON Users(userName);
-- Frequent query that uses the index

SELECT 
    b.booking_id,
    b.booking_date,
    u.userName,
    f.Airline,
    f.Departure_airport,
    f.Arrival_airport
FROM 
    Booking_Information b
JOIN 
    Users u ON b.user_id = u.user_id
JOIN 
    Flight f ON b.flight_id = f.flight_id
WHERE 
    u.userName = 'jane_smith';
SELECT * FROM users;

-- 5) INDEX ON availability status of food_options_table
CREATE INDEX idx_food_options_availability_status ON Food_options_table(availability_status);
-- Frequent query that uses this index
SELECT 
    f.food_id,
    f.food_type,
    f.description,
    f.Price,
    f.availability_status,
    fo.Flight_id
FROM 
    Food_options_table f
JOIN 
    Flight fo ON f.Flight_id = fo.Flight_id
WHERE 
    f.availability_status = 'Available' AND fo.Flight_status = 'On Time';


-- 6) INDEX ON original_flight_id in multiconnectedFlights
CREATE INDEX idx_connections_original_flight_id ON Multi_flight_connections(original_flight_id);
-- Query that uses this index
SELECT 
    ConnectionID,
    original_flight_id,
    Connected_flight_id,
    Layover_duration,
    Layover_airport
FROM 
    Multi_flight_connections
WHERE 
    original_flight_id = 1;

-- 7) INDEX ON booking_id of Booking_information
CREATE INDEX idx_booking_booking_id ON Booking_Information(booking_id);
-- Query that uses the index
SELECT 
    b.booking_id,
    b.booking_date,
    u.userName,
    f.Airline,
    f.Departure_airport,
    f.Arrival_airport
FROM 
    Booking_Information b
JOIN 
    Users u ON b.user_id = u.user_id
JOIN 
    Flight f ON b.flight_id = f.flight_id
WHERE 
    b.booking_id = 2;


-- 8) INDEX ON user_id, flight_id OF booking_information
CREATE INDEX idx_booking_user_flight ON Booking_Information(user_id, flight_id);

-- Query that uses this index
SELECT 
    b.booking_id,
    b.booking_date,
    u.userName,
    f.Airline,
    f.Departure_airport,
    f.Arrival_airport
FROM 
    Booking_Information b
JOIN 
    Users u ON b.user_id = u.user_id
JOIN 
    Flight f ON b.flight_id = f.flight_id
WHERE 
    b.user_id = 1
    AND b.flight_id = 1;
	
	

-- Queries that use different functions and roles


-- Activate the Customer Support role
SET ROLE customer_support;

-- Get detailed information about a specific user's bookings using the GetUserBookings function
SELECT
    bi.booking_id,
    bi.booking_date,

    GetUserBookings(1) AS ub
FROM
booking_information bi;




-- 
-- Activate the Review Management role
SET ROLE review_management;

-- Get the average rating for each product using the GetAverage function
SELECT
    flight_id,
    Get_Average_rating(rating) AS average_rating
FROM
    reviews_and_ratings
GROUP BY
    flight_id,average_rating;


SET ROLE inventory_management;

-- Get food options for a specific flight using the get_food_options_for_flight function
SELECT
    flight_id,
    food_id,
    food_type,
    price,
    availability_status
FROM
    get_food_options_for_flight(2) AS fo
WHERE
    flight_id = 2;
SET role admin;
SET ROLE flight_management;

-- Check seat availability for a specific flight and seat type using the check_seat_availability function
SELECT
    flight_id,
    seat_number,
    type_of_seat,
    availability_status,
    check_seat_availability(1, 'Economy') AS available_seats
FROM
    seat_class
WHERE
    flight_id = 1
    AND type_of_seat = 'Economy';


SET ROLE customer_support;

-- Get detailed information about a specific user's bookings using the GetUserBookings function
SELECT
    bi.booking_id,
    bi.booking_date,
    pd.payment_status
FROM
    GetUserBookings(1) AS ub
JOIN booking_information bi ON ub.booking_id = bi.booking_id
JOIN payment_details pd ON bi.payment_id = pd.payment_id;




-- Activate the Finance role
SET ROLE finance;

-- Calculate the total cost of all bookings made in the last month using CalculateTotalCost function
SELECT
    SUM(total_cost) AS total_monthly_cost
FROM (
    SELECT
        CalculateTotalCost(booking_id) AS total_cost
    FROM
        booking_information
    WHERE
        booking_date >= DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '1 month'
) AS monthly_bookings;


-- Activate the Review Management role
SET ROLE review_management;

-- Get average ratings and count of reviews for each flight using get_average_rating function
SELECT
    f.flight_id,
    f.airline,
    f.departure_airport,
    f.arrival_airport,
    AVG(get_average_rating(r.flight_id)) AS average_rating,
    COUNT(r.review_id) AS total_reviews
FROM
    flight f
LEFT JOIN reviews_and_ratings r ON f.flight_id = r.flight_id
GROUP BY
    f.flight_id, f.airline, f.departure_airport, f.arrival_airport;


-- Activate the Inventory Management role
SET ROLE inventory_management;

-- Get seat class details and ratings for all flights using get_seat_rating_with_average function
SELECT
    s.flight_id,
    s.type_of_seat,
    s.seat_number,
    s.price,
    s.availability_status,
    s.seat_status,
    s.seat_features,
    AVG(r.rating) AS average_rating
FROM
    seat_class s
LEFT JOIN reviews_and_ratings r ON s.flight_id = r.flight_id
GROUP BY
    s.flight_id, s.type_of_seat, s.seat_number, s.price, s.availability_status, s.seat_status, s.seat_features;






	
	
	
	
	
	
	
	
	
