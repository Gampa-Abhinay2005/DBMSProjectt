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













































