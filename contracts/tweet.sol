// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Twitter{

    uint16 public  MAX_TWEET_LENGTH = 285;

    struct Tweet {
        address author;
        string content;
        uint256 timestamp;
        uint256 likes;
    }
    mapping (address => Tweet[]) public tweets;
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner(){
        require(msg.sender == owner, "YOU ARE NOT OWNER");
        _;
    }

    function changeTweetLength(uint16 newLength) public onlyOwner {
        MAX_TWEET_LENGTH = newLength;
    }

    function getTweetLength() public view onlyOwner returns(uint16) {
        return MAX_TWEET_LENGTH;
    }

    function createTweets(string memory _tweet) public {
        require(bytes(_tweet).length <= MAX_TWEET_LENGTH, "Tweet length is too much long");

        Tweet memory newTweet = Tweet({
            author: msg.sender,
            content: _tweet,
            timestamp: block.timestamp,
            likes: 0
        });

        tweets[msg.sender].push(newTweet);
    }

    function hitLike(address _owner, uint _i) public {
        require(_i < tweets[_owner].length, "Invalid tweet index"); // Ensure the index is valid
        tweets[_owner][_i].likes += 1;
    }

    function getTweets(address _owner, uint _i) public view returns(Tweet memory) {
        return tweets[_owner][_i];
    }

    function getAllTweets(address _owner) public view returns(Tweet[] memory) {
        return tweets[_owner];
    }
}