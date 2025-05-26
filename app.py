import pymysql
import spacy
import google.generativeai as genai
from flask import Flask, request, jsonify, render_template
from flask_cors import CORS
from datetime import datetime

# Load NLP Model
nlp = spacy.load("en_core_web_sm")

# Initialize Flask App
app = Flask(__name__)
CORS(app)  # Enable Cross-Origin Resource Sharing

# Configure Gemini API
GEMINI_API_KEY = "YOUR_API_KEY"  # Replace with your actual key
genai.configure(api_key=GEMINI_API_KEY)
model = genai.GenerativeModel("gemini-2.0-flash")

# MySQL Database Connections
try:
    # FD Database
    fd_conn = pymysql.connect(
        host="HOST_NAME",
        user="USER_NAME",
        password="PASSWORD",
        database="DATABASE_NAME",
        port=PORT_NUMBER
    )
    fd_cursor = fd_conn.cursor()
except pymysql.Error as e:
    print(f"FD database connection failed: {e}")
    exit(1)

try:
    # Savings Database
    savings_conn = pymysql.connect(
        host="HOST_NAME",
        user="USER_NAME",
        password="PASSWORD",
        database="DATABASE_NAME",
        port=PORT_NUMBER
    )
    savings_cursor = savings_conn.cursor()
except pymysql.Error as e:
    print(f"Savings database connection failed: {e}")
    exit(1)

# Bank Names Mapping
bank_names = {
    "SBI": "State Bank of India",
    "PNB": "Punjab National Bank",
    "BOB": "Bank of Baroda",
    "CANARA": "Canara Bank",
    "UBI": "Union Bank",
    "BOI": "Bank of India",
    "INDIAN": "Indian Bank",
    "CBI": "Central Bank of India",
    "IOB": "Indian Overseas Bank",
    "UCO": "UCO Bank",
    "BOM": "Bank of Maharashtra",
    "PSB": "Punjab and Sind Bank",
    "JKB": "Jammu and Kashmir Bank",
    "HDFC": "HDFC Bank",
    "ICICI": "ICICI Bank",
    "INDUSIND": "Indusind Bank",
    "IDFC": "IDFC First Bank",
    "KB": "Karnataka Bank",
    "KVB": "Karur Vysya Bank",
    "KOTAK": "Kotak Mahindra Bank",
    "IDBI": "IDBI Bank",
    "YES": "Yes Bank",
    "AXIS": "Axis Bank",
    "Bandan": "Bandan Bank",
    "CSB": "CSB Bank",
    "CUB": "City Union Bank",
    "DCB": "DCB Bank",
    "DB": "Dhanalaxmi Bank",
    "FB": "Federal Bank",
}

# FD Database Functions
def get_all_fd_rates(bank_name):
    try:
        query = """
        SELECT tenure_range, regular_rate, senior_citizen_rate, min_deposit, compounding
        FROM fd_rates fr
        JOIN banks b ON fr.bank_id = b.bank_id
        WHERE b.bank_name = %s AND fr.effective_date <= CURDATE()
        ORDER BY fr.tenure_min_days ASC;
        """
        fd_cursor.execute(query, (bank_name,))
        results = fd_cursor.fetchall()
        if results:
            response = f"FD rates for {bank_name}:\n"
            for row in results:
                tenure, reg_rate, senior_rate, min_deposit, compounding = row
                response += f"{tenure}: Regular {reg_rate}%, Senior {senior_rate}%, Min ₹{min_deposit}, {compounding}\n"
            return response.strip()
        return f"No FD rate data available for {bank_name}."
    except pymysql.Error as e:
        return f"Database error: {e}"

def get_fd_rate(bank_name, tenure_days, senior_citizen=False):
    try:
        rate_column = "senior_citizen_rate" if senior_citizen else "regular_rate"
        query = f"""
        SELECT {rate_column}, min_deposit, compounding
        FROM fd_rates fr
        JOIN banks b ON fr.bank_id = b.bank_id
        WHERE b.bank_name = %s 
        AND fr.tenure_min_days <= %s AND fr.tenure_max_days >= %s
        AND fr.effective_date <= CURDATE()
        ORDER BY fr.effective_date DESC LIMIT 1;
        """
        fd_cursor.execute(query, (bank_name, tenure_days, tenure_days))
        result = fd_cursor.fetchone()
        return result if result else None
    except pymysql.Error as e:
        return None

