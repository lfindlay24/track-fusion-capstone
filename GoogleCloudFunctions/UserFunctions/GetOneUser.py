import firebase_admin
from firebase_admin import credentials, firestore
from flask import jsonify, Request

# Initialize the Firebase Admin SDK
# This will automatically use the default credentials for the Cloud Function
firebase_admin.initialize_app()

# Firestore DB instance
db = firestore.client()

def GetOneUser_http(request: Request):

    userAsDict = {}

    userId = request.view_args('userId')
    
    if not userId:
        return 'ERROR: Path Variable Invalid or Missing', 400

    user = db.collection('users').document(userId).get()
    if not user.exists:
        return 'ERROR: User not found', 400
    userAsDict[user.id] = user.to_dict()
    return userAsDict, 200