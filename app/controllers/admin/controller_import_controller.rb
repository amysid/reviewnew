class Admin::ControllerImportController < ApplicationController
	def new
              @user_import = UserImport.new
             end

            def create
             @user_import = UserImport.new(params[:product_import])
            if @user_import.save
            redirect_to admin_users_path, notice: "Imported products successfully."
             else
            render :new
            end
          end
end
