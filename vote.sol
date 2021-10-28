pragma solidity >=0.7.0 <0.9.0;

contract Vote {
    
    //voters: voted = bool, access to vote = uint , vote index
    struct Voter{
        uint vote;
        bool voted;
        uint voteWeight;
        
        
    }
    
    struct Proposal{
        
        bytes32 name; //basic unit meausrement of information
        uint voteCount; 
    }
    

    Proposal[] public proposals; 
    mapping(address => Voter) public voters;
    address public chairperson;
    
    constructor(bytes32[] memory proposalNames){
        
        chairperson = msg.sender;
        
        voters[chairperson].voteWeight = 1;
       
       for(uint i=0; i < proposalNames.length; i ++){
           proposals.push(Proposal({
               name: proposalNames[i],
               voteCount: 0
           }));
       } 
    }
    
    //Function to autenticate voters
    function fiveRightToVote(address voter) public {
        require(msg.sender  == chairperson,
                'Only the chairperson can five access to vote');
        //require the voter hasnt voted yet
        require(!voters[voter].voted,
                'The voter has already voted.');
        require(voters[voter].voteWeight == 0);
        
        
        voters[voter].voteWeight == 1;
    }
    
    //function for voting
    
    function vote(uint proposal) public {
        Voter storage sender = voters[msg.sender];
        require(sender.voteWeight != 0, 'Has no right to vote');
        require(!sender.voted, 'Already voted');
        
        sender.voted = true;
        sender.vote = proposal;
        
        proposals[proposal].voteCount = proposals[proposal].voteCount + sender.voteWeight; 
    }
    
    //function for showing the results
    
    //Function that shows the winning proposal by integer
    function winningProposal() public view returns (uint winningProposal_){
        uint winningVoteCount = 0;
        for(uint i = 0; i < proposals.length; i++ ){
            if(proposals[i].voteCount > winningVoteCount){
                winningVoteCount = proposals[i].voteCount;
                winningProposal_ = i;
            }
        }
    }
    
    //function that shows the winner by the name
    function winningName()public view returns (bytes32 winningName_){
        winningName_ = proposals[winningProposal()].name;
    }
    
}
