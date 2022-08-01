// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.0;

import {DSTest} from "ds-test/test.sol";
import {Utilities} from "./utils/Utilities.sol";
import {console} from "./utils/Console.sol";
import {Vm} from "forge-std/Vm.sol";
import {stdCheats} from "forge-std/stdlib.sol";
import {CheeseTouch} from "../Contract.sol";
import "src/mocks/MockERC721.sol";

contract ContractTest is DSTest {
    // nft Id
    uint256 nftId;
    // initializes CheeseTouch contract
    CheeseTouch public cheeseTouch;
    // Access Hevm via the `vm` instance (an up-to-date cheatcodes interface that's imported above)
    Vm internal immutable vm = Vm(HEVM_ADDRESS);
    // allow you to create users
    Utilities internal utils;
    // allows you to send money to users and also defines users
    address payable[] internal users;
    // define URI
    string public _baseTokenURI; // Base token URI
    // define owner
    address public _owner;
    // declare deadline
    uint256 public deadline;
    // Counter for the number of tokens minted
    uint256 public counter;

    MockERC721 public mockNFT;

    struct Checkpoint {
        uint256 tokenId;
        uint256 lastTransfer;
        address owner;
    }

    mapping(uint256 => Checkpoint) public checkpoints;

    mapping(address => uint256) internal scores;

    mapping(uint256 => address) private _owners;

    mapping(address => uint256) private _balances;

    event Transfer(address indexed from, address indexed to, uint256 tokenId);

    ////////SETUP USERS, VALUES, INITIALIZE VARIABALES////////

    // setup method runs before every individual test
    function setUp() public {
        // initialize CheeseTouch contract, fill in test parameters from CheeseTouch constructor
        cheeseTouch = new CheeseTouch("TEST NFT", "NFT", "Testing");
        // For the base setUp function, we simply use the utils functions that came with the template already. They allow us to create 5 user addresses which hold Ether
        mockNFT = new MockERC721();
        utils = new Utilities();
        users = utils.createUsers(3);
        // initialize owner
        _owner = msg.sender;
        // initialize URI
        _baseTokenURI = "testing";
        // initialize deadline time
        deadline = 1 days; // Set the deadline for the game
        // Set first checkpoint
        checkpoints[counter] = Checkpoint(counter, block.timestamp, msg.sender);

        // Game is starting with the owner
        // _mint(msg.sender, counter); // Mints the token with tokenID '0'

        counter += 1; // Increment the counter to '1'
        
    }

    function testBaseURI (string memory _uri) public {
        _uri = _baseTokenURI;
        address bob = users[1];
        // ensure _uri equals _baseTokenURI
        assertEq(_uri, _baseTokenURI);

        // check if owner can setbaseURI or else error occurs
        vm.prank(bob);
        vm.expectRevert(bytes('Only the owner can do this'));
        cheeseTouch.setBaseTokenURI("test");
    }

    function testCannotMint () public {
        address bob = address(0);
        address bobby = users[1];

        // test with 0 address, expected error
        vm.prank(bob);
        vm.expectRevert(bytes("ERC721: mint to the zero address"));
        cheeseTouch.mint(bob, 2);

        // test with existing token, expected error
        cheeseTouch.mint(bobby, 2);
        vm.expectRevert(bytes("ERC721: token already minted"));
        cheeseTouch.mint(bob, 2);
    }
    
    function testCannotCreateCheese () public {
        counter += 1;

        vm.expectRevert(bytes("Cannot create cheese while the game is in progress"));
        cheeseTouch.createCheese();
    }

     function testCanBurnCheese () public {
        mockNFT.mint(1);

        mockNFT.burn(2);
        assertEq(_balances[address(this)], 0);
    }

    function testCannotBurnCheese () public {

        vm.expectRevert(bytes("Cannot create cheese while the game is in progress"));
        cheeseTouch.createCheese();
    }

    function testCanTransferToken () public {
        mockNFT.mint(1);
        address to = users[1];

		cheeseTouch.transferFrom(address(this), to, 0);
        assertEq(_balances[to], 0);
    }

    function testCannotTransferToken () public {
        address from = address(this);
        address to = users[1];
        vm.warp(2 days);

        vm.expectRevert(bytes("Cheese token can only be transferred within 24 hours after it transferred"));
        cheeseTouch.transferFrom(from, to, 0);
    }
}