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

  def image_update
    if params[:file].present?
      current_user.image.update(file: params[:file])
      redirect_to user_profile_web_user_path(id: current_user.id)
      flash[:notice] = "Profile updated successfully."
    end
    if params[:current_password].present?
      if params[:password].present? && params[:password_confirmation].present?
        unless params[:password] == params[:password_confirmation]
        redirect_to request.referer
        flash[:notice] = "Password didn't match with the confirmation password."
        end
        current_user.update(password: params[:password])
        redirect_to user_profile_web_user_path(id: current_user.id)
        flash[:notice] = "Password updated successfully."
      else
        redirect_to request.referer
        flash[:notice] = "Please enter new password." 
      end
    end
    
  end

  def show
  end

  def profile
    # binding.pry
  end
  
end
