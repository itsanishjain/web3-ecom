// SPDX-License-Identifier: Apache 2.0
pragma solidity ^0.8.0;

// to get pricefeed of ETH AND USD
import "https://github.com/smartcontractkit/chainlink/blob/develop/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";


contract Paypal { 

    // Kovan Address: 0x9326BFA02ADD2366b30bacB125260Af641031331
    // Rinkeby Address:  0x8A753747A1Fa494EC906cE90E9f37563A8AF630e
    AggregatorV3Interface internal priceFeed;
    constructor() {
        priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
    }

    struct seller{
        uint amount;
        address sellerAddress;
    }

    // who sends us funds mapping
    mapping(address => seller) public senderToSeller;

    function getEthInUSD() public view returns(uint) {
        (,int price,,,) = priceFeed.latestRoundData();
        /*
        we have this wei and gwei terms because in solidity  we don't have concept of decimals
        this price which we got from chainlink api is have 8 decimal place means
        */
        // so we just convert 8 decimal price into 18 decimal 
        // 1ETH = 10**9 Gwei  = 10**18 Wei
        return uint(price * 10**10);
    }

    // 10**18 wei if we send 1 ETH == 10**18
    function convertionRate(uint msgValue) public view returns(uint){
        uint ethPriceInUSD = getEthInUSD();
        uint ethAmountInUSD = (msgValue * ethPriceInUSD);
        return ethAmountInUSD / 10**18;
        
     }

    // this function recives the funds from other address and added to contract adddress
    // payable is use to add funds to your contract
    // adding payable modifier when we want to add ETH to our smart contract means when want to 
    // except sometime of payments
    function pay() public payable  {
        uint minimumUSD = 50 * 10**18; // 50$ USD in Wei terms
        // getEthInUSD returns price of 1 ETh in $
        // uint valueInUSD =  getEthInUSD() * msg.value;
        uint ethAmountInUSD = convertionRate(msg.value);
        require(ethAmountInUSD >=minimumUSD,"Please sends 50$ or more then 50$");
        senderToSeller[msg.sender].amount += msg.value;
        // as I am now I am the only the seller in this website 
        // but in more complex one where other can be seller as well we need to think here
        senderToSeller[msg.sender].sellerAddress = msg.sender;
    }

  

    // transfer is to send funds from YOUR smart contract address to recipient address
    function sendToBob(address payable _bobAddress,uint amoutInWei) public {
        _bobAddress.transfer(amoutInWei);
        senderToSeller[msg.sender].amount -= amoutInWei;
    }
    
}
