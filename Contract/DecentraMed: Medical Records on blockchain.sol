// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title DecentraMed: Medical Records on Blockchain
 * @dev A decentralized system for storing and accessing patient medical records securely.
 */
contract DecentraMed {
    address public owner;

    struct Record {
        string patientName;
        string diagnosis;
        string treatment;
        uint256 timestamp;
    }

    mapping(address => Record[]) private patientRecords;
    mapping(address => bool) public authorizedDoctors;

    event RecordAdded(address indexed patient, string diagnosis, uint256 timestamp);
    event DoctorAuthorized(address indexed doctor, bool status);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    modifier onlyAuthorizedDoctor() {
        require(authorizedDoctors[msg.sender], "Not an authorized doctor");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /**
     * @dev Authorize or revoke doctor access.
     * @param _doctor The doctor’s Ethereum address.
     * @param _status True to authorize, False to revoke.
     */
    function authorizeDoctor(address _doctor, bool _status) public onlyOwner {
        authorizedDoctors[_doctor] = _status;
        emit DoctorAuthorized(_doctor, _status);
    }

    /**
     * @dev Add a medical record for a patient (only authorized doctors can do this).
     * @param _patient Address of the patient.
     * @param _name Patient's name.
     * @param _diagnosis Diagnosis details.
     * @param _treatment Treatment details.
     */
    function addRecord(
        address _patient,
        string memory _name,
        string memory _diagnosis,
        string memory _treatment
    ) public onlyAuthorizedDoctor {
        patientRecords[_patient].push(
            Record(_name, _diagnosis, _treatment, block.timestamp)
        );
        emit RecordAdded(_patient, _diagnosis, block.timestamp);
    }

    /**
     * @dev Retrieve all medical records for a patient.
     * @return An array of records belonging to the caller (patient).
     */
    function getMyRecords() public view returns (Record[] memory) {
        return patientRecords[msg.sender];
    }
}

