/**
 *Submitted for verification at Etherscan.io on 2019-10-17
*/

/**
 *Submitted for verification at Etherscan.io on 2019-09-20
*/

/**
 *Submitted for verification at Etherscan.io on 2019-09-19
*/

/**
 *Submitted for verification at Etherscan.io on 2019-09-19
*/

/**
 *Submitted for verification at Etherscan.io on 2019-07-24
*/

pragma solidity  ^0.4.24;
//import "github.com/Arachnid/solidity-stringutils/strings.sol";

contract Ownable {
  address public owner;


  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);


  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  constructor() public {
    owner = msg.sender;
  }

  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  function transferOwnership(address newOwner) public onlyOwner {
    require(newOwner != address(0));
    emit OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }

}


contract Rating is Ownable {
    // bytes tempNum ; //temporarily hold the string part until a space is recieved
    // string[] numbers;
    struct Product {
        uint id;
        string category_id; 
        string title;
        uint reviewsCount;
        uint sumRating;
        mapping(address => bool) hasReviewed;
    }
    struct Category {
       string title;
       mapping(string => string) criterias;
    }
    mapping(string => string[]) criteriasId;
    string[] categoriesId;
    event ProductAdded(uint id,string title);
    event ProductReviewed(uint id,uint avgRating);
    mapping(uint => address[]) public reviewers;
    mapping(string => string)  review;
    mapping(string => Category) categories;
    mapping(uint => Product) products;
    uint public productCount = 0;
    uint public categoryCount = 0;
    string v="";

    constructor() public {
        owner = msg.sender;
        
    }
    
    function addressToString(address _addr) public pure returns(string memory)
    {
        bytes32 value = bytes32(uint256(_addr));
        bytes memory alphabet = "0123456789abcdef";

        bytes memory str = new bytes(51);
        str[0] = '0';
        str[1] = 'x';
        for (uint256 i = 0; i < 20; i++) {
            str[2+i*2] = alphabet[uint8(value[i + 12] >> 4)];
            str[3+i*2] = alphabet[uint8(value[i + 12] & 0x0f)];
        }
        return string(str);
    }
    
    function uint2str(uint i) public pure returns (string memory) {
    if (i == 0) return "0";
    uint j = i;
    uint length;
    while (j != 0) {
        length++;    
        j /= 10;
    }
    bytes memory bstr = new bytes(length);
    uint k = length - 1;
    while (i != 0) {
        bstr[k--] = byte(uint8(48 + i % 10));  
        i /= 10;
    }
    return string(bstr);
   }
   
   function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) public pure returns (string memory){
    bytes memory _ba = bytes(_a);
    bytes memory _bb = bytes(_b);
    bytes memory _bc = bytes(_c);
    bytes memory _bd = bytes(_d);
    bytes memory _be = bytes(_e);
    string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
    bytes memory babcde = bytes(abcde);
    uint k = 0;
    for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
    for ( i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
    for ( i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
    for ( i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
    for ( i = 0; i < _be.length; i++) babcde[k++] = _be[i];
    return string(babcde);
}

function strConcat(string memory _a, string memory _b, string memory _c, string memory _d) internal pure returns (string memory) {
    return strConcat(_a, _b, _c, _d, "");
}

function strConcat(string memory _a, string memory _b, string memory _c) internal pure returns (string memory) {
    return strConcat(_a, _b, _c, "", "");
}

function strConcat(string memory _a, string memory _b) internal pure returns (string memory) {
    return strConcat(_a, _b, "", "", "");
}
//keccak256(abi.encodePacked(number[num])) == keccak256(abi.encodePacked(""))
function categoryPresent(string memory _categoryId) internal view returns(bool) {
        for(uint i=0;i<categoriesId.length;i++)  {
           if(keccak256(bytes(categoriesId[i])) ==  keccak256(bytes(_categoryId))) {
                return true;
            } else {
                return false;
            }
    }
}

    function addProduct(string memory _title , string memory _category_id) public onlyOwner {
        //require(keccak256(bytes(_title)) != keccak256(""), "The title property is required.");
        //require(categoryPresent(_category_id) == true, "No such category with given id is present.");
        Product memory product = Product({
            id: productCount,
            category_id: _category_id,
            title: _title,
            reviewsCount: 0,
            sumRating: 0
        });

        products[productCount] = product;
        productCount++;
        emit ProductAdded(product.id, product.title);
    }
    
    function addCategory(string memory _title ,string memory _categoryId) public onlyOwner {
      require(categoryPresent(_categoryId) == false, "Category with this id already exists.");    
      categories[_categoryId].title = _title;
      categoriesId.push(_categoryId);
      categoryCount++;
    }
    
    function addCriteria(string memory  _categoryId , string memory _criteria , string memory _criteriaId) public onlyOwner {
         categories[_categoryId].criterias[_criteriaId] = _criteria;
         criteriasId[_categoryId].push(_criteriaId);
    }
    
  
    function addReview(uint _productId, uint[] memory ratings) public  returns(string memory result) {
        Product storage product = products[_productId];
        //require(keccak256(bytes(product.title)) != keccak256(""), "Product not found.");
        for(uint i=0;i<ratings.length;i++) {
       // require(ratings[i] >= 0 && ratings[i] <= 5, "Rating is out of range.");
        }
        //require(!product.hasReviewed[msg.sender], "This address already reviewed this product.");
        string memory reviewerAddress = addressToString(msg.sender);
        string memory categoryId = product.category_id;
        string memory productId = uint2str(_productId);
        string memory reviews = "reviews::";
        string memory index = strConcat(productId,"#",reviewerAddress,"#",categoryId);
        for( i=0;i<criteriasId[product.category_id].length;i++) {
            string memory id = criteriasId[product.category_id][i];
            reviews = strConcat(reviews,categories[product.category_id].criterias[id],":",uint2str(ratings[i]),",");
          }
        review[index] = reviews;
        calculateAverageRating(_productId,ratings);
        product.reviewsCount++;
        product.hasReviewed[msg.sender] = true;
        reviewers[_productId].push(msg.sender) -1;
        emit ProductReviewed(product.id, product.sumRating / product.reviewsCount);
        return review[index];
    }
    
    function calculateAverageRating(uint _productId ,uint[] memory ratings) internal {
       uint avgRating = 0;
       Product storage product = products[_productId];
       for(uint i=0;i<ratings.length;i++) {
        avgRating += ratings[i] ;
        }
        avgRating = avgRating/ratings.length;
        product.sumRating = product.sumRating+avgRating;
    }
    
    
    function getProduct(uint productId) public view returns (uint id, string memory title, uint avgRating, bool hasReviewed) {
        Product storage product = products[productId];
        uint _avgRating = 0;

        if(product.reviewsCount > 0)
            _avgRating = product.sumRating / product.reviewsCount;
        
        return (
            product.id,
            product.title,
            _avgRating,
            product.hasReviewed[msg.sender]
        );
    }
    
   
   function getRatings(uint _productId , uint index) private view returns(string memory result) {
       Product storage product = products[_productId];
       string memory _categoryId = product.category_id;
       address reviewer = reviewers[_productId][index];
       string memory a = addressToString(reviewer);
       string memory reviews="review::";
       string memory productId = uint2str(_productId);
          string memory temp = review[strConcat(productId,"#",a,"#",_categoryId)];
          reviews = strConcat(reviews,temp,",","","");
          reviews = strConcat(a,"#",reviews,"","");
          return reviews;
   }
    
    function getAllRatings(uint _productId) public view returns (string memory) {
        string memory results="@";
        string memory b;
        uint length = reviewers[_productId].length;
       
        for(uint i=0;i<length;i++) {

          b = getRatings(_productId,i);
          results = strConcat(results,b,"@","","");
          
        }
        return results;
    }
}