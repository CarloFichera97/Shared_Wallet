pragma solidity ^0.8.4;

//Shared Wallet
//Deposit

contract Shared_Wallet {
    
    address owner;
    uint allowance = 100;
    uint allowance_frequency = 180;
    mapping(address => uint) public balanceReceived;
    mapping(address => uint) TimeCount;
    mapping(address => uint) countAmountWithdrawn;
    
    constructor () {
        owner = msg.sender;
    }
     //Function to get address of the Smart Contract Owner
    function getOwner() public view returns(address) {
        return owner;
    }
    
    //Function to get the total balance of the smart contract
    function getBalance() public view returns(uint) {
         return address(this).balance;
     }
     
     //Function to get the allowance
     function getAllowance() public view returns(uint) {
         return uint(allowance);
     }

     //Function to get the frequency at which a user can withdraw its allowance 
     function getFreqAllowance() public view returns(uint) {
         return uint(allowance_frequency);
     }
     //Function to get how much money a user has withdrawn in the allowed time period
    function getAmountWithdrawn() public view returns(uint) {
         return uint(countAmountWithdrawn[msg.sender]);
     }
     // Function to get:
        // - How long the user has to wait if the totality of the withdrawable allowance in the allowed time period has been already withdrawn
        // - How much time left the user has to withdraw its remaining allowance in the allocated time period
     function getTime() public view returns(uint) {
         if (TimeCount[msg.sender] == 0) {
            return uint(0);
         } else {
             return(TimeCount[msg.sender] - block.timestamp);
         }
     }
     //Function to set the maximum allowance that a normal user is allowed to withdraw - Owner Only
     function setAllowance(uint _allowance) public payable {
         require(msg.sender == owner, "You are not the owner and cannot change the allowance value");
         require(_allowance >= 0, "The allowance set must be positive");
         allowance = _allowance;
     }
     //Function to set how often the allowance can be withdrawn - Owner Only
     function setfrequencyWithdrawal(uint _allowance_frequency) public {
        require(msg.sender == owner, "You are not the owner and cannot change the allowance value");
        require(_allowance_frequency >= 0, "The allowance set must be positive");
        allowance_frequency = _allowance_frequency;
    }

     //Function to send money to the smart contract
     function sendMoney() public payable {
         balanceReceived [msg.sender] += msg.value;
     }
     
     //Function to withdraw the totality of the money locked in the smart contract - Owner Only
     function withdrawTotalMoney(address payable _to) public {
         require(msg.sender == owner, "You are not the owner and cannot withdraw all the funds contained in the smart contract");
         _to.transfer(getBalance());
     }
     
     //Function to withdraw a smaller amount of money than the maximum available
     // - Owner - Can withdraw as much as desired
     // - User - Can withdraw an amount <= than the allowance
     function withdrawPartialMoney(address payable _to, uint _amount) public payable {
         require(_amount <= getAllowance(), "You cannot withdraw more than your allowance");
         require(_amount <= getBalance(), "There are not enough funds Locked in the Smart Contract");
         if (msg.sender == owner){
            _to.transfer(_amount);
         } else {
             if (TimeCount[msg.sender] < block.timestamp) {
                 countAmountWithdrawn[msg.sender] = 0;
                 TimeCount[msg.sender] = 0;
                 }
             if (countAmountWithdrawn[msg.sender] == 0) {
                 TimeCount[msg.sender] = block.timestamp + allowance_frequency;
                 }
             countAmountWithdrawn[msg.sender] = countAmountWithdrawn[msg.sender] + _amount;
             require(countAmountWithdrawn[msg.sender] <= getAllowance(), "You are not allowed to withdraw more than your allowance");
             _to.transfer(_amount);
             }
     }

     //Function to destroy the smart contract - Owner Only
    function destroySmartContract(address payable _to) public {
        require(msg.sender == owner, "You are not the owner");
        selfdestruct(_to);
    } 
}