def calculate_fd_interest(bank_name, deposit_amount, tenure_days, senior_citizen=False):
    try:
        fd_data = get_fd_rate(bank_name, tenure_days, senior_citizen)
        if not fd_data:
            return f"No FD rate found for {bank_name} for {tenure_days} days."
        
        interest_rate, min_deposit, compounding = fd_data
        if deposit_amount < min_deposit:
            return f"Deposit amount ₹{deposit_amount} is below the minimum required ₹{min_deposit} for {bank_name}."
        
        periods_per_year = {"Quarterly": 4, "Monthly": 12, "Yearly": 1, "Half-Yearly": 2}.get(compounding, 4)
        years = tenure_days / 365
        interest = deposit_amount * ((1 + (interest_rate / 100) / periods_per_year) ** (periods_per_year * years) - 1)
        maturity_amount = deposit_amount + interest
        
        return (f"For {bank_name} with ₹{deposit_amount} over {tenure_days} days "
                f"({'Senior Citizen' if senior_citizen else 'Regular'}): "
                f"Interest ₹{interest:.2f}, Maturity ₹{maturity_amount:.2f} at {interest_rate}% ({compounding}).")
    except Exception as e:
        return f"Error calculating FD interest: {str(e)}"

def compare_fd_banks(bank1, bank2, tenure_days=None, senior_citizen=False):
    try:
        rate_column = "senior_citizen_rate" if senior_citizen else "regular_rate"
        if tenure_days:
            query = f"""
            SELECT b.bank_name, fr.{rate_column}
            FROM fd_rates fr
            JOIN banks b ON fr.bank_id = b.bank_id
            WHERE b.bank_name IN (%s, %s)
            AND fr.tenure_min_days <= %s AND fr.tenure_max_days >= %s
            AND fr.effective_date <= CURDATE()
            ORDER BY fr.{rate_column} DESC;
            """
            fd_cursor.execute(query, (bank1, bank2, tenure_days, tenure_days))
        else:
            query = f"""
            SELECT b.bank_name, AVG(fr.{rate_column}) as avg_rate
            FROM fd_rates fr
            JOIN banks b ON fr.bank_id = b.bank_id
            WHERE b.bank_name IN (%s, %s)
            AND fr.effective_date <= CURDATE()
            GROUP BY b.bank_name
            ORDER BY avg_rate DESC;
            """
            fd_cursor.execute(query, (bank1, bank2))
        
        results = fd_cursor.fetchall()
        if results:
            response = f"FD Comparison of {bank1} and {bank2} ({'Senior Citizen' if senior_citizen else 'Regular'}):\n"
            for row in results:
                response += f"{row[0]}: {row[1]:.2f}%\n"
            return response.strip()
        return f"No comparison data available for {bank1} and {bank2}."
    except pymysql.Error as e:
        return f"Database error: {e}"

def get_highest_fd_rate(tenure_days=None, senior_citizen=False):
    try:
        rate_column = "senior_citizen_rate" if senior_citizen else "regular_rate"
        if tenure_days:
            query = f"""
            SELECT b.bank_name, fr.{rate_column}
            FROM fd_rates fr
            JOIN banks b ON fr.bank_id = b.bank_id
            WHERE fr.tenure_min_days <= %s AND fr.tenure_max_days >= %s
            AND fr.effective_date <= CURDATE()
            ORDER BY fr.{rate_column} DESC LIMIT 1;
            """
            fd_cursor.execute(query, (tenure_days, tenure_days))
        else:
            query = f"""
            SELECT b.bank_name, MAX(fr.{rate_column}) as max_rate
            FROM fd_rates fr
            JOIN banks b ON fr.bank_id = b.bank_id
            WHERE fr.effective_date <= CURDATE()
            GROUP BY b.bank_name
            ORDER BY max_rate DESC LIMIT 1;
            """
            fd_cursor.execute(query)
        
        result = fd_cursor.fetchone()
        return (f"The bank offering the highest FD rate is {result[0]} with {result[1]}% "
                f"({'Senior Citizen' if senior_citizen else 'Regular'}).") if result else "No data available."
    except pymysql.Error as e:
        return f"Database error: {e}"

# Savings Database Functions
def get_all_interest_rates(bank_name):
    try:
        query = """
        SELECT min_amount, max_amount, interest_rate FROM SavingsInterestRates 
        WHERE bank_name = %s ORDER BY min_amount ASC;
        """
        savings_cursor.execute(query, (bank_name,))
        results = savings_cursor.fetchall()
        if results:
            response = f"Interest rates for {bank_name}:\n"
            for row in results:
                min_amt, max_amt, rate = row
                response += f" ₹{min_amt} - ₹{max_amt}: {rate}%\n"
            return response.strip()
        return f"No interest rate data available for {bank_name}."
    except pymysql.Error as e:
        return f"Database error: {e}"

