// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract Marketplace is ERC721URIStorage, AccessControl {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    enum Auction {
        dutch,
        english,
        min_price,
        drop,
        lottery,
        free_spin
    }

    struct Listing {
        address seller;
        uint256 price;
        Auction auctionType;
    }

    IERC721 public nftContract;
    mapping(uint256 => Listing) public listings;

    event NFTListed(uint256 indexed tokenId, uint256 price, Auction auctionType);
    event NFTBought(uint256 indexed tokenId, address buyer);

    constructor(address _nftContract) ERC721("MyNFT", "MNFT") {
        nftContract = IERC721(_nftContract);
        _setupRole(MINTER_ROLE, msg.sender);
    }

    modifier onlyOwnerOf(uint256 tokenId) {
        require(nftContract.ownerOf(tokenId) == msg.sender, "You must own the NFT to list it for sale");
        _;
    }

    function isAuctionType(uint auctionType) internal pure returns (bool) {
        return auctionType == uint(Auction.dutch) || auctionType == uint(Auction.english) || auctionType == uint(Auction.min_price) || auctionType == uint(Auction.drop) || auctionType == uint(Auction.lottery) || auctionType == uint(Auction.free_spin);
    }

    function listNFT(uint256 tokenId, uint256 price, Auction auctionType) public onlyOwnerOf(tokenId) {
        require(isAuctionType(uint(auctionType)), "Invalid auction type");
        nftContract.approve(address(this), tokenId);
        listings[tokenId] = Listing(msg.sender, price, auctionType);
        emit NFTListed(tokenId, price, auctionType);
    }

    function buyNFT(uint256 tokenId) public payable {
        Listing memory listing = listings[tokenId];
        require(msg.value >= listing.price, "The price is too low");
        payable(listing.seller).transfer(listing.price);
        nftContract.safeTransferFrom(listing.seller, msg.sender, tokenId);
        delete listings[tokenId];
        emit NFTBought(tokenId, msg.sender);
    }

    function mintNFT(address recipient, string memory tokenURI) public {
        require(hasRole(MINTER_ROLE, msg.sender), "Caller is not a minter");
        uint256 newTokenId = totalSupply() + 1;
        _mint(recipient, newTokenId);
        _setTokenURI(newTokenId, tokenURI);
    }
}