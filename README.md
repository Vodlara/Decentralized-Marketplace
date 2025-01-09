## Overview
This contract enables a decentralized marketplace where users can list, edit, delete, and purchase items. Sellers manage their inventory, while buyers can securely purchase items.

### Features
- **List Items**: Sellers can list new items with attributes like name, description, price, and quantity.
- **Edit/Delete Items**: Only the owner of an item can edit or delete it.
- **Purchase Items**: Buyers can purchase items by sending the required payment.
- **Event Notifications**: Events are emitted for key actions like listing, editing, deleting, or purchasing items.

### Contract Structure
1. **MarketplaceBase**: Contains shared functionality like item storage and events.
2. **DecentralizedMarketplace**: Main contract inheriting from `MarketplaceBase`.

## Deployment Instructions

1. Install [Remix IDE](https://remix.ethereum.org/) or use any Ethereum development framework (e.g., Hardhat, Truffle).
2. Compile the contract with Solidity version 0.8.0 or above.
3. Deploy the contract on an Ethereum-compatible network.

### Example Deployment Using Remix
- Copy the contract code into Remix.
- Compile the contract.
- Deploy it on a test network (e.g., Ropsten, Goerli) using MetaMask.

## Interaction Instructions

### Listing an Item
1. Call `listItem` with the following parameters:
   - `_name`: Name of the item (string).
   - `_description`: Description of the item (string).
   - `_price`: Price in wei (uint256).
   - `_quantity`: Quantity available (uint256).

### Editing an Item
- Call `editItem` with:
  - `_itemIndex`: Index of the item in the seller's list.
  - New values for `_name`, `_description`, `_price`, `_quantity`.

### Deleting an Item
- Call `deleteItem` with the item's `_itemIndex`.

### Purchasing an Item
- Call `purchaseItem` with:
  - `_seller`: Address of the seller.
  - `_itemIndex`: Index of the item to purchase.
  - `_quantity`: Quantity to purchase.
  - Send the exact `msg.value` (price * quantity).

## Test Suite

1. **Deployment Tests**
   - Ensure the contract deploys successfully.

2. **Item Management Tests**
   - Test listing items with valid and invalid parameters.
   - Test editing/deleting items by owners and non-owners.

3. **Purchase Tests**
   - Test purchasing items with correct and incorrect payments.
   - Test stock updates after purchase.

### Example Tests
```javascript
const { expect } = require("chai");

describe("DecentralizedMarketplace", function () {
    let marketplace;

    before(async function () {
        const Marketplace = await ethers.getContractFactory("DecentralizedMarketplace");
        marketplace = await Marketplace.deploy();
        await marketplace.deployed();
    });

    it("Should list an item", async function () {
        await marketplace.listItem("Item1", "Description1", ethers.utils.parseEther("0.1"), 10);
        const items = await marketplace.getSellerItems(owner.address);
        expect(items.length).to.equal(1);
    });

    it("Should edit an item", async function () {
        await marketplace.editItem(0, "NewItem1", "NewDescription1", ethers.utils.parseEther("0.2"), 5);
        const items = await marketplace.getSellerItems(owner.address);
        expect(items[0].price).to.equal(ethers.utils.parseEther("0.2"));
    });

    it("Should delete an item", async function () {
        await marketplace.deleteItem(0);
        const items = await marketplace.getSellerItems(owner.address);
        expect(items.length).to.equal(0);
    });
});
```*/
