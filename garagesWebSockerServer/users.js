// Local record of users
const users = new Map();

// Record socket ID with user's name and chat room
function addUser(id, name, room) {
  if (!name && !room) return new Error('Username and room are required');
  if (!name) return new Error('Username is required');
  if (!room) return new Error('Room is required');
  users.set(id, {user: name, room});
}

// Return user's name and chat room from socket ID
function getUser(id) {
  return users.get(id) || {};
}

// Delete user record
function deleteUser(id) {
  const user = getUser(id);
  users.delete(id);
  return user;
}

module.exports = {
  addUser,
  getUser,
  deleteUser,
};
