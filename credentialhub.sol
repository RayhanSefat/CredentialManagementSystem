pragma solidity ^0.8.0;

import "./ownable.sol";

contract CredentialHub is Ownable {

    mapping (address => address[]) trustedNodes;

    struct Credential {
        address issuer;
        address holder;
        uint content;
        uint signatureOfIssuer;
    }

    function addTrustedNode(address _trusted) external {
        trustedNodes[msg.sender].push(_trusted);
    }

    function verifyTrust(address _node) external view returns (bool) {
        return isNodeReachable(msg.sender, _node, new address[](0));
    }

    function isNodeReachable(address _currentNode, address _targetNode, address[] memory _visitedNodes) internal view returns (bool) {
        address[] memory directlyTrustedNodes = trustedNodes[_currentNode];
        for (uint i = 0; i < directlyTrustedNodes.length; i++) {
            if (directlyTrustedNodes[i] == _targetNode) {
                return true;
            }
        }

        for (uint i = 0; i < directlyTrustedNodes.length; i++) {
            address nextNode = directlyTrustedNodes[i];
            bool alreadyVisited = false;
            for (uint j = 0; j < _visitedNodes.length; j++) {
                if (_visitedNodes[j] == nextNode) {
                    alreadyVisited = true;
                    break;
                }
            }
            if (!alreadyVisited) {
                address[] memory newVisitedNodes = new address[](_visitedNodes.length + 1);
                for (uint j = 0; j < _visitedNodes.length; j++) {
                    newVisitedNodes[j] = _visitedNodes[j];
                }
                newVisitedNodes[_visitedNodes.length] = _currentNode;

                if (isNodeReachable(nextNode, _targetNode, newVisitedNodes)) {
                    return true;
                }
            }
        }

        return false;
    }
}
