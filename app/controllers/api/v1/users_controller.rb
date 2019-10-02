class Api::V1::UsersController < ApplicationController

	def sign_up
    
    @user = User.find_by(email: params["user"][:email].try(:downcase)) if params["user"][:email].present?
    return render json: {responseCode: 402, responseMessage: "User already exist."} if @user.present?
    if params["user"][:password] != params["user"][:password_confirmation] 
      return render json: {responseCode: 402, responseMessage: "Password doesn't matched."}
    end
	 @user = User.new(user_params)
	  if @user.save!
	    device = @user.devices.create(device_params) 
      # UserMailer.registration_confirmation(@user).deliver!
      @selected = @user.slice(:id, :email, :access_token, :name)
      render :json =>  {:responseCode => 200,:responseMessage => 'Registration successfully', :user => @selected}

    else
      render :json =>  {:responseCode => 500,:responseMessage => @user.errors.full_messages.first }	  
    end
	end

 



 private

  def authentication_failed
  	render json: {responseCode: 403, responseMessage: ('Please check your email/password.')}
  end
  
  def user_params
  	password = params[:password]
    params.require(:user).permit(:name,:email,:password,:password_confirmation)
  end
    

  def device_params
    params.require(:device).permit(:device_type, :device_token)
  end	


end
