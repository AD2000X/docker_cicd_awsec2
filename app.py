# Simple Flask web application
# Defines a single route that returns a greeting message
# Configures the server to listen on all interfaces

from flask import Flask  # Import Flask framework
app = Flask(__name__)  # Initialize Flask application

@app.route("/")  # Register route for the root URL
def hello():  # Handler function for root route
    return "Hello, Docker + CI/CD + AWS!!!!"  # Return greeting message

if __name__ == "__main__":  # Only run server if script is executed directly
    app.run(host="0.0.0.0", port=5000)  # Run on all interfaces, port 5000
