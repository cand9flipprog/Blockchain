// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract SellApartment {
    struct Apartment {
        uint ID;
        uint square;
        uint lifetime;
        address owner;
    }

    struct ApartmentSales {
        uint ID;
        uint price;
        uint sellingPeriod;
        bool status;
        bool confirm;
        address buyer;
    }
 
    Apartment[] public apartmentArray;
    ApartmentSales[] public salesApartmentArray;

    address admin = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
    address owner;

    constructor() {
        require(msg.sender == admin);
        apartmentArray.push(Apartment(apartmentArray.length, 50, 7, 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2));
    }


    // Функция регистрации новой квартиры
    function registerNewApartment(uint _square, uint _lifetime, address _owner) public {
        require(msg.sender == admin, "You are not admin!");
        apartmentArray.push(Apartment(apartmentArray.length, _square, _lifetime, _owner));
    }

    // Функция создания предложения на продажу
    function createOffer(uint _apartmentID, uint _price, uint _sellingPeriod) public {
        require(apartmentArray[_apartmentID].owner == msg.sender, "You are not the owner of this apartment!");
        require(!salesApartmentArray[_apartmentID].status, "The apartment is already on sale!");

        salesApartmentArray[_apartmentID] = ApartmentSales(_apartmentID, _price, _sellingPeriod, true, false, address(0));
    }

    // Функция отмены продажи
    function cancelOffer(uint _ID) public {
        require(msg.sender == apartmentArray[_ID].owner, "You are not owner!");
        require(salesApartmentArray[_ID].status, "This apartment is not sale!");

        salesApartmentArray[_ID].status = false;
        salesApartmentArray[_ID].confirm = false;
        salesApartmentArray[_ID].buyer = address(0);
    }

    // Функция подтверждения продажи
    function confirmOffer(uint _ID) public payable {
        require(salesApartmentArray[_ID].status, "The apartment is not sale!");
        require(!salesApartmentArray[_ID].confirm, "The purchase has already been confirmed!");
        require(msg.value == salesApartmentArray[_ID].price, "Invalid payment amount!");

        salesApartmentArray[_ID].status = true;
        salesApartmentArray[_ID].buyer = msg.sender;
    }

    // Функция подтверждения перевода денежных средств
    function buyApartment(uint _ID) public payable {
        require(salesApartmentArray[_ID].status, "The apartment is not sale!");
        require(salesApartmentArray[_ID].confirm, "The purchase has not been confirm!");

        address payable seller = payable(apartmentArray[_ID].owner);
        seller.transfer(salesApartmentArray[_ID].price);

        apartmentArray[_ID].owner = salesApartmentArray[_ID].buyer;
        salesApartmentArray[_ID].status = false;
        salesApartmentArray[_ID].buyer = address(0);
    }
}
