from flask import Flask, render_template, request, redirect, url_for, session, flash
from datetime import datetime
from flask_bcrypt import generate_password_hash
import psycopg2

app = Flask(__name__)
app.secret_key = b'_5#y2L"F4Q8z\n\xec]/'

dbname = 'dbms_project_final'
username = 'postgres'
password = 'abhi@545'
host = 'localhost'

# Create a connection to PostgreSQL
def connect_db():
    return psycopg2.connect(dbname=dbname, user=username, password=password, host=host)
def execute_sql_query(query):
    connection = psycopg2.connect(host=host, dbname=dbname, user=username, password=password)
    cursor = connection.cursor()
    cursor.execute(query)
    data = cursor.fetchall()
    cursor.close()
    connection.close()
    return data
def get_food_options_for_flight(flight_id):
    # Execute SQL query to get food options for the given flight ID
    query = f"SELECT * FROM get_food_options_for_flight({flight_id})"
    return execute_sql_query(query)
def parse_total_cost_data(total_cost_data_str):
    # Remove parentheses and split the string into individual values
    values = total_cost_data_str.strip('()').split(',')
    # Convert the values to appropriate data types
    total_cost = float(values[0])
    flight_id = int(values[1])
    departure_date = values[2]
    arrival_date = values[3]
    seat_number = values[4]
    return {'total_cost': total_cost, 'flight_id': flight_id, 'departure_date': departure_date, 'arrival_date': arrival_date, 'seat_number': seat_number}

@app.route('/')
def welcome():
    return render_template('welcome.html')

# Route for displaying the login page
@app.route('/next_page_1.html', methods=['GET'])
def show_login_page():
    return render_template('login.html')  # Render the login.html template for GET requests


@app.route('/login', methods=['POST'])
def login():
    conn = None
    try:
        conn = connect_db()
        cur = conn.cursor()

        # Get username and password from the form
        username = request.form['username']
        password_input = request.form['password']
    
        # Query the database for the user
        cur.execute("SELECT user_id, password FROM Users WHERE username = %s", (username,))
        user_data = cur.fetchone()
        print(user_data)
        if user_data:
            # User found, check if password matches
            stored_password = user_data[1]
            user_id = user_data[0]
            if password_input == stored_password:
                session['user_id'] = user_id
                
                # Insert into login_attempts table with login_success = True
                cur.execute(
                    "INSERT INTO login_attempts (user_id, login_time, login_success) VALUES (%s, %s, %s)",
                    (user_id, datetime.now(), True)
                )
                conn.commit()
                
                return render_template('flight.html')  # Render the flight.html template after successful login
            else:
                # Invalid password, insert into login_attempts table with login_success = False
                cur.execute(
                    "INSERT INTO login_attempts (user_id, login_time, login_success) VALUES (%s, %s, %s)",
                    (user_id, datetime.now(), False)
                )
                conn.commit()
                # Render login page with error
                return render_template('login.html', error='Invalid username or password. Please try again.')
        else:
            # User not found, render login page with error
            return render_template('login.html', error='Invalid username or password. Please try again.')
    except Exception as e:
        # Handle exceptions, perhaps log the error
        print(e)
        return render_template('error.html')
    finally:
        if conn:
            conn.close()

@app.route('/previous_bookings')
def show_previous_bookings():
    conn = connect_db()  # Connect to your database
    cur = conn.cursor()
    user_id = session.get('user_id')
    try:
        # Query to fetch previous bookings for the specified user
        sql_query = "SELECT * FROM booking_information WHERE user_id = %s ORDER BY booking_date DESC"
        cur.execute(sql_query, (user_id,))
        booking_info = cur.fetchall()
        print(booking_info)
        # Render the HTML template with the booking information
        return render_template('previous_bookings.html', bookings=booking_info)

    except Exception as e:
        # Handle exceptions
        print(e)
        flash('Error fetching previous bookings.', 'error')
        return redirect(url_for('index'))  # Redirect to homepage or error page

    finally:
        cur.close()
        conn.close()

@app.route('/next_page.html')
def users_1():
    return render_template('users3.html')

