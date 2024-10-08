// Initialize Socket.io
const io = require('socket.io')(server);

// [START cloudrun_websockets_redis_adapter]
const { createAdapter } = require('@socket.io/redis-adapter');
// Replace in-memory adapter with Redis
const subClient = redisClient.duplicate();
io.adapter(createAdapter(redisClient, subClient));
// [END cloudrun_websockets_redis_adapter]
// Add error handlers
redisClient.on('error', err => {
  console.error(err.message);
});

subClient.on('error', err => {
  console.error(err.message);
});

// Listen for new connection
// When a connection is established listen for different events within the server
io.on('connection', socket => {
    // Add listener for "signin" event
    // When a user "signs in" they are added to the group, connection to the group is established
    // and all other users in the group are notified of the new user 
    socket.on('signin', async ({ user, room }, callback) => {
      try {
        // Record socket ID to user's name and chat room
        addUser(socket.id, user, room);
        // Call join to subscribe the socket to a given channel
        socket.join(room);
        // Emit notification event
        socket.in(room).emit('notification', {
          title: "Someone's here",
          description: `${user} just entered the room`,
        });
        // Retrieve room's message history or return null
        const messages = await getRoomFromCache(room);
        // Use the callback to respond with the room's message history
        // Callbacks are more commonly used for event listeners than promises
        callback(null, messages);
      } catch (err) {
        callback(err, null);
      }
    });
  
    // [START cloudrun_websockets_update_socket]
    // Add listener for "updateSocketId" event
    socket.on('updateSocketId', async ({ user, room }) => {
      try {
        addUser(socket.id, user, room);
        socket.join(room);
      } catch (err) {
        console.error(err);
      }
    });
    // [END cloudrun_websockets_update_socket]
  
    // Add listener for "sendMessage" event
    socket.on('sendMessage', (message, callback) => {
      // Retrieve user's name and chat room  from socket ID
      const { user, room } = getUser(socket.id);
      if (room) {
        const msg = { user, text: message };
        // Push message to clients in chat room
        io.in(room).emit('message', msg);
        addMessageToCache(room, msg);
        callback();
      } else {
        callback('User session not found.');
      }
    });
  
    // Add listener for disconnection
    socket.on('disconnect', () => {
      // Remove socket ID from list
      const { user, room } = deleteUser(socket.id);
      if (user) {
        io.in(room).emit('notification', {
          title: 'Someone just left',
          description: `${user} just left the room`,
        });
      }
    });
  });