class Web::UsersController < ApplicationController
  def index
  	#binding.pry	
  	if (current_user.present? && current_user.role == "admin")
        redirect_to admin_home_index_path(current_user)
  	end
  	
  end

  def show
  end

  def profile
    # binding.pry
  end
  
end
