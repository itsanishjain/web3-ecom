// SPDX-License-Identifier: Apache 2.0
pragma solidity ^0.8.0;

import "./Paypal.sol";


contract Ecom is Paypal{

    uint ID = 0;
    mapping(address => uint[]) cart; 
    struct product {
        address owner;
        uint id;
        string name;
        string description;
        string author;
        string productImageUrl;
        uint256 priceInUSD;
    }

    product[] public products;



    // function to add product to blockchain
    function addProduct(string memory _name,string memory _description,string memory _author,
    string memory _productImageUrl,
    uint256 _priceInUSD) public {
        products.push(product({
            owner:msg.sender,
            id:ID,
            name:_name,
            description:_description,
            author:_author,
            productImageUrl:_productImageUrl,
            priceInUSD:_priceInUSD
            }));
        ID = ID + 1;  
    } 

    // function to add item to a cart
    function addItemToCart(uint _id) public {
        cart[msg.sender].push(_id);

    }
    
    // get items from your cart
    function getItemsFromCart() public view returns(uint[] memory) {
        address _userAddress = msg.sender;
        return cart[_userAddress];
    }


    //  buy a product
    function getCartTotal() public view  returns(uint) {
        address _userAddress = msg.sender;
        uint cartTotal = 0;
        uint[] memory cartItems =  cart[_userAddress];
        for(uint i = 0 ; i<cartItems.length ; i++){
            cartTotal += products[i].priceInUSD;
        }
        return cartTotal;
    }
   
    // function checkout() public payable {
    //     uint cartTotal = getCartTotal(); // total value of cart in USD
    //     // sends funds to SC take some cut may 1% and then send remaning to seller
    //     // in this version I am only seller so code is not so complex

    // }


}