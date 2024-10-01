from google.cloud import firestore

def hello_firestore(request):
    # Initialize Firestore client
    db = firestore.Client()

    # Get a reference to the 'users' collection
    users_ref = db.collection('users')

    # Add a new document to the 'users' collection
    new_user = {
        'name': 'John Doe',
        'email': 'johndoe@example.com',
        'age': 30
    }
    users_ref.add(new_user)

    # Retrieve all documents from the 'users' collection
    users = users_ref.get()

    # Print the documents
    for user in users:
        print(f'{user.id} => {user.to_dict()}')

    return 'Firestore interaction complete!'