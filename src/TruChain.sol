// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

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
        uint32 productId;
        uint32 ownerId;
        address productOwner;
        uint256 txTimeStamp;
    }

    // State variables
    uint32 private s_productIdCounter = 0; // Product ID
    uint32 private s_participantIdCounter = 0; // Participant ID
    uint32 private s_registrationIdCounter = 0; // Registration ID
    mapping(uint32 => Product) public s_products;
    mapping(uint32 => Participant) public s_participants;
    mapping(uint32 => Registration) public s_registrations;
    mapping(uint32 => uint32[]) public s_productChain; // Proeuct ID => Registration IDs

    // Events
    event TransferProduct(
        uint32 indexed productId,
        address indexed from,
        address indexed to
    );

    // Modifiers
    modifier onlyProductOwner(uint32 _productId) {
        require(
            msg.sender == s_products[_productId].productOwner,
            "Only product owner can call this function."
        );
        _;
    }

    modifier onlyManufacturer(uint32 _participantId) {
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
        uint32 _ownerId,
        string memory _modelNo,
        string memory _partNo,
        string memory _serialNo,
        uint256 _cost
    ) public onlyManufacturer(_ownerId) returns (uint32) {
        uint32 uid = s_productIdCounter++;
        Product memory p = Product(
            _modelNo,
            _partNo,
            _serialNo,
            s_participants[_ownerId].participantAddress,
            _cost,
            block.timestamp
        );
        s_products[uid] = p;
        return uid;
    }

    function createParticipant(
        string memory _type,
        address _address,
        string memory _username,
        string memory _password
    ) public returns (uint32) {
        uint32 uid = s_participantIdCounter++;
        Participant memory p = Participant(
            _type,
            _address,
            _username,
            _password
        );
        s_participants[uid] = p;
        return uid;
    }

    function transferProduct(
        uint32 _productId,
        uint32 _participantIdFrom,
        uint32 _participantIdTo
    ) public onlyProductOwner(_productId) {
        (, address from, ) = getParticipant(_participantIdFrom);
        (, address to, ) = getParticipant(_participantIdTo);
        // Create registration
        uint32 rid = s_registrationIdCounter++;
        Registration memory r = Registration(
            _productId,
            _participantIdFrom,
            to,
            block.timestamp
        );
        s_registrations[rid] = r;
        s_productChain[_productId].push(rid);

        // Make transfer
        s_products[_productId].productOwner = to;
        emit TransferProduct(_productId, from, to);
    }

    // View/Pure Functions

    function getProduct(
        uint32 _productId
    ) public view returns (Product memory) {
        return s_products[_productId];
    }

    function getProductChain(
        uint32 _productId
    ) public view returns (uint32[] memory) {
        return s_productChain[_productId];
    }

    function getParticipant(
        uint32 _participantId
    ) public view returns (string memory, address, string memory) {
        Participant memory p = s_participants[_participantId];
        // Ignore the password
        return (p.participantType, p.participantAddress, p.username);
    }

    function getRegistration(
        uint32 _rid
    ) public view returns (Registration memory) {
        return s_registrations[_rid];
    }
}
