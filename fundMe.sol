// SPDX-License-Identifier: MIT

// Make a chailink get call https://docs.chain.link/docs/make-a-http-get-request/

pragma solidity >=0.6.6 <0.7.0;

// Importing an interface 
// Note: interfaces compile down to an ABI (Application Binary Interface)
// ABI tells solidity and other programming languages how it can interact with another contract
// Anytime, you interact with an already deployed contract you will need an ABI
// Interface compiles down to ABI
import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";


// This contract will accept some type of payment 
// Note: everything on etherem is computed in the Wei currency. smallest unit of measure on ethereum

contract FundMe {
    // mapping of address and values. this will be used to record who sent how much money
    mapping(address => uint256) public  addresstoAmountFunded;
    address[] public funders;
    address public owner;
    
    constructor() public {
        owner = msg.sender;
    }

    // when function is defined as "payable", it means, it can be used to pay for things.
    // fund function will be red on remix becuase its a payable function 
    function fund() public payable {
        // This is the minimum amount of funds that can be sent
         uint256 minimumUSD = 50 * 10 ** 18;
         require(getConversionRate(msg.value) >= minimumUSD,"You need to send more ETH :(");
         addresstoAmountFunded[msg.sender] += msg.value;
         funders.push(msg.sender);
        // how to get the conversion rates for smart contracts 
        // what the ETH to US conversion rate is?   
    }

    function getVersion() public view returns(uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        return priceFeed.version();
    }
    
    function getPrice() public view returns(uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);

        // Below is an example of tuple
        // function latestRoundData outputs roundId, answer,startedAt,UpdatedAt, answeredInRound
        // We only care about returning the answer. 
        // Since we have a lot of unused varialbes 
        (,int256 answer, , ,) = priceFeed.latestRoundData();
        return uint256(answer*10000000000);
    }
    // all the units in solidity are in wei. 
    function getConversionRate(uint256 ethAmount) public view returns(uint256) {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) /1000000000000000000;
        return ethAmountInUsd;
    }

    // check this in the function and run the rest of the code where _; is
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function withdraw() payable onlyOwner public {
        msg.sender.transfer(address(this).balance);

        for (uint256 funderIndex=0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addresstoAmountFunded[funder] = 0;
        } 
        funders = new address[](0);
    }
}
