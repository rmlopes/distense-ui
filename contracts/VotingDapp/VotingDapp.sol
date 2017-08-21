pragma solidity ^0.4.11;

import '../lib/SafeMath.sol';

contract VotingDapp {
  using SafeMath for uint256;

  struct Poll {
    bytes32 _pollID;
    address createdBy;
    Option[] options;
    uint256 createdAt;
    PollType pollType;
    uint256 endDate;
    bytes secret;
    mapping (address => Voter) voters;
    uint256 winningIndex;
    bool hasEnded;
    uint256 cost;
  }

  struct Voter {
    address voterAddress;
    bool hasVoted;
    bool isApproved;
  }

  struct Option {
    string text;
    uint256 votes;
  }

  mapping (bytes32 => Poll) public polls;
  enum PollType { Anyone, Approved, Secret }

  //TODO payable
  function VotingDapp() {
  }

  function createPoll(
    address _createdBy,
    PollType _pollType,
    uint256 _endDate,
    string[] _options,
    address[] _voters,
    bytes _secret
  ) external returns (bool) {
    require(_createdBy != address(0));
    uint256 _createdAt = block.timestamp;
    require(_endDate <= _createdAt + 1 years);
    bytes32 _pollID = keccak256(_createdBy, _endDate, _createdAt, _pollType);	// uniqueID that will be bytes32
    Poll storage poll = Poll(
      _pollID,
      _createdBy,
      _options,
      _createdAt,
      _pollType,
      _endDate,
      _secret
    );
    // Loop through provided voters and mark them boolean in approvedVoters mapping
    // TODO determine max approvedVoters length that will be under block gas limit + whatever other gas is consumed by this function
    for (uint256 i = 0; i < _voters.length; i++){
      address votersAddress = _voters[i];
      Voter storage voter = Voter(votersAddress, false, true);
      polls[_pollID].voters[votersAddress] = voter;
    }
    return true;
  }

  function addApprovedVoter(bytes32 _pollID, address _address) onlyCreator external returns (bool) {
    polls[_pollID].approvedVoters[_address] = true;
  }

  //TODO
  function resolvePoll() {
  }

  function vote(bytes32 _pollID,string _text) isApproved hasntVoted external returns (bool) {
    Poll storage poll = polls[_pollID];
    require(block.timestamp <= poll.endDate);
    poll.voters[msg.sender].hasVoted = true;
    uint256 index = poll.options[_text];
    poll.options[index].votes += 1;
    return true;
  }

  //TODO
  /*modifier pollCreationFunded(){  
  }*/

  modifier onlyCreator(address _pollID){
    require(polls[_pollID].createdBy == msg.sender);
    _;
  }

  modifier isApproved(PollType _pollType, address _pollID) {
    require (_pollType == PollType.Anyone || polls[_pollID].voters[msg.sender].isApproved);
    _;
  }

  modifier hasntVoted(address _pollID) {
    require (!polls[_pollID].voters[msg.sender].hasVoted);
    _;
  }
}




