# NGMI NFT Game

The NGMI only allows 1 token to be “live” at any time. If no token is live, anyone can mint one at any time. 

Players can then transfer this live token to anyone else. Once this token reaches 24 hours of being live, that token “dies” and the player who still holds it can no longer transfer it to anyone else.

Using OpenZeppelin's ERC721, ERC721Enumerable contracts, the NGMI contract consists of `_baseURI()`, `setBaseTokenURI(string memory _uri)`, `createNGMI()`, `mint(address to, uint256 tokenId`, `_burn(uint256 tokenId)`, and custom transfer hooks such as `_beforeTokenTransfer(address from, address to, uint256 tokenId)` and `_afterTokenTransfer(address from, address to, uint256 tokenId)`.

Contract and tests are done with Foundry.

[Contract Source](src/ngmi.sol) • [Contract Test](src/test/ngmi.t.sol)
