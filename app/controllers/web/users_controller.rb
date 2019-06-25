class Web::UsersController < ApplicationController
  def index
  end

  def show
  end
  
  def otp
  	binding.pry
  	 @user = User.find_by_email(params[:user][:email])
  	 if @user.present?
  	 	@user.update(fb_id: SecureRandom.hex(2))
  	 	 UserNotifierMailer.send_signup_email(@user).deliver_now
         session[:otp] = @user
         return otp_web_users_path(@user)
      else
         return  new_user_password_path
     end
 end

  def otp_verification
  	binding.pry
  	if session[:otp]["fb_id"] == params[:code]
  		redirect_to reset_password_web_users_path
  		
  	else
  	    redirect_to otp_web_users_path
  	 end 
  end

  # def reset_password
  # 	binding.pry
  # 	if session[:otp]["fb_id"] == params[:code]
  # 		redirect_to reset_password_web_users_path
  		
  # 	else
  # 	    redirect_to otp_web_users_path
  # 	 end 
  # end
  def reset_password
     binding.pry
  end

def update
	binding.pry
end

  def reset_password_confirmation
  	# binding.pry
  	if @user.present?
  		@user.update(password_params)
  		redirect_to user_session_path
  	else
  		redirect_to reset_password_confirmation_web_users_path
  	end
  end

private
def password_params
	params.require(:user).permit(:password, :password_confirmation)
end

   

end
