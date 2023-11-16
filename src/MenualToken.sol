// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MenualToken {
    // mapp balance
    mapping(address => uint256) private s_balances;

    // name function
    function name() public pure returns (string memory) {
        return "Menual Token";
    }

    // decimals function
    function decimals() public pure returns (uint8) {
        return 18;
    }

    //total supply
    function totalSupply() public pure returns (uint256) {
        return 100 ether;
    }

    // balanceOf function
    function balanceOf(address _owner) public view returns (uint256) {
        return s_balances[_owner];
    }

    // transfer function
    function transfer(address _to, uint256 _amount) public {
        uint previousBalances = balanceOf(msg.sender) + s_balances[_to];
        s_balances[msg.sender] -= _amount;
        s_balances[_to] += _amount;
        require(balanceOf(msg.sender) + s_balances[_to] == previousBalances);
    }
}
