// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract TransferMoney {
    struct User {
        string name;
        uint role;
    }

    struct Transfer {
        address owner;
        address somebody;
        uint256 amount;
        bool status;
        bytes32 secret_key;
    }

    mapping(address => User) public users;
    Transfer[] public transfers;

    constructor() {
        users[msg.sender] = User("Dmitriy", 0);
    }

    function create_user(string memory _name, uint _role) public {
        users[msg.sender] = User(_name, _role);
    }

    function create_offer(address _somebody, string memory _secret_key) public payable {
        require(msg.value > 0, "Infussicient value sent");
        require(msg.sender != _somebody, "You cant pay to yourself");

        transfers.push(Transfer(msg.sender, _somebody, msg.value, true, keccak256(abi.encodePacked(_secret_key))));
    }

    function accept_offer(uint _transferID, string memory _user_secret_key) public {
        require(transfers[_transferID].status, "This offer is not available!");
        require(msg.sender == transfers[_transferID].somebody, "You are not somebody in transfer!");
        
        if(keccak256(abi.encodePacked(_user_secret_key)) == transfers[_transferID].secret_key) {
            payable(msg.sender).transfer(transfers[_transferID].amount);
        } else {
            payable(transfers[_transferID].owner).transfer(transfers[_transferID].amount);
        }

        transfers[_transferID].status = false;
    }

    function cancel_offer(uint _userID) public {
        require(msg.sender == transfers[_userID].owner, "You are not owner in this transfer");
        require(transfers[_userID].status, "Transfer already accept");
        
        payable(msg.sender).transfer(transfers[_userID].amount);
        
        transfers[_userID].status = false;
    }

    function change_role(address _somebody) public {
        require(users[msg.sender].role == 1, "You are not admin!");
        users[_somebody].role = 1;
    }
}