@app.route('/register', methods=['POST'])
def register():
    conn = connect_db()
    cur = conn.cursor()

    # Get form data from POST request
    userName = request.form['userName']
    passwordInput = request.form['password']
    first_name = request.form['first_name']
    last_name = request.form['last_name']
    address = request.form['address']
    phone_number = request.form['phone_number']
    age = request.form['age']
    email = request.form['email']

    # Hash the password (for security)
    passwordHash = (passwordInput)

    # Insert user data into the database
    sql = """INSERT INTO Users (userName, password, first_name, last_name, address, phone_number, age, Email)
             VALUES (%s, %s, %s, %s, %s, %s, %s, %s)"""
    data = (userName, passwordHash, first_name, last_name, address, phone_number, age, email)

    try:
        cur.execute(sql, data)
        conn.commit()

        return redirect(url_for('welcome'))  # Redirect to welcome page after successful registration
    except Exception as e:
        conn.rollback()
        app.logger.error("Error registering user: %s", e)
        return "Error registering user. Please try again later."
    finally:
        cur.close()
        conn.close()

@app.route('/next_page_flights.html')
def flights_1():
    return render_template('flight.html')

@app.route('/search_direct_flights', methods=['POST'])
def search_flights():
    # Retrieve form data from the request object
    departure_airport = request.form['departure_airport']
    arrival_airport = request.form['arrival_airport']
    departure_date = request.form['departure_date']
    passenger_count = request.form['passenger_count']

    # Connect to the database
    conn = connect_db()
    cur = conn.cursor()

    try:
        # Call the search_flights function in the database
        cur.execute("SELECT * FROM search_flights(%s, %s, %s, %s)", (departure_airport, arrival_airport, departure_date, passenger_count))
        flights = cur.fetchall()
        user_id = session.get('user_id')

       
        # Close database connection
        cur.close()
        conn.close()

        # Render the search_results.html template with flight information
        return render_template('search_results.html', flights=flights)
    except Exception as e:
        # Handle any errors that occur during database query
        conn.rollback()
        app.logger.error("Error during flight search: %s", e)
        return "Error during flight search. Please try again later."
@app.route('/search_multi_flights', methods=['POST'])
def search_flights1():
    # Retrieve form data from the request object
    departure_airport = request.form['departure_airport']
    arrival_airport = request.form['arrival_airport']
    departure_date = request.form['departure_date']
    passenger_count = request.form['passenger_count']

    # Connect to the database and create a cursor
    # Replace connect_db() and connect to your actual database
    conn = connect_db()
    cur = conn.cursor()

    try:
        # Call the search_multi_connected_flights1 function in the database
        cur.execute(
    """
    SELECT * FROM search_multi_connected_flights1(
        CAST(%s AS VARCHAR),
        CAST(%s AS VARCHAR),
        CAST(%s AS DATE),
        CAST(%s AS INT)
    )
    """,
    (departure_airport, arrival_airport, departure_date, passenger_count),
)

        # Fetch the results
        flight_results = cur.fetchall()
        print(flight_results)
        # Close the cursor and connection
        cur.close()
        conn.close()

        # Process and return the flight results
        if flight_results:
            return render_template('flight_results.html', flights=flight_results)
        else:
            return render_template('no_results.html')

    except Exception as e:
        # Handle exceptions, perhaps log the error
        print(e)
        cur.close()
        conn.close()
        return render_template('error.html')

@app.route('/book_flight1', methods=['POST'])
def book_multi_flight():
    try:
        # Retrieve flight ID for the original flight from the form data
        original_flight_id = request.form.get('original_flight_id')
        print(f"Original Flight ID: {original_flight_id}")
        connected_flight_id = request.form.get('connected_flight_id')
        # Check if seats are available for the original flight
        query_original_availability = f"SELECT check_seat_availability1({original_flight_id})"
        original_seats_available = execute_sql_query(query_original_availability)
        query_connected_availability = f"SELECT check_seat_availability({connected_flight_id})"
        connected_seats_available = execute_sql_query(query_connected_availability)
        print(f"Original Seats Available: {original_seats_available}")

        if original_seats_available[0][0] and connected_seats_available[0][0]:
            # Retrieve seat ratings data for the original flight
            query_original_ratings = f"SELECT * FROM get_seat_rating_with_average({original_flight_id})"
            original_seat_ratings_data = execute_sql_query(query_original_ratings)

            print("Original Seat Ratings Data:")
            print(original_seat_ratings_data)

            # Render the HTML template with the seat ratings data for the original flight
            return render_template('mutli_flight_seat_ratings.html', original_seat_ratings=original_seat_ratings_data)
        else:
            # Render a template indicating that seats are not available for the original flight
            return render_template('no_seats_available.html')

    except Exception as e:
        # Handle exceptions, perhaps log the error
        print(e)
        # Render a template for an error page
        return render_template('error.html')




