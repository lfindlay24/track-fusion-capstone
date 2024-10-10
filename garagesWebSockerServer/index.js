const { addUser, getUser, deleteUser } = require('./users');

const express = require('express');
const http = require('http');
const socketIo = require('socket.io');

const app = express();
const server = http.createServer(app);
const io = socketIo(server, {
    cors: {
        origin: '*',
    },
});

io.on('connection', (socket) => {
    console.log('New client connected');

    //When A user signs in they are added to the group, connection to the group is established
    socket.on('signin', async ({ user, room }) => {
        try {
            // Record socket ID to user's name and chat room
            addUser(socket.id, user, room);
            // Call join to subscribe the socket to a given channel
            socket.join(room);
            // Emit notification event to notify other users of the added user
            socket.in(room).emit('notification', {
                title: "Someone's here",
                description: `${user} just entered the room`,
            });
            // Retrieve room's message history or return null
            //const messages = await getRoomFromCache(room);
            // Use the callback to respond with the room's message history
            // Callbacks are more commonly used for event listeners than promises
        } catch (err) {
            console.error(err);
        }
    });

    // Add listener for "sendMessage" event
    socket.on('sendMessage', (message) => {
        // Retrieve user's name and chat room  from socket ID
        const { user, room } = getUser(socket.id);
        if (room) {
            const msg = { user, text: message };
            // Push message to clients in chat room
            io.in(room).emit('message', msg);
            //addMessageToCache(room, msg);
            //callback();
        } else {
            //callback('User session not found.');
        }
    });

    socket.on('disconnected', () => {
        console.log('Client disconnected');
    });
});

const PORT = process.env.PORT || 3000;
server.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});
