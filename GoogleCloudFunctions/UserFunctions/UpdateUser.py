import firebase_admin
from firebase_admin import credentials, firestore
from flask import jsonify, Request

# Initialize the Firebase Admin SDK
# This will automatically use the default credentials for the Cloud Function
firebase_admin.initialize_app()

# Firestore DB instance
db = firestore.client()

def updateUser_http(request: Request):

    request_json = request.get_json(silent=True)

    userId = request.args.get('userId')

    user = db.collection('users').document(userId).get()
    if  not user.exists:
        return 'ERROR: User doesnt exist', 400
    
    if not request_json:
        return 'ERROR: Invalid JSON data', 400
    if not userId:
        return 'ERROR: Path Variable Invalid or Missing', 400

    if 'name' not in request_json:
        request_json['name'] = user.get('name')
    if 'password' not in request_json:
        request_json['password'] = user.get('password')
    if 'isPremiumAccount' not in request_json:
        request_json['isPremiumAccount'] = user.get('isPremiumAccount')
    if 'email' not in request_json:
        request_json['email'] = user.get('email')
    else:
        # Check if the email is already in use
        existingUser = db.collection('users').document(request_json['email']).get()
        if existingUser.exists:
            return 'ERROR: Cannot Change emails to an already active user', 400
        else:
            # If email is not being used delete the old user and create a new one with a new email
            db.collection('users').document(request_json['email']).set(request_json)
            db.collection('users').document(userId).delete()
            userId = request_json['email']
            return 'Email updated Successfully', 200
    doc_ref = db.collection('users').document(userId).set(request_json)
    return 'User updated Successfully', 200