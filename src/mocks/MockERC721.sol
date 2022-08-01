//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

// ERC721 Enumarable Extension Contract
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

// Creating a mock contract of ERC721 becuase _mint function is internal
contract MockERC721 is ERC721("TEST", "TST") {
    string baseURI = "Testing";
    // Expose external mint function 
    function mint(uint256 counter) external {
        _mint(msg.sender, counter);
    }

    function tokenURI(uint256) public view override returns (string memory) {
        return baseURI;
    }

    function burn(uint256 counter) external {
        _burn(counter - 1);
    }
}