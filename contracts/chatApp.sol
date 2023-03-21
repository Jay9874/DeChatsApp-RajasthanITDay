// SPDX License Identifier: MIT

pragma solidity ^0.8.0;

contract ChatApp {
    // User struct
    struct User {
        string name;
        Friend[] friendList;
    }

    // Friend struct
    struct Friend {
        address pubkey;
        string name;
    }

    // Message struct
    struct Message {
        address sender;
        uint256 timestamp;
        string msg;
    }

    struct AllUsers {
        string name;
        address accountAddress;
    }

    AllUsers[] public getAllUsers;

    // Mapping of users
    mapping(address => User) users;
    mapping(bytes32 => Message[]) messages;

    // Check if user exists
    function checkUserExist(address pubkey) public view returns (bool) {
        return bytes(users[pubkey].name).length > 0;
    }

    // Create user
    function createAccount(string calldata name) external {
        require(!checkUserExist(msg.sender), "User already exists");
        require(bytes(name).length > 0, "Name cannot be empty");
        users[msg.sender].name = name;
        getAllUsers.push(AllUsers(name, msg.sender));
    }

    // Get user name
    function getUsername(address pubkey) external view returns (string memory) {
        require(checkUserExist(pubkey), "User does not exist");
        return users[pubkey].name;
    }

    // Add friend
    function addFriend(address friend_key, string calldata name) external {
        require(checkUserExist(msg.sender), "Create an account first");
        require(checkUserExist(friend_key), "Friend does not exist");
        require(msg.sender != friend_key, "Cannot add yourself as a friend");
        require(
            checkAldreadyFriend(msg.sender, friend_key) == false,
            "Already friends"
        );
        _addFriend(msg.sender, friend_key, name);
        _addFriend(friend_key, msg.sender, users[msg.sender].name);
    }

    //Check if already friends
    function checkAldreadyFriend(
        address pubkey,
        address friend_key
    ) internal view returns (bool) {
        if (
            users[pubkey].friendList.length >
            users[friend_key].friendList.length
        ) {
            address temp = pubkey;
            pubkey = friend_key;
            friend_key = temp;
        }
        for (uint256 i = 0; i < users[pubkey].friendList.length; i++) {
            if (users[pubkey].friendList[i].pubkey == friend_key) {
                return true;
            }
        }
        return false;
    }

    // Add friend to friend list
    function _addFriend(
        address pubkey,
        address friend_key,
        string memory name
    ) internal {
        users[pubkey].friendList.push(Friend(friend_key, name));
    }

    //Get friend list
    function getMyFriendList(address pubkey)
        external
        view
        returns (Friend[] memory)
    {
        require(checkUserExist(pubkey), "User does not exist");
        return users[pubkey].friendList;
    }

    //get chat code
    function _getChatCode(address pubkey1, address pubkey2)
        internal
        pure
        returns (bytes32)
    {
        require(pubkey1 != pubkey2, "Cannot chat with yourself");
        if (pubkey1 < pubkey2) {
            return keccak256(abi.encodePacked(pubkey1, pubkey2));
        } else {
            return keccak256(abi.encodePacked(pubkey2, pubkey1));
        }
    }

    // Send message
    function sendMessage(address friend_key, string calldata _msg) external {
        require(checkUserExist(msg.sender), "Create an account first");
        require(checkUserExist(friend_key), "Friend does not exist");
        require(
            checkAldreadyFriend(msg.sender, friend_key) == true,
            "Not friends"
        );
        bytes32 chat_code = _getChatCode(msg.sender, friend_key);
        messages[chat_code].push(Message(msg.sender, block.timestamp, _msg));
    }

    // Get message
    function readMessage(address friend_key)
        external
        view
        returns (Message[] memory)
    {
        require(checkUserExist(msg.sender), "Create an account first");
        require(checkUserExist(friend_key), "Friend does not exist");
        require(
            checkAldreadyFriend(msg.sender, friend_key) == true,
            "Not friends"
        );
        bytes32 chat_code = _getChatCode(msg.sender, friend_key);
        return messages[chat_code];
    }

    // Get all users
    function getAllUsersList() external view returns (AllUsers[] memory) {
        return getAllUsers;
    }
}
