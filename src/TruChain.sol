// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Counters} from "openzeppelin/utils/Counters.sol";

// Layout of Contract:
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// view & pure functions

contract TruChain {
    using Counters for Counters.Counter;

    // Type declarations
    struct Product {
        string modelNumber;
        string partNumber;
        string serialNumber;
        address productOwner;
        uint256 price;
        uint256 mfgTimeStamp;
    }

    struct Participant {
        string participantType;
        address participantAddress;
        string username;
        string password;
    }

    struct Registration {
        uint256 productId;
        uint256 ownerId;
        address productOwner;
        uint256 txTimeStamp;
    }

    // State variables
    Counters.Counter public s_productIdCounter; // Product ID
    Counters.Counter public s_participantIdCounter; // Participant ID
    Counters.Counter public s_registrationIdCounter; // Registration ID
    mapping(uint256 => Product) public s_products;
    mapping(uint256 => Participant) public s_participants;
    mapping(uint256 => Registration) public s_registrations;
    mapping(uint256 => uint256[]) public s_productChain; // Proeuct ID => Registration IDs

    // Events
    event TransferProduct(
        uint256 indexed productId,
        address indexed from,
        address indexed to
    );

    // Modifiers
    modifier onlyProductOwner(uint256 _productId) {
        require(
            msg.sender == s_products[_productId].productOwner,
            "Only product owner can call this function."
        );
        _;
    }

    modifier onlyManufacturer(uint256 _participantId) {
        require(
            keccak256(
                abi.encodePacked(s_participants[_participantId].participantType)
            ) == keccak256("Manufacturer"),
            "Only the product manufacturer can create its own products."
        );
        _;
    }

    // Functions
    constructor() {}

    function createProduct(
        uint256 _ownerId,
        string memory _modelNo,
        string memory _partNo,
        string memory _serialNo,
        uint256 _cost
    ) public onlyManufacturer(_ownerId) returns (uint256) {
        // Create product with new ID
        Counters.increment(s_productIdCounter);
        uint256 uid = Counters.current(s_productIdCounter);
        Product memory p = Product(
            _modelNo,
            _partNo,
            _serialNo,
            s_participants[_ownerId].participantAddress,
            _cost,
            block.timestamp
        );
        // Update state and return ID
        s_products[uid] = p;
        return uid;
    }

    function createParticipant(
        string memory _type,
        address _address,
        string memory _username,
        string memory _password
    ) public returns (uint256) {
        // Create participant with new ID
        Counters.increment(s_participantIdCounter);
        uint256 uid = Counters.current(s_participantIdCounter);
        Participant memory p = Participant(
            _type,
            _address,
            _username,
            _password
        );
        // Update state and return ID
        s_participants[uid] = p;
        return uid;
    }

    function transferProduct(
        uint256 _productId,
        uint256 _participantIdFrom,
        uint256 _participantIdTo
    ) public onlyProductOwner(_productId) returns (uint256) {
        (, address from, ) = getParticipant(_participantIdFrom);
        (, address to, ) = getParticipant(_participantIdTo);
        // Create registration with new ID
        Counters.increment(s_registrationIdCounter);
        uint256 rid = Counters.current(s_registrationIdCounter);
        Registration memory r = Registration(
            _productId,
            _participantIdFrom,
            to,
            block.timestamp
        );
        // Update state
        s_registrations[rid] = r;
        s_productChain[_productId].push(rid);

        // Make transfer
        s_products[_productId].productOwner = to;
        emit TransferProduct(_productId, from, to);

        // Return registration ID
        return rid;
    }

    // View/Pure Functions

    function getProduct(
        uint256 _productId
    ) public view returns (Product memory) {
        return s_products[_productId];
    }

    function getProductChain(
        uint256 _productId
    ) public view returns (uint256[] memory) {
        return s_productChain[_productId];
    }

    function getParticipant(
        uint256 _participantId
    ) public view returns (string memory, address, string memory) {
        Participant memory p = s_participants[_participantId];
        // Ignore the password
        return (p.participantType, p.participantAddress, p.username);
    }

    function getRegistration(
        uint256 _rid
    ) public view returns (Registration memory) {
        return s_registrations[_rid];
    }
}
