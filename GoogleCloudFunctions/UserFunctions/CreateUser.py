import firebase_admin
from firebase_admin import credentials, firestore
from flask import jsonify, Request

# Initialize the Firebase Admin SDK
# This will automatically use the default credentials for the Cloud Function
firebase_admin.initialize_app()

# Firestore DB instance
db = firestore.client()

def createUser_http(request: Request):

    request_json = request.get_json(silent=True)
    
    if not request_json:
        return 'ERROR: Invalid JSON data', 400

    if request_json and 'name' in request_json and 'email' in request_json and 'password' in request_json:
        user = db.collection('users').document(request_json['email']).get()
        if user.exists:
            return 'ERROR: User already exists', 400
        # Add a new document to the specified Firestore collection
        request_json['isPremiumAccount'] = False
        doc_ref = db.collection('users').document(request_json['email']).set(request_json)
    else:
        return 'ERROR: Invalid request\nPlease make sure you include a unique email, a name, and password', 400
    return 'User created successfully', 200