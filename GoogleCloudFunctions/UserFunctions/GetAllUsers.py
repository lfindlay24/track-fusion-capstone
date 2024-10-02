import firebase_admin
from firebase_admin import credentials, firestore
from flask import jsonify, Request

# Initialize the Firebase Admin SDK
# This will automatically use the default credentials for the Cloud Function
firebase_admin.initialize_app()

# Firestore DB instance
db = firestore.client()

def getAllUsers_http(request: Request):
    # Get all documents from the "users" collection

    usersAsDict = {}

    users = db.collection('users').stream()
    if users is None:
        return 'ERROR: No users found', 400
    for user in users:
        usersAsDict[user.id] = user.to_dict()
    return usersAsDict, 200