@app.route('/book_flight', methods=['POST'])
def book_flight():
    # Dummy flight ID for demonstration
    flight_id = request.form.get('flight_id')

    # Check if seats are available for the flight using the existing PostgreSQL function
    query = f"SELECT check_seat_availability1({flight_id})"
    seats_available = execute_sql_query(query)
    print(seats_available[0][0])
    if seats_available[0][0]:
        # Execute the PostgreSQL function to get seat ratings data
        query = f"SELECT * FROM get_seat_rating_with_average({flight_id})"
        seat_ratings_data = execute_sql_query(query)

        # Render the HTML template with the seat ratings data
        return render_template('seat_ratings.html', seat_ratings=seat_ratings_data)
    else:
        # Render a template indicating that seats are not available
        return render_template('no_seats_available.html')

@app.route('/add_food_addons', methods=['POST'])
def add_food_addons():
    # Debugging: Print form data
    print(request.form)

    flight_id = request.form.get('flight_id')


    seat_number = request.form.get('seat_number')

    type_of_seat = request.form.get('type_of_seat')
    

    # Assuming execute_sql_query function is defined and works correctly
    query = f"SELECT * FROM get_food_options_for_flight({flight_id}, '{seat_number}', '{type_of_seat}')"
    food_data = execute_sql_query(query)

    # Debugging: Print retrieved food data
    print(food_data)

    # Render the HTML template with the food options data
    return render_template('food_options.html', food=food_data)


@app.route('/add_food_addons_11', methods=['POST'])
def add_food_addons_11():
    # Debugging: Print form data
    print(request.form)

    flight_id = request.form.get('flight_id')


    seat_number = request.form.get('seat_number')

    type_of_seat = request.form.get('type_of_seat')
    

    # Assuming execute_sql_query function is defined and works correctly
    query = f"SELECT * FROM get_food_options_for_flight({flight_id}, '{seat_number}', '{type_of_seat}')"
    food_data = execute_sql_query(query)

    # Debugging: Print retrieved food data
    print(food_data)

    # Render the HTML template with the food options data
    return render_template('food_options11.html', food=food_data)

@app.route('/book_seat11', methods=['POST'])
def show_cost_11():
    flight_id = request.form.get('flight_id')
    print(flight_id)
    seat_num = str(request.form.get('seat_number'))  # Cast seat_num to string
    
    # Assuming execute_sql_query function is defined and works correctly
    query = f"SELECT calculate_total_payment_amount({flight_id}, '{seat_num}')"
    total_cost_data = execute_sql_query(query)
    
     # Parse the total_cost_data string into individual values
    total_cost_dict = parse_total_cost_data(total_cost_data[0][0]) if total_cost_data else None
    # Render the HTML template with the total cost data
    return render_template('show_cost11.html', total_cost=total_cost_dict)
