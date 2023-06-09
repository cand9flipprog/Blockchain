// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

    contract PaintingCar {

    struct Car {
        address payable owner;
        bool status;
        uint price;
    }
    
    struct Masters {
        uint ID;
        address payable master;
    }

    mapping(uint => Car) public cars;
    mapping(uint => Masters) public masters;
    uint public numCars = 0;
    uint public numMasters = 0;
    address public admin = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;

    constructor() {
        cars[numCars] = Car(payable(0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2), false, 0);
        masters[numMasters] = Masters(numMasters, payable(0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db));
        numCars++;
        numMasters++;
    }
    
    function paintingCar(uint _ID, uint _MasterID) public payable {
        require(_ID < numCars, "Car not found!");
        require(cars[_ID].owner == msg.sender, "You are not the owner of this car!");
        require(!cars[_ID].status, "This car is already being painted!");
        require(masters[_MasterID].master != address(0), "Master not found!");
        require(cars[_ID].price <= msg.value, "Insufficient payment to start painting!");

        cars[_ID].status = true;
        masters[_MasterID].master.transfer(cars[_ID].price * 10**18);
        cars[_ID].owner.transfer(msg.value - cars[_ID].price * 10**18);
    }

    function cancelPaintingCar(uint _ID) public {
        require(msg.sender == cars[_ID].owner, "You are not the owner of this car!");
        require(cars[_ID].status, "This car is not being painted!");

        cars[_ID].status = false;
    }

    function calcPrice(uint _ID, uint _MasterID, uint _Price) public {
        require(masters[_MasterID].master == msg.sender, "You are not a master!");
        require(_ID <= numCars, "Car not found!");

        cars[_ID].price = _Price;
    }

    function addNewMaster(address payable _Master) public {
        require(msg.sender == admin, "You are not an admin!");
        require(_Master != address(0), "Invalid master address!");
        for (uint i = 0; i < numMasters; i++) {
            require(masters[i].master != _Master, "Master already exists!");
        }
        masters[numMasters] = Masters(numMasters, _Master);
        numMasters++;
    }

    function newCar(address payable _owner) public {
        require(msg.sender == admin, "You are not an admin!");
        require(_owner != address(0), "Invalid owner address!");

        cars[numCars] = Car(_owner, false, 0);
        numCars++;
    }

}
