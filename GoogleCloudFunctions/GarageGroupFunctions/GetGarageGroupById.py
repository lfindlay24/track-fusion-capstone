import firebase_admin
from firebase_admin import credentials, firestore
from flask import jsonify, Request

# Initialize the Firebase Admin SDK
# This will automatically use the default credentials for the Cloud Function
firebase_admin.initialize_app()

# Firestore DB instance
db = firestore.client()

def getOneGroup_http(request: Request):

    groupAsDict = {}

    groupId = request.args.get('groupId')
    
    if not groupId:
        return 'ERROR: Path Variable Invalid or Missing', 400

    group = db.collection('GarageGroups').document(groupId).get()
    if not group.exists:
        return 'ERROR: Group not found', 400
    groupAsDict[group.id] = group.to_dict()
    return groupAsDict, 200