pragma solidity ^0.8.0;

import "./ownable.sol";

contract CredentialHub is Ownable {
    struct Credential {
        address issuer;
        address holder;
        uint content;
        uint signatureOfIssuer;
    }

    
}
