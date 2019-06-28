# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  # GET /resource/password/new
  def new
    super
  end

  # POST /resource/password
  def create
    # binding.pry
    super
  end

  # GET /resource/password/edit?reset_password_token=abcdef
  def edit
       # binding.pry
    super
  end

  # PUT /resource/password
  def update
   # binding.pry
   # super
     self.resource = resource_class.reset_password_by_token(resource_params)

    if resource.errors.empty?
      resource.unlock_access! if unlockable?(resource)
      flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
      set_flash_message(:notice, flash_message) if is_navigational_format?

       redirect_to root_path
    else
      return after_resetting_password_path_for(resource)
    end

    #redirect_to new_user_session_path
  end

   protected

  def after_resetting_password_path_for(resource)
    #binding.pry
     redirect_to root_path
  end

  #The path used after sending reset password instructions
  def after_sending_reset_password_instructions_path_for(resource_name)
    #binding.pry
    super(resource_name)
  end
end
