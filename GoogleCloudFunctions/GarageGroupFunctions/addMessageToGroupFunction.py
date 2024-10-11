import firebase_admin
from firebase_admin import credentials, firestore
from flask import jsonify, Request

# Initialize the Firebase Admin SDK
# This will automatically use the default credentials for the Cloud Function
firebase_admin.initialize_app()

# Firestore DB instance
db = firestore.client()

def addMessageToGroup_http(request: Request):

    message = {
        "user": "",
        "text": "",
        "time": 0
    }

    request_json = request.get_json(silent=True)

    groupId = request.args.get('groupId')

    group = db.collection('GarageGroups').document(groupId).get()
    if  not group.exists:
        return 'ERROR: Group doesnt exist', 400
    group = group.to_dict()
    message['user'] = request_json['user']
    message['text'] = request_json['text']
    message['time'] = request_json['time']
    group['messages'].append(message)
    
    
    if not groupId:
        return 'ERROR: GroupId Path Variable Invalid or Missing', 400

    doc_ref = db.collection('GarageGroups').document(groupId).set({"messages": group['messages']}, merge=True)
    if not doc_ref:
        return 'ERROR: Failed to save Message', 400
    return 'SUCCESS: Message saved to group', 200