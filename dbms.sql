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
SELECT check_seat_availability(1, 'A1');
SELECT * FROM SEAT_Class;
select * from flight;
select * from seat_class;

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


-- 3) Procedure to cancels a booking, updates seat availability and 


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

-- Grant privileges to Finance role
GRANT SELECT, UPDATE ON payment_details TO finance;

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

-- Create the trigger on booking_information table
CREATE TRIGGER update_total_cost_trigger
AFTER INSERT OR UPDATE ON booking_information
FOR EACH ROW
EXECUTE FUNCTION update_total_cost();


-- 3) Create a trigger to update booking status based on payment status

CREATE OR REPLACE FUNCTION update_booking_status()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
        UPDATE booking_information bi
        SET booking_status = (
            CASE 
                WHEN pd.payment_status = 'Success' THEN 'Confirmed'
                ELSE 'Pending'
            END
        )
        FROM Payment_Details pd
        WHERE bi.payment_id = pd.payment_id AND bi.booking_id = NEW.booking_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create the trigger on Payment_Details table
CREATE TRIGGER update_booking_status_trigger
AFTER INSERT OR UPDATE ON Payment_Details
FOR EACH ROW
EXECUTE FUNCTION update_booking_status();



-- 4) Trigger to set flight delay status 
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



-- 5) Create a trigger to enforce referential integrity between tables
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

-- 6) Trigger to prevent dupliate rows with same user
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








