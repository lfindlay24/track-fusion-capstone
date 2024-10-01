from google.cloud import firestore
import firebase_admin
from firebase_admin import credentials
from google.cloud import functions

import functions_framework

# Initialize Firestore client with project ID
project_id = 'utahjazz24'
db = firestore.Client(project=project_id)

@functions_framework.http
def createUser_http(request):
    request_json = request.get_json(silent=True)

    if request.get_verb() != 'POST':
        return 'ERROR: Only POST requests are allowed', 405

    if request_json and 'name' in request_json and 'email' in request_json and 'password' in request_json:
        db = firestore.Client()
        doc_ref = db.collection(u'users').document(request_json['email'])
        doc_ref.set({
            u'name': request_json['name'],
            u'email': request_json['email'],
            u'password': request_json['password']
        })
    else:
        return 'ERROR: Invalid request', 400
    return 'User created successfully', 200


# Add a new document
db = firestore.Client()
doc_ref = db.collection(u'users').document(u'alovelace')
doc_ref.set({
    u'first': u'Ada',
    u'last': u'Lovelace',
    u'born': 1815
})

# Then query for documents
users_ref = db.collection(u'users')

for doc in users_ref.stream():
    print(u'{} => {}'.format(doc.id, doc.to_dict()))