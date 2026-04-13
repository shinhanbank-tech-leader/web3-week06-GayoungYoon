// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Contract {
    address public owner;
    address public charity;

    constructor(address _charity) {
        owner = msg.sender;
        charity = _charity;
    }
    
    receive() external payable {}
    
    function tip() public payable {
        ( bool s , ) = owner.call{value: msg.value}("");
        require(s);
    }

    function donate() public payable {
        ( bool s , ) = charity.call{value: address(this).balance}("");
        require(s);
        selfdestruct(payable(charity));
    }

}



// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract Escrow {
	address public arbiter;
	address public beneficiary;
	address public depositor;

	constructor(address _arbiter, address _beneficiary) payable {
		arbiter = _arbiter;
		beneficiary = _beneficiary;
		depositor = msg.sender;
	}

	event Approved(uint);
	
	error NotAuthorized();

	function approve() external {
		if(msg.sender != arbiter) revert NotAuthorized();

		uint balance = address(this).balance;

		(bool success, ) = beneficiary.call{ value: balance }("");
		require(success);
		
		emit Approved(balance);
	}
}
