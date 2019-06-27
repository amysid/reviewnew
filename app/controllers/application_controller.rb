class ApplicationController < ActionController::Base
	include CommonConcern
    protect_from_forgery with: :exception
    before_action :banned?
    before_action :configure_permitted_parameters, if: :devise_controller?
    around_action :convert_flash, if: :check_flash


    protected
    def configure_permitted_parameters
          	# binding.pry
         devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:name, :email, :password, :password_confirmation)}
         devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:name, :email, :password, :current_password, :password_confirmation, image_attributes: [:id, :file, :_destroy])}
    end

    def after_sign_out_path_for(resource)
         return new_user_session_path
    end 

    def after_update_path_for(resource)
      return new_user_session_path       
    end

    def after_sign_in_path_for(resource)
      # binding.pry
       if(resource.role == "admin")
        return  admin_homes_index_path
       else  
        super
       end
    end

    def after_resetting_password_path_for(resource)
   #super(resource)
   new_user_session_path if is_navigational_format?
 end

 # The path used after sending reset password instructions
  def after_sending_reset_password_instructions_path_for(resource_name)
   super(resource_name)
  end

    def banned?
      if current_user.present? && !current_user.status?
        sign_out current_user
        flash.clear
        flash[:alert] = "This account has been blocked by admin."
        # convert_flash
        root_path
      end
    end
end
