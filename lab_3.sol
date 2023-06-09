// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
import "hardhat/console.sol";

contract Voting {
    struct Headman {
        uint ID;
        uint votedNumber;
        string surname;
        string group;
        bool statusRegistered;
    }

    struct Students {
        uint ID;
        string surname;
        string group;
        uint votedNum;
        bool statusVoted;
    }

    mapping(uint => Headman) public headmansArr;
    mapping(uint => Students) public studentsArr;

    uint public numHeadmans = 0;
    uint public numStudents = 0;

    address admin = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;

    uint VotedTime = 60;
    bool VotedStatus = false;

    constructor() {
        studentsArr[numStudents] = Students(numStudents, "Ivanov", "ISiP(p) 2/3", 1, false);
        numStudents++;

        studentsArr[numStudents] = Students(numStudents, "Petrov", "ISiP(p) 2/3", 1, false);
        numStudents++;

        studentsArr[numStudents] = Students(numStudents, "Limanov", "KSK 2/27", 1, false);
        numStudents++;

        studentsArr[numStudents] = Students(numStudents, "Semenov", "KSK 2/27", 1, false);
        numStudents++;
    }

    function addNewStudent(uint _ID, string memory _Surname, string memory _Group) public {
        require(msg.sender == 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, "You are not admin");
        for(uint i = 0; i < numStudents; i++) {
            require(studentsArr[i].ID != _ID, "Headman already exists!");
        }
        studentsArr[numStudents] = Students(numStudents, _Surname, _Group, 1, false);
        numStudents++;
    }

    function addNewHeadman(uint _ID, string memory _Surname, string memory _Group) public {
        require(msg.sender == admin, "You are not admin!");
        for(uint i = 0; i < numHeadmans; i++) {
            require(headmansArr[i].ID != _ID, "Headman already exists!");
        }
        headmansArr[numHeadmans] = Headman(numHeadmans, 0, _Surname, _Group, false);
        numHeadmans++;
    }

    function voted(uint _ID, string memory _Group) public {
        require(block.timestamp < VotedTime, "Voted is not started");
        for(uint i = 0; i < numStudents; i++) {
            require(studentsArr[i].statusVoted, "You are already voted!");
        }
        for(uint i = 0; i < numStudents; i++) {
            require(keccak256(abi.encodePacked(studentsArr[i].group)) == keccak256(abi.encodePacked(_Group)), "You are not this group!");
            for(uint j = 0; j < numHeadmans; j++) {
                require(keccak256(abi.encodePacked(headmansArr[i].group)) == keccak256(abi.encodePacked(_Group)), "You are not this group");
            }
        }
        
    }
}
