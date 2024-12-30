## FiDelis

---

## Overview  
**FiDelis** is a blockchain-based tokenized loyalty program smart contract built with Clarity, designed to reward and manage customer loyalty seamlessly. It enables businesses to issue loyalty tokens, manage rewards, and provide customers with a transparent and decentralized platform to redeem their benefits.

---

## Features  

1. **Tokenized Rewards**  
   - Customers earn and manage **LoyaltyTokens** (symbol: `LYT`), a digital representation of loyalty points.

2. **Secure Transactions**  
   - Transfer tokens securely between accounts.
   - Only the contract owner can mint new tokens.

3. **Reward Management**  
   - Businesses can add rewards with specific costs and availability.
   - Customers can redeem rewards by exchanging their tokens.

4. **Decentralized Transparency**  
   - All balances, rewards, and transactions are stored on the blockchain, ensuring trust and accountability.

---

## Smart Contract Functions  

### Read-Only Functions  
1. **`get-name`**  
   - Returns the token name (`LoyaltyToken`).

2. **`get-symbol`**  
   - Returns the token symbol (`LYT`).

3. **`get-balance(account)`**  
   - Returns the token balance of a specified account.

4. **`get-reward(reward-id)`**  
   - Fetches the details of a reward using its ID.

---

### Public Functions  
1. **`transfer(amount, sender, recipient)`**  
   - Transfers tokens from one account to another.  
   - Verifies the sender's authorization and balance before transferring.

2. **`mint(amount, recipient)`**  
   - Allows the contract owner to mint new tokens for a specified account.

3. **`add-reward(name, cost, available)`**  
   - Adds a new reward with its name, cost, and availability.  
   - Only accessible by the contract owner.

4. **`redeem-reward(reward-id)`**  
   - Allows customers to redeem rewards by spending their tokens.  
   - Validates the user's balance and reward availability.

---

## Error Handling  
FiDelis uses specific error constants to handle edge cases effectively:  

- **`ERR-NOT-AUTHORIZED (u100)`**: Action requires authorization but the user is unauthorized.  
- **`ERR-INSUFFICIENT-BALANCE (u101)`**: User has insufficient tokens for the transaction.  
- **`ERR-INVALID-AMOUNT (u102)`**: Invalid or non-positive token/reward values.  
- **`ERR-REWARD-NOT-AVAILABLE (u103)`**: Reward is unavailable or out of stock.

---

## Data Structures  

### Data Maps  
1. **`balances`**:  
   - Key: `principal` (user address)  
   - Value: `uint` (token balance)

2. **`rewards`**:  
   - Key: `uint` (reward ID)  
   - Value:  
     - `name` (`string-ascii 50`)  
     - `cost` (`uint`)  
     - `available` (`uint`)

---

### Contract Variables  
- **`token-name`**: Name of the token (default: `LoyaltyToken`).  
- **`token-symbol`**: Symbol for the token (default: `LYT`).  
- **`owner`**: Address of the contract owner.  
- **`reward-counter`**: Tracks the total number of rewards added.

---

## Deployment Instructions  

1. Deploy the FiDelis smart contract on the Stacks blockchain.  
2. Set the contract owner during initialization (defaults to the deployer's principal address).  
3. Use the `mint` function to distribute tokens to customers.  
4. Add rewards using the `add-reward` function.

---

## Usage  

### For Businesses  
- Reward customers with `LYT` tokens.  
- Create and manage enticing rewards to maintain customer engagement.

### For Customers  
- Accumulate `LYT` tokens through purchases or activities.  
- Redeem tokens for rewards using a secure and transparent blockchain platform.

---

## Future Enhancements  

- **Dynamic Reward Updates**: Allow reward modifications post-creation.  
- **Multi-Owner Access**: Enable multiple authorized accounts to manage the loyalty program.  
- **Expiration Mechanism**: Introduce token and reward expiration dates.  
- **Reward Categories**: Add categories for better organization of rewards.  

---

## License  
This project is open-source and licensed under the [MIT License].

---

With **FiDelis**, loyalty is no longer just a program—it's a transparent and engaging ecosystem powered by blockchain technology.