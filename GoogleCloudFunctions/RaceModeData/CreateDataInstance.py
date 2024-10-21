import firebase_admin
from firebase_admin import credentials, firestore
from flask import jsonify, Request

# Initialize the Firebase Admin SDK
# This will automatically use the default credentials for the Cloud Function
firebase_admin.initialize_app()

# Firestore DB instance
db = firestore.client()

def uploadRaceData_http(request: Request):

    request_json = request.get_json(silent=True)
    
    if not request_json:
        return 'ERROR: Invalid JSON data', 400

    if request_json and 'userId' in request_json and 'raceTime' in request_json and 'raceDistance' in request_json and 'raceLocation' in request_json and 'recordingEvents' in request_json:
        # Add a new document to the specified Firestore collection
        doc_ref = db.collection('RaceModeData').document().set(request_json)
    else:
        return 'ERROR: Invalid request\nPlease make sure you include a userId, a raceTime, raceDistance, raceLocation, and recordingEvents', 400
    return 'Race Data successfully saved.', 200