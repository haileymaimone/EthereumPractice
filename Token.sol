// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

contract Token 
{
    // token variable declarations
    string public name;
    string public symbol;
    uint256 public decimals;
    uint256 public totalSupply;
    
    // keeps track of the balances 
    mapping(address => uint256) public balanceOf;
    // keeps track of allowances approved
    mapping(address => mapping(address => uint256)) public allowance;


    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);


    // constructor initializes all variables
    constructor(string memory _name, string memory _symbol, uint _decimals, uint _totalSupply)
    {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        totalSupply = _totalSupply;
        balanceOf[msg.sender] = totalSupply;
    }

    // function ensures balance of sender is sufficient
    function transfer(address _to, uint256 _value) external returns (bool success) 
    {
        require(balanceOf[msg.sender] >= _value); // ensures balance of the sender has enough tokens to send the _value
        _transfer(msg.sender, _to, _value);  // calls _transfer function
        return true; // returns true to notify of transfer success 
    }

    // function transfers tokens from sender (_from) to receiver (_to)
    function _transfer(address _from, address _to, uint256 _value) internal 
    {
        // ensure sending is to valid address, 0x0 address cane be used to burn() 
        require(_to != address(0));
        balanceOf[_from] = balanceOf[_from] - (_value); //subtracts value from senders balance and sets balanceOf to the new balance
        balanceOf[_to] = balanceOf[_to] + (_value); // adds the value that was sent to the balance of the person receiving the tokens
        emit Transfer(_from, _to, _value);
    }

    // function to approve another account to spend on your behalf
    // parameters:  _spender address of spender allowed to spend, 
    //              _value amount of token being sent
    // returns true if address approved
    // emit the Approval event
    // allow the _spender to spend up to _value on your behalf
    function approve(address _spender, uint _value) external returns (bool)
    {
        // ensures sending is to the valid address
        require(_spender != address(0));
        allowance[msg.sender][_spender]= _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    // transfer by approved person from original address of an amount within the approved limit
    // parameters: _from is the address sending the tokens and the amount to send
    //             _to is the receiver of the tokens,
    //             _value is the amount of tokens to be sent
    // returns true when transfer from original account is a success
    // Allows _spender to spend up to _value on your behalf
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool)
    {
        require(_value <= balanceOf[_from]);  // ensures the value being sent and transferred is less than or equal to the balance of the sender
        require(_value <= allowance[_from][msg.sender]);  // ensures the value is less than/equal to the allowance given to the approved person
        allowance[_from][msg.sender] = allowance[_from][msg.sender] - (_value); // allowance is set to new allowance after value spent
        _transfer(_from, _to, _value); // calls transfer function to proceed with transfer
        return true;
    }
}
