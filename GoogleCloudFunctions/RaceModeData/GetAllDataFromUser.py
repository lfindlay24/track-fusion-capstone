import firebase_admin
from firebase_admin import credentials, firestore
from flask import jsonify, Request

# Initialize the Firebase Admin SDK
# This will automatically use the default credentials for the Cloud Function
firebase_admin.initialize_app()

# Firestore DB instance
db = firestore.client()

def getRaceData_http(request: Request):

    raceData = {}
    userId = request.args.get('userId')
    
    if not userId:
        return 'ERROR: Path Variable Invalid or Missing', 400
    
    docs = db.collection('RaceModeData').where('userId', '==', userId).stream()

    for doc in docs:
        raceData[doc.id] = doc.to_dict()
    return raceData, 200