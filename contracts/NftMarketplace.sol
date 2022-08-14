// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

error NftMarketplace__PriceMusBeAboveZero();
error NftMarketplace__NotApprovedForMarketplace();
error NftMarketplace__AlreadyListed(address nftAddress, uint256 tokenId);
error NftMarketplace__NotOwner();

contract NftMarketplace {
    //     1.Create a decentralized NFT marketplace
    // 1.1 list nfts on marketplace
    // 1.2 buyitem
    // 1.3 cancelitem
    // 1.4 updatelist
    // 1.5 withdrawpayment
    constructor() {}

    struct Listing {
        uint256 price;
        address seller;
    }

    event ItemListed(
        address indexed seller,
        address indexed nftAddress,
        uint256 indexed tokenId,
        uint256 price
    );
    //modifiers
    modifier notListed(
        address nftAddress,
        uint256 tokenId,
        address owner
    ) {
        Listing memory listing = s_listings[nftAddress][tokenId];
        if (listing.price > 0) {
            if (listing.price > 0) {
                revert NftMarketplace__AlreadyListed(nftAddress, tokenId);
            }
            _;
        }
    }
   
modifier isListed (address nftAddress, uint256 tokenId) {
    Listing memory listing=s_listings[nftAddress][tokenId];
}


    modifier isOwner(
        address nftAddress,
        uint256 tokenId,
        address spender
    ) {
        IERC721 nft = IERC721(nftAddress);
        address owner = nft.ownerOf(tokenId);
        if (spender != owner) {
            revert NftMarketplace__NotOwner();
        }
        _;
    }

    mapping(address => mapping(uint256 => Listing)) private s_listings;

    /*
@notice Method for listing your nfts on the marketplace
@param nftAddress: Address of the NFT
@param tokenId: The token ID of the NFT
@param price:
*/
    function listItem(
        address nftAddress,
        uint256 tokenId,
        uint256 price
        
    //challenge: have this contract accept payment in a subset of tokens as well
   //Hint: use Chainlink Price Feed to convert the price of the tokens between each other
    ) external notListed(nftAddress, tokenId, msg.sender) isOwner(nftAddress, tokenId, msg.sender) {
        if (price <= 0) {
            revert NftMarketplace__PriceMusBeAboveZero();
        }
        //Option 1. Send NFT to the contract Transfet -> "hold" the NFT
        //Option 2. Owners can still hold their NFT, and give the marketplace approval to sell the nft for them
        IERC721 nft = IERC721(nftAddress);
        if (nft.getApproved(tokenId) != address(this)) {
            revert NftMarketplace__NotApprovedForMarketplace();
        }
        s_listings[nftAddress][tokenId] = Listing(price, msg.sender);
        emit ItemListed(msg.sender, nftAddress, tokenId, price);
    }

    function buyItem(address nftAddress, uint256 tokenId) external payable{

    }  {
        
    }
}
