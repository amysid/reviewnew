module AccountConcern

  def get_new_address password
    account = Client.personal_new_account(password)
    account = account["result"]
    unlock_account account, password
    account
  end

  def unlock_account address, password
    status = Client.personal_unlock_account(address,password) rescue nil
    # status = Client.personal_unlock_account(address,password,"nil")
    get_balance address
    return status["result"] rescue nil
  end

  def get_balance address
    balance = Client.get_balance(address) rescue nil
    # if balance < 1000000000000000000 
    #   @formatter = Ethereum::Formatter.new
    #   value = Client.int_to_hex(@formatter.to_wei(1.0))
    #   Client.eth_send_transaction({from: Client.personal_list_accounts["result"][0],to: address,value: value})
    # end
    balance
  end

end
