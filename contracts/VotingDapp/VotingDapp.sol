pragma solidity ^0.4.11;

import '../lib/SafeMath.sol';

contract VotingDapp {
  
  using SafeMath for uint256;

  struct Poll {
    bytes32 pollID;
    string question;
    address createdBy;
    mapping (bytes32 => uint256) options;
    uint256 createdAt;
    PollType pollType;
    uint256 endDate;
    bytes secret;
    mapping (address => Voter) voters;
    bytes32 winningOption;
    bool hasEnded;
    uint256 cost;
  }

  struct Voter {
    bool hasVoted;
    bool isApproved;
  }

  struct Option {
    bytes32 text;
    uint256 votes;
  }

  mapping (bytes32 => Poll) public polls;

  enum PollType { Anyone, Approved, Secret }

  //TODO 
  function VotingDapp() {
  }

  //TODO payable
  function createPoll(
    PollType _pollType,
    uint256 _endDate,
    bytes32[] _options,
    address[] _voters,
    bytes _secret
  ) external returns (bool) 
  {
    address _createdBy = msg.sender;
    uint256 _createdAt = block.timestamp;
    require(_endDate <= _createdAt + 1 years);
    uint _pollTypeUint = uint(PollType(_pollType));
    bytes32 _pollID = keccak256(_createdBy, _endDate, _createdAt, _pollTypeUint);	// uniqueID that will be bytes32
    polls[_pollID].pollID = _pollID;
    polls[_pollID].createdAt = _createdAt;
    polls[_pollID].createdBy = _createdBy;
    polls[_pollID].pollType = _pollType;
    polls[_pollID].endDate = _endDate;
    polls[_pollID].secret = _secret;
    for (uint i = 0; i < _options.length; i++) {
      polls[_pollID].options[_options[i]] = 0;
    }
    // Loop through provided voters and mark them boolean in approvedVoters mapping
    // TODO determine max approvedVoters length that will be under block gas limit + whatever other gas is consumed by this function
    for (uint256 j = 0; j < _voters.length; j++) {
      polls[_pollID].voters[_voters[j]].hasVoted = false;
      polls[_pollID].voters[_voters[j]].isApproved = true;
    }
    return true;
  }

  function addApprovedVoter(bytes32 _pollID, address _address) onlyCreator(_pollID) external returns (bool) {
    polls[_pollID].voters[_address].isApproved = true;
  }

  //TODO
  function resolvePoll() {
  }

  function vote(bytes32 _pollID,bytes32 _text, PollType _pollType) 
  isApproved(_pollType, _pollID) 
  hasntVoted(_pollID)
  external returns (bool) 
  {
    require(block.timestamp <= polls[_pollID].endDate);
    polls[_pollID].voters[msg.sender].hasVoted = true;
    polls[_pollID].options[_text] += 1;
    return true;
  }

  //TODO
  /*modifier pollCreationFunded(){  
  }*/

  modifier onlyCreator(bytes32 _pollID){
    require(polls[_pollID].createdBy == msg.sender);
    _;
  }

  modifier isApproved(PollType _pollType, bytes32 _pollID) {
    require (_pollType == PollType.Anyone || polls[_pollID].voters[msg.sender].isApproved);
    _;
  }

  modifier hasntVoted(bytes32 _pollID) {
    require (!polls[_pollID].voters[msg.sender].hasVoted);
    _;
  }
}




