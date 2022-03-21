// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Allowlist is Ownable {
    bool public allowlistIsActive = false;

    mapping(address => bool) _allowlist;

    function isAllowed(address _address) public view returns (bool) {
        return _allowlist[_address];
    }

    modifier onlyAllowed() {
        require(isAllowed(msg.sender), "Msg.sender is not allowed.");
        _;
    }

    modifier allowlistIsActive() {
        require(allowlistIsActive, "Allowlist is not active yet.");
        _;
    }

    function flipAllowlistState() external onlyOwner {
        allowlistIsActive = !allowlistIsActive;
    }

    function addToAllowlistt(address[] memory _addresses) external onlyOwner {
        for (uint256 i = 0; i < _addresses.length; i++) {
            require(_addresses[i] != address(0), "Can't add the null address.");
            _allowlist[addresses[i]] = true;
        }
    }

    function removeFromAllowlist(address[] calldata _addresses)
        external
        onlyOwner
    {
        for (uint256 i = 0; i < _addresses.length; i++) {
            _allowlist[_addresses[i]] = false;
        }
    }
}
