class Web::UsersController < ApplicationController
  def index
     	if (current_user.present? && current_user.role == "admin")
       redirect_to admin_homes_index_path
 	end
  end

  def show
  end

  def profile
    # binding.pry
  end
  
end
