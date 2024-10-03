import firebase_admin
from firebase_admin import credentials, firestore
from flask import jsonify, Request

# Initialize the Firebase Admin SDK
# This will automatically use the default credentials for the Cloud Function
firebase_admin.initialize_app()

# Firestore DB instance
db = firestore.client()

def updateGarageGroup_http(request: Request):

    request_json = request.get_json(silent=True)

    groupId = request.args.get('groupId')

    group = db.collection('GarageGroups').document(groupId).get()
    if  not group.exists:
        return 'ERROR: Group doesnt exist', 400
    
    if not request_json:
        return 'ERROR: Invalid JSON data', 400
    if not groupId:
        return 'ERROR: Path Variable Invalid or Missing', 400

    if 'groupName' not in request_json:
        request_json['groupName'] = group.get('groupName')
    doc_ref = db.collection('GarageGroups').document(groupId).set({"groupName": request_json['groupName']}, merge=True)
    if not doc_ref:
        return 'ERROR: Failed to update Group Name', 400
    return 'Group Name updated Successfully', 200