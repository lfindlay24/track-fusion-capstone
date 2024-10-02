import firebase_admin
from firebase_admin import credentials, firestore
from flask import jsonify, Request

# Initialize the Firebase Admin SDK
# This will automatically use the default credentials for the Cloud Function
firebase_admin.initialize_app()

# Firestore DB instance
db = firestore.client()

def getAllGarageGroups_http(request: Request):
    # Get all documents from the "users" collection

    groupsAsDict = {}

    groups = db.collection('GarageGroups').stream()
    if groups is None:
        return 'ERROR: No users found', 400
    for group in groups:
        groupsAsDict[group.id] = group.to_dict()
    return groupsAsDict, 200