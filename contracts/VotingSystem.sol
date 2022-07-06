// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
// secrete ballot 
// 1address one vote
// transperency clear and understood by everyone
// accurately counted
// reliablity

contract VotingSystem {
    // variable decleration
    struct vote{
        address voterAddress;
        bool choice;
    }

    struct voter {
        string voterName;
        bool voted;
    }

    uint private countResult = 0;
    uint public Finalresult = 0;
    uint public totalvoter = 0;
    uint public totalvote = 0;

    address public BallotOfficialAddress;
    string public ballotofficialName;
    string public proposal;

    mapping(uint => vote) private votes;
    mapping(address => voter) public voterRegister;


    enum State {created, Voting, Ended}
    State public state;



    // modofires
    modifier condition(bool _condition){
        require(_condition);
        _;
    }

    modifier onlyOfficial(){
        require(msg.sender == BallotOfficialAddress);
        _;
    }
    modifier inState(State _state) {
        require(state == _state);
        _;
    }

     

    // events

    // functions
    constructor(string memory _ballotofficialName, string memory _proposal){
        BallotOfficialAddress = msg.sender;
        ballotofficialName = _ballotofficialName;
        proposal = _proposal;

        state = State.created;
    }

    function addVoter(address _voterAddress, string memory _voterName) public inState(State.created) onlyOfficial {
        voter memory v;
        v.voterName = _voterName;
        v.voted = false;
        voterRegister[_voterAddress] = v;
        totalvoter++;
    }

    function StartVote() public inState(State.created) onlyOfficial{
        state = State.Voting;
    }

    function doVote(bool _choice) public inState(State.Voting) returns (bool voted) {
        bool found = false;

        if(bytes(voterRegister[msg.sender].voterName).length != 0 && !voterRegister[msg.sender].voted){
            voterRegister[msg.sender].voted = true;
            vote memory v;
            v.voterAddress = msg.sender;
            v.choice = _choice;
            if(_choice){
                countResult++;
            }
            votes[totalvote] = v;
            totalvote++;
            found = true;
        }
        return found;
    }

    function EndVote() public inState(State.Voting) onlyOfficial {
        state = State.Ended;
        Finalresult = countResult;

    }
}
