import firebase_admin
from firebase_admin import credentials, firestore
from flask import jsonify, Request

# Initialize the Firebase Admin SDK
# This will automatically use the default credentials for the Cloud Function
firebase_admin.initialize_app()

# Firestore DB instance
db = firestore.client()

def removeUserFromGarageGroup_http(request: Request):

    request_json = request.get_json(silent=True)

    groupId = request.args.get('groupId')

    userId = request.args.get('userId')

    group = db.collection('GarageGroups').document(groupId).get()
    if  not group.exists:
        return 'ERROR: Group doesnt exist', 400
    group = group.to_dict()
    if userId not in group['members']:
        return 'ERROR: User isnt in the group', 400
    group['members'].remove(userId)
    
    user = db.collection('users').document(userId).get()
    if not user.exists:
        return 'ERROR: User doesnt exist', 400
    
    if not groupId:
        return 'ERROR: GroupId Path Variable Invalid or Missing', 400
    if not userId:
        return 'ERROR: UserId Path Variable Invalid or Missing', 400

    doc_ref = db.collection('GarageGroups').document(groupId).set({"members": group['members']}, merge=True)
    if not doc_ref:
        return 'ERROR: Failed to remove user', 400
    return 'SUCCESS: User {0} removed from group'.format(userId), 200