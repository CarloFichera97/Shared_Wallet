pragma solidity >0.5.13;

//Shared Wallet
//Deposit

contract Shared_Wallet {
    
    address payable owner;
    int allowance;
    
    constructor () public {
        owner = msg.sender;
    }
    
    mapping(address => uint) public balanceReceived;
    

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
     
     function setAllowance(int _allowance) public payable {
         require(msg.sender == owner, "You are not the owner and cannot change the allowance value");
         require(_allowance > 0, "The allowance set must be positive");
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
     
     //Require further implementation for withdrawing a desired amount of money smaller than the allowance
     //Note. It is necessary that the user is not allowed to withdraw an amount lower than the allowance multiple times and it is necessary
     //to define the function such that the sum over the total withdrawals is <= Allowance function (address payable _to, uint _amount, uint _allowance)public
     function withdrawPartialMoney(address payable _to) public {
         _to.transfer(getAllowance());
         
     }
     
    function destroySmartContract(address payable _to) public {
        
        require(msg.sender == owner, "You are not the owner");
        selfdestruct(_to);
    }
     
}