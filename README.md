# Shared_Wallet
## Basic Functionalities
The aim of this project is to realise a Shared wallet with the following basic functionalities:
1. **Deposit**
    - The smart contract should be able to receive funds
2. **Withdrawal**
    - The smart contract should let the user withdraw funds depending on:
        - User Allowance
        - User Type
            - Contract owner
                - Should be able to withdraw any desired amount whenever needed
            - Generic User
                - Should be able to withdraw the entirety of the allowance only once every n seconds 
                    - n to be defined
                - Should be able to withdraw less than the allowance multiple times during the n seconds
                    - The sum of all of the withdrawals must be less or equal than its allowance
        
3. **Allowance**
    - The Allowance value should be an externally settable value depending on user type
    - The frequency at which the allowance can be withdrawn should be a value settable depending on user type

4. **Visualisation**
    - The smart contract should provide the user with the ability to visualise the followings:
        - Owner Address
        - Smart Contract Balance
        - Total Allowance Withdrawable
        - Remaining Allowance Withdrawable

5. **Self-Destruction**
    - The smart contract should be self destructible and, if self-destructed, the remaining funds locked in the smart contract should be sent to the contract owner
    
## User-Specific Smart Contract Interraction
### Generic User
The user should be able to:
- Check the Smart Contract balance
- Check who is the owner of the smart contract
- Check how much is the total allowance
- Check what is the remaining amount of wei that he allowed to withdraw before the totality of the allowance has been withdrawn
    - The user must be able to now the result of Allowance-Amount_already_withdrawn if desired

### Owner
The owner, other than being able to do everything that a normal user does, should be able to:
- Withdraw whatever desired amount even if higher than the allowance and equal to the smart contract balance
- Change the value of the allowance
- Change how often the allowance can be withdrawn
- Destroy the Smart Contract


See table below for a summary of what a generic user and the owner should be entitled to do.
<!-- Tables -->
|Functionality | User|Owner|
|--------------| -------- | -------------- |
|Check Smart Contract balance |Yes|Yes|
|Check Owner |Yes|Yes|
|Check total Allowance|Yes|Yes|
|Check remaining allowance withdrawable |Yes|Yes|
|Withdraw any desired amount |No|Yes|
|Change the value of the allowance |No|Yes|
|Change how often the allowance can be withdrawn |No|Yes|
|Destroy the Smart Contract |No|Yes|


