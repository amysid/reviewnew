class Admin::StaticContentController < ApplicationController
	before_action :find_content, only: [:show,:edit,:update,:status,:destroy]
    layout 'admin_lte_2'

    def index
    	@s_no = 0
    	@static_contents = StaticContent.all
    end
   
    def edit
    	# binding.pry
    end
     
    def update
    	binding.pry
    	 @user = StaticContent.find_by(id: params[:id])
        if @user.update_attributes(user_params)
         redirect_to admin_static_content_index_path
        else
         flash[:alert] = @user.errors.full_messages
         redirect_to admin_static_content_index_path
        end
    end


    private
    def user_params
    	params.require(:static_content).permit(:title, :description)
    end
    def find_content
    	# binding.pry
      @user = StaticContent.find_by(id: params[:id])
      redirect_to admin_users_path unless @user
    end
end
