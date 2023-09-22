// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 < 0.9.0;

contract transferMoney {
    struct User {
        string name;
        uint role;
        uint balance;
    }

    struct Transfer {
        address owner;
        address somebody;
        uint amount;
        bytes32 secretKey;
        bool transferStatus;
    }

    mapping(uint => User) public users;
    mapping(uint => Transfer) public transfers;

    uint public numUsers = 0;
    uint public numTransfers = 0;

    constructor() {
        // Create Administrators

        users[numUsers] = User("Roman", 1, 45);
        numUsers++;

        users[numUsers] = User("Alexander", 1, 20);
        numUsers++;

        // Create default users

        users[numUsers] = User("Dmitriy", 0, 10);
        numUsers++;

        users[numUsers] = User("Ivan", 0, 15);
        numUsers++;

        users[numUsers] = User("Alexey", 0, 20);
        numUsers++;

        users[numUsers] = User("Maxim", 0, 30);
        numUsers++;
    }


    // function for create offer for send money

    function createOffer(address _somebody, uint _amount, string memory secretKey) public payable {
        require(msg.value >= _amount, "Check money");
        require(_somebody != msg.sender, "You can not pay money to me!");
        require(_amount != 0, "You haven't money");

        transfers[numTransfers] = Transfer(msg.sender, _somebody, _amount, keccak256(abi.encodePacked(secretKey)), true);
        numTransfers++;
    }


    // function get money out contract

    function getMoney(uint _ID, uint _somebodyID, address _somebody, bytes32 key) public {
        require(transfers[_ID].somebody == msg.sender, "You are not sender!");
        if(transfers[_ID].secretKey == key) {
            payable(_somebody).transfer(transfers[_ID].amount * 10 ** 18);
            
            users[_ID].balance -= transfers[_ID].amount;
            users[_somebodyID].balance += transfers[_ID].amount;

            transfers[_ID].transferStatus = false;
        } else {
            payable(transfers[_ID].owner).transfer(transfers[_ID].amount);

            transfers[_ID].transferStatus = false;
        }
    }

    // function cancel offer for contract

    function cancelOffer(uint _ID) public {
        require(transfers[_ID].owner == msg.sender, "You are not sender!");
        payable(transfers[_ID].owner).transfer(transfers[_ID].amount * 10 ** 18);

        transfers[_ID].transferStatus = false;
    }


    // function change role
                     
    function changeRole(uint _ID) public {
        require(users[_ID].role == 1, "You are not admin");
        users[_ID].role = 1;
    }
}
