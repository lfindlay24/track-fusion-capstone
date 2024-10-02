import firebase_admin
from firebase_admin import credentials, firestore
from flask import jsonify, Request

# Initialize the Firebase Admin SDK
# This will automatically use the default credentials for the Cloud Function
firebase_admin.initialize_app()

# Firestore DB instance
db = firestore.client()

def create_document(request: Request):
    try:
        # Parse the request JSON data
        request_json = request.get_json(silent=True)
        
        if not request_json:
            return jsonify({"error": "Invalid JSON data"}), 400

        # Add a new document to the specified Firestore collection
        doc_ref = db.collection('users').add(request_json)

        return jsonify({
            'message': 'Document created successfully',
            'documentId': doc_ref[1].id
        }), 200

    except Exception as e:
        print(f"Error creating document: {e}")
        return jsonify({"error": "Failed to create document"}), 500
