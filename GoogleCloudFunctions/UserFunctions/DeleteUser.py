import firebase_admin
from firebase_admin import credentials, firestore
from flask import jsonify, Request

# Initialize the Firebase Admin SDK
# This will automatically use the default credentials for the Cloud Function
firebase_admin.initialize_app()

# Firestore DB instance
db = firestore.client()

def deleteUser_http(request: Request):
    
    userId = request.args.get('userId')
    
    if not userId:
        return 'ERROR: Path Variable Invalid or Missing', 400

    user = db.collection('users').document(userId).get()
    if not user.exists:
        return 'ERROR: User not found', 400
    db.collection('users').document(userId).delete()
    return 'User deleted successfully', 200