def get_interest_rate(bank_name, deposit_amount):
    try:
        query = """
        SELECT interest_rate FROM SavingsInterestRates 
        WHERE bank_name = %s AND min_amount <= %s AND max_amount >= %s
        ORDER BY updated_on DESC LIMIT 1;
        """
        savings_cursor.execute(query, (bank_name, deposit_amount, deposit_amount))
        result = savings_cursor.fetchone()
        return f"The interest rate for {bank_name} with a deposit of ₹{deposit_amount} is {result[0]}%." if result else f"No interest rate found for ₹{deposit_amount} in {bank_name}."
    except pymysql.Error as e:
        return f"Database error: {e}"

def compare_savings_banks(bank1, bank2):
    try:
        query = """
        SELECT bank_name, AVG(interest_rate) as avg_rate FROM SavingsInterestRates 
        WHERE bank_name IN (%s, %s) 
        GROUP BY bank_name 
        ORDER BY avg_rate DESC;
        """
        savings_cursor.execute(query, (bank1, bank2))
        results = savings_cursor.fetchall()
        if results:
            response = f"Comparison of {bank1} and {bank2}:\n"
            for row in results:
                response += f"{row[0]}: {row[1]:.2f}%\n"
            return response.strip()
        return f"No comparison data available for {bank1} and {bank2}."
    except pymysql.Error as e:
        return f"Database error: {e}"

def get_highest_interest_bank():
    try:
        query = """
        SELECT bank_name, interest_rate 
        FROM SavingsInterestRates 
        WHERE interest_rate = (SELECT MAX(interest_rate) FROM SavingsInterestRates)
        LIMIT 1;
        """
        savings_cursor.execute(query)
        result = savings_cursor.fetchone()
        return f"The bank offering the highest interest rate is {result[0]} with {result[1]}%." if result else "No data available."
    except pymysql.Error as e:
        return f"Database error: {e}"

# NLP Function for FD
def extract_fd_details(message):
    doc = nlp(message.lower())
    bank_names_found = []
    deposit_amount = None
    tenure_days = None
    senior_citizen = False

    if any(keyword in message.lower() for keyword in ["senior citizen", "senior", "elderly"]):
        senior_citizen = True

    for token in doc:
        if token.text.upper() in bank_names:
            bank_names_found.append(bank_names[token.text.upper()])
        elif token.like_num:
            if deposit_amount is None and token.text.replace(',', '').isdigit():
                deposit_amount = int(token.text.replace(',', ''))
            elif any(keyword in message.lower() for keyword in ["day", "days", "year", "years", "month", "months"]):
                if token.text.isdigit():
                    num = int(token.text)
                    next_token = token.nbor(1) if token.i + 1 < len(doc) else None
                    if next_token and next_token.text in ["year", "years"]:
                        tenure_days = num * 365
                    elif next_token and next_token.text in ["month", "months"]:
                        tenure_days = num * 30
                    elif next_token and next_token.text in ["day", "days"]:
                        tenure_days = num

    return bank_names_found, deposit_amount, tenure_days, senior_citizen

# NLP Function for Savings
def extract_savings_details(message):
    doc = nlp(message.lower())
    bank_names_found = []
    deposit_amount = None
    days = None
    rate = None

    for token in doc:
        if token.text.upper() in bank_names:
            bank_names_found.append(bank_names[token.text.upper()])
        elif token.like_num:
            if deposit_amount is None and token.text.replace(',', '').isdigit():
                deposit_amount = int(token.text.replace(',', ''))
            elif "day" in message and token.text.isdigit():
                days = int(token.text)
            elif ("rate" in message or "%" in token.text) and token.like_num:
                rate = float(token.text.replace('%', ''))

    return bank_names_found, deposit_amount, days, rate

