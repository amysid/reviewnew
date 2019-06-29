class Web::UsersController < ApplicationController
  def index
  	if (current_user.present? && current_user.role == "admin")
        redirect_to admin_home_index_path(current_user)
  	end
  end
  
    
    def check_email
        @user = User.pluck(:email)
        if @user.include?(params[:user][:email])
          render json: false
        else
          render json: true
        end
    end

  def check_email_login
      @user = User.pluck(:email)
      if @user.include?(params[:user][:email])
        render json: true
      else
        render json: false
      end
  end


  def show
  end

  def profile
    # binding.pry
  end
  
end
