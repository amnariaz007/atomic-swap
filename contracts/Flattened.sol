// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}

// File: contracts/HTLC.sol

// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.15; 

contract HTLC {
  uint public startTime;
  uint public lockTime = 10000 seconds;
  string public secret; //swapping
  bytes32 public hash = 0x41da7906f272f1c9ac1e8c4c32085b2551301d37ce2001a8896fb2868ec3d063;
  address public recipient;
  address public owner; 
  uint public amount; 
  IERC20 public token;

  constructor(address _recipient, address _token, uint _amount) { 
    recipient = _recipient;
    owner = msg.sender; 
    amount = _amount;
    token = IERC20(_token);
  } 

  function fund() external {
    startTime = block.timestamp;
    token.transferFrom(msg.sender, address(this), amount);
  }

  function withdraw(string memory _secret) external { 
    require(keccak256(abi.encodePacked(_secret)) == hash, 'wrong secret');
    secret = _secret; 
    token.transfer(recipient, amount); 
  } 

  function refund() external { 
    require(block.timestamp > startTime + lockTime, 'too early');
    token.transfer(owner, amount); 
  } 
}
