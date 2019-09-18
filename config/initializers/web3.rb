Abi = '[{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"productId","type":"uint256"}],"name":"getProduct","outputs":[{"name":"id","type":"uint256"},{"name":"title","type":"string"},{"name":"avgRating","type":"uint256"},{"name":"hasReviewed","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_title","type":"string"}],"name":"addProduct","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"productCount","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_productId","type":"uint256"},{"name":"_rating","type":"uint8"}],"name":"addReview","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"inputs":[],"payable":false,"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":false,"name":"id","type":"uint256"},{"indexed":false,"name":"title","type":"string"}],"name":"ProductAdded","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"id","type":"uint256"},{"indexed":false,"name":"avgRating","type":"uint256"}],"name":"ProductReviewed","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"previousOwner","type":"address"},{"indexed":true,"name":"newOwner","type":"address"}],"name":"OwnershipTransferred","type":"event"}]'
# Client = Ethereum::HttpClient.new('http://localhost:7545')
Client = Ethereum::HttpClient.new('http://review.cmex.network:8545')
# ContractInstance = 

def get_crypt key , salt
  key = ActiveSupport::KeyGenerator.new(key.to_s).generate_key(salt.to_i.to_s,32)
  ActiveSupport::MessageEncryptor.new(key)
end

Encrypt_me = lambda {|key,salt,data|
	crypt = get_crypt key , salt
	crypt.encrypt_and_sign(data)
}
Decrypt_me = lambda{|key,salt,encoded_data|
	crypt = get_crypt key , salt
	crypt.decrypt_and_verify(encoded_data)
}
def get_client address
	# client = Ethereum::HttpClient.new('http://localhost:7545')
	client = Ethereum::HttpClient.new('http://review.cmex.network:8545')
	client.default_account = address
	client
end

# address for server 0x171d653cbe909b5e9eb365c17bdbc19fdd26d443
Contract_instance = Proc.new{|address|
	client = address.present? ? (get_client address) : Client
	Ethereum::Contract.create(name: "MyContract", address: "0xf14d265eaa26c9a6f951f82428005eabc260db8a", abi: Abi,client: client)
}
Get_client = Proc.new{|address|
	client = address.present? ? (get_client address) : Client
}
