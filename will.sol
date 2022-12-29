pragma solidity ^0.8.7;


contract Will{

    address owner;
    uint fortune;
    bool deceased;
    uint i;
     
     constructor() payable public {
        owner = msg.sender; // msg sender represents address that is being called
        fortune = msg.value; // msg value tells us how much ether is being send
        deceased = false;
     }
 
    // create modifier so the only person who can call the contract is the owner.
    modifier onlyOwner{
        require(msg.sender == owner);
        _;
    }
    
    // create modifier so that we only allocate funds if friend's gramps deceased.
      modifier mustBeDeceased{
           require(deceased == true);
           _;
      }

      address payable[] familyWallets;
      // map through inheritance
      mapping(address => uint) inheritance;

      // set inheritance for each address
      function setInheritance(address payable wallet, uint amount) onlyOwner public{
          // to add wallets to the family wallets
          familyWallets.push(wallet);
          inheritance[wallet] = amount;

      }

      // pay each family member based on thier wallet address

      function payout() private mustBeDeceased {
          for(i=0; i<familyWallets.length; i++){
            familyWallets[i].transfer(inheritance[familyWallets[i]]);           
          }
      }

      // oracle switch simulation
      function hasDeceased() public onlyOwner{
          deceased = true;
          payout();
      }
}















