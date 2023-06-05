// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract PaintingCar {
    struct Car {
        address owner;
        bool status;
        uint price;
    }
    struct Masters {
        uint ID;
        address master;
    }

    Car[] public carsArray;
    Masters[] public mastersArray;

    constructor() {
        carsArray.push(Car(0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2, false, 0));
        mastersArray.push(Masters(mastersArray.length, 0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB));
    }

    function paintingCar(uint _ID, address _Master) public payable {
        require(carsArray[_ID].owner == msg.sender, "You are not owner this car!");
        require(_ID < carsArray.length, "Not found car!");
        require(!carsArray[_ID].status, "This car already paiting!");

        carsArray[_ID].status = true;

        address payable masterAddress = payable(_Master);
        masterAddress.transfer(carsArray[_ID].price * 10**18);
    }

    function calcPrice(uint _ID, address _Master, uint _Price) public {
        require(msg.sender == _Master, "You are not master!");
        carsArray[_ID].price = _Price;
    }

    function addNewMaster(address _Master) public {
        require(msg.sender == 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, "You are not admin!");
        mastersArray.push(Masters(mastersArray.length, _Master));
    }

    function newCar(address _owner) public {
        require(msg.sender == 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, "You are not admin!");
        carsArray.push(Car(_owner, false, 0));
    }
}