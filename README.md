# Solidity Basic Timelock Vault

This repository features a fundamental smart contract written in **Solidity** that implements a time-based locking mechanism for ERC-20 tokens.

## Goal

* Demonstrate competence in advanced Solidity concepts like time manipulation (`block.timestamp`) and access control.
* Showcase safe interaction with external contracts using the `IERC20` interface.
* Provide a clear, simple example of a token lock, which is a common component in DeFi and vesting schedules.

## Contract Functionality (`TimelockVault.sol`)

The contract's key functions are:

1.  **Deployment:** Requires the address of the ERC-20 token to be locked. It immediately sets the `unlockTime` based on the predefined `LOCK_DURATION` (30 days).
2.  **`lockTokens(uint256 amount)`:** Allows the contract owner to send tokens to the vault, provided they have granted the contract the necessary token allowance.
3.  **`withdrawTokens()`:** Permits the contract owner to retrieve the locked tokens **only after** the `unlockTime` has passed.
4.  **Access Control:** Uses OpenZeppelin's `Ownable` contract to restrict key actions (locking and withdrawing) to the deployer.

## Tech Stack

* **Language:** Solidity (`^0.8.0`)
* **External Dependencies:** OpenZeppelin Contracts (for `IERC20` and `Ownable`)

## Implementation Details

* **Token Standard:** ERC-20 Interface (`IERC20`)
* **Time:** Uses `block.timestamp` for secure time checks.
* **Security:** Uses `require()` statements to prevent unauthorized or premature withdrawal.

## Note on Dependencies

To deploy or test this locally using a framework like Hardhat or Foundry, you would need to install the OpenZeppelin Contracts package:

```bash
npm install @openzeppelin/contracts
