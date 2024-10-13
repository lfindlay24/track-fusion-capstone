const fetch = require('node-fetch');

// Writes a message to Firestore
async function addMessage(text, user, time, room) {

    fetch("https://track-fusion-api-gateway-t8b6s4l.uc.gateway.dev/trackfusion/garageGroups/" + room, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            text: text,
            user: user,
            time: time,
        })
    })
        .then(data => {
            console.log(data);
        })
        .catch(error => {
            console.error('Error:', error);
        });

}


module.exports = {
    addMessage,
};
