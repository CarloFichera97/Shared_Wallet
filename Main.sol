pragma solidity >0.5.13;

//Shared Wallet
//Deposit

contract Shared_Wallet {
    
    address owner;
    int allowance = 100;
    mapping(address => uint) public balanceReceived;
    mapping(address => uint) TimeCount;
    mapping(address => uint) countAmountWithdrawn;
    
    constructor () {
        owner = msg.sender;
    }

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

    function getAmountWithdrawn() public view returns(uint) {
         return uint(countAmountWithdrawn[msg.sender]);
     }

     function TestTime() public view returns(uint) {
         uint Time = TimeCount[msg.sender] - block.timestamp;
         if (Time >180) {
             return(0);
         }
         else {
            return uint(Time);
         }
    }
     
     function setAllowance(int _allowance) public payable {
         require(msg.sender == owner, "You are not the owner and cannot change the allowance value");
         require(_allowance >= 0, "The allowance set must be positive");
         allowance = _allowance;
     }
     
     //Function to send money to the smart contract
     function sendMoney() public payable {
         balanceReceived [msg.sender] += msg.value;
     }
     
     function withdrawTotalMoney(address payable _to) public {
         require(msg.sender == owner, "You are not the owner and cannot withdraw all the funds contained in the smart contract");
         _to.transfer(getBalance());
     }
     
     //This function allow the user to withdraw a certain amount of money during a certain amount of Time
     //The maximum amount of money withdrawable depends on the allowance which is set by the contract owner
     //The user can withdraw more than one time during the set period as long as the sum of al the withdrawals are <= allowance 
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
                 TimeCount[msg.sender] = block.timestamp + 180;
                 }
             countAmountWithdrawn[msg.sender] = countAmountWithdrawn[msg.sender] + _amount;
             require(countAmountWithdrawn[msg.sender] <= getAllowance(), "You are not allowed to withdraw more than your allowance");
             _to.transfer(_amount);
             }
     }
    function destroySmartContract(address payable _to) public {
        require(msg.sender == owner, "You are not the owner");
        selfdestruct(_to);
    } 
}