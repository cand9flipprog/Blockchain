// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Voting {
    struct Headman {
        uint ID;
        uint votedNumber;
        string surname;
        string group;
    }

    struct Students {
        uint ID;
        address student;
        string surname;
        string group;
        bool statusVoted;
    }

    mapping(uint => Headman) public headmansArr;
    mapping(address => Students) public studentsMapping;

    uint public numHeadmans = 0;
    uint public timeVoted = 0;

    bool public votingStarted = false;

    address admin = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;

    constructor() {
        studentsMapping[0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2] = Students(0, 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2, "Ivanov", "KSK", false);
        studentsMapping[0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db] = Students(1, 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db, "Petrov", "KSK", false);
        studentsMapping[0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB] = Students(2, 0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB, "Lipatov", "ISIP", false);
        studentsMapping[0x617F2E2fD72FD9D5503197092aC168c91465E7f2] = Students(3, 0x617F2E2fD72FD9D5503197092aC168c91465E7f2, "Semenov", "ISIP", false);
    }

    function addNewStudent(uint _ID, address _student, string memory _surname, string memory _group) public {
        require(msg.sender == admin, "You are not admin");
        require(studentsMapping[_student].ID != _ID, "Headman already exists!");
        studentsMapping[_student] = Students(_ID, _student, _surname, _group, false);
    }

    function addNewHeadman(uint _ID, string memory _surname, string memory _group) public {
        require(msg.sender == admin, "You are not admin!");
        require(headmansArr[_ID].ID != _ID, "Headman already exists!");
        headmansArr[_ID] = Headman(_ID, 0, _surname, _group);
        numHeadmans++;
    }

    function startVoted() public {
        require(msg.sender == admin, "You are not admin!");
        require(!votingStarted, "Voting has already started!");
        timeVoted = block.timestamp + 5 minutes; 
        votingStarted = true;
    }

    function vote(address _student, uint _headmanID) public {
        require(votingStarted, "Voting has not started yet");
        require(block.timestamp <= timeVoted, "The voting period is over");
        require(!studentsMapping[_student].statusVoted, "You already voted");
        require(studentsMapping[_student].student == msg.sender, "You are not owner this account");
        require(keccak256(abi.encodePacked(studentsMapping[_student].group)) == keccak256(abi.encodePacked(headmansArr[_headmanID].group)), "You are not in the same group");

        studentsMapping[_student].statusVoted = true;
        headmansArr[_headmanID].votedNumber++;
    }

    function getVotingResult() public view returns (string memory) {
        require(votingStarted, "Voting has not started yet");
        require(block.timestamp >= timeVoted, "Voting is still going on");

        uint maxVotes = 0;
        uint winnerHeadman;

        for (uint i = 0; i < numHeadmans; i++) {
            if (headmansArr[i].votedNumber > maxVotes) {
                maxVotes = headmansArr[i].votedNumber;
                winnerHeadman = i;
            }
        }

        return string(abi.encodePacked("Winner headman - ", headmansArr[winnerHeadman]));
    }
