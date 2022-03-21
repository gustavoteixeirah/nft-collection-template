// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "./ERC721A.sol";

contract ChangeMe is Ownable, ERC721A, ReentrancyGuard {
    using Strings for uint256;
    using Address for address;

    string public nftBaseUri;
    bool public saleIsActive;
    bool public isMetadataLocked;

    uint256 public constant MAX_TOKEN_SUPPLY = ChangeMe;
    uint256 public constant MAX_MINT_QUANTITY = ChangeMe;

    address wallet1 = ChangeMe;
    address wallet2 = ChangeMe;
    address wallet3 = ChangeMe;

    constructor(string memory _initialBaseURI, bool _initialSaleStatus)
        ERC721A("ChangeMe", "ChangeMe")
    {
        nftBaseURI = _initialBaseURI;
        saleIsActive = _initialSaleStatus;
        isMetadataLocked = false;
    }

    modifier quantityIsOk(uint256 amount) {
        require(
            amount > 0 && amount <= MAX_MINT_QUANTITY,
            "Minting would exceed max purchase per transaction."
        );
        require(
            totalSupply() + amount <= MAX_TOKEN_SUPPLY,
            "Minting would exceed max supply."
        );
        _;
    }

    modifier saleActive() {
        require(saleIsActive, "Sale is not active.");
        _;
    }

    function flipSaleState() public onlyOwner {
        saleIsActive = !saleIsActive;
    }

    function mint(uint256 amount)
        public
        saleActive
        nonReentrant
        quantityIsOk(amount)
    {
        _safeMint(msg.sender, amount);
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return nftBaseUri;
    }

    function setBaseURI(string memory _newBaseURI) external onlyOwner {
        require(!isMetadataLocked, "Metadata is locked");
        nftBaseUri = _newBaseURI;
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );

        string memory base = _baseURI();

        return string(abi.encodePacked(base, tokenId.toString()));
    }

    function lockMetadata() external onlyOwner {
        isMetadataLocked = true;
    }

    function withdrawAll() external onlyOwner {
        uint256 currentBalance = address(this).balance;
        uint256 fivePercent = currentBalance.mul(5).div(100);

        require(payable(wallet2).send(fivePercent));
        require(payable(wallet3).send(fivePercent));
        require(payable(wallet1).send(address(this).balance));
    }
}