@app.route('/process_payment11', methods=['POST'])
def confirm_payment11():
    conn = connect_db()
    cur = conn.cursor()

    try:
        # Get form data from POST request
        payment_method = request.form.get('payment_option')
        total_cost = request.form.get('total_cost')
        flight_id = request.form.get('flight_id')
        departure_date = request.form.get('departure_date')
        arrival_date = request.form.get('arrival_date')
        seat_number = request.form.get('seat_number')  # Added seat_number retrieval
        
        # Check if any required data is missing
        if not all([payment_method, total_cost, flight_id, departure_date]):
            raise ValueError("Missing required form data.")

        # Insert payment data into the payment_details table
        sql_payment = """INSERT INTO payment_details (payment_date, mode_of_payment, payment_amount, payment_status)
                         VALUES (CURRENT_DATE, %s, %s, 'successful')"""
        data_payment = (payment_method, total_cost)
        
        cur.execute(sql_payment, data_payment)
        # Retrieve the last inserted payment_id
        cur.execute("SELECT lastval()")
        payment_id = cur.fetchone()[0]

        # Get user ID from session or request (assuming it's stored during login)
        
        user_id = session.get('user_id')  # Assuming username is stored in the session


        # Insert booking information into the booking_information table
        print(departure_date)
        print(arrival_date)
        sql_booking = """INSERT INTO booking_information (user_id, total_cost, payment_id, booking_date, flight_id, departure_date, arrival_date)
                         VALUES (%s, %s, %s, CURRENT_DATE, %s, %s, %s)"""
        data_booking = (user_id, total_cost, payment_id, flight_id,  departure_date, arrival_date)
        cur.execute(sql_booking, data_booking)
        
        sql_update_seat_status = """UPDATE seat_class SET seat_status = 'Occupied' WHERE flight_id = %s AND seat_number = %s"""
        data_update_seat_status = (flight_id, seat_number)
        cur.execute(sql_update_seat_status, data_update_seat_status)

        conn.commit()
        cur.execute("SELECT * FROM booking_information ORDER BY booking_id DESC LIMIT 1")
        booking_info = cur.fetchone()
        
        # Flash a success message
        flash('Booking confirmed!', 'success')

        # Redirect to the URL for booking a seat on the connected flight
        return render_template('booking1.html', booking_info = booking_info)

    except Exception as e:
        conn.rollback()
        app.logger.error("Error inserting payment details or booking information: %s", e)
        flash('Error processing payment. Please try again later.', 'error')
        return redirect(url_for('booking_error'))

    finally:
        cur.close()
        conn.close()
@app.route('/seat_ratings')
def show_seat_ratings():
    connected_flight_id = session.get('connected_flight_id')
    print(connected_flight_id)
    print(session['connected_flight_id'])

    query_connected_ratings = f"SELECT * FROM get_seat_rating_with_average({connected_flight_id})"
    connected_seat_ratings_data = execute_sql_query(query_connected_ratings)

    print(connected_seat_ratings_data)
    return render_template('seat_ratings11.html', seat_ratings=connected_seat_ratings_data)
@app.route('/book_seat', methods=['POST'])
def show_cost():
    flight_id = request.form.get('flight_id')
    print(flight_id)
    seat_num = str(request.form.get('seat_number'))  # Cast seat_num to string
    
    # Assuming execute_sql_query function is defined and works correctly
    query = f"SELECT calculate_total_payment_amount({flight_id}, '{seat_num}')"
    total_cost_data = execute_sql_query(query)
    
     # Parse the total_cost_data string into individual values
    total_cost_dict = parse_total_cost_data(total_cost_data[0][0]) if total_cost_data else None
    # Render the HTML template with the total cost data
    return render_template('show_cost.html', total_cost=total_cost_dict)
@app.route('/book/4', methods = ['POST'])
def show_cost1122():
    flight_id = request.form.get('flight_id')
    seat_num = str(request.form.get('seat_number'))  # Cast seat_num to string
    food_id = request.form.get('food_id')
    type_of_seat = str(request.form.get('type_of_seat'))
    # Assuming execute_sql_query function is defined and works correctly
    query = f"SELECT calculate_total_payment_amount_given_food({flight_id}, {food_id}, '{seat_num}', '{type_of_seat}')"
    total_cost_data = execute_sql_query(query)
    
     # Parse the total_cost_data string into individual values
    total_cost_dict = parse_total_cost_data(total_cost_data[0][0]) if total_cost_data else None
    # Render the HTML template with the total cost data
    return render_template('show_cost.html', total_cost=total_cost_dict)
@app.route('/book/5', methods = ['POST'])
def show_cost1():
    flight_id = request.form.get('flight_id')
    seat_num = str(request.form.get('seat_number'))  # Cast seat_num to string
    food_id = request.form.get('food_id')
    type_of_seat = str(request.form.get('type_of_seat'))
    # Assuming execute_sql_query function is defined and works correctly
    query = f"SELECT calculate_total_payment_amount_given_food({flight_id}, {food_id}, '{seat_num}', '{type_of_seat}')"
    total_cost_data = execute_sql_query(query)
    
     # Parse the total_cost_data string into individual values
    total_cost_dict = parse_total_cost_data(total_cost_data[0][0]) if total_cost_data else None
    # Render the HTML template with the total cost data
    return render_template('show_cost.html', total_cost=total_cost_dict)
