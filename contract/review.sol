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

pragma solidity ^ 0.5 .7;

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
        uint criteriaCount;
        mapping(string => string) criterias;
    }
    mapping(string => string[]) criteriasId;
    string[] categoriesId;
    event ProductAdded(uint id, string title);
    event ProductReviewed(uint id, uint avgRating);
    mapping(uint => address[]) public reviewers;
    mapping(string => string) public review;  // strConcat(productId, "#", reviewerAddress, "#", product.category_id);
    mapping(string => Category) public categories;
    mapping(uint => Product) products;
    uint public productCount = 0;
    uint public categoryCount = 0;
    string v = "";

    constructor() public {
        owner = msg.sender;

    }

    function addressToString(address _addr) public pure returns(string memory) {
        bytes32 value = bytes32(uint256(_addr));
        bytes memory alphabet = "0123456789abcdef";

        bytes memory str = new bytes(51);
        str[0] = '0';
        str[1] = 'x';
        for (uint256 i = 0; i < 20; i++) {
            str[2 + i * 2] = alphabet[uint8(value[i + 12] >> 4)];
            str[3 + i * 2] = alphabet[uint8(value[i + 12] & 0x0f)];
        }
        return string(str);
    }

    function uint2str(uint i) internal pure returns(string memory) {
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

    


    function addProduct(string memory _title, string memory _category_id) categorypresent(_category_id) public onlyOwner {
        require(keccak256(bytes(_title)) != keccak256(""), "The title property is required.");
        // require(category_existance(_category_id) == true, "No such category with given id is present.");
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

    function addCategory(string memory _title, string memory _categoryId) public onlyOwner {
        require(stringpresent(categories[_categoryId].title) == false, "Category with this id already exists.");
        categories[_categoryId].title = _title;
        categoriesId.push(_categoryId);
        categoryCount++;

    }

    

    function addCriteria(string memory _categoryId, string memory _criteria, string memory _criteriaId) categorypresent(_categoryId) public onlyOwner {
        // require(category_existance(_categoryId) == true, "No such category with given id is present.");
        require(criteria_existance(_categoryId, _criteriaId) == false, "Criteria already exists.");
        categories[_categoryId].criterias[_criteriaId] = _criteria;
        criteriasId[_categoryId].push(_criteriaId);
        // if (review[concat(concat(productId, "#", reviewerAddress),"#",product.category_id)]) {
            
        // }
        categories[_categoryId].criteriaCount++;
    }


    function addReview(uint _productId, uint[] memory ratings) validate_review(_productId,ratings) public returns(string memory result) {
        
        Product storage product = products[_productId];
        require(keccak256(bytes(product.title)) != keccak256(""), "Product not found.");
        for (uint i = 0; i < ratings.length; i++) {
            require(ratings[i] >= 0 && ratings[i] <= 5, "Rating is out of range.");
        }
       
        string memory reviewerAddress = addressToString(msg.sender);
        // string memory categoryId = product.category_id;
        string memory productId = uint2str(_productId);
        string memory reviews = "reviews::";
        //string memory index = concat(productId, "#", reviewerAddress, "#", product.category_id);
        string memory index = concat(productId, "#", reviewerAddress);
        index = concat(index,"#",product.category_id);
        for (uint i = 0; i < criteriasId[product.category_id].length; i++) {
            string memory id = criteriasId[product.category_id][i];
            string memory str_rating = uint2str(ratings[i]);
            //reviews = concat(reviews, categories[product.category_id].criterias[id], ":", str_rating, ",");
            reviews = concat(reviews, categories[product.category_id].criterias[id], ":");
            reviews = concat(reviews,str_rating,",");
        }
        review[index] = reviews;
        calculateAverageRating(_productId, ratings);
        product.reviewsCount++;
        product.hasReviewed[msg.sender] = true;
        reviewers[_productId].push(msg.sender) - 1;
        emit ProductReviewed(product.id, product.sumRating / product.reviewsCount);
        return review[index];
    }
    
    function getProductCriterias(uint _productId) public view returns(string memory) {
        Product storage product = products[_productId];
        string memory result = "criterias::";
        string[] memory criteriasArray = criteriasId[product.category_id];
        for(uint i=0;i<criteriasId[product.category_id].length;i++) {
        result = concat(result,categories[product.category_id].criterias[criteriasArray[i]],",");
        }
        return result;
    }
    
    function getCategoryCriteria(string memory _categoryId , string memory _criteriaId) public view returns(string memory) {
        return categories[_categoryId].criterias[_criteriaId];
    }
    
    function calculateAverageRating(uint _productId, uint[] memory ratings) internal {
        uint avgRating = 0;
        Product storage product = products[_productId];
        for (uint i = 0; i < ratings.length; i++) {
            avgRating += ratings[i];
        }
        avgRating = avgRating / ratings.length;
        product.sumRating = product.sumRating + avgRating;
    }


    function getProduct(uint productId) public view returns(uint id, string memory title, uint avgRating, bool hasReviewed) {
        Product storage product = products[productId];
        uint _avgRating = 0;

        if (product.reviewsCount > 0)
            _avgRating = product.sumRating / product.reviewsCount;

        return (
            product.id,
            product.title,
            _avgRating,
            product.hasReviewed[msg.sender]
        );
    }


    function getRatings(uint _productId, uint index) private view returns(string memory result) {
        Product storage product = products[_productId];
        string memory _categoryId = product.category_id;
        address reviewer = reviewers[_productId][index];
        string memory a = addressToString(reviewer);
        string memory reviews = "review::";
        string memory productId = uint2str(_productId);
        string memory temp = review[concat(concat(productId, "#", a), "#", _categoryId)];
        reviews = concat(reviews,"",temp);
        reviews = concat(a, "#", reviews);
        return reviews;
    }

    function getAllRatings(uint _productId) public view returns(string memory) {
        string memory results = "@";
        string memory b;
        uint length = reviewers[_productId].length;

        for (uint i = 0; i < length; i++) {

            b = getRatings(_productId, i);
            results = concat(results,"@",b);

        }
        return results;
    }
    
    function stringpresent(string memory data) pure internal returns(bool) {
        // Check String must present
        return bytes(data).length > 0;
    }
    
    function criteria_existance(string memory _categoryId, string memory _criteria_id) categorypresent(_categoryId) internal view returns(bool) {
        // string memory _cat_title = categories[_categoryId].title;
        // if (stringpresent(_cat_title)) {
            if(stringpresent(categories[_categoryId].criterias[_criteria_id])){
                return true;
            }

        // }
        return false;
    }

    
    modifier categorypresent(string memory _categoryId) {
        // Check Category must present
        require(stringpresent(categories[_categoryId].title), "Categoy must exist.");
        _;
    }
    
    modifier criteriapresent(string memory _categoryId, string memory _criteria_id) {
        // Check Criteria must present
        require(criteria_existance(_categoryId,_criteria_id), "Critea must exist.");
        _;
    }
    
    modifier validate_review(uint _productId,uint [] memory _rating) {
        // Check String must present
        Product storage product = products[_productId];
         require(!product.hasReviewed[msg.sender], "You already reviewed this product.");
        // require(criteria_existance(_categoryId,_criteria_id), "Critea must exist.");
        require(categories[product.category_id].criteriaCount == _rating.length, "Rating criteria does't match.");
        _;
    }
    
    function concat(string memory _str1, string memory _str2 , string memory _delimiter) pure internal returns(string memory) {
       return string(abi.encodePacked(_str1, _str2, _delimiter));
   }

}

