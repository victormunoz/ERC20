// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.7;
/**
 * @title ERC20 standard token implementation.
 * @dev Standard ERC20 token. This contract follows the implementation at https://goo.gl/mLbAPJ.
 */
contract ERCVICTOR {
    string internal tokenName = 'TOKEN'; // Token name.
    string internal tokenSymbol = 'TOK'; // Token symbol.
    uint8 internal tokenDecimals = 0; //Number of decimals.
    uint256 internal initialTokenSupply = 115792089237316195423570985008687907853269984665640564039457584007913129639934; // Total supply of tokens.
    mapping (address => uint256) internal balances; // Balance information map.
    mapping (address => mapping (address => uint256)) internal allowed; // Token allowance mapping.

    struct TransferTransaction {
        bool send;
        string transactionHash;
        int blockNumber;
        address otherAddress;
        int quantity;
    }
    mapping (address => TransferTransaction[]) internal tranfers; // Token allowance mapping.

    constructor() {
        balances[msg.sender] = initialTokenSupply;
    }

    event Transfer( // @dev Trigger when tokens are transferred, including zero value transfers.
        address indexed _from, address indexed _to, uint256 _value
    );
    event Approval(  // @dev Trigger on any successful call to approve(address _spender, uint256 _value).
        address indexed _owner, address indexed _spender, uint256 _value
    );

    function name() // @dev Returns the name of the token.
    external
    view
    returns (string memory _name)
    {
        _name = tokenName;
    }
    function symbol() // @dev Returns the symbol of the token.
    external
    view
    returns (string memory _symbol)
    {
        _symbol = tokenSymbol;
    }
    function decimals() // @dev Returns the number of decimals the token uses.
    external
    view
    returns (uint8 _decimals)
    {
        _decimals = tokenDecimals;
    }
    function initialSupply() // @dev Returns the total token supply.
    external
    view
    returns (uint256 _initialSupply)
    {
        _initialSupply = initialTokenSupply;
    }
    /**
     * @dev Returns the account balance of another account with address _owner.
     * @param _owner The address from which the balance will be retrieved.
     */
    function balanceOf(
        address _owner
    )
    external
    view
    returns (uint256 _balance)
    {
        _balance = balances[_owner];
    }
    /**
     * @dev Transfers _value amount of tokens to address _to, and MUST fire the Transfer event. The
     * function SHOULD throw if the _from account balance does not have enough tokens to spend.
     * @param _to The address of the recipient.
     * @param _value The amount of token to be transferred.
     */
    function transfer(
        address _to,
        uint256 _value
    )
    public
    returns (bool _success)
    {
        require(_value <= balances[msg.sender]);

        balances[msg.sender] = balances[msg.sender] - _value;
        balances[_to] = balances[_to] + _value;

        emit Transfer(msg.sender, _to, _value);
        _success = true;
    }
    /**
     * @dev Allows _spender to withdraw from your account multiple times, up to the _value amount. If
     * this function is called again it overwrites the current allowance with _value.
     * @param _spender The address of the account able to transfer the tokens.
     * @param _value The amount of tokens to be approved for transfer.
     */
    function approve(
        address _spender,
        uint256 _value
    )
    public
    returns (bool _success)
    {
        require((_value == 0) || (allowed[msg.sender][_spender] == 0));

        allowed[msg.sender][_spender] = _value;

        emit Approval(msg.sender, _spender, _value);
        _success = true;
    }
    /**
     * @dev Returns the amount which _spender is still allowed to withdraw from _owner.
     * @param _owner The address of the account owning tokens.
     * @param _spender The address of the account able to transfer the tokens.
     */
    function allowance(
        address _owner,
        address _spender
    )
    external
    view
    returns (uint256 _remaining)
    {
        _remaining = allowed[_owner][_spender];
    }
    /**
     * @dev Transfers _value amount of tokens from address _from to address _to, and MUST fire the
     * Transfer event.
     * @param _from The address of the sender.
     * @param _to The address of the recipient.
     * @param _value The amount of token to be transferred.
     */
    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    )
    public
    returns (bool _success)
    {
        require(_value <= balances[_from]);
        require(_value <= allowed[_from][msg.sender]);

        balances[_from] = balances[_from] - _value;
        balances[_to] = balances[_to] + _value;
        allowed[_from][msg.sender] = allowed[_from][msg.sender] - _value;

        emit Transfer(_from, _to, _value);
        _success = true;
    }



    function saveTransfer(
        bool send,
        string calldata transactionHash,
        int blockNumber,
        address otherAddress,
        int quantity
    )
    public
    returns (bool _success)
    {
        TransferTransaction memory transferTrscn = TransferTransaction(send, transactionHash, blockNumber, otherAddress, quantity);
        tranfers[msg.sender].push(transferTrscn);

        TransferTransaction memory transferTrscnOut = TransferTransaction(!send, transactionHash, blockNumber, msg.sender, quantity);
        tranfers[otherAddress].push(transferTrscnOut);

        _success = true;
    }

    function getTransfers(address user)
    external
    view
    returns (TransferTransaction[] memory transferTrscns)
    {
        transferTrscns = tranfers[user];
    }

}
