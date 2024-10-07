import firebase_admin
from firebase_admin import credentials, firestore
from flask import jsonify, Request

# Initialize the Firebase Admin SDK
# This will automatically use the default credentials for the Cloud Function
firebase_admin.initialize_app()

# Firestore DB instance
db = firestore.client()

def login_http(request: Request):

    request_json = request.get_json(silent=True)
    
    if not request_json:
        return 'ERROR: Invalid JSON data', 400

    if request_json and 'email' in request_json and 'password' in request_json:
        user = db.collection('users').document(request_json['email']).get()
        if user.exists:
            user_data = user.to_dict()
            if user_data['password'] == request_json['password']:
                return jsonify(user_data), 200
            else:
                return 'ERROR: Invalid password', 400
    else:
        return 'ERROR: Invalid request\nPlease make sure you include a unique email, and password', 400