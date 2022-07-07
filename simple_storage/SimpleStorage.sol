// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

contract SimpleStorage {
    
    // variable defs
    uint256 favoriteNumber;

    // structure defs
    struct People {
        uint256 favoriteNumber;
        string name;
    }

    // Initialize empty array to store values
    People[] public people;
    
    // create a map to lookat a person's favorite number
    mapping(string=> uint256) public nameToFavoriteNumber;

    function store(uint256 _favoriteNumber) public {
        favoriteNumber = _favoriteNumber;
    }

    function retrieve() public view returns (uint256) {
        return favoriteNumber;
    }

    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        people.push(People(_favoriteNumber,_name));
        nameToFavoriteNumber[_name] = _favoriteNumber;
    }
}
