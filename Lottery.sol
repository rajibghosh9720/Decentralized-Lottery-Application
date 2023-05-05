// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.0 <0.10.0;

contract Lottery{

    address public manager;
    address payable [] public participents;

    constructor(){
        manager=msg.sender;
    }

    receive() external payable 
    {
        require(msg.value==1 ether);
        participents.push(payable (msg.sender));
    }

    function getBalance() public view returns(uint)
    {
        require(msg.sender==manager);
        return address(this).balance;
    }

    function random() public view returns(uint){
       return  uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp,participents.length)));

    }
    function selectWinner() public {
        
        require(msg.sender==manager);
        require(participents.length>3);
        uint select =random();
        address payable winner;
        uint index=select % participents.length;
        winner=participents[index];
        winner.transfer(getBalance());
        participents=new address payable [](0);

    }

}