// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Twitter{

    uint16 public  MAX_TWEET_LENGTH = 285;

    struct Tweet {
        uint256 id;
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

    event TweetCreated(uint256 id, address author, string content, uint256 timestamp);
    event TweetLike(address liker, address tweetAuthor, uint256 tweetId, uint256 newLikesCount);
    event TweetUnlike(address unLiker, address tweetAuthor, uint256 tweetId, uint256 newLikesCount);

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
            id: tweets[msg.sender].length,
            author: msg.sender,
            content: _tweet,
            timestamp: block.timestamp,
            likes: 0
        });

        tweets[msg.sender].push(newTweet);

        emit TweetCreated(newTweet.id, newTweet.author, newTweet.content, newTweet.timestamp);
    }

    function likeTweet(address author, uint256 id) external {
        require (tweets[author][id].id == id, "TWEET NOT FOUND");
        tweets[author][id].likes++;

        emit TweetLike(msg.sender, author, id, tweets[author][id].likes);
    }

    function disLikeTweet(address author, uint256 id) external {
        require (tweets[author][id].id == id, "TWEET NOT FOUND");
        require (tweets[author][id].likes > 0, "NO LIKES");
        tweets[author][id].likes--;

        emit TweetUnlike(msg.sender, author, id, tweets[author][id].likes);
    }

    function getTweets(address _owner, uint _i) public view returns(Tweet memory) {
        return tweets[_owner][_i];
    }

    function getAllTweets(address _owner) public view returns(Tweet[] memory) {
        return tweets[_owner];
    }
}