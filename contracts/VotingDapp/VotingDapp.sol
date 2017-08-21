pragma solidity ^0.4.11;

import './SafeMath.sol';

contract VotingDapp {
  using SafeMath for uint256;

  struct Poll {
    bytes32 public _pollID;
    address public createdBy;
    Option[] public options;
    uint256 public createdAt;
    PollType public type;
    uint256 public endDate;
    bytes public secret;
    mapping (address => Voter) public voters;
    uint256 public winningIndex;
    bool public hasEnded;
    uint256 public cost;
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
  enum PollType { Anyone, Approved, Secret };

  function VotingDapp() /*payable*/ {

  }

  function createPoll(
    address _createdBy,
    PollType _pollType,
    uint256 _endDate,
    string[] _options,
    address[] _oters,
    bytes _secret
  ) external returns (bool) {
    require(_creator != address(0));
    _createdAt = block.timestamp;
    require(_endDate <= _createdAt + 1 years);
    bytes32 _pollID = keccak256(_createdBy, _endDate, _createdAt, _pollType);	// uniqueID that will be bytes32
    poll = Poll(
      _pollID
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
      votersAddress = _voters[i];
      voter = Voter(votersAddress, false, true);
      polls[_pollID].voters[votersAddress] = voter;
    }
    return true;
  }

  function addApprovedVoter(bytes32 _pollID, address _address) onlyCreator external returns (bool) {
    polls[_pollID].approvedVoters[_address] = true;
  }

  function resolvePoll() external return () {

  }

  function vote(bytes32 _pollID, _text) isApproved hasntVoted external returns (bool) {
    poll = polls[_pollID];
    require(block.timestamp <= poll.endDate);
    poll.voters[msg.sender].hasVoted = true;
    uint256 index = poll.options[_text];
    poll.options[index].votes += 1;
    return true;
  }

  modifier pollCreationFunded() {
  }

  modifier onlyCreator(){
    require(polls[pollID].createdBy == msg.sender);
    _;
  }

  modifier isApproved() {
    require (pollType == PollType.Anyone || polls[_pollID].voters[msg.sender].isApproved);
    _;
  }

  modifier hasntVoted() {
    require (!polls[_pollID].voters[msg.sender].hasVoted);
    _;
  }
}




