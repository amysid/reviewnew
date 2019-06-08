class ApplicationController < ActionController::Base
	include CommonConcern
    protect_from_forgery with: :exception
    before_action :configure_permitted_parameters, if: :devise_controller?

    protected
    def configure_permitted_parameters
          	# binding.pry
         devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:name, :email, :password, :password_confirmation)}
         devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:name, :email, :password, :current_password, :password_confirmation)}
    end

    def after_sign_out_path_for(resource)
         return new_user_session_path
    end

    def after_sign_in_path_for(resource)
      # binding.pry
       if(resource.role == "admin")
        return  admin_home_index_path(current_user)
       else  
        super
       end
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
