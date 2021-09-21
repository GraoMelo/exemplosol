pragma solidity ^0.5.0;


// This is the part of the ERC20 interface we're using.
contract IERC20 {
  //that method no good pratic.
  function transfer(address to, uint256 value) external view returns(bool);
  //size of the valeu most information 
}


contract Auction { //the encapsulation not ood
  address payable public seller; 

  IERC20 public prizeToken;
  uint256 public prizeAmount;

  uint256 public auctionEnd; // timestamp

  address payable public highBidder;
  uint256 public highBid;


  constructor(IERC20 _prizeToken, uint256 _prizeAmount) public {
    seller = msg.sender; //

    // We're auctioning off tokens.
    prizeToken = _prizeToken; 
    prizeAmount = _prizeAmount; 

    // All auctions last 24 hours.
    auctionEnd = now + 24 hours; 
		//timestamp format error. 
  }


  function placeBid(uint256 bid) external payable {
    require(now < auctionEnd, "Auction is over.");
    require(bid > highBid, "Bid too low.");

    require(msg.value == bid * prizeAmount, "Wrong ether amount.");

    highBidder.transfer(highBid * prizeAmount);

    // Record new high bidder and their bid.
    highBidder = msg.sender;
    highBid = bid;
  }


  function settleAuction() external {
    require(now >= auctionEnd, "Auction is still running.");

    // Transfer collected ether to the seller.
    seller.transfer(highBid * prizeAmount);

    // Transfer prize to the high bidder.
    require(prizeToken.transfer(highBidder, prizeAmount));
  }
}
