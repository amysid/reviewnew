module AuthUserConcern

  def default_contract_instance
    Contract_instance.call
  end

  def contract_instance
    # current_user.key
    Contract_instance.call(current_user.account_address)
  end

  def get_client
    Get_client.call(current_user.account_address)
  end

  def get_default_client
    Get_client.call
  end  
end
