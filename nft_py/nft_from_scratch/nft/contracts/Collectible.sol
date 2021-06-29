pragma solidity 0.6.6;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@chainlink/contracts/src/v0.6/VRFConsumerBase.sol";

contract Collectible is ERC721, VRFConsumerBase {
    
    bytes32 internal keyHash;
    uint256 public fee;
    uint256 public tokenCounter;

    enum Specs{NGANYA, MINIVAN, BUS, BIKE}
    

    mapping(bytes32 => address) public requestIdToSender;
    mapping(bytes32 => string) public requestIdToTokenURI; 
    mapping(uint256 => Specs) public tokenIdToMatatuSpecs;
    mapping(bytes32 => uint256) public requestIdToTokenId;
    event requestedCollectible(bytes32 indexed requestId);
    
    constructor(address _VRFCoordinator, address _LinkToken, bytes32 _keyhash) public 
    
    VRFConsumerBase(_VRFCoordinator, _LinkToken)
    
    ERC721("Matatu", "CRYPTOMA3"){
        keyHash = _keyhash;
        fee= 0.1 * 10 ** 18;
        //track all tokens minted
        tokenCounter = 0;
    }

    function createMatatu(uint256 userProvidedSeed, string memory tokenURI) 
    public returns (bytes32){
        bytes32 requestId = requestRandomness(keyHash, fee, userProvidedSeed);
        requestIdToSender[requestId] = msg.sender;
        requestIdToTokenURI[requestId] = tokenURI;
        emit requestedCollectible(requestId);
    }

    function fulfillRandomness(bytes32 requestId, uint256 randomNumber) internal override {
        address matatuOwner = requestIdToSender[requestId];
        string memory tokenURI = requestIdToTokenURI[requestId];
        uint256 newItemId = tokenCounter;
        _safeMint(matatuOwner, newItemId);
        _setTokenURI(newItemId, tokenURI);
        Specs Matspecs = Specs(randomNumber % 3);
        tokenIdToMatatuSpecs[newItemId] = Matspecs;
        requestIdToTokenId[requestId] = newItemId;
        tokenCounter = tokenCounter + 1;
    }

    function setTokenURI(uint256 tokenId, string memory _tokenURI) public {
        require(
            _isApprovedOrOwner(_msgSender(), tokenId),
            "ERC721 transfer caller is not owner nor approved"
        );
        _setTokenURI(tokenId, _tokenURI);
    }
    
}