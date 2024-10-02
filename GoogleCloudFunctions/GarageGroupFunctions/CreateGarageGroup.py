import firebase_admin
from firebase_admin import credentials, firestore
from flask import jsonify, Request

# Initialize the Firebase Admin SDK
# This will automatically use the default credentials for the Cloud Function
firebase_admin.initialize_app()

# Firestore DB instance
db = firestore.client()

def createGarageGroup_http(request: Request):

    request_json = request.get_json(silent=True)
    
    if not request_json:
        return 'ERROR: Invalid JSON data', 400

    if request_json and 'groupName' in request_json:
        # Add a new document to the specified Firestore collection
        request_json['members'] = []
        doc_ref = db.collection('GarageGroups').add(request_json)
    else:
        return 'ERROR: Invalid request\nPlease make sure you include a Group Name', 400
    return 'Garage created successfully', 200