from flask import Flask, render_template, request, redirect, url_for, session
from datetime import datetime
from flask_bcrypt import generate_password_hash
import psycopg2

app = Flask(__name__)
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
        userName = request.form['username']
        passwordInput = request.form['password']
    
        # Query the database for the user
        cur.execute("SELECT * FROM Users WHERE userName = %s AND password = %s", (userName, passwordInput))
        user = cur.fetchone()

        if user:
            # User found and password matches, proceed with login
            return render_template('flight.html')  # Render the flight.html template after successful login
        else:
            # Invalid credentials, render the login page again with an error message
            return render_template('login.html', error='Invalid username or password. Please try again.')

    except Exception as e:
        if conn:
            conn.rollback()
        app.logger.error("Error during login: %s", e)
        return "Error during login. Please try again later."
    finally:
        if conn:
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

@app.route('/search_flights', methods=['POST'])
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
    
@app.route('/book_flight', methods=['POST'])

def book_flight():
    # Dummy flight ID for demonstration
    flight_id = request.form.get('flight_id')

    # Execute the PostgreSQL function to get seat ratings data
    query = f"SELECT * FROM get_seat_rating_with_average({flight_id})"
    seat_ratings_data = execute_sql_query(query)

    # Render the HTML template with the seat ratings data
    return render_template('seat_ratings.html', seat_ratings=seat_ratings_data)

@app.route('/add_food_addons', methods=['POST'])
def add_food_addons():

        flight_id = request.form.get('flight_id')
        print(f"Flight Id: {flight_id}")
        
        # Assuming execute_sql_query function is defined and works correctly
        query = f"SELECT * FROM get_food_options_for_flight({flight_id})"
        food_data = execute_sql_query(query)
        # Render the HTML template with the food options data
        return render_template('food_options.html', food=food_data)

@app.route('/book_seat', methods=['POST'])
def show_cost():
    flight_id = request.form.get('flight_id')
    seat_num = str(request.form.get('seat_number'))  # Cast seat_num to string
    
    # Assuming execute_sql_query function is defined and works correctly
    query = f"SELECT calculate_total_payment_amount({flight_id}, '{seat_num}')"
    total_cost_data = execute_sql_query(query)
    
    # Render the HTML template with the total cost data
    return render_template('show_cost.html', total_cost=total_cost_data)

@app.route('/confirm_payment', methods=['POST'])
def confirm_payment():
    conn = connect_db()
    cur = conn.cursor()

    try:
        # Get form data from POST request
        payment_method = request.form['payment_method']
        total_cost = request.form['total_cost']

        # Insert payment data into the payment_details table
        sql_payment = """INSERT INTO payment_details (payment_date, mode_of_payment, payment_amount, payment_status)
                         VALUES (CURRENT_DATE, %s, %s, 'successful')"""
        data_payment = (payment_method, total_cost)
        cur.execute(sql_payment, data_payment)

        # Retrieve the last inserted payment_id
        cur.execute("SELECT lastval()")
        payment_id = cur.fetchone()[0]

        # Get user ID from session or request (assuming it's stored during login)
        username = session.get('username')  # Assuming username is stored in the session
        print(f"username: {username}")
        if not username:
            raise Exception("Username not found in session.")

        # Query the database to fetch the user ID based on the username
        cur.execute("SELECT user_id FROM Users WHERE userName = %s", (username,))
        user_id = cur.fetchone()[0]

        # Get booking details from the request
        flight_id = request.form['flight_id']
        seat_number = request.form['seat_number']
        booking_date = datetime.now().date()
        departure_date = request.form['departure_date']

        # Insert booking information into the booking_information table
        sql_booking = """INSERT INTO booking_information (user_id, total_cost, payment_id, booking_date, flight_id, departure_date)
                         VALUES (%s, %s, %s, %s, %s, %s)"""
        data_booking = (user_id, total_cost, payment_id, booking_date, flight_id, departure_date)
        cur.execute(sql_booking, data_booking)

        conn.commit()
        return f"Selected Payment Method: {payment_method}, Total Cost: ${total_cost}. Payment details and booking information inserted into the database."

    except Exception as e:
        conn.rollback()
        app.logger.error("Error inserting payment details or booking information: %s", e)
        return "Error inserting payment details or booking information. Please try again later."

    finally:
        cur.close()
        conn.close()

if __name__ == '__main__':
    app.run(debug=True)


if __name__ == '__main__':
    app.run(debug=True)
