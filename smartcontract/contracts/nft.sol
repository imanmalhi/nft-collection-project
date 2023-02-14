// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./nftWhitelist.sol";

contract nft is ERC721Enumerable, Ownable {
    string _baseTokenURI;

    // _price is the price of one NFT
    uint256 public _price = 0.01 ether;

    // _paused is used to pause the conract in case of an emergency
    bool public _paused;

    // max number of nfts
    uint256 public maxTokenIds = 50;

    // total nuumber of nfts (tokenIds) minted
    uint256 public tokenIds;

    // Whitelist contract instance
    nftWhitelist whitelist;

    // boolean to keep track of whether the presale started or not
    bool public presaleStarted;

    // timestamp for when the presale would end
    uint256 public presaleEnded;

    modifier onlyWhenNotPaused {
        require (!_paused, "Contract currently paused.");
        _;
    }

    // ERC721 constructor takes in a "name" and a "symbol" to the token collection
    // Constructor takes in the baseURI to set _baseTokenURI for the collection. It also initializes an instance of the whitelist interface
    constructor (string memory baseURI, address whitelistContract) ERC721("Iman NFT", "INFT") {
        _baseTokenURI = baseURI;
        whitelist = nftWhitelist(whitelistContract);
    }

    // startPresale starts a presale for the whitelisted addresses
    function startPresale() public onlyOwner {
        presaleStarted = true;
        presaleEnded = block.timestamp + 30 minutes;
    }

    // presaleMint allows a user to mint one NFT per transaction during the presale
    function presaleMint() public payable onlyWhenNotPaused {
        require (presaleStarted && block.timestamp < presaleEnded, "Pre-sale is not active.");
        require (whitelist.whitelistAddresses(msg.sender), "You are not whitelisted.");
        require (tokenIds < maxTokenIds, "Exceeded maximum NFT supply.");
        require (msg.value >= _price, "Ether sent is not correct.");

        tokenIds += 1;

        _safeMint(msg.sender, tokenIds);
    }

    // _baseURI overrides the OZ ERC721 implementation which returned an empty sting for the baseURI
    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    // setPaused makes the contract paused or unpaused
    function setPaused(bool value) public onlyOwner {
        _paused = value;
    }

    // withdraw sends all the ether in the contract to the owner of the contract
    function withdraw() public onlyOwner {
        address _owner = owner();
        uint256 amount = address(this).balance;
        (bool sent, ) =  _owner.call{value: amount}("");
        require (sent, "Failed to send Ether.");
    }

    // function to receive Ether. msg.data must be empty
    receive() external payable {}

    // fallback function is called when msg.data is not empty
    fallback() external payable {}
}
