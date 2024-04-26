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


INSERT INTO Flight (Airline, Departure_airport, Arrival_airport, Departure_date_time, Arrival_date_time, Airline_type, Flight_status)
VALUES ('Delta Airlines', 'JFK', 'LAX', '2024-05-01 08:00:00', '2024-05-01 11:30:00', 'Domestic', 'On Time'),
       ('United Airlines', 'ORD', 'SFO', '2024-05-02 10:00:00', '2024-05-02 13:30:00', 'Domestic', 'Delayed'),
       ('Emirates', 'DXB', 'JFK', '2024-05-03 15:00:00', '2024-05-03 20:30:00', 'International', 'On Time'),
       ('British Airways', 'LHR', 'JFK', '2024-05-04 14:00:00', '2024-05-04 17:30:00', 'International', 'On Time'),
       ('Air France', 'CDG', 'LAX', '2024-05-05 16:00:00', '2024-05-05 20:30:00', 'International', 'On Time');

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

INSERT INTO Multi_flight_connections (original_flight_id, connected_flight_id, Leg_number, Layover_duration, Layover_airport)
VALUES (1, 2, 1, '2 hours', 'ORD'),  -- Connection from Delta Airlines to United Airlines at Chicago
       (3, 4, 1, '3 hours', 'JFK'),  -- Connection from Emirates to British Airways at JFK
		(2, 3, 1, '2 hours', 'ORD'),  -- Connection from United Airlines to Emirates at Chicago
       (4, 5, 1, '4 hours', 'JFK');  -- Connection from British Airways to Air France at JFK
select * FROM Multi_flight_connections;
INSERT INTO Passengers_list (user_id, booking_id, name, age, gender, passenger_type)
VALUES (1, 1, 'John Doe', 30, 'Male', 'Adult'),
       (2, 2, 'Jane Smith', 25, 'Female', 'Adult'),
       (3, 3, 'Mike Jones', 35, 'Male', 'Adult'),
       (4, 4, 'Sarah Brown', 28, 'Female', 'Adult'),
       (5, 5, 'Chris Evans', 40, 'Male', 'Adult');

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
BEGIN 
	SELECT COALESCE(SUM(sc.price), 0) + COALESCE(SUM(ft.price),0)
	INTO total_cost
	FROM Seat_class sc
	LEFT JOIN Booking_Information bi ON sc.flight_id = bi.flight_id
	LEFT JOIN Food_options_table ft ON ft.flight_id = bi.flight_id
	WHERE bi.booking_id = p_booking_id;
	
	SELECT Promotions_table.discount_amount
	INTO v_discount_amount
	FROM promotions_table
	WHERE promotions_table.booking_id = p_booking_id;
	
	IF v_discount_amount is NOT NULL THEN 
		total_cost := total_cost - v_discount_amount;
	END IF;
	
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

-- 4) Function to check the seat availability
CREATE OR REPLACE FUNCTION check_seat_availability(p_flight_id INTEGER, p_seat_number VARCHAR(10))
RETURNS BOOLEAN
AS $$
DECLARE
    seat_available BOOLEAN;
BEGIN
    SELECT CASE
               WHEN EXISTS (
                       SELECT 1
                       FROM Seat_class
                       WHERE flight_id = p_flight_id AND seat_number = p_seat_number AND availability_status = 'Available'
                   )
               THEN TRUE
               ELSE FALSE
           END
    INTO seat_available;

    RETURN seat_available;
END;
$$ LANGUAGE plpgsql;
-- 5) Function that gives list of flights from given given departure airport to arrival airport
CREATE OR REPLACE function search_flights(
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
		(f.departure_airport=search_flights.departure_airport_code
		 OR f.arrival_airport = search_flights.arrival_airport_code)
		AND DATE(f.departure_date_time)=search_flights.departure_date 
		AND f.flight_id IN (
			SELECT f1.flight_id FROM Flight f1
			JOIN Seat_class s on f1.flight_id = s.flight_id
			WHERE s.availability_status = 'available'
			GROUP BY f1.flight_id
			HAVING COUNT(f1.flight_id)>=search_flights.num_passengers
		)
	UNION
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
		Multi_flight_connections mfc
	JOIN 
		Flight f ON mfc.connected_flight_id = f.flight_id
	WHERE
		mfc.original_flight_id IN(
			SELECT 
				f.flight_id
			FROM
				Flight f
			WHERE 
				f.departure_airport = search_flights.departure_airport_code
				AND f.arrival_airport = search_flights.arrival_airport_code
				AND DATE(f.departure_date_time) = search_flights.departure_date
		)
	ORDER BY
		departure_date_time ASC;
END;
$$ LANGUAGE plpgsql;
SELECT * FROM search_flights(
	departure_airport_code := 'JFK',
	arrival_airport_code := 'LAX',
	departure_date := '2024-05-01',
	num_passengers := 2
);


SELECT * FROM flight;



