# Chatbot API
@app.route('/chat', methods=['POST'])
def chatbot():
    try:
        data = request.json
        user_message = data.get("message", "").strip()
        mode = data.get("mode", "fd").lower()  # Default to FD chatbot

        if mode == "fd":
            bank_names_found, deposit_amount, tenure_days, senior_citizen = extract_fd_details(user_message)
            gemini_prompt = f"""
            User query: "{user_message}"
            Classify the query intent as one of:
            1. all_rates (e.g., "FD rates of SBI")
            2. specific_rate (e.g., "SBI FD rate for 1 year")
            3. calculate_interest (e.g., "Calculate FD interest for 50000 in SBI for 1 year")
            4. compare_banks (e.g., "Compare SBI and PNB FD rates")
            5. best_rate (e.g., "Which bank has the highest FD rate?")
            6. unknown (anything else)
            Respond only with the intent name in lowercase.
            """
            intent_response = model.generate_content(gemini_prompt)
            intent = intent_response.text.strip().lower()

            if intent == "all_rates" and len(bank_names_found) == 1:
                response = get_all_fd_rates(bank_names_found[0])
            elif intent == "specific_rate" and len(bank_names_found) == 1 and tenure_days:
                fd_data = get_fd_rate(bank_names_found[0], tenure_days, senior_citizen)
                if fd_data:
                    rate, min_deposit, compounding = fd_data
                    response = (f"The FD rate for {bank_names_found[0]} for {tenure_days} days "
                                f"({'Senior Citizen' if senior_citizen else 'Regular'}) is {rate}% "
                                f"with min deposit ₹{min_deposit}, {compounding}.")
                else:
                    response = f"No FD rate found for {bank_names_found[0]} for {tenure_days} days."
            elif intent == "calculate_interest" and len(bank_names_found) == 1 and deposit_amount and tenure_days:
                response = calculate_fd_interest(bank_names_found[0], deposit_amount, tenure_days, senior_citizen)
            elif intent == "compare_banks" and len(bank_names_found) == 2:
                response = compare_fd_banks(bank_names_found[0], bank_names_found[1], tenure_days, senior_citizen)
            elif intent == "best_rate":
                response = get_highest_fd_rate(tenure_days, senior_citizen)
            else:
                gemini_fallback_prompt = f"""
                You are a banking assistant specializing in fixed deposit (FD) rates in India. 
                Respond naturally to this user query: '{user_message}'. 
                If relevant, use this context: {bank_names_found if bank_names_found else 'No banks mentioned'}, 
                {'Senior Citizen' if senior_citizen else 'Regular'}, 
                {f'Deposit: ₹{deposit_amount}' if deposit_amount else ''}, 
                {f'Tenure: {tenure_days} days' if tenure_days else ''}.
                """
                gemini_fallback = model.generate_content(gemini_fallback_prompt)
                response = gemini_fallback.text.strip()

        elif mode == "savings":
            bank_names_found, deposit_amount, days, rate = extract_savings_details(user_message)
            gemini_prompt = f"""
            User query: "{user_message}"
            Classify the query intent as one of:
            1. all_rates (e.g., "Interest rates of SBI")
            2. specific_rate (e.g., "SBI rate for 5000")
            3. compare_banks (e.g., "Compare SBI and HDFC")
            4. best_rate (e.g., "Which bank has the highest rate?")
            5. unknown (anything else)
            Respond only with the intent name in lowercase.
            """
            intent_response = model.generate_content(gemini_prompt)
            intent = intent_response.text.strip().lower()

            if intent == "all_rates" and len(bank_names_found) == 1:
                response = get_all_interest_rates(bank_names_found[0])
            elif intent == "specific_rate" and len(bank_names_found) == 1 and deposit_amount:
                response = get_interest_rate(bank_names_found[0], deposit_amount)
            elif intent == "compare_banks" and len(bank_names_found) == 2:
                response = compare_savings_banks(bank_names_found[0], bank_names_found[1])
            elif intent == "best_rate":
                response = get_highest_interest_bank()
            else:
                gemini_fallback_prompt = f"""
                You are a banking assistant specializing in savings interest rates in India. 
                Respond naturally to this user query: '{user_message}'. 
                If relevant, use this context: {bank_names_found if bank_names_found else 'No banks mentioned'}.
                """
                gemini_fallback = model.generate_content(gemini_fallback_prompt)
                response = gemini_fallback.text.strip()

        else:
            response = "Invalid chatbot mode. Please select 'Savings' or 'FD'."

        return jsonify({"response": response})
    except Exception as e:
        return jsonify({"response": f"An error occurred: {str(e)}"}), 500

# Serve the front-end
@app.route('/')
def home():
    return render_template('index.html')

# Run Flask App
if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)

# Cleanup on exit
fd_conn.close()
savings_conn.close()
