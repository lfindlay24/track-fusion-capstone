import firebase_admin
from firebase_admin import credentials, firestore
from flask import jsonify, Request

# Initialize the Firebase Admin SDK
# This will automatically use the default credentials for the Cloud Function
firebase_admin.initialize_app()

# Firestore DB instance
db = firestore.client()

def deleteRaceData_http(request: Request):
    
    userId = request.args.get('userId')
    raceId = request.args.get('raceId')
    
    if not userId:
        return 'ERROR: Path Variable Invalid or Missing', 400
    if not raceId:
        return 'ERROR: Path Variable Invalid or Missing', 400

    data = db.collection('RaceModeData').document(raceId).get()
    if not data.exists:
        return 'ERROR: Data not found', 400
    if data.to_dict()['userId'] != userId:
        return 'ERROR: User does not have permission to delete this data', 400
    db.collection('RaceModeData').document(raceId).delete()

    return 'Data deleted successfully', 200