// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Base contract for shared functionality
contract MarketplaceBase {
    // Struct to represent an item
    struct Item {
        string name;
        string description;
        uint256 price; // Price in wei
        uint256 quantity;
    }

    // Mapping to store items listed by each seller
    mapping(address => Item[]) public sellerItems;

    // Event to notify when a new item is listed
    event ItemListed(
        address indexed seller,
        string name,
        uint256 price,
        uint256 quantity
    );

    // Modifier to check if the caller is the owner of the item
    modifier onlyItemOwner(uint256 _itemIndex) {
        require(_itemIndex < sellerItems[msg.sender].length, "Invalid item index");
        _;
    }
}

// Main contract inheriting from MarketplaceBase
contract DecentralizedMarketplace is MarketplaceBase {

    // Event to notify when an item is edited
    event ItemEdited(
        address indexed seller,
        uint256 itemIndex,
        string name,
        uint256 price,
        uint256 quantity
    );

    // Event to notify when an item is deleted
    event ItemDeleted(
        address indexed seller,
        uint256 itemIndex
    );

    // Event to notify when an item is purchased
    event ItemPurchased(
        address indexed buyer,
        address indexed seller,
        uint256 itemIndex,
        uint256 quantity
    );

    // Function to list a new item
    function listItem(
        string memory _name,
        string memory _description,
        uint256 _price,
        uint256 _quantity
    ) public {
        require(bytes(_name).length > 0, "Item name cannot be empty");
        require(bytes(_description).length > 0, "Item description cannot be empty");
        require(_price > 0, "Price must be greater than zero");
        require(_quantity > 0, "Quantity must be greater than zero");

        // Create a new item and add it to the seller's list
        Item memory newItem = Item({
            name: _name,
            description: _description,
            price: _price,
            quantity: _quantity
        });

        sellerItems[msg.sender].push(newItem);

        emit ItemListed(msg.sender, _name, _price, _quantity);
    }

    // Function to edit an existing item
    function editItem(
        uint256 _itemIndex,
        string memory _name,
        string memory _description,
        uint256 _price,
        uint256 _quantity
    ) public onlyItemOwner(_itemIndex) {
        require(bytes(_name).length > 0, "Item name cannot be empty");
        require(bytes(_description).length > 0, "Item description cannot be empty");
        require(_price > 0, "Price must be greater than zero");
        require(_quantity > 0, "Quantity must be greater than zero");

        Item storage item = sellerItems[msg.sender][_itemIndex];
        item.name = _name;
        item.description = _description;
        item.price = _price;
        item.quantity = _quantity;

        emit ItemEdited(msg.sender, _itemIndex, _name, _price, _quantity);
    }

    // Function to delete an item
    function deleteItem(uint256 _itemIndex) public onlyItemOwner(_itemIndex) {
        uint256 lastIndex = sellerItems[msg.sender].length - 1;
        if (_itemIndex != lastIndex) {
            sellerItems[msg.sender][_itemIndex] = sellerItems[msg.sender][lastIndex];
        }
        sellerItems[msg.sender].pop();

        emit ItemDeleted(msg.sender, _itemIndex);
    }

    // Function to fetch all items listed by a seller
    function getSellerItems(address _seller) public view returns (Item[] memory) {
        return sellerItems[_seller];
    }

    // Function to purchase an item
    function purchaseItem(address _seller, uint256 _itemIndex, uint256 _quantity) public payable {
        require(_quantity > 0, "Quantity must be greater than zero");
        require(_itemIndex < sellerItems[_seller].length, "Invalid item index");

        Item storage item = sellerItems[_seller][_itemIndex];
        require(_quantity <= item.quantity, "Not enough stock");
        require(msg.value == item.price * _quantity, "Incorrect payment amount");

        // Transfer payment to the seller
        payable(_seller).transfer(msg.value);

        // Deduct the purchased quantity
        item.quantity -= _quantity;

        emit ItemPurchased(msg.sender, _seller, _itemIndex, _quantity);
    }
}