@app.route('/book/6', methods = ['POST'])
def show_cost111():
    flight_id = request.form.get('flight_id')
    seat_num = str(request.form.get('seat_number'))  # Cast seat_num to string
    food_id = request.form.get('food_id')
    type_of_seat = str(request.form.get('type_of_seat'))
    # Assuming execute_sql_query function is defined and works correctly
    query = f"SELECT calculate_total_payment_amount_given_food({flight_id}, {food_id}, '{seat_num}', '{type_of_seat}')"
    total_cost_data = execute_sql_query(query)
    
     # Parse the total_cost_data string into individual values
    total_cost_dict = parse_total_cost_data(total_cost_data[0][0]) if total_cost_data else None
    # Render the HTML template with the total cost data
    return render_template('show_cost11.html', total_cost=total_cost_dict)
@app.route('/process_payment', methods=['POST'])
def confirm_payment():
    conn = connect_db()
    cur = conn.cursor()

    try:
        # Get form data from POST request
        payment_method = request.form.get('payment_option')
        total_cost = request.form.get('total_cost')
        flight_id = request.form.get('flight_id')
        departure_date = request.form.get('departure_date')
        arrival_date = request.form.get('arrival_date')
        seat_number = request.form.get('seat_number')  # Added seat_number retrieval
        session['flight_id'] = flight_id
        # Check if any required data is missing
        if not all([payment_method, total_cost, flight_id, departure_date]):
            raise ValueError("Missing required form data.")

        # Insert payment data into the payment_details table
        sql_payment = """INSERT INTO payment_details (payment_date, mode_of_payment, payment_amount, payment_status)
                         VALUES (CURRENT_DATE, %s, %s, 'successful')"""
        data_payment = (payment_method, total_cost)
        
        cur.execute(sql_payment, data_payment)
        # Retrieve the last inserted payment_id
        cur.execute("SELECT lastval()")
        payment_id = cur.fetchone()[0]

        # Get user ID from session or request (assuming it's stored during login)
        
        user_id = session.get('user_id')  # Assuming username is stored in the session


        # Insert booking information into the booking_information table
        print(departure_date)
        print(arrival_date)
        sql_booking = """INSERT INTO booking_information (user_id, total_cost, payment_id, booking_date, flight_id, departure_date, arrival_date)
                         VALUES (%s, %s, %s, CURRENT_DATE, %s, %s, %s)"""
        data_booking = (user_id, total_cost, payment_id, flight_id,  departure_date, arrival_date)
        cur.execute(sql_booking, data_booking)
        
        sql_update_seat_status = """UPDATE seat_class SET seat_status = 'Occupied' WHERE flight_id = %s AND seat_number = %s"""
        data_update_seat_status = (flight_id, seat_number)
        cur.execute(sql_update_seat_status, data_update_seat_status)

        conn.commit()
        cur.execute("SELECT * FROM booking_information ORDER BY booking_id DESC LIMIT 1")
        booking_info = cur.fetchone()
        
        return render_template('booking.html', booking_info=booking_info)

    except Exception as e:
        conn.rollback()
        app.logger.error("Error inserting payment details or booking information: %s", e)
        return "Error inserting payment details or booking information. Please try again later."

    finally:
        cur.close()
        conn.close()

@app.route("/exit", methods=["POST", "GET"])

def review():
    return render_template('review.html')

@app.route("/confirm_review", methods=["POST"])
def confirm_review():
    conn = connect_db()
    cur = conn.cursor()
    if request.method == "POST":
        user_id = session.get('user_id') # Assuming you get user_id from session or form
        flight_id = int(session.get('flight_id'))
        review_text = request.form.get('review_text')
        rating = request.form.get('rating')
        rating_status = request.form.get('rating_status')




        sql_insert_review = """INSERT INTO reviews_and_ratings 
                        (user_id, flight_id, review_text, review_date, rating, rating_status) 
                      VALUES (%s, %s, %s, CURRENT_DATE, %s, %s)"""

# Define the data tuple containing the values to insert
        data_review = (user_id, flight_id, review_text, rating, rating_status)

# Execute the INSERT statement using the cursor
        cur.execute(sql_insert_review, data_review)

# Commit the changes to the database
        conn.commit()

# Close the cursor and database connection when done
        cur.close()
        conn.close()
        return redirect(url_for('review_confirmation'))
    else:
        return "Invalid request method"

@app.route("/review_confirmation")
def review_confirmation():
    return render_template('review_confirmation.html')
    

if __name__ == '__main__':
    app.run(debug=True)
