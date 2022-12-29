pragma solidity 0.8.7;

contract Lottery {

    address manager;
    address payable[] players;

    constructor() {
        manager = msg.sender;
    }

    // Function to check if player already in the game.
    function playerAllreadyExists(address player) view private returns(bool) {
        for(uint i = 0; i < players.length; i++) {
            if(players[i] == player) {
                return true;
            }
        }
        return false;
    }

    // Function to get list of all players
    function getAllPlayers() view public returns(address payable[] memory) {
        return players;
    }

    // Function to generate random number
    function random() view private returns(uint) {
        return uint(sha256(abi.encodePacked(block.difficulty, block.number, players)));
    }

    // Function to enter the lottery game.
    function EnterLottery() public payable {
        require(msg.sender != manager, "Manager is not allowed to enter");
        require(playerAllreadyExists(msg.sender) == false,"Player already is lottery");
        require(msg.value == 5 wei, "Lottery amount is not matching requirement");
        players.push(payable(msg.sender));
    }

    // Funtion to pick winner out of game
    function pickWinner() public {
        require(msg.sender == manager, "Only manager permitted");
        require(players.length > 5, "Atleast 5 players required for lottery to be withdraw");
        uint index = random() % players.length;
        address ContractAddress = address(this);
        // Transferring money to the winner player
        players[index].transfer(ContractAddress.balance);
        // resetting the player
        players = new address payable[] (0);
    }
}